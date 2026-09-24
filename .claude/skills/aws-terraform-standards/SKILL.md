---
name: aws-terraform-standards
description: Terraform and AWS structure standards, profile-aware (free vs scale). Use for any infra work or review.
---
- Read the profile first: infra/terraform/profiles/{free,scale}.tfvars and skill aws-free-tier-profile. Optional/paid resources are gated by variables (`count = var.enable_x ? 1 : 0`); modules take `profile` and switch implementation (ecs-service: ec2|fargate, database: rds|aurora, cache: single|replicated).
- State: S3 + DynamoDB lock (both free-tier friendly). Modules versioned; envs/main composes modules (scale adds envs/{staging,prod} in separate accounts). Pin providers. CI: fmt, validate, tflint, checkov, plan on PR; apply only via pipeline with approval.
- Network: free = VPC 2 AZ, public subnets for compute, private for data, no NAT; scale = 3 AZ private compute + NAT + endpoints. Public entry is always CloudFront: free = CloudFront -> EC2 origin (edge_mode=cloudfront_direct); scale = ALB behind CloudFront.
- Compute: free = ECS on EC2 (bridge, fixed host port, ASG 1/1, swap); scale = Fargate target-tracking autoscaling on CPU/RPS/SQS depth, deployment circuit breaker.
- Data: free = RDS PostgreSQL single-AZ + Valkey single node, encrypted with AWS-managed keys, 7-day backups; scale = Aurora multi-AZ + readers, replicated Valkey, PITR, cross-region backup copy.
- IAM: least privilege, per-service task roles, GitHub OIDC, no long-lived keys, no wildcards.
- Tags: project, env, profile, service. Budgets and alarms in every env.
- Every module ships alarms + runbook links, and a `cost_notes` output/README line with expected monthly cost per profile.
- Region ap-south-2: default provider region; add `provider "aws" { alias = "use1" region = "us-east-1" }` for CloudFront ACM certs and CloudFront-scoped WAF. Route 53 and CloudFront are global. Do not plan MediaConvert or Managed Grafana in ap-south-2.
- Before adding any resource type, verify it is offered in ap-south-2 (see aws-free-tier-profile verification commands).
