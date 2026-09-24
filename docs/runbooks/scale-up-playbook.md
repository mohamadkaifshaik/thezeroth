# Scale-up playbook (free -> scale)
Trigger any of: public launch date set, >1k concurrent users, credits < 20%, p99 or CPU-credit exhaustion on t3.micro, need for HA.
1. Upgrade to the Paid plan (keeps remaining credits). Set budgets first.
2. Create AWS Organization + accounts (dev, staging, prod, logging/security). Note: credits end when joining an Organization; plan cutover accordingly.
3. Apply scale.tfvars in staging; migrate data: RDS Postgres -> Aurora (snapshot restore or DMS), rehearse twice.
4. Swap adapters via config: Valkey replicated multi-AZ, OpenSearch (reindex from Postgres), Fargate services with autoscaling, MediaConvert video, WAF, Secrets Manager/CMKs, NAT + endpoints.
5. Load test at 2x-10x target on staging; failure drills (AZ, DB failover, cache failover); restore drill.
6. production-reviewer issues GO-FOR-PUBLIC-LAUNCH; canary rollout; keep free env as rollback until stable.
