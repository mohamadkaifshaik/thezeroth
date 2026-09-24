# Project: Text-first social platform (Twitter-like) with media uploads

Goal: a high-end, horizontally scalable, production-ready app. Web, iOS and Android from one Flutter codebase; Go backend on AWS.
Cost strategy: build on the AWS FREE profile first; keep a SCALE profile one variable-flip away (see docs/runbooks/scale-up-playbook.md).

## Product scope

Short text posts, replies, quotes, reposts, likes, follow graph, home timeline, profiles, notifications (in-app + push), media (images, GIF; video behind a flag), search, blocks/mutes/reports, basic moderation tooling.

## AWS account & region (confirmed)

- Account type: CREDIT-BASED (created after 15 Jul 2025). $100 credits + up to $100 more via onboarding tasks (launch+terminate an EC2 instance, create an RDS database, deploy a Lambda function, try a Bedrock prompt, create a Budget). The Free plan ends at 6 months or when credits are used, then the account closes unless upgraded to Paid (remaining credits carry over). There are NO 12-month free instance hours.
- Region: ap-south-2 (Hyderabad), 3 AZs. Everything lives here except CloudFront-related global pieces: ACM certificates for CloudFront (and WAF for CloudFront) must be created in us-east-1 (Terraform provider alias).
- Joining an AWS Organization / Control Tower expires credits => ONE standalone account in the free profile.
- NOT available in ap-south-2 (checked Sep 2026): AWS Elemental MediaConvert, Amazon Managed Grafana. Available: EC2 (T3/T4g), ECS, ECR, RDS, Aurora, ElastiCache, S3, CloudFront, Cognito, SES, SNS, SQS, Lambda, DynamoDB, SSM, X-Ray, OpenSearch, WAF, GuardDuty, Kinesis, MSK, Managed Prometheus. Always verify specific instance/engine offerings in-region before writing Terraform (commands in skill aws-free-tier-profile).
- Credit burn (rough estimates, cost-guardian must verify with the AWS Pricing API): always-on free profile without ALB ~ $45-60/month; with ALB ~ $65-85/month => credits last roughly 2-4 months. Therefore: do NOT provision AWS until needed (first `terraform apply` at the end of Phase 2), keep everything else local, and stop idle resources.
- Aurora, RDS Proxy, NAT Gateway, ALB, WAF, Secrets Manager, customer KMS keys, OpenSearch, MSK, Fargate are paid (consume credits). Always-free allowances exist for e.g. Lambda, DynamoDB (25 GB), SQS/SNS (1M requests), CloudFront, CloudWatch basics.
- Record the account creation date and credit expiry in docs/adr/0001-free-tier-profile.md (the 6-month clock started at account creation).

## Profiles (Terraform var `profile`, files in infra/terraform/profiles/)

| Concern       | FREE profile (default now)                                                                        | SCALE profile (before public launch)                                                               |
| ------------- | ------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Compute       | ECS on EC2, t3.micro, bridge networking, 1 instance                                               | ECS Fargate (or EC2 ASG), multi-AZ, autoscaling                                                    |
| Database      | RDS PostgreSQL db.t4g.micro, single-AZ, 20 GB                                                     | Aurora PostgreSQL multi-AZ + readers                                                               |
| Cache         | ElastiCache for Valkey cache.t3.micro, 1 node                                                     | Valkey replicated, multi-AZ (cluster mode if needed)                                               |
| Search        | Postgres FTS (tsvector + pg_trgm)                                                                 | OpenSearch                                                                                         |
| Queues        | SQS + SNS                                                                                         | SQS/SNS, Kinesis/MSK if fanout demands                                                             |
| Media         | S3 + CloudFront; images/GIF only, Go worker                                                       | + video (MediaConvert only exists in ap-south-1; or ffmpeg workers), signed URLs                   |
| Secrets/keys  | SSM Parameter Store (Standard) + AWS-managed keys                                                 | Secrets Manager + CMKs                                                                             |
| Network       | Public subnets for compute (SG locked to ALB), private for data, NO NAT                           | Private subnets + NAT/VPC endpoints                                                                |
| Edge          | CloudFront -> EC2 origin (no ALB; SG allows only CloudFront prefix list), app-level rate limiting | ALB behind CloudFront + WAF                                                                        |
| Observability | CloudWatch logs (7d), few metrics/alarms, X-Ray sampled                                           | + Managed Prometheus + self-hosted Grafana (Managed Grafana not in ap-south-2), container insights |
| Accounts      | 1 account, env = `main` (+ local docker-compose)                                                  | dev/staging/prod accounts via Organizations                                                        |

## Stack (unchanged in both profiles)

Flutter (BLoc, go_router, freezed, Dio) | Go 1.22+ (chi/echo, sqlc + pgx, OpenAPI via oapi-codegen / openapi-generator) | Cognito auth | Terraform | GitHub Actions + OIDC | OpenTelemetry | Push notifications via FCM HTTP v1 (free; covers Android, iOS, web) sent from the worker, not SNS mobile push.

## Architecture rules that make free -> scale painless

- Modular monolith first: two binaries, `cmd/api` and `cmd/worker`, with domain packages (users, posts, graph, timeline, media, notify, search) behind interfaces so they can be extracted into services later.
- Ports & adapters: Cache, Queue, Search, ObjectStore, MediaProcessor, PushSender, Ranker are interfaces; free and scale adapters chosen by config. Never call AWS/Redis SDKs from domain code.
- Memory budget on t3.micro (1 GiB): OS+ECS agent ~300 MB, api <= 300 MB, worker <= 200 MB, leave headroom; add a 1 GB swap file in user_data.
- DB: pgxpool max 10 conns per binary; keep total < 50. No long transactions. Indexes reviewed with EXPLAIN.
- Valkey (~0.5 GB): timelines capped (~200 IDs) with TTL for inactive users, `maxmemory-policy volatile-lru`, never the only copy of data; must be rebuildable from Postgres.
- ECS on t3.micro: use `bridge` network mode (awsvpc is limited by ENIs on micro instances). Free profile has no ALB, so the api uses a fixed host port behind a Caddy/TLS sidecar; dynamic ports only if edge_mode=alb.
- Free-profile deploys are rolling with a short blip (minimumHealthyPercent=0); no canary until the scale profile.

## Repo layout

backend/ (cmd/api, cmd/worker, internal/, pkg/, migrations/, api/openapi.yaml) | app/ (Flutter) | infra/terraform/ (modules/, envs/main, profiles/) | docker-compose.yml (local Postgres, Valkey, LocalStack, MinIO) | docs/

## Team and workflow (always follow)

planner -> architect -> ux-designer -> [backend-developer | frontend-developer | media-engineer | infra-engineer] -> tester -> code-reviewer + security-reviewer -> cost-guardian (any infra/cost impact) -> production-deployer (deploy) -> production-reviewer (GO/NO-GO) -> production-deployer (prod, human-approved).

- No implementation before spec + design exist. Developers stop and ask when unclear.
- Most development and testing happens LOCALLY (docker compose) to save credits. AWS is for integration and release rehearsal.
- Production/AWS-changing actions (terraform apply, deploys, DNS, prod migrations) need explicit human approval.
- Any Terraform plan adding a resource outside the free allowlist (skill aws-free-tier-profile) needs cost-guardian sign-off AND human approval.

## Engineering rules

- Stateless services, idempotent handlers, timeouts + retries with jitter + circuit breakers, graceful shutdown.
- Cursor pagination only. Time-sortable IDs. Authn + object-level authz + validation + rate limit on every endpoint.
- Never proxy media through the API; never store media in Postgres.
- Migrations expand/contract. No secrets in code; SSM/Secrets Manager only. Least-privilege IAM.
- Every feature: tests, metrics, runbook entry, feature flag if risky.

## Targets

FREE profile (beta, honest ceiling): ~1-5k DAU, ~50 rps peak, timeline p99 < 500 ms, single-AZ so availability ~99%, RPO 24 h (daily snapshots), RTO 4 h.
SCALE profile: timeline p99 < 300 ms, post create p99 < 500 ms, 99.95% availability, RPO <= 5 min, RTO <= 30 min.

## Commands (fill in as scaffolding lands)

make up (docker compose) | make backend-test | make app-test | make infra-plan PROFILE=free | make cost-check
