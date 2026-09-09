# Unit 8: Version, Publish, and Operate

## Overview

This instructor-led close moves the agent from a project development asset toward an operated service. The instructor connects versioning and rollback, publishing, identity and RBAC, distribution, automation, and the next capability decision.

> **📝 Terminology note:** Foundry is transitioning from the legacy **Agent Application + Deployment** model to a new agent object model. New agents have a stable `agent_endpoint` and unique identity; “publish” then refers to distribution to Microsoft 365 or Teams. Older environments can still expose a stable endpoint through an Agent Application. See the [migration comparison](https://learn.microsoft.com/azure/foundry/agents/how-to/migrate-agent-applications) and [legacy Agent Application guidance](https://learn.microsoft.com/azure/foundry/agents/how-to/agent-applications).

---

## Prerequisites

- ✅ Completed [Unit 7](./unit-7-prove-and-improve-quality.md)
- ✅ A known-good, evaluated **Lightbulb-Agent** version
- ✅ Instructor access to the project's publish and RBAC experiences

---

## Concept: Separate Change from Release

- An **agent version** captures instructions, model, tools, and related configuration for comparison and rollback.
- In the **new model**, the Agent owns its stable endpoint, unique identity, authorization schemes, and version selector.
- In the **legacy model**, publishing creates an **Agent Application** and Deployment with a stable endpoint and separate identity/RBAC scope.
- **Distribution publishing** makes the stable agent endpoint available through supported Microsoft 365 or Teams channels.
- Updating the version selected behind a stable endpoint should be a controlled release with rollback, not an untracked edit.

Publishing can change the runtime identity. Reassign the least-privilege permissions required by knowledge and tools; development permissions do not necessarily transfer.

---

## Steps

### Step 1: Instructor Publish Walkthrough

The instructor:

1. Selects the evaluated agent version and identifies the rollback version.
2. Opens the current experience and shows the Agent's stable endpoint and version selector.
3. Reviews the dedicated agent identity, authentication policy, and RBAC scope.
4. If the environment uses the legacy model, shows the **Agent Application** and Deployment that route the stable endpoint to an approved version.
5. Shows how to update or roll back the selected version without changing the consumer-facing endpoint.
6. Distinguishes endpoint release from publishing that endpoint to Microsoft 365 or Teams.

### Step 2: Choose a Distribution and Delivery Path

| Need | Path |
|---|---|
| Build and test interactively | Foundry portal |
| Integrate an application | SDK or REST/Responses API |
| Repeat releases across environments | CI/CD with versioned configuration and approval gates |
| Share with end users | Approved web app, API consumer, Teams, or Microsoft 365 channel where supported |

Never distribute project-wide development access when consumers only need invoke permission on the published resource.

### Step 3: Production Checklist

- Evaluated version and rollback version recorded
- Stable endpoint smoke-tested
- Agent identity granted least-privilege RBAC and downstream API scopes
- OAuth OBO used where actions must preserve end-user authority
- Backend authorization and audit verified for every write
- Knowledge freshness, ACLs, citations, and owners defined — the operational half of the source decision made in [Unit 2, Step 6](./unit-2-enterprise-knowledge-grounding.md)
- Guardrails and human-approval policy tested
- Application Insights monitoring, alerts, retention, and privacy controls configured
- Rate limits, quotas, cost thresholds, incident response, and support ownership documented
- CI/CD prevents unreviewed configuration or capability promotion

### Step 4: Next-Capability Decision Map

| If the requirement is... | Consider... | Status reminder |
|---|---|---|
| Custom code, framework, or runtime control | **Hosted agents** | Check supported runtimes and regions |
| Personalized cross-session context | **Memory** | **Preview where indicated**; define consent, retention, deletion, and isolation |
| Scheduled or event-driven execution | **Routines** | **Preview where indicated**; govern unattended actions |
| Durable multi-step background work | **Long-running/autopilot patterns** | **Preview/architecture-dependent**; require checkpoints, cancellation, and recovery |
| Delegation between specialized agents | **A2A (Agent2Agent)** | **Preview where indicated**; authenticate peers and constrain delegated authority |
| Consequential decisions requiring review | **Human-in-the-loop** | **Preview**; design explicit approval, timeout, escalation, and audit behavior |

Choose the next capability only after defining its purpose, authority, evaluation evidence, and operating owner.

The current preview and availability status of each capability above is recorded in the **Feature Maturity** table in the [workshop README](../README.md#feature-maturity). Check it before committing to a delivery date — several of these move quickly.

---

## Summary

You've now seen the lifecycle end to end: define boundaries, ground knowledge, route capabilities, connect tools, reuse capabilities, govern actions, prove quality, then version, publish, and operate through a stable, authorized endpoint. What carries over to a real workload is the sequence and the questions asked at each stage, not the specific configuration of a workshop lightbulb.

---

## Key Concepts

- **Agent Version** — A snapshot used for evaluation, release, comparison, and rollback.
- **Stable Agent Endpoint** — The governed production entry point owned by a new Agent or, in the legacy model, an Agent Application.
- **Agent Application** — The legacy publishing resource that wraps an agent version with a stable endpoint, identity, and RBAC scope.
- **Agent Identity** — The workload identity used by the published agent at runtime.
- **Distribution** — Making the agent available through an approved application or channel without exposing the development project.
- **Operational Readiness** — Evidence that identity, authorization, quality, safety, telemetry, cost, and ownership are production-ready.
