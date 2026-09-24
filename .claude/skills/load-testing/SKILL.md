---
name: load-testing
description: k6 load, stress, spike and soak testing, profile-aware. Use for timeline, posting, upload and fanout paths.
---
- Scenarios: read-heavy timeline (95% reads), post burst, viral post (hot key), high-follower fanout, upload storm, login storm.
- FREE profile: run mainly LOCALLY against docker compose sized to the same limits (1 GiB RAM cap, 2 vCPU throttled) to find bottlenecks and regressions. On AWS, run only short, small tests (<= 5 min, <= 50 rps) because t3 burst credits and credit budget are limited; watch CPUCreditBalance. Goal: prove the free-profile ceiling (~50 rps) and graceful degradation (429/503, no crashes).
- SCALE profile: staging sized like prod; ramp, hold at 1x/2x/5x peak, spike, 2h soak; failure modes (AZ loss, cache/DB failover, queue backlog).
- Watch: DB connections/CPU, cache memory/evictions, queue age, GC/memory per task, p99 per endpoint.
- Scripts in tests/load/; results in docs/perf/<date>.md with profile noted; CI gate on p99 regression > 20% (local run).
