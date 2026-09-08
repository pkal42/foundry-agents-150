# Unit 5: Toolboxes and Skills

## Overview

In this 17-minute unit, you'll address an enterprise scaling problem: duplicating tool connections, credentials, and behavioral guidance across many agents.

You'll consume a prepared, versioned **Toolbox** and **Skill** rather than installing CLI extensions or authoring long configuration files. The focus is the operating model: reusable tools, centralized authentication and governance, controlled version promotion, and safe adoption by agents.

> **📝 Preview note:** Toolboxes and Skills evolve quickly and can have regional, model, SDK, or portal limitations. Treat them as preview unless the current [Toolbox documentation](https://learn.microsoft.com/azure/foundry/agents/how-to/tools/toolbox) and [Skills documentation](https://learn.microsoft.com/azure/foundry/agents/how-to/tools/skills) state otherwise for your exact scenario.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed [Unit 4](./unit-4-mcp-tools-and-actions.md)
- ✅ Access to the preprovisioned workshop environment
- ✅ An instructor-prepared `lightbulb-toolbox`
- ✅ An instructor-prepared, versioned `lightbulb-assistant` Skill

> **⚠️ Important:** Participants do not install or update `azd`, create credentials, or author Toolbox YAML in this unit. Those are platform-team or pre-session responsibilities.

---

## Concept: Scale the Capability, Not the Copy-and-Paste

Without a shared capability layer, every agent independently configures the same endpoints and authentication.

| Problem | Enterprise impact |
|---|---|
| Duplicate connections | Configuration drift and expensive updates |
| Duplicate credentials | Larger secret-management and rotation surface |
| Inconsistent descriptions | Unpredictable tool selection |
| Embedded guidance | Policy updates require editing every agent |
| No version boundary | Changes reach consumers without controlled promotion |

A **Toolbox** packages approved tools behind a managed endpoint. A **Skill** packages reusable behavioral or procedural guidance. Both should follow a version lifecycle.

### Centralized Does Not Mean Uncontrolled

Central management should establish:

- Named owners and reviewers
- Approved authentication patterns
- Least-privilege identities
- Versioned changes and promotion criteria
- Consumer inventory and rollback procedures
- Telemetry, policy, and incident response

Each consuming agent still needs an explicit purpose and should attach only capabilities required for that purpose.

---

## Steps

### Step 1: Inspect the Prepared Toolbox

Open the instructor-provided `lightbulb-toolbox` in the supported Foundry or toolkit experience.

Confirm:

| Item | What to inspect |
|---|---|
| Version | Immutable version identifier and current/default status |
| Tools | Microsoft Learn read tools and lightbulb read/write tools |
| Descriptions | Clear selection guidance and side-effect language |
| Authentication | Centrally configured connection type; no participant-owned secrets |
| Consumers | Which agents or environments use this version |

> **📝 Note:** Connecting non-Foundry tools can send data outside the Foundry compliance boundary. Platform owners must review each external service's terms, data handling, and cost.

### Step 2: Inspect the Prepared Skill

Open the prepared `lightbulb-assistant` Skill and identify its contract:

```markdown
---
name: lightbulb-assistant
description: Shared operating guidance for approved SmartGlow controls.
---

# Lightbulb Assistant

- Read current state before using toggle when a target state is requested.
- Use only supported colors.
- Report success only from tool evidence.
- Escalate ambiguous or higher-impact requests instead of guessing.
```

A Skill is guidance, not a permission grant. It cannot authorize a tool call that the identity or backend denies.

### Step 3: Consume the Prepared Capability

Follow the instructor's prepared path for the current environment:

1. Open **Lightbulb-Agent**.
2. Add or select the prepared `lightbulb-toolbox`.
3. Select the instructor-designated published/default version.
4. Confirm that the expected tools and prepared Skill are discoverable.
5. Save the agent.

If the agent already has direct Microsoft Learn and lightbulb MCP connections, remove duplicates only after confirming the Toolbox exposes equivalent tools. Keep a rollback path to the prior agent version.

### Step 4: Verify Behavior

Run:

```
Check the light. If it is off, turn it on, set it to white, and report the final state.
```

Confirm:

- The Toolbox exposes the expected tools
- The agent reads state before conditionally toggling
- The supported color is passed through the schema
- The response follows the prepared Skill
- The target application visibly reflects the change

Then ask:

```
Set brightness to 50%.
```

The agent should reject the unsupported capability rather than inventing a tool.

### Step 5: Walk Through Skill Promotion

The instructor demonstrates this promotion flow without changing the participant environment:

1. Create a new Skill version.
2. Review its diff and compatibility with existing consumers.
3. Test it against a non-default Toolbox or agent version.
4. Run routing, safety, and regression evaluations.
5. Promote the approved version.
6. Monitor consumers and roll back if quality degrades.

Do not assume that every consumer updates immediately or in the same way. Record whether consumers pin a version or follow a promoted default.

---

## Summary

You've consumed a prepared Toolbox and Skill and reviewed the enterprise controls that make shared capabilities safer than duplicated agent configuration.

### What's Next

In **[Unit 6: Safe and Governed Actions](./unit-6-safe-and-governed-actions.md)**, you'll layer guardrails, identity, backend authorization, and human approval around those capabilities.

---

## Key Concepts

- **Toolbox** — A managed, versioned collection of tools exposed to approved consumers.
- **Skill** — Reusable, versioned behavioral or procedural guidance.
- **Centralized Authentication** — Managing approved connection patterns and credentials outside each individual agent.
- **Promotion** — Moving a tested version into approved or default use.
- **Consumer Contract** — The versions, tools, schemas, identities, and behaviors an agent depends on.
- **Rollback** — Restoring a known-good capability or agent version after regression.
