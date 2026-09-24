# 0003 Free profile edge: CloudFront directly to EC2 (no ALB)
- Status: Proposed (default for free profile; flip `edge_mode = "alb"` if problems)
- Context: An ALB plus its public IPv4 addresses costs roughly $20+/month, about a third of the free-profile burn, and buys little with a single instance.
- Decision: CloudFront (free allowance) -> Elastic IP origin on 443. Caddy sidecar terminates TLS (Let's Encrypt on an origin hostname). Security group allows only the CloudFront origin-facing prefix list; CloudFront adds a secret header that the app verifies. Fixed host port; rolling deploy with minimumHealthyPercent=0. WebSockets/SSE work through CloudFront.
- Alternatives: ALB + ACM (simpler, paid); API Gateway (per-request cost, limits); direct public EC2 without CloudFront (no caching/DDoS buffer).
- Consequences: no load-balancer health checks; brief deploy blip; extra moving part (Caddy, origin cert renewal, header rotation). Requires a domain name. Migrate to ALB in the scale profile.
