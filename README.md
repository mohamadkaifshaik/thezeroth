# Claude Code team setup (Go + AWS FREE-TIER + Flutter)
1. Copy CLAUDE.md, .claude/, docs/, infra/ into your repo root; commit. Requires `jq` for the format hook.
2. Run `claude`, `/agents` to confirm the 13 agents loaded. Account: credit-based, region ap-south-2.
3. Start: `/bootstrap-project` -> `/plan-feature <feature>` -> approve -> `/build-feature <feature>` -> `/cost-check` -> `/release <version>`.
AWS/production changes always pause for your approval. See docs/runbooks/scale-up-playbook.md for going beyond the free profile.
