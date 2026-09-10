# Unit 8: Version, Publish, and Operate

## Overview

This unit is a discussion and review unit. **You do not deploy anything, and nothing here can fail.** If you had trouble with the earlier labs, you can still complete this one.

The question it answers: you have an agent that works — how do you release it without being afraid of every change?

The answer is to separate two ideas that beginners usually merge:

- A **version** is a saved snapshot of the agent's configuration. Making a version is how you make a change reversible.
- **Publishing** is exposing an agent to consumers. A **stable endpoint** is one fixed address they call.

Because the endpoint stays the same, you can change which version sits behind it — or roll back — without anyone re-pointing their application.

> **📝 Note:** Foundry is moving from the older **Agent Application + Deployment** model to a newer agent model, so your portal may show either. Both give you a stable endpoint. See the [migration comparison](https://learn.microsoft.com/azure/foundry/agents/how-to/migrate-agent-applications).

---

## Prerequisites

- ✅ Completed [Unit 7](./unit-7-prove-and-improve-quality.md), or at least read it
- ✅ A **Lightbulb-Agent** you consider working
- ✅ A note of which earlier version you would fall back to

Instructor access to publishing and RBAC is needed only to *demonstrate* Step 1. You can read Step 1 without it.

---

## Concept: Separate Change from Release

| Model | Production entry point |
|---|---|
| **New agent model** | The Agent owns the endpoint, identity, and version selector |
| **Legacy model** | An Agent Application and Deployment expose the selected version |

One thing that surprises people: **publishing can change the runtime identity.** The agent stops running as *you* and starts running as its own workload identity. Permissions that worked while you were testing may not exist for the published agent, so a tool that worked in the playground can fail in production.

---

## Steps

### Step 1: Review the Release

Walk through this with your instructor, or just read it if you have no publishing access:

1. Select the evaluated agent version.
2. Identify the version you would roll back to.
3. Open the stable endpoint and the version selector.
4. Review the agent identity, authentication policy, and RBAC scope.
5. If your environment uses the legacy model, look at the Agent Application and Deployment.
6. Change the selected version, then change it back — **without touching the endpoint**.

Step 6 is the whole point. The approved version changed; the address consumers call did not.

### Step 2: Choose the Delivery Path

| Need | Delivery path |
|---|---|
| Build and test | Foundry portal |
| Integrate an application | SDK or REST API |
| Release across environments | CI/CD with approvals |
| Share with end users | Approved app, API, Teams, or Microsoft 365 channel |

Give consumers invoke access to the published resource. Do not give them project-wide development access.

### Step 3: Check Production Readiness

This is the list to run before an agent takes real traffic. It looks long, but it is only five questions:

**Can I undo this?**

- The evaluated version and the rollback version are both written down
- The stable endpoint passes a smoke test after every promotion
- CI/CD blocks a promotion that nobody reviewed

**Is it running as the right identity?**

- The runtime identity has least-privilege access — only what the agent actually needs
- You re-checked its role assignments *after* publishing. As you saw in Unit 5, a published agent gets a **new** identity, and earlier grants do not follow it
- OAuth on-behalf-of (OBO) is used when an action must respect the *user's* permissions rather than the agent's

**Is every action still controlled?**

- The backend authorizes and logs every write — never the tool description alone
- Guardrails and approval rules have been tested, including the "does it still allow legitimate work" case from Unit 6

**Is the knowledge trustworthy?**

- Each source has a named owner, a refresh expectation, access rules, and a citation expectation

**Will I know when it breaks?**

- Application Insights monitoring, alerts, retention, and privacy controls are configured
- Rate limits, quotas, and cost limits are set
- Incident response and support ownership are documented — a named person, not a team inbox

### Step 4: Choose the Next Capability

| Requirement | Consider |
|---|---|
| Custom code or runtime control | **Hosted agents** |
| Personalized cross-session context | **Memory** |
| Scheduled or event-driven execution | **Routines** |
| Durable background work | **Long-running agent patterns** |
| Delegation between agents | **A2A (Agent2Agent)** |
| Review before consequential actions | **Human-in-the-loop** |

Several capabilities can be preview or region-dependent. Check the [Feature Maturity table](../README.md#feature-maturity) before planning delivery.

Choose a capability only after defining its purpose, authority, evaluation evidence, and operating owner.

### Enterprise Takeaway

Promote an evaluated version behind a stable endpoint. Verify the runtime identity and permissions, automate the release with approval gates, and keep a tested rollback path.

---

## Summary

You've completed the agent lifecycle:

1. Define scope and boundaries
2. Ground responses in approved knowledge
3. Route requests to the correct capability
4. Connect tools and actions
5. Reuse tools and guidance
6. Govern agent actions
7. Evaluate and improve quality
8. Version, publish, and operate

The lightbulb is only the workshop example. The same lifecycle applies to enterprise agents that retrieve data, call systems, and perform governed actions.

---

## Key Concepts

- **Agent Version** — A snapshot used for evaluation, release, and rollback.
- **Stable Agent Endpoint** — The production address that remains stable across version changes.
- **Agent Application** — The legacy resource that exposes an agent version through an endpoint and identity.
- **Agent Identity** — The workload identity used by the running agent.
- **Distribution** — Making the agent available through an approved application or channel.
- **Operational Readiness** — Evidence that quality, safety, identity, telemetry, cost, and ownership are production-ready.
