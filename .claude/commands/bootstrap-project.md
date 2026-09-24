---
description: Phase 0 (LOCAL ONLY): scaffold repo, local env, CI, free-profile Terraform plan and walking skeleton
---
Execute Phase 0 in docs/roadmap.md. Do NOT run terraform apply or create AWS resources.
1. Ask me (one question): the AWS account creation date and current credit balance/expiry (fill ADR 0001).
2. architect: baseline design + ADRs (profile mechanics, modular monolith, edge mode, data, auth, observability).
3. infra-engineer: run in-region availability checks (ap-south-2), docker-compose local env, Terraform baseline for the `free` profile (validate/plan only), CI with GitHub OIDC, budgets definition, `make aws-pause/aws-resume` scripts.
4. backend-developer: Go skeleton (api + worker, health, auth middleware, OpenAPI codegen, sqlc, migrations, ports with free adapters incl. FCM PushSender, Makefile).
5. frontend-developer: Flutter skeleton (flavors, theme, router, generated API client, FCM wiring) on iOS, Android, web.
6. tester: CI harness. cost-guardian reviews the plan and updates docs/costs/estimate.md with real Pricing API numbers.
Stop with a walking skeleton running locally and a reviewed plan; wait for my approval before any AWS apply (planned for end of Phase 2).
