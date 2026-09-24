---
name: mobile-release
description: Build, sign and ship Flutter apps to App Store, Google Play and web. Use for client releases and store readiness.
---
- Versioning: semver + build numbers from CI. Flavors dev/staging/prod.
- CI: Fastlane or Codemagic/GitHub Actions macOS runners; secrets via CI store; signing via match/Play App Signing.
- iOS: TestFlight internal -> external -> phased release. Android: internal -> closed -> staged rollout (1% -> 10% -> 50% -> 100%). Halt rollout on crash-free rate < 99.5%.
- Web: `flutter build web`, upload to S3, CloudFront invalidation, versioned assets, cache headers, rollback by previous artifact.
- Store readiness: privacy labels/data safety form, UGC moderation + report/block features (required), account deletion in-app (required), permissions strings, screenshots, ATT/consent if tracking.
- Force-upgrade mechanism via remote config for breaking API changes.
- Crash-free rate, ANR, startup and adoption monitored for 48h after each rollout.
