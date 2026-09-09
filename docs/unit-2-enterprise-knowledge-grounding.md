# Unit 2: Enterprise Knowledge and Grounding

## Overview

In this unit, you'll give **Lightbulb-Agent** evidence it can retrieve and cite. You'll compare three source patterns:

1. **Grounding with Bing Search** for current public information
2. **Uploaded files** for quick, agent-specific grounding
3. **Foundry IQ knowledge bases** for reusable, curated enterprise knowledge backed by Azure AI Search

The required hands-on path uses all three SmartGlow documents as uploaded agent files. Where Azure AI Search capacity and Foundry IQ are available, an optional extension moves the same sources into a reusable knowledge base.

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

For the optional Foundry IQ extension, you also need an **Azure AI Search S1** service provisioned and connected by workshop infrastructure.

> **⚠️ Important:** Azure AI Search is not required for the core workshop path. When enabled, infrastructure provisions and connects the S1 Search service but does **not** automatically create a Foundry IQ knowledge base. Knowledge sources and the knowledge base must be authored in the portal or prepared before the session.

---

## Concept: Select the Source Before the Tool

| Source | Best for | Strength | Tradeoff |
|---|---|---|---|
| **Grounding with Bing Search** | Current public facts and news | Fresh, broad coverage with web citations | Public data, variable authority, data leaves the Azure compliance boundary, usage-based cost |
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
6. Never substitute public web or GitHub results for configured SmartGlow knowledge.

### Curated Source Authority

The three workshop documents intentionally demonstrate that “newest” and “authoritative” must be evaluated by subject, not applied as one global rule:

| Source | Version/freshness | Authoritative for | Precedence rule |
|---|---|---|---|
| [`lightbulb-manual.md`](./assets/lightbulb-manual.md) | Version 1.0, updated 2025 | Product specifications, supported colors, state behavior, and feature limitations | Remains authoritative for product capabilities |
| [`smartglow-support-policy.md`](./assets/smartglow-support-policy.md) | Version 2.0, effective August 15, 2026 | Participant support, deployment actions, and workshop warranty claims | Explicitly supersedes conflicting manual instructions in those subjects |
| [`smartglow-operations-runbook.md`](./assets/smartglow-operations-runbook.md) | Version 1.1, reviewed August 20, 2026 | Organizer health checks, incident response, escalation data, and operational troubleshooting | Use for operator procedures; do not expose organizer-only details unnecessarily |

Freshness metadata helps resolve conflicts, but date alone is not enough. Source ownership, audience, subject, and an explicit supersession statement determine authority.

Think of an employee handbook published in 2020 and a policy memo issued last month. The memo does not replace the handbook wholesale — it supersedes it only on the topics it actually addresses. For everything else, the handbook still stands. That is exactly the relationship between the product manual and the support policy below, and it is why "newest wins" is the wrong rule to teach an agent.

---

## Steps

### Step 1: Add Current Public Knowledge

The workshop uses **Grounding with Bing Search**, preprovisioned as a G1 resource and connected to your Foundry project.

Foundry offers more than one way to reach the public web. Both are generally available and both are Bing-backed; they differ in **who owns the resource**:

| | **Grounding with Bing Search** (this workshop) | **Web search** |
|---|---|---|
| Bing resource | Created and owned by your organization | Managed by Microsoft |
| Project connection | An explicit connection you configure and can audit | None required |
| Roles needed | Contributor or Owner to create the resource; Foundry Project Manager to create the connection | No roles beyond project access |
| Parameters | `count`, `freshness`, `market`, `set_lang` | `user_location`, `search_context_size` |
| Models | Azure OpenAI models and Foundry models sold by Azure | Azure OpenAI models |

The workshop teaches the enterprise-managed path. When your organization creates the Bing resource and the project connection, the dependency becomes a resource you can see in your subscription, place under RBAC, attribute cost to, and revoke. That visibility is the point: an agent's external dependencies should appear in the same inventory and controls as the rest of your estate, not arrive as an implicit capability.

Web search is a reasonable choice for a quick prototype, where not having to create a Bing resource is an advantage rather than a gap. It is not preview — it is a different ownership model.

1. Open **Build** > **Agents** > **Lightbulb-Agent**.
2. In **Tools**, select the preprovisioned **Grounding with Bing Search** connection for the workshop.
3. Save the agent.
4. Test:

   ```
   What are the latest developments in smart-home lighting? Cite the public sources you used.
   ```

Confirm that the answer is current and includes usable citations. Do not use this source for private SmartGlow policy.

> **⚠️ Data boundary:** Grounding with Bing Search is a First Party Consumption Service. Data sent to it **flows outside the Azure compliance and Geo boundary**, and the Microsoft Data Protection Addendum does not apply to it. It is governed by the Grounding with Bing terms of use and carries its own usage-based cost. Owning the resource gives you control over the connection; it does not move the data back inside the Azure boundary. Confirm both points with your compliance owner before using web grounding in production. The same boundary applies to Web search and to Grounding with Bing Custom Search **(preview)**.

#### Note: Web IQ

You may hear **Web IQ** discussed alongside the tools above. It is a different thing, and the naming overlap with Foundry IQ causes real confusion, so it is worth separating here.

Web IQ is one of four capabilities in **Microsoft IQ**, the intelligence layer Microsoft describes across its stack:

| Capability | Provides |
|---|---|
| **Work IQ** | Context on people, collaboration, and workflows |
| **Fabric IQ** | Business entities, relationships, properties, and rules |
| **Foundry IQ** | Curated institutional knowledge — policies, authoritative documents, reusable knowledge bases (Unit 2's optional extension) |
| **Web IQ** | Retrieval of current information from the public web |

So Foundry IQ and Web IQ are siblings in the same family, one pointed at your curated internal knowledge and one at the open web. That is the useful mental model, and it maps onto the distinction this unit already makes between private evidence and public evidence.

How Web IQ differs from the tools you configured:

- It returns **structured, citation-ready data to the developer** with passage-level retrieval, rather than handing the agent a grounded answer. Your code decides what enters the model's context.
- Microsoft positions it as agent-native, aimed at multi-step workflows needing fine-grained control over retrieval and orchestration, and positions Grounding with Bing as the entry point for search-style web augmentation.
- It is currently **limited access**.

**This workshop does not use Web IQ.** Grounding with Bing Search is the correct tool for the workshop scenario and for most agents that need a grounded, cited answer from the public web. Web IQ is worth investigating when you need control over the retrieved passages themselves. Check current availability and terms before planning around it.

### Step 2: Upload the SmartGlow Workshop Files

1. Review the product manual, support policy, and operations runbook. Identify their different owners, audiences, and areas of authority.
2. In the agent's **Tools** or **Knowledge** area, choose the portal option for uploading files or file search.
3. Upload all three workshop files and wait for processing to finish:
   - `lightbulb-manual.md`
   - `smartglow-support-policy.md`
   - `smartglow-operations-runbook.md`
4. Save the agent.
5. Add this **source rule** to the agent instructions:

   ```
   For SmartGlow facts, use only the configured workshop files or Foundry IQ knowledge base. Do not use public web search, GitHub search, model knowledge, or a similarly named repository as a fallback. Cite the configured document used. If the configured sources do not contain the answer, say what evidence is missing instead of searching the public web.
   ```

   This rule says *which sources are allowed*. It deliberately does not yet say which document wins when two of them disagree — you'll add that in Step 5, after seeing the conflict for yourself.

6. Test:

   ```
   What colors does the SmartGlow 101 support, and can I set brightness to 50%?
   ```

Expected evidence: the answer names the supported presets, explains the brightness limitation, and cites the manual.

Treat a fluent answer as a failure if its citation points to public GitHub, another workshop repository, or any source other than the configured `lightbulb-manual.md`.

### Optional Step 3: Create or Inspect a Curated Foundry IQ Knowledge Base

> **🎤 Instructor demonstration:** Steps 3–4 are normally demonstrated rather than performed by participants, because the uploaded files from Step 2 carry every later unit. Run them yourself only if your facilitator says the schedule allows.

Complete this extension only when Azure AI Search and Foundry IQ are available. Otherwise, continue to Step 5 with the uploaded files.

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

> **📝 Note:** Uploading files to one agent and creating reusable Foundry IQ knowledge sources are separate operations. If indexing cannot complete, keep the uploaded files connected and continue with the core workshop.

### Optional Step 4: Connect and Test the Knowledge Base

1. Open **Lightbulb-Agent**.
2. Add the prepared or newly created `smartglow-workshop-kb` from the agent's knowledge configuration.
3. If the same documents are still attached through file search, follow the instructor's direction: temporarily remove the duplicate file attachment or use traces to make the intended retrieval path unambiguous.
4. Save the agent and start a new conversation.
5. Continue to Step 5 and run the same required tests against the knowledge base. Compare its retrieval trace and citations with the uploaded-file baseline.

### Step 5: Test Precedence, Citations, and Missing Evidence

Use whichever SmartGlow knowledge source is configured: the uploaded workshop files from Step 2 or the optional Foundry IQ knowledge base from Steps 3–4.

First, test retrieval across all three sources:

```
A participant's light resets after the service restarts, and then the app becomes unavailable. Is the reset expected, should the participant rerun azd up, and what should the support owner do? Cite each workshop document you rely on.
```

The answer should:

- Cite the manual for in-memory state and the expected reset behavior.
- Cite the newer support policy to tell the participant **not** to rerun `azd up`, redeploy, change RBAC, or restart services during the live workshop.
- Cite the operations runbook for health checks, support-owner troubleshooting, and reassignment or escalation.
- Explain that the support policy supersedes conflicting manual deployment, support, and warranty-claim instructions.
- Avoid treating all three documents as equally authoritative for every subject.

**Append** this **precedence rule** below the source rule you added in Step 2. That rule is still in the agent's instructions — instructions persist across conversations, so starting a new conversation in the optional steps did not remove it. The new rule adds authority by subject and does not repeat what the source rule already says:

```
For SmartGlow sources, apply authority by subject. Use Product Manual version 1.0 for specifications and supported capabilities. Use Support Policy version 2.0 for participant support, deployment actions, and warranty claims because it explicitly supersedes conflicting manual guidance. Use Operations Runbook version 1.1 for organizer health checks and incident response. Cite source titles and versions. When sources conflict outside these rules, show the conflict and ask for human clarification.
```

You now have two short rules that do different jobs: one restricts *which* sources are allowed, the other decides *which one wins* by subject. Keep them separate — when routing misbehaves later, you want to know which of the two failed.

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

### Step 6: Make the Enterprise Decision

You have now seen three source patterns behave differently on the same questions. Decide which one you would take into a real workload, and record why against the four questions that determine source choice:

- **Authority:** Who owns and approves each source, and who resolves conflicts between them?
- **Permissions:** Must retrieval honor the caller's identity or source ACLs, or is the corpus uniformly readable?
- **Residency and compliance:** Where are content, queries, and telemetry processed? Web grounding leaves the Azure boundary; uploaded files and Search do not.
- **Scale:** Is this knowledge attached to one agent, or shared across agents, teams, and environments?

Freshness, citation quality, cost, and Search tier matter just as much, but they are operational commitments rather than source-selection criteria. They appear in the production checklist in [Unit 8, Step 3](./unit-8-version-publish-and-operate.md).

The decision is rarely one pattern. It is usually uploaded files for a narrow, agent-specific corpus, a shared knowledge base for anything two agents both need, and web grounding only where public currency genuinely matters.

---

## Summary

You grounded the agent with current public information and authoritative uploaded workshop files. Where capacity permitted, you also compared that baseline with a reusable multi-source Foundry IQ knowledge-base pattern.

### What's Next

In **[Unit 3: Instructions and Capability Routing](./unit-3-instructions-and-capability-routing.md)**, you'll turn these source decisions into a concise routing contract.

All later units use the configured SmartGlow knowledge source and do not require Azure AI Search specifically.

---

## Key Concepts

- **Grounding** — Basing an answer on retrieved evidence rather than model training alone.
- **Grounding with Bing Search** — Web grounding through a Bing resource your organization creates, connects, and governs.
- **File Search** — Agent-specific retrieval over uploaded files, useful for quick experiments.
- **Foundry IQ** — A managed knowledge layer for reusable, multi-source, permission-aware retrieval.
- **Web IQ** — The Microsoft IQ capability for public-web retrieval, returning structured passages to the developer. Limited access; not used in this workshop.
- **Knowledge Source** — A configured connection to indexed or remote content.
- **Knowledge Base** — A reusable resource that groups sources and retrieval parameters.
- **Citation Fidelity** — Whether claims can be traced to the evidence actually used.
- **Source Precedence** — Selecting authority by subject, ownership, version, and explicit supersession rather than by retrieval rank alone.
- **Conflict Handling** — Exposing incompatible evidence and applying an explicit authority rule.
- **Missing Evidence** — Stating that the curated sources do not establish an answer instead of guessing or substituting an inappropriate source.
