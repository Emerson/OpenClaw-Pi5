#!/bin/bash
# AttuneWell Daily AWS Cost Report
# Posts a cost breakdown to #attune-well on Slack

export AWS_ACCESS_KEY_ID=REDACTED
export AWS_SECRET_ACCESS_KEY="REDACTED"
export AWS_DEFAULT_REGION=ca-central-1

# Date ranges
MONTH_START=$(date -d "$(date +%Y-%m-01)" +%Y-%m-%d 2>/dev/null || date -v1d +%Y-%m-%d)
TODAY=$(date +%Y-%m-%d)
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d 2>/dev/null || date -v-1d +%Y-%m-%d)

# Fetch MTD costs by service
MTD_JSON=$(aws ce get-cost-and-usage \
  --time-period "Start=${MONTH_START},End=${TODAY}" \
  --granularity MONTHLY \
  --metrics "UnblendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE \
  --output json 2>&1)

# Fetch yesterday's costs by service
YESTERDAY_JSON=$(aws ce get-cost-and-usage \
  --time-period "Start=${YESTERDAY},End=${TODAY}" \
  --granularity DAILY \
  --metrics "UnblendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE \
  --output json 2>&1)

python3 - <<'PYEOF'
import json, os, sys, subprocess
from datetime import date, timedelta

month_start = os.environ.get('MONTH_START', '')
today_str = os.environ.get('TODAY', '')
yesterday_str = os.environ.get('YESTERDAY', '')

mtd_raw = os.environ.get('MTD_RAW', '')
yday_raw = os.environ.get('YDAY_RAW', '')

def parse_costs(json_str):
    try:
        d = json.loads(json_str)
        groups = d['ResultsByTime'][0]['Groups']
        costs = {}
        for g in groups:
            svc = g['Keys'][0]
            amt = float(g['Metrics']['UnblendedCost']['Amount'])
            if amt > 0.005:
                costs[svc] = amt
        return costs
    except Exception as e:
        return {}

mtd = parse_costs(mtd_raw)
yday = parse_costs(yday_raw)

mtd_total = sum(mtd.values())
yday_total = sum(yday.values())

# Days elapsed this month
today = date.today()
days_elapsed = today.day - 1  # yesterday's data
days_in_month = 30  # close enough
monthly_projected = (mtd_total / max(days_elapsed, 1)) * days_in_month if days_elapsed > 0 else 0

# Service name shortener
def short_name(svc):
    mapping = {
        'Amazon Elastic Container Service': 'ECS (Fargate)',
        'EC2 - Other': 'EC2/NAT Gateway',
        'AmazonCloudWatch': 'CloudWatch',
        'Amazon Elastic Load Balancing': 'Load Balancer',
        'Amazon Relational Database Service': 'RDS (Postgres)',
        'Amazon ElastiCache': 'ElastiCache (Redis)',
        'Amazon Virtual Private Cloud': 'VPC/NAT',
        'AWS Secrets Manager': 'Secrets Manager',
        'Amazon Route 53': 'Route 53',
        'Amazon EC2 Container Registry (ECR)': 'ECR',
        'Amazon Simple Storage Service': 'S3',
        'Tax': 'Tax (HST)',
    }
    for k, v in mapping.items():
        if k in svc:
            return v
    # Shorten Claude/Bedrock
    if 'Bedrock' in svc or 'Claude' in svc:
        return 'Bedrock (AI)'
    return svc[:35]

lines = []
lines.append(f"*💰 AttuneWell AWS Cost Report — {today.strftime('%b %d, %Y')}*")
lines.append("")
lines.append(f"*Yesterday:* ${yday_total:.2f}")
lines.append(f"*Month-to-date ({month_start} → today):* ${mtd_total:.2f}")
lines.append(f"*Projected monthly:* ${monthly_projected:.0f}")
lines.append("")

lines.append("*MTD by service:*")
sorted_mtd = sorted(mtd.items(), key=lambda x: -x[1])
for svc, amt in sorted_mtd:
    name = short_name(svc)
    if 'Tax' in svc:
        continue
    lines.append(f"  • {name}: ${amt:.2f}")

# Show tax separately
tax = mtd.get('Tax', 0)
if tax > 0:
    lines.append(f"  + Tax: ${tax:.2f}")

lines.append("")
# Budget flag
budget = 200
pct = (mtd_total / budget) * 100
days_in = today.day
days_total = 31
day_pct = (days_in / days_total) * 100
if pct > day_pct + 15:
    lines.append(f"⚠️ Spend pace: {pct:.0f}% of ${budget} budget with {days_in} days elapsed ({day_pct:.0f}% of month)")
else:
    lines.append(f"✅ Spend pace: {pct:.0f}% of ${budget} budget ({days_in} days in, on track)")

print('\n'.join(lines))
PYEOF
) 

# Re-run in a way that passes vars to python3
python3 - <<PYEOF
import json, os, subprocess
from datetime import date, timedelta

today = date.today()
yesterday = today - timedelta(days=1)
month_start = today.replace(day=1)

def parse_costs(json_str):
    try:
        d = json.loads(json_str)
        groups = d['ResultsByTime'][0]['Groups']
        costs = {}
        for g in groups:
            svc = g['Keys'][0]
            amt = float(g['Metrics']['UnblendedCost']['Amount'])
            if amt > 0.005:
                costs[svc] = amt
        return costs
    except Exception as e:
        return {}

mtd = parse_costs("""$MTD_JSON""")
yday = parse_costs("""$YESTERDAY_JSON""")

mtd_total = sum(mtd.values())
yday_total = sum(yday.values())

days_elapsed = today.day - 1
days_in_month = 30
monthly_projected = (mtd_total / max(days_elapsed, 1)) * days_in_month if days_elapsed > 0 else 0

def short_name(svc):
    mapping = {
        'Amazon Elastic Container Service': 'ECS (Fargate)',
        'EC2 - Other': 'EC2/NAT Gateway',
        'AmazonCloudWatch': 'CloudWatch',
        'Amazon Elastic Load Balancing': 'Load Balancer',
        'Amazon Relational Database Service': 'RDS (Postgres)',
        'Amazon ElastiCache': 'ElastiCache (Redis)',
        'Amazon Virtual Private Cloud': 'VPC/NAT',
        'AWS Secrets Manager': 'Secrets Manager',
        'Amazon Route 53': 'Route 53',
        'Amazon EC2 Container Registry (ECR)': 'ECR',
        'Amazon Simple Storage Service': 'S3',
        'Tax': 'Tax (HST)',
    }
    for k, v in mapping.items():
        if k in svc:
            return v
    if 'Bedrock' in svc or 'Claude' in svc:
        return 'Bedrock (AI)'
    return svc[:35]

lines = []
lines.append(f"*💰 AttuneWell AWS Cost Report — {today.strftime('%b %d, %Y')}*")
lines.append("")
lines.append(f"*Yesterday:* \${yday_total:.2f}")
lines.append(f"*Month-to-date ({month_start.strftime('%b %d')} → today):* \${mtd_total:.2f}")
lines.append(f"*Projected monthly:* \${monthly_projected:.0f}")
lines.append("")
lines.append("*MTD by service:*")

sorted_mtd = sorted(mtd.items(), key=lambda x: -x[1])
for svc, amt in sorted_mtd:
    if 'Tax' in svc:
        continue
    name = short_name(svc)
    lines.append(f"  • {name}: \${amt:.2f}")

tax = mtd.get('Tax', 0)
if tax > 0:
    lines.append(f"  + Tax: \${tax:.2f}")

lines.append("")
budget = 200
pct = (mtd_total / budget) * 100
days_in = today.day
days_total = 31
day_pct = (days_in / days_total) * 100
if pct > day_pct + 15:
    lines.append(f"⚠️ Spend pace: {pct:.0f}% of \${budget} budget with {days_in} days elapsed ({day_pct:.0f}% of month)")
else:
    lines.append(f"✅ Spend pace: {pct:.0f}% of \${budget} budget ({days_in} days in, on track)")

msg = '\n'.join(lines)

# Post to Slack via openclaw
import subprocess
result = subprocess.run(
    ['openclaw', 'slack', 'send', '--channel', 'C0A7J6YJSKZ', '--text', msg],
    capture_output=True, text=True
)
print(result.stdout)
print(result.stderr)
PYEOF
