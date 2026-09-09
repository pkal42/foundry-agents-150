# Unit 2: Enterprise Knowledge and Grounding

## Overview

In this unit, you'll give **Lightbulb-Agent** information it can retrieve and cite. You will compare three ways to provide evidence:

1. **Grounding with Bing Search** for current public information
2. **Uploaded files** for quick, agent-specific grounding
3. **Foundry IQ knowledge bases** for reusable, curated enterprise knowledge backed by Azure AI Search

The required path uses uploaded SmartGlow files. An optional exercise shows how the same information can be managed as a reusable Foundry IQ knowledge base.

> **📝 Preview note:** The portal experience used for the optional Foundry IQ exercise is preview and might not be available in every environment.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed [Unit 1](./unit-1-agent-scope-and-boundaries.md)
- ✅ Access to **Lightbulb-Agent** in the Foundry playground
- ✅ The workshop files:
  - [`assets/lightbulb-manual.md`](./assets/lightbulb-manual.md)
  - [`assets/smartglow-support-policy.md`](./assets/smartglow-support-policy.md)
  - [`assets/smartglow-operations-runbook.md`](./assets/smartglow-operations-runbook.md)

The optional Foundry IQ exercise also requires a connected **Azure AI Search S1** service. Azure AI Search is not required for the core workshop path.

---

## Concept: Select the Source Before the Tool

| Source pattern | Use it for | Simple example |
|---|---|---|
| **Grounding with Bing Search** | Current public information | Recent smart-home news |
| **Uploaded files** | A small set of approved documents used by an agent | SmartGlow product and support files |
| **Foundry IQ knowledge base** | Curated knowledge reused across agents | A shared company support knowledge base |

Think of these as different shelves in a company library. Public web grounding is the news shelf, uploaded files are a folder prepared for one team, and Foundry IQ is a managed collection that many teams can reuse.

### How to Choose Evidence

The newest document does not automatically answer every question. **Use the source responsible for the subject.** A newer support policy can replace the support section of an older manual without replacing the manual's product specifications.

1. Use the source responsible for the subject and cite the evidence used.
2. Use the public web only for current public information; never substitute it for configured SmartGlow knowledge.
3. If evidence is missing or authority is unclear, state the gap instead of guessing.

| Subject | Authoritative source | Authority note |
|---|---|---|
| Product behavior and capabilities | [`lightbulb-manual.md`](./assets/lightbulb-manual.md), version 1.0 | Governs specifications, supported colors, state behavior, and feature limitations |
| Participant support and deployment actions | [`smartglow-support-policy.md`](./assets/smartglow-support-policy.md), version 2.0 | Supersedes conflicting manual guidance for support, deployment, and warranty claims |
| Health checks and incident response | [`smartglow-operations-runbook.md`](./assets/smartglow-operations-runbook.md), version 1.1 | Governs support-owner troubleshooting, escalation, and operational procedures |

An explicit supersession statement controls only the subjects it covers. If authoritative sources still conflict, show the conflict and request human clarification.

---

## Steps

### Step 1: Add Current Public Knowledge

The workshop uses **Grounding with Bing Search** for current public information. Your organization owns the Bing resource and its connection to the Foundry project.

1. Open **Build** > **Agents** > **Lightbulb-Agent**.
2. In **Tools**, select the preprovisioned **Grounding with Bing Search** connection for the workshop.
3. Confirm that no other web tool is selected. The agent should have one clear route to public information.
4. Save the agent.
5. Test:

   ```
   What are the latest developments in smart-home lighting? Cite the public sources you used.
   ```

Confirm that the answer includes current public sources.

Now ask:

```
What colors does the SmartGlow 101 support?
```

The agent might find a confident answer on the public web. The answer could even be correct, but the public web is not the approved source for SmartGlow product information.

This is like finding a company policy through an internet search instead of using the approved employee portal. The information might match, but you cannot rely on it as the company's authoritative source.

> **⚠️ Enterprise note — public-web data boundary:** When the agent uses Grounding with Bing Search, the search query is sent to the Bing service outside the Azure compliance and geographic boundary. The Microsoft Data Protection Addendum does not apply to this service; its own terms of use and usage-based charges apply. Owning the Bing resource gives your organization visibility, access control, cost attribution, and the ability to remove the connection, but it does not keep the query inside your Azure tenant. Before production use, decide what information may appear in search queries, avoid sending confidential or personal data, and confirm the design with your security and compliance owners.

### Step 2: Upload the SmartGlow Workshop Files

1. Review the product manual, support policy, and operations runbook. Notice that each document answers a different kind of question.
2. In the agent's **Tools** or **Knowledge** area, choose the portal option for uploading files or file search.
3. Upload all three workshop files and wait for processing to finish:
   - `lightbulb-manual.md`
   - `smartglow-support-policy.md`
   - `smartglow-operations-runbook.md`
4. Save the agent.
5. Add this **source rule** to the agent instructions:

   ```
   For SmartGlow facts, use only the configured SmartGlow files or Foundry IQ knowledge base. Do not use public web search, GitHub search, model knowledge, or a similarly named repository as a fallback. Cite the configured document used. If the configured sources do not contain the answer, say what evidence is missing instead of searching the public web.
   ```

   This rule says which sources are allowed for SmartGlow facts.

6. Test:

   ```
   What colors does the SmartGlow 101 support, and can I set brightness to 50%?
   ```

The answer should name the five supported colors, explain that brightness control is unavailable, and cite `lightbulb-manual.md`. Compare this citation with the public-web answer from Step 1.

### Step 3: Apply Source Authority

Append this rule below the source rule from Step 2:

```
For SmartGlow questions, use the source responsible for the subject. Use Product Manual version 1.0 for product behavior and capabilities, Support Policy version 2.0 for participant support and deployment actions, and Operations Runbook version 1.1 for support-owner troubleshooting and incident response. If the sources conflict outside these subjects, show the conflict and ask for human clarification.
```

Save the agent and start a new conversation.

#### Test 1: Use Multiple Sources

```
My SmartGlow 101 was on and blue. After the service restarted, it returned to off and white. The web application loads, but my agent can no longer control the light. What happened, what should I do, and what should the support owner check?
```

Check which source supports each part:

| Part of the answer | Expected source |
|---|---|
| Why the light reset | Product Manual version 1.0 |
| What the participant should do | Support Policy version 2.0 |
| What support should check | Operations Runbook version 1.1 |

#### Test 2: Recognize Missing Evidence

```
What is SmartGlow's policy for international warranty transfers?
```

The agent should say that the configured sources do not provide this policy and should direct the user to the policy owner. It should not guess or search the public web for a private company policy.

### Optional Step 4: Try Foundry IQ

> **🎤 Optional hands-on extension:** Complete this exercise only when Azure AI Search and Foundry IQ are available. If a prepared knowledge base exists, open it instead of creating another one. If indexing does not complete, reconnect the uploaded files and continue to Step 5.

1. In the Foundry project, open **Build** > **Knowledge** and select the connected workshop **Azure AI Search S1** service.
2. Create or open the knowledge base named `smartglow-workshop-kb`.
3. If you are creating it, add the three SmartGlow files as knowledge sources and wait for indexing to complete.
4. Add `smartglow-workshop-kb` to **Lightbulb-Agent** and temporarily remove the duplicate uploaded-file connection.
5. Save the agent and rerun one Step 3 test. Confirm that the answer still uses the correct sources.

Uploaded files and Foundry IQ are separate configurations. Adding a knowledge base does not automatically remove or convert previously uploaded files.

### Step 5: Make the Enterprise Decision

You have now seen three source patterns:

| Need | Suggested pattern |
|---|---|
| Current public information | Grounding with Bing Search |
| A small set of documents for one agent | Uploaded files |
| Curated knowledge shared across agents | Foundry IQ knowledge base |

In an enterprise workload, also ask who owns the information, who is allowed to access it, where it is processed, and how it will be kept current.

### Enterprise Takeaway

Retrieval can find relevant information, but relevance does not make a source authoritative. Use approved company knowledge for company facts, use the public web for public information, and check citations before trusting the answer.

---

## Summary

You connected public and company-approved information, taught the agent which source controls each subject, and tested how it handles missing evidence. You may also have compared uploaded files with a reusable Foundry IQ knowledge base.

### What's Next

In **[Unit 3: Instructions and Capability Routing](./unit-3-instructions-and-capability-routing.md)**, you'll turn these source decisions into a concise routing contract.

All later units use the configured SmartGlow knowledge source and do not require Azure AI Search specifically.

---

## Key Concepts

- **Grounding** — Basing an answer on retrieved evidence rather than model training alone.
- **Grounding with Bing Search** — Web grounding through a Bing resource your organization creates, connects, and governs.
- **File Search** — Retrieval over uploaded files in a project vector store, useful for narrow or agent-specific knowledge.
- **Foundry IQ** — A managed knowledge layer for reusable, multi-source, permission-aware retrieval.
- **Source Authority** — Using the source responsible for the subject rather than automatically choosing the newest or highest-ranked result.
- **Citation Fidelity** — Whether claims can be traced to the evidence actually used.
