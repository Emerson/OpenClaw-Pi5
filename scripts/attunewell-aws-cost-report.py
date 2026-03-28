#!/usr/bin/env python3
"""
AttuneWell Daily AWS Cost Report
Fetches yesterday's spend + MTD totals and posts to #attune-well Slack channel.
"""

import json
import os
import subprocess
from datetime import date, timedelta

AWS_ENV = {
    "AWS_ACCESS_KEY_ID": "REDACTED",
    "AWS_SECRET_ACCESS_KEY": "REDACTED",
    "AWS_DEFAULT_REGION": "ca-central-1",
}

SLACK_CHANNEL = "C0A7J6YJSKZ"  # #attune-well
MONTHLY_BUDGET = 200

SERVICE_NAMES = {
    "Amazon Elastic Container Service": "ECS (Fargate)",
    "EC2 - Other": "EC2 / NAT Gateway",
    "AmazonCloudWatch": "CloudWatch",
    "Amazon Elastic Load Balancing": "Load Balancer",
    "Amazon Relational Database Service": "RDS (Postgres)",
    "Amazon ElastiCache": "ElastiCache (Redis)",
    "Amazon Virtual Private Cloud": "VPC / NAT",
    "AWS Secrets Manager": "Secrets Manager",
    "Amazon Route 53": "Route 53",
    "Amazon EC2 Container Registry (ECR)": "ECR",
    "Amazon Simple Storage Service": "S3",
}


def short_name(svc):
    for k, v in SERVICE_NAMES.items():
        if k in svc:
            return v
    if "Bedrock" in svc or "Claude" in svc:
        return "Bedrock (AI)"
    return svc[:40]


def aws_cost(start, end, granularity="MONTHLY"):
    cmd = [
        "aws", "ce", "get-cost-and-usage",
        "--time-period", f"Start={start},End={end}",
        "--granularity", granularity,
        "--metrics", "UnblendedCost",
        "--group-by", "Type=DIMENSION,Key=SERVICE",
        "--output", "json",
    ]
    import os
    env = {**os.environ, **AWS_ENV}
    result = subprocess.run(cmd, capture_output=True, text=True, env=env)
    data = json.loads(result.stdout)
    groups = data["ResultsByTime"][0]["Groups"]
    costs = {}
    for g in groups:
        svc = g["Keys"][0]
        amt = float(g["Metrics"]["UnblendedCost"]["Amount"])
        if amt > 0.005:
            costs[svc] = amt
    return costs


def build_report(today, mtd, yday):
    month_start = today.replace(day=1)
    mtd_total = sum(mtd.values())
    yday_total = sum(yday.values())

    days_elapsed = max(today.day - 1, 1)  # days with billing data
    projected = (mtd_total / days_elapsed) * 30

    lines = [
        f"*💰 AttuneWell AWS Cost Report — {today.strftime('%b %d, %Y')}*",
        "",
        f"*Yesterday:* ${yday_total:.2f}",
        f"*Month-to-date ({month_start.strftime('%b %d')} → today):* ${mtd_total:.2f}",
        f"*Projected monthly:* ~${projected:.0f}",
        "",
        "*MTD by service:*",
    ]

    sorted_mtd = sorted(
        [(svc, amt) for svc, amt in mtd.items() if "Tax" not in svc],
        key=lambda x: -x[1],
    )
    for svc, amt in sorted_mtd:
        lines.append(f"  • {short_name(svc)}: ${amt:.2f}")

    tax = mtd.get("Tax", 0)
    if tax > 0:
        lines.append(f"  + Tax (HST): ${tax:.2f}")

    lines.append("")

    # Pace check
    pct_budget = (mtd_total / MONTHLY_BUDGET) * 100
    pct_month = (today.day / 31) * 100
    if pct_budget > pct_month + 15:
        lines.append(
            f"⚠️ *Pace:* {pct_budget:.0f}% of ${MONTHLY_BUDGET} budget used "
            f"({today.day} days in — running hot)"
        )
    elif projected < MONTHLY_BUDGET * 0.75:
        lines.append(
            f"✅ *Pace:* on track — projected ${projected:.0f} vs ${MONTHLY_BUDGET} budget"
        )
    else:
        lines.append(
            f"✅ *Pace:* {pct_budget:.0f}% of ${MONTHLY_BUDGET} budget "
            f"({today.day} days in)"
        )

    return "\n".join(lines)


def get_slack_token():
    """Read bot token from OpenClaw config."""
    config_path = os.path.expanduser("~/.openclaw/openclaw.json")
    with open(config_path) as f:
        config = json.load(f)
    return config["channels"]["slack"]["botToken"]


def post_to_slack(message):
    import urllib.request
    import urllib.parse

    token = get_slack_token()
    payload = json.dumps({"channel": SLACK_CHANNEL, "text": message}).encode()
    req = urllib.request.Request(
        "https://slack.com/api/chat.postMessage",
        data=payload,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
    )
    with urllib.request.urlopen(req) as resp:
        result = json.loads(resp.read())
    if result.get("ok"):
        print("Posted to Slack OK")
    else:
        print(f"Slack error: {result.get('error')}")


def main():
    today = date.today()
    yesterday = today - timedelta(days=1)
    month_start = today.replace(day=1)

    print(f"Fetching AWS costs for {month_start} → {today}...")
    mtd = aws_cost(str(month_start), str(today), "MONTHLY")
    yday = aws_cost(str(yesterday), str(today), "DAILY")

    report = build_report(today, mtd, yday)
    print(report)
    print()
    post_to_slack(report)


if __name__ == "__main__":
    main()
