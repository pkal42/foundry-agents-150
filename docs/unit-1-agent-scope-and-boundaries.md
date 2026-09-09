# Unit 1: Build an Agent with Clear Scope and Boundaries

## Overview

In this unit, you'll create **Lightbulb-Agent** and define its job before adding knowledge or tools.

By the end, the agent will know what kinds of requests it should handle and will clearly state when it lacks the information or capability to complete a request.

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

Instructions describe the agent's job, but they do not provide information or permission. Connected knowledge provides evidence, tools provide actions, and identities and backend permissions determine what the agent may access.

Think of the instructions as a **job description** and tools and permissions as an **access badge**. The job description can say what someone is expected to do, but the badge determines which doors they can actually open.

### Prompt Agent vs. Hosted Agent

> **📝 Note:** This workshop uses a **prompt agent**, configured in the portal with instructions, knowledge, and tools. Hosted agents add custom application code and runtime control, but participants do not need that distinction to complete this unit.

---

## Steps

### Step 1: Create and Configure the Prompt Agent

1. Open [Microsoft Foundry](https://ai.azure.com) and select the project created by setup.
2. Select **Build** > **Agents**.
3. Select **New agent** > **Build an agent** and choose the prompt-agent option if prompted.
4. Name the agent:

   ```
   Lightbulb-Agent
   ```

5. Select the predeployed workshop model.
6. Open the agent's **Tools** list and turn off anything already selected, including **Web search** if it is enabled.
7. In **Instructions**, enter:

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

8. Save the agent.

> **⚠️ Important:** Always inspect what is already enabled. New agents can include tools such as **Web search** by default. Turn them off for this baseline so you can clearly see what the agent can and cannot do before you add capabilities.

> **📝 Note:** Instructions can tell the agent to control a light, but only a connected tool can actually change it.

### Step 2: Establish the Baseline

Open the playground, start a new conversation, and test three different boundaries:

| Test | Prompt | Expected behavior |
|---|---|---|
| **Action** | `Turn on the light.` | Explains that no control tool is connected and does not claim the light changed |
| **Knowledge** | `What colors does the SmartGlow 101 support?` | Says the product information is not available instead of guessing |
| **Scope** | `Plan my vacation.` | Politely explains that the request is outside the agent's purpose |

If the agent answers the color question from public information, return to Step 1 and confirm that **Web search** and every other tool are off. Start a new conversation and test again.

You will reverse both of these limits deliberately: the second in Unit 2, the first in Unit 4.

### Step 3: Explain the Current Boundary

Review the agent configuration:

| Capability | Current state |
|---|---|
| Conversation | ✅ The model can respond |
| Purpose and scope | ✅ Defined in instructions |
| SmartGlow product facts | ❌ No approved knowledge is connected |
| Current web information | ❌ Web tools are turned off |
| Lightbulb actions | ❌ No control tool is connected |

Always inspect what is already enabled. An agent's actual boundary includes both the capabilities you add and any defaults that were already selected. In later units, you will add capabilities one at a time and test each one.

### Enterprise Takeaway

An agent should not receive broad access simply because its instructions describe a broad job. Define the job first, inspect existing defaults, then add and test only the knowledge and tools the agent needs.

---

## Summary

You created an agent with a defined purpose, scope, and authority boundary. It can respond in chat, but it does not yet have approved SmartGlow knowledge or permission to change the light.

### What's Next

In **[Unit 2: Enterprise Knowledge and Grounding](./unit-2-enterprise-knowledge-grounding.md)**, you'll compare Grounding with Bing Search, uploaded files, and the Foundry IQ knowledge-base experience **(preview)**.

---

## Key Concepts

- **Purpose** — The business outcome the agent exists to support.
- **Scope** — The requests and subject areas the agent should handle.
- **Authority** — The actions and data access actually granted by tools, identities, and backend permissions.
- **Capability Boundary** — The line between what an agent can discuss and what it can verifiably know or do.
- **Baseline Test** — A small set of prompts that captures behavior before capabilities are added.
