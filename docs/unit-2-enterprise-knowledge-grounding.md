# Unit 2: Enterprise Knowledge and Grounding

## Overview

In this 25-minute unit, you'll give **Lightbulb-Agent** evidence it can retrieve and cite. You'll compare three source patterns:

1. **Web search** for current public information
2. **Uploaded files** for quick, agent-specific grounding
3. **Foundry IQ knowledge bases** for reusable, curated enterprise knowledge backed by Azure AI Search

The hands-on path begins with the SmartGlow manual, then uses multiple workshop documents to create or inspect a curated knowledge base where the environment permits.

> **📝 Preview note:** Foundry IQ availability varies by feature and API version. The Microsoft Foundry and Azure portal experiences for agentic retrieval are preview. Check the current [Foundry IQ documentation](https://learn.microsoft.com/azure/foundry/agents/concepts/what-is-foundry-iq) before production adoption.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed [Unit 1](./unit-1-agent-scope-and-boundaries.md)
- ✅ Access to **Lightbulb-Agent** in the Foundry playground
- ✅ The workshop files:
  - [`assets/lightbulb-manual.md`](./assets/lightbulb-manual.md)
  - [`assets/smartglow-support-policy.md`](./assets/smartglow-support-policy.md)
  - [`assets/smartglow-operations-runbook.md`](./assets/smartglow-operations-runbook.md)
- ✅ The **Azure AI Search S1** service provisioned and connected by workshop infrastructure

> **⚠️ Important:** Infrastructure provisions and connects the S1 Search service. It does **not** automatically create a Foundry IQ knowledge base. Knowledge sources and the knowledge base must be authored in the portal or prepared before the session.

---

## Concept: Select the Source Before the Tool

| Source | Best for | Strength | Tradeoff |
|---|---|---|---|
| **Web search** | Current public facts and news | Fresh, broad coverage with web citations | Public data, variable authority, external-query considerations |
| **Uploaded files / file search** | Fast proof of concept with a few controlled documents | Simple, agent-specific setup | Manual refresh and limited reuse/governance |
| **Foundry IQ knowledge base** | Shared enterprise content across sources and agents | Curated retrieval, citations, reusable knowledge, permission-aware patterns | Requires source design, Search capacity, identity, and lifecycle ownership |

Foundry IQ uses Azure AI Search as the underlying indexing and retrieval infrastructure. A **knowledge base** references one or more **knowledge sources** and controls retrieval behavior; it is not the same thing as the Search service itself.

### Evidence Rules

Teach the agent to:

1. Prefer the source closest to the business fact.
2. Cite evidence used in the answer.
3. Surface conflicts instead of silently choosing a convenient source.
4. Say when evidence is missing or stale.
5. Use the web only when freshness or public context is required.

### Curated Source Authority

The three workshop documents intentionally demonstrate that “newest” and “authoritative” must be evaluated by subject, not applied as one global rule:

| Source | Version/freshness | Authoritative for | Precedence rule |
|---|---|---|---|
| [`lightbulb-manual.md`](./assets/lightbulb-manual.md) | Version 1.0, updated 2025 | Product specifications, supported colors, state behavior, and feature limitations | Remains authoritative for product capabilities |
| [`smartglow-support-policy.md`](./assets/smartglow-support-policy.md) | Version 2.0, effective August 15, 2026 | Participant support, deployment actions, and workshop warranty claims | Explicitly supersedes conflicting manual instructions in those subjects |
| [`smartglow-operations-runbook.md`](./assets/smartglow-operations-runbook.md) | Version 1.1, reviewed August 20, 2026 | Organizer health checks, incident response, escalation data, and operational troubleshooting | Use for operator procedures; do not expose organizer-only details unnecessarily |

Freshness metadata helps resolve conflicts, but date alone is not enough. Source ownership, audience, subject, and an explicit supersession statement determine authority.

---

## Steps

### Step 1: Add Current Public Knowledge

1. Open **Build** > **Agents** > **Lightbulb-Agent**.
2. In **Tools**, review the available web options.
3. Use the instructor-designated **Grounding with Bing Search** connection if it was preprovisioned for the workshop. If the portal presents **Web search (preview)** instead, follow the instructor's configuration and treat it as a preview capability.
4. Save the agent.
5. Test:

   ```
   What are the latest developments in smart-home lighting? Cite the public sources you used.
   ```

Confirm that the answer is current and includes usable citations. Do not use this source for private SmartGlow policy.

### Step 2: Upload the SmartGlow Manual

1. Review [`assets/lightbulb-manual.md`](./assets/lightbulb-manual.md). Identify supported colors, limitations, troubleshooting, safety, and warranty details.
2. In the agent's **Tools** or **Knowledge** area, choose the portal option for uploading files or file search.
3. Upload `lightbulb-manual.md` and wait for processing to finish.
4. Save the agent.
5. Add this routing rule to the agent instructions:

   ```
   For SmartGlow product specifications, supported features, safety, and product behavior, use the SmartGlow Product Manual before public web search. Cite the document used. If the document does not contain the answer, say what evidence is missing.
   ```

6. Test:

   ```
   What colors does the SmartGlow 101 support, and can I set brightness to 50%?
   ```

Expected evidence: the answer names the supported presets, explains the brightness limitation, and cites the manual.

### Step 3: Compare Source Selection

Run these prompts and inspect citations or tool activity:

| Prompt | Intended source |
|---|---|
| `According to the product manual, how do I make a warranty claim?` | Uploaded manual, while clearly identifying it as version 1.0 guidance |
| `What are today's smart-home headlines?` | Web search |
| `What does SmartGlow support require before escalation?` | Missing until the support policy is included |

For the third prompt, a correct answer should disclose missing evidence rather than search the public web for an internal policy. The first prompt establishes an intentionally stale baseline that the curated knowledge base will correct.

### Step 4: Create or Inspect a Curated Foundry IQ Knowledge Base

This exercise has two supported workshop modes.

| Mode | Participant action | Instructor/pre-session action |
|---|---|---|
| **Authoring available** | Create sources and a knowledge base in the portal | Ensure permissions, model support, and S1 Search connection are ready |
| **Prepared environment** | Inspect, connect, and test the prepared knowledge base | Create and index the knowledge sources before the session |

#### Participant authoring path

1. In the Foundry project, select **Build** > **Knowledge**.
2. Select the connected workshop **Azure AI Search S1** service.
3. Create knowledge sources for:
   - `lightbulb-manual.md`
   - `smartglow-support-policy.md`
   - `smartglow-operations-runbook.md`
4. Create a knowledge base named:

   ```
   smartglow-workshop-kb
   ```

5. Add the three knowledge sources and use the workshop defaults for retrieval.
6. Wait for source processing or indexing to complete.

#### Prepared-environment path

1. Open **Build** > **Knowledge**.
2. Select `smartglow-workshop-kb`.
3. Inspect its knowledge sources and verify that all three workshop documents are present.
4. Note who owns source refresh, access control, and promotion to production.

> **📝 Note:** Uploading a file to one agent and creating a reusable Foundry IQ knowledge source are separate operations. If indexing cannot complete during the unit, continue with the prepared knowledge base or use the manual upload for the remaining tests.

### Step 5: Connect and Test the Knowledge Base

1. Open **Lightbulb-Agent**.
2. Add the prepared or newly created `smartglow-workshop-kb` from the agent's knowledge configuration.
3. If the same documents are still attached through file search, follow the instructor's direction: temporarily remove the duplicate file attachment or use traces to make the intended retrieval path unambiguous.
4. Save the agent and start a new conversation.
5. Test across the curated set:

   ```
   A participant's light resets after the service restarts, and then the app becomes unavailable. Is the reset expected, should the participant rerun azd up, and what should the support owner do? Cite each workshop document you rely on.
   ```

The answer should:

- Cite the manual for in-memory state and the expected reset behavior.
- Cite the newer support policy to tell the participant **not** to rerun `azd up`, redeploy, change RBAC, or restart services during the live workshop.
- Cite the operations runbook for health checks, support-owner troubleshooting, and reassignment or escalation.
- Explain that the support policy supersedes conflicting manual deployment, support, and warranty-claim instructions.
- Avoid treating all three documents as equally authoritative for every subject.

### Step 6: Test Precedence, Citations, and Missing Evidence

Add this rule to the instructions:

```
For SmartGlow sources, apply authority by subject. Use Product Manual version 1.0 for specifications and supported capabilities. Use Support Policy version 2.0 for participant support, deployment actions, and warranty claims because it explicitly supersedes conflicting manual guidance. Use Operations Runbook version 1.1 for organizer health checks and incident response. Cite source titles and versions. When sources conflict outside these rules, show the conflict and ask for human clarification.
```

Test the intentional conflict:

```
The manual says I can rerun azd up to make a warranty claim. The workshop app is unavailable right now. What should I do, and which source controls?
```

The answer should follow and cite **Support Policy version 2.0**, explain that it supersedes the manual for participant deployment and warranty claims, and direct the participant to the designated support owner. It may cite the runbook only for organizer-facing remediation.

Verify domain-specific routing:

| Prompt | Expected authoritative source |
|---|---|
| `Which colors and power states are supported?` | Product Manual version 1.0 |
| `May a participant change RBAC during the live workshop?` | Support Policy version 2.0 |
| `What should an organizer check when MCP cannot connect?` | Operations Runbook version 1.1 |

Test a question not covered by the sources:

```
What is SmartGlow's policy for international warranty transfers?
```

A strong response cites no irrelevant source, says the curated evidence does not establish such a policy, and directs the user to the policy owner. Absence of evidence is not permission to invent a rule or search the public web for a private policy.

### Step 7: Make the Enterprise Decision

For a real workload, document:

- **Authority:** Who owns and approves each source?
- **Freshness:** How is content refreshed and stale content retired?
- **Permissions:** Must retrieval honor the caller's identity or source ACLs?
- **Residency and compliance:** Where are content, queries, and telemetry processed?
- **Scale:** Is knowledge shared across agents, teams, or environments?
- **Quality:** How will citation fidelity, coverage, and conflicting evidence be evaluated?
- **Cost:** What Search tier, indexing, model, and query volume are required?

---

## Summary

You grounded the agent with current public information and authoritative workshop content, then moved from an agent-specific file to a reusable multi-source knowledge-base pattern.

### What's Next

In **[Unit 3: Instructions and Capability Routing](./unit-3-instructions-and-capability-routing.md)**, you'll turn these source decisions into a concise routing contract.

---

## Key Concepts

- **Grounding** — Basing an answer on retrieved evidence rather than model training alone.
- **File Search** — Agent-specific retrieval over uploaded files, useful for quick experiments.
- **Foundry IQ** — A managed knowledge layer for reusable, multi-source, permission-aware retrieval.
- **Knowledge Source** — A configured connection to indexed or remote content.
- **Knowledge Base** — A reusable resource that groups sources and retrieval parameters.
- **Citation Fidelity** — Whether claims can be traced to the evidence actually used.
- **Source Precedence** — Selecting authority by subject, ownership, version, and explicit supersession rather than by retrieval rank alone.
- **Conflict Handling** — Exposing incompatible evidence and applying an explicit authority rule.
- **Missing Evidence** — Stating that the curated sources do not establish an answer instead of guessing or substituting an inappropriate source.
