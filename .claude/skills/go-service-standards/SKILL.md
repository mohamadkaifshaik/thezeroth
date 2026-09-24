---
name: go-service-standards
description: Go service structure, reliability and quality standards. Use when writing or reviewing any Go code.
---
- Layout: cmd/<svc>/main.go, internal/{http,service,repo,domain,platform}, migrations/. Handlers thin, business logic in service, SQL via sqlc in repo. Dependency injection by constructor, interfaces at consumer side.
- Config from env (12-factor), validated at startup. Secrets from Secrets Manager/SSM.
- Every request: context with deadline; propagate request_id and trace context. Every outbound call: timeout, retry with exponential backoff + jitter (idempotent only), circuit breaker, bulkhead.
- pgx pool sized per task; prepared statements; no unbounded queries; explicit indexes reviewed via EXPLAIN.
- Graceful shutdown (SIGTERM drain), /healthz (liveness), /readyz (dependencies).
- Logging: slog JSON, no PII. Metrics: RED per endpoint + business counters (Prometheus/OTel). Tracing: OTel.
- Concurrency: errgroup, no goroutine leaks, always -race in CI.
- Workers: at-least-once semantics, idempotent by key, DLQ, visibility timeout > processing time.
- Tooling: golangci-lint, govulncheck, gofumpt. Tests: table-driven, Testcontainers, fuzz where parsing.
