---
name: testing-strategy
description: Test pyramid and tooling for Go backend, Flutter clients and infra. Use when writing or planning tests.
---
- Go: unit (~70%, table-driven), integration (~20%, Testcontainers/localstack, migrations up/down), contract (OpenAPI validation), fuzz for parsers, -race always.
- Flutter: unit + widget + golden tests; integration_test/Patrol on Android emulator, iOS simulator, web (Chrome); accessibility checks (meetsGuideline).
- E2E (~10%): sign up, post with image, follow, home timeline, like, notification, delete account.
- Infra: terraform validate, tflint, checkov/tfsec, plan review; ephemeral env smoke tests.
- Load/perf: see load-testing. Security: SAST, dependency scan, DAST on staging.
- Every bug fix starts with a failing regression test. No sleeps; fixed clocks; seeded data.
- Coverage is a signal; every acceptance criterion needs a test.
