---
name: api-conventions
description: REST/OpenAPI conventions for errors, pagination, idempotency, versioning and codegen between Go and Flutter. Use when creating or changing any endpoint or client call.
---
- backend/api/openapi.yaml is the source of truth. Go server stubs via oapi-codegen; Dart client via openapi-generator (dart-dio). Regenerate on every change; CI fails on drift.
- Routes: /v1/posts, /v1/users/{id}/followers, /v1/timelines/home. Plural nouns; verbs only for actions (POST /v1/posts/{id}/like).
- IDs are opaque strings (snowflake/ULID). Never expose sequential DB IDs.
- Pagination: ?limit=&cursor= -> { data: [], next_cursor }. Max limit 100.
- Errors: { error: { code, message, request_id, details? } } with correct HTTP status and stable code enum.
- POST create endpoints accept Idempotency-Key. 429 includes Retry-After.
- Auth: Bearer JWT (Cognito). Every handler authorizes at the object level.
- Additive changes only within a version; breaking change => /v2.
