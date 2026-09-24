---
name: deployment-runbook
description: Deployment, release and rollback procedure, profile-aware. Use for every deploy and release.
---
1. Preconditions: CI green, images scanned, release doc, rollback plan, no active incident, budget/credits healthy (cost-guardian).
2. Order: infra (terraform plan reviewed) -> DB expand migrations -> worker -> api -> clients/web.
3. FREE profile (edge_mode=cloudfront_direct): fixed host port + ECS rolling deploy with minimumHealthyPercent=0 and maximumPercent=100 (one t3.micro cannot host old+new tasks and a fixed port cannot be shared); expect a few seconds of blip; deployment circuit breaker on; container health check plus an external synthetic probe through CloudFront; smoke test immediately; keep previous image tag for one-command rollback (update service to previous task definition).
4. SCALE profile: canary 5% -> 25% -> 100% via weighted target groups or CodeDeploy, auto-abort on SLO burn.
5. Staging: FREE profile has no separate staging account: rehearse with docker compose + a temporary `terraform plan` diff; release = deploy to `main` behind feature flags/ramping. SCALE: real staging soak of 15+ min.
6. Human approval before any AWS/production change. Never force flags.
7. Rollback: previous task definition/image, flip feature flag; never roll back destructive migrations (expand/contract).
8. Post-deploy: dashboards, budget check, close release doc.
