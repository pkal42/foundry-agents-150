# Unit 1: Build an Agent with Clear Scope and Boundaries

## Overview

Welcome to Unit 1 of the **AI Agents with Microsoft Foundry** workshop! You'll create a portal-first **prompt agent** and define its purpose, scope, and authority before adding knowledge or tools.

By the end of this unit, you'll have a working **Lightbulb-Agent** in the Foundry playground and a baseline that makes its limitations visible. It can discuss the intended task, but it cannot yet retrieve workshop documents or change application state.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ The [Microsoft Foundry](https://ai.azure.com) project link
- ✅ The workshop identity 
- ✅ The lightbulb application link

> **📝 Note:** The organizer provisions and validates the environment before the workshop. Participants do not run `azd`, deploy resources, or change Azure role assignments. Use the **Foundry (new)** experience; portal labels can change, but this workshop uses **Build** > **Agents** and a prompt agent configured in the portal.

---

## Concept: Purpose, Scope, and Authority

A useful agent contract answers three questions:

| Boundary | Question | Lightbulb-Agent answer |
|---|---|---|
| **Purpose** | Why does this agent exist? | Help users understand and control the workshop lightbulb |
| **Scope** | Which requests should it handle? | Lightbulb state, supported colors, product help, and workshop-relevant Azure guidance |
| **Authority** | What may it actually do? | Initially, only respond in chat; later units grant specific read and write tools |

These are different. Instructions can describe an action, but they do not grant authority. Authority comes from connected tools, identities, and backend permissions.

A job description is not building access. You can write "approves expense reports" into someone's role description, but they cannot approve anything until an administrator grants that permission in the finance system. The description states intent; the permission grants capability. Instructions are the job description. Tools, identities, and RBAC are the badge that opens the door.

This distinction is the reason for the baseline test in Step 3: the agent will be told it helps control a lightbulb before it has any ability to do so.

### Prompt Agent vs. Hosted Agent

| Approach | Best fit |
|---|---|
| **Prompt agent** | Portal-first configuration of model, instructions, knowledge, and tools |
| **Hosted agent** | Custom code, orchestration, frameworks, or runtime behavior |

This workshop begins with a prompt agent so you can focus on lifecycle decisions rather than application code.

---

## Steps

### Step 1: Create the Prompt Agent

1. Open [Microsoft Foundry](https://ai.azure.com) and select the project created by setup.
2. Select **Build** > **Agents**.
3. Select **New agent** -> **Build an agent** and choose the portal's prompt-agent option if prompted.
4. Name the agent:

   ```
   Lightbulb-Agent
   ```

5. Select the predeployed workshop model.
6. Open the agent's **Tools** list and **turn off anything already selected**. At minimum you will find the built-in **Web search** tool enabled; the portal switches it on for you.
7. Save the agent.

> **⚠️ Always inspect what is already enabled.** New agents can include tools such as **Web search** by default. Turn them off for this baseline so you can clearly see what the agent can and cannot do before you add capabilities.

### Step 2: Define the Initial Contract

In **Instructions**, enter:

```
You are Lightbulb-Agent.

Purpose:
- Help users understand and control the SmartGlow workshop lightbulb.

Scope:
- Explain that you can help with lightbulb state, supported colors, product questions, and relevant workshop technology.
- Politely redirect unrelated requests.

Authority:
- Never claim that an action succeeded unless a connected tool returned evidence that it succeeded.
- State limitations clearly, ask one concise clarification question when needed, and do not invent capabilities or facts.

Response style:
- Be friendly, concise, and transparent about sources and limitations.
```

Save the agent.

> **💡 Tip:** The phrase “never claim that an action succeeded” is an authority boundary. It prevents a text-only agent from role-playing a successful real-world action.

### Step 3: Establish the Baseline

Open the playground, start a new conversation, and run these prompts:

```
Turn on the light.
```

```
What colors does the SmartGlow 101 support?
```

Record whether the agent:

- States that it cannot yet control the light
- Avoids inventing SmartGlow specifications

**If the agent answers the colour question anyway** — usually a fluent list of five colours — it still has a web tool attached. Go back to Step 1 and confirm every tool is off, then start a new conversation and run the prompt again. The answer may even be correct; that is what makes it worth catching. An agent that reaches an unintended source and happens to be right is a problem you have not found yet, not a problem you do not have.

You will reverse both of these limits deliberately: the second in Unit 2, the first in Unit 4.

### Step 4: Inspect the Capability Boundary

Review the agent configuration:

| Capability | Current state |
|---|---|
| Model response | ✅ Available |
| Explicit purpose and scope | ✅ Defined in instructions |
| Current web information | ❌ None — after you turned off the default **Web search** tool in Step 1 |
| SmartGlow product evidence | ❌ No document or knowledge base connected |
| External actions | ❌ No MCP tools connected |
| Persistent memory | ❌ Not configured |

Always inspect what is already enabled. An agent's actual boundary includes both the capabilities you add and any defaults that were already selected. In later units, you will add capabilities one at a time and test each one.

---

## Summary

You've created a prompt agent with an explicit purpose, scope, and authority boundary. The agent can converse, but it correctly avoids claiming knowledge or actions it cannot verify.

### What's Next

In **[Unit 2: Enterprise Knowledge and Grounding](./unit-2-enterprise-knowledge-grounding.md)**, you'll compare Grounding with Bing Search, uploaded files, and the Foundry IQ knowledge-base experience **(preview)**.

---

## Key Concepts

- **Prompt Agent** — An agent configured through model, instructions, knowledge, and tools without requiring a custom hosted runtime.
- **Purpose** — The business outcome the agent exists to support.
- **Scope** — The requests and subject areas the agent should handle.
- **Authority** — The actions and data access actually granted by tools, identities, and backend permissions.
- **Capability Boundary** — The line between what an agent can discuss and what it can verifiably know or do.
- **Baseline Test** — A small set of prompts that captures behavior before capabilities are added.
