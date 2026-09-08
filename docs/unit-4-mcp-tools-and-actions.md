# Unit 4: MCP Tools and Actions

## Overview

In this 30-minute unit, you'll use **Model Context Protocol (MCP)** for two different risk profiles:

1. A brief, read-only Microsoft Learn documentation lookup
2. Hands-on lightbulb tools that read and change application state

You'll examine tool schemas, authentication, read versus write behavior, conditional chaining, and visible application feedback.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed [Unit 3](./unit-3-instructions-and-capability-routing.md)
- ✅ Access to **Lightbulb-Agent** and the Foundry playground
- ✅ The deployed lightbulb application URL, **AZURE_WEBAPP_URL**
- ✅ The application is responsive and exposes `{AZURE_WEBAPP_URL}/mcp`

> **📝 Note:** The workshop lightbulb MCP endpoint is intentionally unauthenticated for a bounded lab. An enterprise MCP server should use an approved authentication flow and enforce authorization in the backend.

---

## Concept: MCP Is a Contract

An MCP server exposes tools with:

- A **name** and **description** used for selection
- An **input schema** that constrains arguments
- A result shape the agent must interpret
- A transport, typically **Streamable HTTP** for remote servers
- An authentication and authorization model

| Operation | Example | Primary concern |
|---|---|---|
| **Read** | Search documentation, get light state | Data exposure, freshness, source quality |
| **Write** | Toggle power, set color | Authorization, validation, idempotency, confirmation, audit |

MCP standardizes discovery and invocation. It does not make a tool safe by itself.

---

## Steps

### Step 1: Connect the Read-Only Microsoft Learn MCP Server

1. Open **Build** > **Agents** > **Lightbulb-Agent**.
2. In **Tools**, select **Add** > **Custom** > **MCP**.
3. Configure:

   | Setting | Value |
   |---|---|
   | Server endpoint | `https://learn.microsoft.com/api/mcp` |
   | Authentication | Unauthenticated |
   | Name | `Microsoft-Learn-Docs` |

4. Connect and inspect the discovered tool names, descriptions, and schemas.
5. Save, then test:

   ```
   Using Microsoft Learn, explain managed identities in Azure and cite the documentation.
   ```

Confirm that the agent uses the MCP tool rather than generic web search. This server retrieves public documentation and is read-only.

### Step 2: Inspect the Lightbulb Tool Contract

The workshop MCP endpoint is:

```
{AZURE_WEBAPP_URL}/mcp
```

It exposes:

| Tool | Type | Contract |
|---|---|---|
| `get_light_state` | Read | Return current power and color |
| `toggle_light` | Write | Invert current power state |
| `set_color` | Write | Set `red`, `green`, `blue`, `yellow`, or `white` |

Notice that `toggle_light` is not an idempotent “turn on” operation. The agent must read state first when the requested end state matters.

### Step 3: Connect the Lightbulb MCP Server

1. Keep the lightbulb application open in one browser window.
2. In the agent's **Tools** section, add another **Custom** > **MCP** connection.
3. Configure:

   | Setting | Value |
   |---|---|
   | Server endpoint | `{AZURE_WEBAPP_URL}/mcp` |
   | Authentication | Unauthenticated for this workshop only |
   | Name | `Lightbulb-Controller` |

4. Connect and verify that the three tools are discovered.
5. Inspect the `set_color` schema. The allowed values should match the backend's supported colors.
6. Save the agent.

> **💡 Tip:** A schema is both routing context and an API boundary. The backend must still validate every argument and caller.

### Step 4: Test Read and Write Operations

Arrange the Foundry playground and lightbulb application side by side.

1. Read state:

   ```
   What's the current state of the light?
   ```

   Confirm that `get_light_state` runs and no state changes.

2. Request a target state:

   ```
   Turn on the light.
   ```

   A correct sequence reads state first. It calls `toggle_light` only if the light is off.

3. Change color:

   ```
   Change the light to blue.
   ```

   Confirm the `set_color` argument and watch the application update.

Visible feedback proves that the tool changed application state; the agent's prose alone does not.

### Step 5: Test Conditional Chaining

Run:

```
Check the light. If it is off, turn it on. Then set it to green and report the final state.
```

Expected path:

1. `get_light_state`
2. Conditional `toggle_light`
3. `set_color` with `green`
4. Optional final `get_light_state` or a trustworthy write response
5. A concise result based on tool evidence

Test the same prompt twice. On the second run, the agent should not toggle an already-on light.

### Step 6: Test Schema and Capability Boundaries

Run:

```
Set the light to purple.
```

The agent should explain the supported colors without sending an invalid write.

Then run:

```
Search Microsoft Learn for Azure App Service health checks, then set the light to yellow.
```

Confirm that the agent routes across two MCP servers: read-only documentation followed by a state-changing tool.

### Step 7: Review the Enterprise MCP Checklist

Before connecting a real MCP server, verify:

- **Schema:** Inputs are narrow, typed, validated, and safely bounded.
- **Description:** Selection guidance is accurate and does not overstate authority.
- **Authentication:** The caller is strongly identified.
- **Authorization:** The backend checks each requested action and resource.
- **Read/write separation:** Consequential tools are easy to identify and govern.
- **Confirmation:** Human approval is required when impact, ambiguity, or policy warrants it.
- **Errors:** Failures are explicit and do not look like success.
- **Observability:** Tool calls, outcomes, and correlation identifiers are auditable.

---

## Summary

You've connected MCP servers for both retrieval and action, inspected their contracts, and verified conditional tool chaining through visible application state.

### What's Next

In **[Unit 5: Toolboxes and Skills](./unit-5-toolboxes-and-skills.md)**, you'll package reusable capabilities for consistent use across agents.

---

## Key Concepts

- **Model Context Protocol (MCP)** — An open protocol for tool and context discovery and invocation.
- **Tool Schema** — The typed input contract that constrains a tool call.
- **Read Tool** — Retrieves data without intentionally changing state.
- **Write Tool** — Creates a side effect and requires stronger authorization and validation.
- **Conditional Chaining** — Using one tool's result to determine the next call.
- **Visible Feedback** — Independent evidence in the target application that an action occurred.
