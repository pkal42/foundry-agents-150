# Unit 5: Toolboxes and Skills

## Overview

In this unit, you'll create a **Skill** and a **Toolbox** instead of configuring the same tools and guidance separately for every agent.

By the end, you'll publish both resources and connect **Lightbulb-Agent** to the shared lightbulb tools and operating guidance.

> **📝 Note:** Toolboxes and Skills evolve quickly and can have regional, model, SDK, or portal limitations. Treat them as preview unless the current [Toolbox documentation](https://learn.microsoft.com/azure/foundry/agents/how-to/tools/toolbox) and [Skills documentation](https://learn.microsoft.com/azure/foundry/agents/how-to/tools/skills) state otherwise for your exact scenario.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed [Unit 4](./unit-4-mcp-tools-and-actions.md)
- ✅ Access to **Lightbulb-Agent**
- ✅ `Lightbulb-Controller` from Unit 4 appears under **Build** > **Tools** > **Configured**
- ✅ The Microsoft Foundry project endpoint and **Foundry User** role
- ✅ The deployed lightbulb MCP endpoint, `{AZURE_WEBAPP_URL}/mcp`
- ✅ The **Tools** > **Skills** and **Toolboxes** preview pages are available in the Foundry portal

> **📝 Note:** The workshop MCP endpoint is unauthenticated only for this bounded lab. Enterprise Toolbox owners should use an approved connection and authentication method.
>
> If the preview pages are unavailable, use the [Microsoft Foundry Toolkit](https://aka.ms/foundrytk) for Visual Studio Code and follow the equivalent creation flow.

---

## Concept: Reuse Tools and Guidance

In Unit 4, **Lightbulb-Agent** connected directly to `Lightbulb-Controller`. That works for one agent, but repeating the same connections and instructions across many agents creates more configuration to maintain.

Without a Toolbox:

```text
Agent A --> Lightbulb-Controller
Agent B --> Lightbulb-Controller
Agent C --> Lightbulb-Controller
```

With a Toolbox:

```text
Agent A --\
Agent B ----> shared-lightbulb-toolbox
Agent C --/       |-- Tool search
                  |-- Lightbulb-Controller
                  |-- Knowledge search tool
                  |-- Support system tool
                  `-- lightbulb-assistant Skill
```

The workshop adds one configured tool, but a production Toolbox can contain many tools and Skills. Each agent still needs one connection to the shared Toolbox endpoint, but it no longer needs separate connections to every underlying capability.

| Resource | What it shares | SmartGlow example |
|---|---|---|
| **Toolbox** | Approved tools through one managed endpoint | Reuse `Lightbulb-Controller` across agents |
| **Skill** | Reusable instructions for using capabilities | Read before toggling and report only confirmed results |
| **Tool search** | Intent-based discovery of relevant tools | Load the lightbulb tools only when the request needs them |

| Direct per-agent setup | Shared Toolbox |
|---|---|
| Add and maintain every tool on every agent | Connect each agent to one Toolbox endpoint |
| Copy behavioral instructions between agents | Attach one shared Skill |
| Load every attached tool definition | Use Tool search to discover relevant tools |
| Update consumers individually | Publish and promote a new Toolbox or Skill version |

Think of a Toolbox as a shared tool cabinet and a Skill as the instructions attached to it. Agents can use the same maintained tools and guidance without each team rebuilding them.

A Skill guides behavior, but it does not grant permission. The connected identity and backend still decide whether an action is allowed.

---

## Steps

### Step 1: Create the Skill

1. Open the workshop project in the [Microsoft Foundry portal](https://ai.azure.com).
2. Select **Build** > **Tools**.
3. Open the **Skills** tab.
4. Select **New skill** > **Create skill**.
5. Complete the form:

   | Field | Value |
   |---|---|
   | Name | `lightbulb-assistant` |
   | Description | `Shared operating guidance for approved SmartGlow controls.` |

6. In **Instruction**, enter:

   ```markdown
   - Read current state before using toggle when a target state is requested.
   - Use only red, green, blue, yellow, or white.
   - Report success only from tool evidence.
   - Ask for clarification instead of guessing.
   ```

7. Select **Create**.
8. Confirm that `lightbulb-assistant` appears on the **Skills** tab with version `1`.

The name uses lowercase letters and hyphens. The description tells agents when the Skill is relevant, while the instruction defines the reusable behavior.

### Step 2: Create the Toolbox

1. In **Build** > **Tools**, open the **Toolboxes** tab.
2. Select **Create toolbox**.
3. Under **Basic info**, enter:

   | Setting | Value |
   |---|---|
   | Name | `shared-lightbulb-toolbox` |
   | Description | `Shared SmartGlow lightbulb tools and operating guidance.` |

4. Under **Included**, review anything selected by default. Remove **Web search**, **Code interpreter**, and **Foundry MCP Server** if they appear. This Toolbox should contain only the Unit 4 lightbulb connection and the Skill.
5. Keep **Tool search** on. This lets the agent discover relevant tools from the Toolbox instead of loading every tool into its context at once.

   > **📝 Note:** Tool search is especially beneficial for a large Toolbox. It reduces the number of tool definitions loaded into the agent's context and helps the agent focus on the tools relevant to the current request.

6. Select **Add** and open the **Configured** tab.
7. Select `Lightbulb-Controller`, which was created in Unit 4. If it is not available, follow [Unit 4, Step 1](./unit-4-mcp-tools-and-actions.md#step-1-connect-and-inspect-the-lightbulb-mcp-server) to create the connection to `{AZURE_WEBAPP_URL}/mcp`, then return here. Do not create another connection when `Lightbulb-Controller` already exists.
8. Select **Add** again and add a Skill.
9. Select `lightbulb-assistant`, then confirm the selection.
10. Under **Guardrail**, keep **None**. You will review guardrails in Unit 6.
11. Confirm that **Included** contains only `Lightbulb-Controller` and `lightbulb-assistant`, with **Tool search** on.
12. Select **Publish**.
13. Confirm that `shared-lightbulb-toolbox` appears on the **Toolboxes** tab with version `1` set as the default.
14. Open the Toolbox and copy the endpoint shown under **Call this toolbox**.

Publishing creates version `1` and makes the first version the default automatically.

> **⚠️ Important:** A shared Toolbox can be used by many agents. Its owner must review authentication, permissions, data handling, and every connected service.

The Toolbox does not appear in the prompt agent's configured-tool catalog. It is a managed MCP endpoint that the agent must connect to. Tool search discovers the relevant tools behind that endpoint when the agent needs them.

### Step 3: Connect the Toolbox to the Agent

1. Open **Lightbulb-Agent** in Microsoft Foundry.
2. In the agent's **Tools** section, select **Add**.
3. Open the **Custom** tab and select **MCP**.
4. Use the endpoint copied from **Call this toolbox**.
5. Select **Unauthenticated** for the portal connection in this workshop.
6. Name the connection `Shared-Lightbulb-Toolbox`.
7. Add the connection.
8. Remove the direct `Lightbulb-Controller` connection from the agent.
9. Confirm that `Shared-Lightbulb-Toolbox` is the agent's only lightbulb tool connection.
10. Save the agent.
11. Start a completely new playground conversation. Do not reuse the Unit 4 conversation because it can retain references to the old direct tool names.

Removing the direct connection ensures that the next test must use the Toolbox. If the test fails, you can re-add the configured `Lightbulb-Controller` as a rollback.

The new MCP entry is only the prompt agent's connection to the Toolbox gateway. It does not recreate `Lightbulb-Controller`, the SmartGlow tools, or the Skill.

> **📝 Note:** The Foundry portal can connect a prompt agent to a same-project Toolbox through its managed runtime while the connection is labeled **Unauthenticated**. A raw external client calling the Toolbox URL directly still requires a Microsoft Entra token for `https://ai.azure.com/.default`. Authentication from the Toolbox to the underlying lightbulb MCP server is a separate boundary and is also unauthenticated only for this bounded workshop.

### Step 4: Verify the Shared Behavior

Run:

```
Check the light. If it is off, turn it on, set it to white, and report the final state.
```

Confirm that the agent:

1. Uses Tool search to find the relevant SmartGlow tools
2. Discovers and calls `get_light_state`, which might appear as `Lightbulb-Controller___get_light_state`
3. Toggles only when the light is off
4. Calls `set_color` with `white`
5. Reports the result from tool evidence
6. Produces a visible change in the lightbulb application

Expand the playground activity or approval card to inspect Tool search, the discovered tool names, and their arguments. A successful sequence demonstrates the benefit of connecting the Toolbox instead of attaching every tool directly to the agent.

The agent now has one shared entry point instead of a direct connection to each underlying capability.

Tool search and Toolbox support are preview capabilities. If the prompt agent still cannot call a tool returned by Tool search, turn off **Tool search**, publish a new Toolbox version, reconnect the Toolbox, and rerun the test. This fallback exposes the Toolbox tools directly while preserving the shared endpoint and Skill.

Then run:

```
Set brightness to 50%.
```

The agent should explain that brightness is unsupported and should not invent a tool.

### Step 5: Understand Version Updates

Toolboxes and Skills should be changed through versions rather than by silently changing every consumer.

A simple update flow is:

1. Create a new version.
2. Review and test the change.
3. Promote the approved version.
4. Monitor consumers and roll back if behavior gets worse.

Record whether each agent uses a pinned version or follows the promoted default.

### Enterprise Takeaway

Use a Toolbox when several agents need the same set of tools and Skills. Each agent connects once to the shared endpoint, while owners manage underlying connections, tool discovery, guidance, and versions centrally. Keep ownership, permissions, testing, and rollback clear because one promoted change can affect many agents.

---

## Summary

You've created and published a Skill and Toolbox, connected **Lightbulb-Agent** to the shared endpoint, verified the behavior, and reviewed how versions prevent uncontrolled updates.

### What's Next

In **[Unit 6: Safe and Governed Actions](./unit-6-safe-and-governed-actions.md)**, you'll apply identity, authorization, guardrails, and human approval to agent actions.

---

## Key Concepts

- **Toolbox** — A reusable collection of approved tool connections.
- **Skill** — Reusable guidance for how an agent should perform a task.
- **Tool Search** — Intent-based discovery that loads relevant Toolbox tools when they are needed.
- **Version** — A controlled snapshot of a Toolbox or Skill.
- **Promotion** — Making a tested version available to consumers.
- **Rollback** — Returning to a known-good version after a problem.
