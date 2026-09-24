---
name: observability-slo
description: SLOs, metrics, tracing, logging, alerting standards, profile-aware. Use when adding features to critical paths or reviewing readiness.
---
- SLIs per journey: timeline load, post create, upload success, login, notification latency.
- SLOs: free profile ~99% availability, timeline p99 < 500 ms; scale 99.95% and p99 < 300 ms. Error-budget policy: freeze releases when budget burns > 50% in 7 days.
- Alert on symptoms; every alarm links a runbook. FREE tier limits: keep to ~10 alarms and ~10 custom metrics; prefer a few high-value ones (5xx rate, p99 latency, CPUCreditBalance, free memory, DB connections/free storage, cache evictions, queue age, credit/budget).
- Logs: JSON to CloudWatch, 7-day retention in free profile (ingestion is billed beyond 5 GB), log at INFO, sample noisy logs.
- Traces: OTel, X-Ray sampled at 1-5% (100k traces/mo free) + 100% errors.
- Client: crash reporting (Firebase Crashlytics is free), jank/startup metrics, analytics behind an interface.
- Synthetic: one Route 53 health check or GitHub Actions cron probe hitting key flows.
- Scale profile adds Amazon Managed Prometheus + Grafana (Managed Grafana is not in ap-south-2: self-host Grafana or use CloudWatch dashboards), container insights, multi-region canaries.
