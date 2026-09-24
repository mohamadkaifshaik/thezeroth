---
name: flutter-app-standards
description: Flutter architecture, performance and platform standards for iOS, Android and web. Use when writing or reviewing Flutter code.
---

- Structure: lib/core (network, storage, theme, routing, l10n), lib/features/<feature>/{data,domain,presentation}, lib/shared/widgets.
- State: BLoc (AsyncNotifier). Routing: go_router with deep links and typed routes. Models: freezed + json_serializable. Networking: generated Dio client, interceptors for auth refresh, retry, logging.
- Flavors: dev, staging, prod (dart-define / flavors) with separate Firebase/AWS configs.
- Performance: const widgets, ListView.builder/slivers, image caching and downsizing, avoid rebuild storms (select), isolates for heavy work, profile in --profile mode; startup budget < 2 s.
- Offline: local cache (drift or isar) for timeline and drafts; optimistic updates with reconciliation.
- Web: responsive breakpoints, URL strategy path, CanvasKit/wasm decision by ADR, SEO share pages via server-rendered meta for public posts.
- Accessibility & i18n: Semantics, dynamic type, l10n (ARB), RTL support.
- Quality: very_good_analysis lints, golden tests, integration_test, crash reporting and analytics behind an interface.
- Secure storage for tokens (flutter_secure_storage); no secrets in the bundle.
