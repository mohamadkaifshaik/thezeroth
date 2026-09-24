---
description: Triage a production incident and produce a postmortem
argument-hint: <symptom>
---
Symptom: $ARGUMENTS
Use production-reviewer (read-only) to gather evidence, propose mitigation (rollback first), and after resolution write docs/runbooks/postmortem-<date>.md with timeline, root cause, impact, and action items assigned to agents.
