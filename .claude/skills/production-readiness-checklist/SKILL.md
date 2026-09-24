---
name: production-readiness-checklist
description: Evidence-based go/no-go checklist for releases, with free-profile and scale-profile verdict tiers.
---
Every item needs evidence. State the active profile first.
Verdict tiers:
- GO-FOR-BETA (free profile): allowed with known limits (single-AZ, single instance, brief deploy blip). Requires: security basics, backups verified (RDS snapshot restore drill done once), budget alerts live, rate limiting on, kill switches/feature flags, rollback tested, legal/moderation basics, capacity ceiling documented and enforced (graceful 429/503).
- GO-FOR-PUBLIC-LAUNCH (scale profile only): all beta items plus everything below.
Reliability: multi-AZ, autoscaling verified, timeouts/retries/circuit breakers, DLQs drained, failover tested (DB, cache, AZ).
Data: PITR + cross-region backups, restore drill, expand-only migrations, RPO/RTO met.
Performance: load test at 2x+ peak within SLOs; no unbounded queries.
Security: no open high/critical; WAF on; secrets rotated; IAM reviewed; pen test; GuardDuty/Security Hub on; privacy flows.
Observability: dashboards, SLO alerts + runbooks, tracing, synthetics, on-call paging tested.
Cost: budgets, forecast at launch traffic, no runaway loops, credits/plan status known (free plan ends within 6 months!).
Product/compliance: ToS/privacy, moderation + report/block, app-store UGC and account-deletion requirements, accessibility.
Verdict: NO-GO / GO-WITH-CONDITIONS / GO-FOR-BETA / GO-FOR-PUBLIC-LAUNCH.
