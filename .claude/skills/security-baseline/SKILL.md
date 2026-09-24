---
name: security-baseline
description: Security baseline for app, mobile and AWS, profile-aware. Use when implementing or reviewing anything touching auth, data, uploads, secrets, IAM or network.
---
- Verify JWT signature, issuer, audience, expiry in middleware; short access tokens, rotating refresh tokens.
- Object-level authorization on every read/write; deny by default. Validate/sanitize input; parameterized SQL; strict CSP/security headers on web.
- Rate limiting: free profile = app-level token bucket in Valkey per user/IP/endpoint (WAF is not free); scale = + WAF managed rules and bot control.
- Uploads: see media-upload-pipeline.
- Secrets: free = SSM Parameter Store SecureString (AWS-managed key); scale = Secrets Manager + rotation + CMKs. None in code, images, logs.
- Instance access: no SSH, no inbound rules except ALB; SSM Session Manager only. Data tier reachable only from the app security group.
- TLS everywhere (ACM free certs), encryption at rest, PII minimised, GDPR export/delete flows, retention policy.
- Supply chain: pinned deps, govulncheck, dart pub audit, container scan (Trivy in CI, free), SBOM.
- AWS detection: free = CloudTrail management events (free copy) + budgets alarms; enable GuardDuty/Security Hub before public launch.
- Mobile: secure storage for tokens, deep-link validation.
- Origin lock (free profile): EC2 security group allows 443 only from the CloudFront origin-facing managed prefix list; the app also requires a secret custom header set by CloudFront (rotate via SSM). Direct hits to the origin IP are rejected.
