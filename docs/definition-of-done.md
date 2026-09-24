# Definition of Done (merge gate)
- Spec acceptance criteria all covered by passing automated tests
- Lint, static analysis, `go test -race`, `flutter analyze/test` green in CI
- OpenAPI updated; generated clients regenerated; no breaking change within a version
- Authn/authz, validation, rate limiting on every new endpoint
- Metrics, traces, structured logs; dashboard and alarm with runbook for new critical paths
- Migrations backward-compatible and tested up/down on a copy of realistic data
- Security review done when required; no high/critical findings open
- Feature flag for risky changes; rollback path documented
- Docs, ADRs and runbooks updated
