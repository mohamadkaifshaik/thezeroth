---
description: Release: cost check, deploy, production review, human-approved rollout
argument-hint: <version>
---
Version: $ARGUMENTS
1. cost-guardian: docs/costs report (must not be RED).
2. production-deployer: preconditions, docs/releases/$ARGUMENTS.md, plan + migrations.
3. tester: regression + short load run per profile.
4. production-reviewer: verdict in docs/releases/$ARGUMENTS-review.md.
5. If verdict allows: show me the plan and ask approval; production-deployer proceeds (rolling on free, canary on scale) and watches rollback triggers.
