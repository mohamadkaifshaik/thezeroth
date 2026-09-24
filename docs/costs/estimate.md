# Rough monthly cost estimate, free profile, ap-south-2 (UNVERIFIED: cost-guardian must confirm via the AWS Pricing API)
| Item | Est. USD/month |
|---|---|
| EC2 t3.micro (1, always on) | 9-12 |
| EBS 30 GB | 3-4 |
| RDS PostgreSQL db.t4g.micro single-AZ | 13-17 |
| RDS storage 20 GB | 3-4 |
| ElastiCache Valkey cache.t3.micro | 12-16 |
| Public IPv4 (Elastic IP) | ~4 |
| Route 53 zone | 0.5 |
| S3, CloudFront, SQS, SNS, Lambda, DynamoDB, SSM, Cognito | 0-3 (within always-free allowances at beta scale) |
| CloudWatch, X-Ray, ECR | 0-3 |
| **Total without ALB (default)** | **~45-60** |
| ALB + its public IPv4s (if edge_mode=alb) | +20-25 |
| **Total with ALB** | **~65-85** |
Credits of $100-$200 therefore cover roughly 2-4 months of ALWAYS-ON runtime. Levers: delay first apply, stop EC2/RDS when idle (RDS auto-restarts after 7 days), destroy ElastiCache when idle (cannot be stopped), keep dev local.
