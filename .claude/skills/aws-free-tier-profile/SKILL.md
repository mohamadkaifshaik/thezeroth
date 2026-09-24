---
name: aws-free-tier-profile
description: Cost guardrails for a CREDIT-BASED AWS account in ap-south-2: allowlist/denylist, region availability checks, budgets, ECS-on-EC2 and Valkey specifics, credit-burn math and surprise-charge checklist. Use for ANY infra, architecture or Terraform work.
---
# Account facts
Credit-based account (after 15 Jul 2025): $100 + up to $100 credits, Free plan max 6 months or until credits are used, then closure unless upgraded. No 12-month free hours. Never join AWS Organizations while on credits. Region ap-south-2 (Hyderabad). Record dates in ADR 0001. Check status with the console Billing > Credits and (if your CLI supports it) `aws freetier get-account-plan-state` / `get-free-tier-usage`.

# Region availability checks (run before writing Terraform; stop if empty)
- aws ec2 describe-instance-type-offerings --region ap-south-2 --filters Name=instance-type,Values=t3.micro
- aws rds describe-orderable-db-instance-options --region ap-south-2 --engine postgres --db-instance-class db.t4g.micro --query 'OrderableDBInstanceOptions[].EngineVersion'
- aws elasticache describe-reserved-cache-nodes-offerings --region ap-south-2 --cache-node-type cache.t3.micro
- aws elasticache describe-cache-engine-versions --region ap-south-2 --engine valkey
Known NOT available in ap-south-2: AWS Elemental MediaConvert, Amazon Managed Grafana.

# Allowlist (free profile; all consume credits except always-free items)
EC2 t3.micro x1, EBS <= 30 GB, RDS PostgreSQL db.t4g.micro single-AZ 20 GB, ElastiCache Valkey cache.t3.micro x1 (node-based), S3, CloudFront (global; ACM cert in us-east-1), one Elastic IP, SQS, SNS, Lambda, DynamoDB (<=25 GB), SSM Parameter Store Standard, ECR (keep last 5 images), CloudWatch (7-day logs), X-Ray (sampled), Cognito, SES (email), Route 53 zone, Budgets.

# Denylist (needs cost-guardian + human approval)
ALB (unless edge_mode=alb approved), NAT Gateway, Aurora, RDS Proxy, Multi-AZ, OpenSearch, MSK/Kinesis, Fargate, WAF, Secrets Manager, customer KMS keys, Container Insights, VPC interface endpoints, Global Accelerator, extra Elastic IPs/public IPv4s, GuardDuty/Config/Security Hub/Inspector, second EC2 instance, cross-region data transfer, MediaLive/MediaConnect and other Elemental services.

# Specifics
- ECS on EC2: launch template with ECS-optimized AMI (from the SSM parameter), ASG min=max=1, capacity provider. bridge network mode, fixed host port for the api, Caddy TLS sidecar, hard memory limits (api 300 MB, worker 200 MB, caddy 40 MB), 1 GB swap in user_data, standard (not unlimited) T3 credits, watch CPUCreditBalance. Build images for linux/amd64.
- Valkey: same clients/commands as Redis; ~0.5 GB; TTLs + volatile-lru; assume no durability.
- No NAT: EC2 in a public subnet; inbound only from the CloudFront prefix list; no SSH (SSM Session Manager). RDS/ElastiCache in private subnets reachable only from the app SG. S3 and DynamoDB gateway endpoints (free).
- Push via FCM from the worker (no SNS mobile push). Search via Postgres FTS. Video disabled.
- Stop-when-idle: stop EC2 (EBS still billed), stop RDS (auto-restarts after 7 days), ElastiCache cannot be stopped (snapshot + delete, restore later). Provide `make aws-pause` / `make aws-resume` scripts (infra-engineer).

# Guardrails
- Budgets on GROSS cost (credits excluded) at $20/$40/$60 monthly plus a weekly manual credit-balance check; billing alerts on.
- Tag everything (project, env, profile, service). Optional resources gated by profile variables.
- Delete unused EBS volumes, snapshots, EIPs, old ECR images, log groups.
- Do most work locally; use AWS for integration and release rehearsal only; short small load tests.
- Surprise list: ALB hours, NAT Gateway, public IPv4 hourly fee, orphaned EBS/EIP, RDS storage/backup > 20 GB, CloudWatch log ingestion, CloudFront invalidations, data transfer out, ElastiCache left running while idle.
- Estimated burn is in docs/costs/estimate.md (~$45-60/month without ALB). Credits last ~2-4 months always-on.
