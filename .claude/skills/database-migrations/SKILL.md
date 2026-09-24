---
name: database-migrations
description: Safe, zero-downtime PostgreSQL schema migrations (expand/contract). Use for any schema change.
---
- Tooling: golang-migrate or atlas; versioned files in backend/migrations; run as a dedicated pipeline step before app rollout.
- Expand -> migrate/backfill -> contract across separate releases. Never drop/rename in the same release as code that stops using it.
- Additive first: nullable columns, new tables, CREATE INDEX CONCURRENTLY. Avoid long locks; set lock_timeout and statement_timeout.
- Backfills in small batches with throttling and resumability; never in a single transaction on big tables.
- Test up/down on realistic data volume; keep rollback notes in the PR.
- Partition or shard plan for large tables (posts, likes, follows) documented in the design.
