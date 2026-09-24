---
name: media-upload-pipeline
description: Secure, scalable media upload/processing/delivery, profile-aware. Use for any attachment feature on backend or client.
---
1. Client requests an upload session (type, size, sha256). API validates quota/limits, returns S3 presigned URLs (multipart for large), short expiry, content-type and size conditions, random key under uploads/.
2. Client uploads directly to S3 (resumable, progress, retry). Never via the API.
3. S3 event -> SQS -> worker: verify magic bytes, scan hook, strip EXIF/GPS, re-encode, variants (thumb/small/medium/large, WebP; AVIF only in scale), blurhash.
   - FREE profile: images/GIF only, processed by the Go worker with bounded concurrency (1-2) and small max dimensions to protect the t3.micro CPU credits and 200 MB memory budget. Video disabled (`FEATURE_VIDEO=false`). MediaConvert is NOT available in ap-south-2.
   - SCALE profile: video engine chosen by ADR: (a) MediaConvert in ap-south-1 (Mumbai) with buckets in ap-south-1 to avoid cross-region transfer, or (b) ffmpeg workers on Fargate/Batch in ap-south-2 producing HLS; plus more variants and autoscaled workers.
4. Status: pending -> processing -> ready | failed. Posts attach only ready media owned by the poster.
5. Serve through CloudFront (always-free allowance helps) with OAC, immutable hashed URLs; originals private.
6. Lifecycle: delete orphans after 24h; S3 lifecycle to IA/Glacier; propagate deletes; invalidate cache sparingly (invalidations cost after the free allowance) by using immutable URLs.
Limits (configurable): free profile image 5 MB, GIF 8 MB, 4 per post, per-user daily quota; scale: image 10 MB, GIF 15 MB, video 512 MB / 2:20.
