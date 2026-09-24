---
name: feed-fanout-design
description: Home timeline, fanout, counters and ranking design, profile-aware (free vs scale). Use for timeline, follow graph or notification delivery work.
---
- Hybrid fanout: fanout-on-write into Valkey sorted sets (score = post ID) for normal accounts; fanout-on-read merge above a follower threshold (~100k scale; ~2k free) to avoid write storms.
- Free profile memory math: Valkey ~0.5 GB (usable ~375 MB). Timeline = 200 IDs x ~16 B ~ 3-4 KB/user => ~50k cached users max; TTL 7 days, only fan out to recently active followers (active in last 7 days), rebuild others on read.
- Timelines hold IDs only; hydrate posts/authors/counters via pipelined batch reads; fall back to Postgres with covering indexes (author_id, id DESC).
- Fanout via SNS -> SQS -> worker; idempotent per (post_id, follower_id); DLQ; in free profile the worker runs in the same instance with bounded concurrency.
- Cache is rebuildable: cold-start builds a timeline from the follow graph (bounded, rate limited).
- Counters: Valkey INCR buffered and flushed to Postgres in batches; eventual consistency accepted.
- Deletes/blocks/mutes/privacy: read-time filters + lazy cleanup.
- Ranking: chronological baseline behind a Ranker interface.
- Always include capacity math for BOTH profiles: posts/s x avg active followers = timeline writes/s; memory = active users x timeline size.
- Degrade gracefully: serve stale timeline if DB/cache impaired.
