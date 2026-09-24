# Roadmap (drive with /plan-feature and /build-feature)
Profile: FREE until Phase 8. Develop locally first; deploy to the single `main` env for integration.
- Phase 0 Foundation (LOCAL ONLY, no credits spent): repo, docker-compose, CI, free-profile Terraform (validate/plan only), walking skeleton (/bootstrap-project)
- Phase 1 Identity: sign up/in (Cognito), profiles, avatars, settings
- Phase 2 Posts: create/delete, replies, quotes, link previews. END OF PHASE 2 = FIRST AWS APPLY in ap-south-2 (`main`), after cost-guardian review and budget alerts
- Phase 3 Media (images/GIF): upload pipeline, CDN, moderation hooks
- Phase 4 Graph + Timeline: follow/unfollow, hybrid fanout (active-follower fanout), blocks/mutes
- Phase 5 Engagement: likes, reposts, counters, notifications, push, realtime
- Phase 6 Discovery: Postgres FTS search, suggested accounts, reports + moderation tools
- Phase 7 Beta hardening: rate limits, backups + restore drill, capacity ceiling + graceful degradation, accessibility, security review; production-reviewer GO-FOR-BETA; store beta tracks (TestFlight/Play internal)
- Phase 8 Scale-up (trigger: launch decision, growth, or credits/plan ending): follow docs/runbooks/scale-up-playbook.md; video, OpenSearch, Aurora, multi-AZ, WAF, multi-account; load tests 2x-10x; GO-FOR-PUBLIC-LAUNCH
- Phase 9 Public launch and operations
Non-AWS costs to budget: Apple Developer Program (annual), Google Play developer fee (one-time), domain name.
