# 0001 Free-tier-first deployment profile
- Status: Accepted
- Context: Minimal budget. Account is CREDIT-BASED (created after 15 Jul 2025): $100 credits + up to $100 via onboarding tasks; Free plan lasts max 6 months or until credits are used, then account closes unless upgraded to Paid. Organizations membership expires credits. Region is ap-south-2 (Hyderabad).
- Decision: `free` Terraform profile (see CLAUDE.md) in ONE standalone account; local docker-compose for dev; first AWS apply at the end of Phase 2. Start on the Free plan (no surprise bills); upgrade to Paid before month 5 or when credits < 20%, whichever is first, to avoid account closure. Set the Budgets/credit alerts before any resource exists.
- Account facts to fill in: creation date = TODO; credit balance = TODO; credit expiry = TODO; plan = Free | Paid.
- Alternatives: Fargate + Aurora from day one (burns credits in weeks); another cloud.
- Consequences: single-AZ, single instance, no HA, rolling deploys with a blip, beta-scale ceiling, ~2-4 months of always-on runtime from credits. Public launch requires the scale-up playbook and the Paid plan.
