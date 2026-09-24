---
description: Implement an approved feature plan with tests and reviews
argument-hint: <feature name matching docs/plans/*.md>
---
Feature: $ARGUMENTS
1. Read docs/plans/$ARGUMENTS.md, the design and OpenAPI contract.
2. Delegate in dependency order (parallel where independent): backend-developer, frontend-developer, media-engineer, infra-engineer.
3. After each task: tester verifies, then code-reviewer reviews; fix blockers.
4. Run security-reviewer if auth, uploads, user content, IAM or networking changed.
5. Verify docs/definition-of-done.md. Summarize what shipped, tests added and follow-ups.
