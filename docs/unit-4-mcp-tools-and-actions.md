# Unit 4: MCP Tools and Actions

## Overview

In this unit, you'll connect the SmartGlow **Model Context Protocol (MCP)** server and use:

1. `get_light_state` to read application state
2. `toggle_light` and `set_color` to change application state

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
| **Read** | Get light state | Data exposure and freshness |
| **Write** | Toggle power, set color | Authorization, validation, idempotency, confirmation, audit |

MCP standardizes discovery and invocation. It does not make a tool safe by itself.

---

## Steps

### Step 1: Connect and Inspect the Lightbulb MCP Server

The workshop MCP endpoint is:

```
{AZURE_WEBAPP_URL}/mcp
```

1. Keep the lightbulb application open in one browser window.
2. In the agent's **Tools** section, select **Add** > **Custom** > **MCP**.
3. Configure:

   | Setting | Value |
   |---|---|
   | Server endpoint | `{AZURE_WEBAPP_URL}/mcp` |
   | Authentication | Unauthenticated for this workshop only |
   | Name | `Lightbulb-Controller` |

4. Connect the server. If an approval setting is shown, keep the default that requires reviewing tool calls.
5. Save the agent and start a new conversation.
6. Ask:

   ```
   What is the current state of the light?
   ```

7. If an approval card appears, confirm that the proposed tool is `get_light_state`, then approve it.
8. Expand the playground activity or tool-call details and confirm that `get_light_state` returned the current power and color.

The portal might show only the MCP server connection during setup rather than listing every remote tool. A successful `get_light_state` call confirms that discovery and invocation are working. The server provides:

| Tool | Type | What it does |
|---|---|---|
| `get_light_state` | Read | Returns current power and color |
| `toggle_light` | Write | Changes the current power state |
| `set_color` | Write | Sets `red`, `green`, `blue`, `yellow`, or `white` |

> **💡 Tip:** A schema is both routing context and an API boundary. The backend must still validate every argument and caller.

`toggle_light` changes the current state rather than directly setting “on” or “off.” When the requested final state matters, the agent should read the state first.

### Step 2: Test Write Operations

Arrange the Foundry playground and lightbulb application side by side.

1. Request a target state:

   ```
   Turn on the light.
   ```

   Review and approve the proposed calls if prompted. A correct sequence reads state first and calls `toggle_light` only if the light is off.

2. Change color:

   ```
   Change the light to blue.
   ```

   Confirm the `set_color` argument and watch the application update.

Visible feedback proves that the tool changed application state; the agent's prose alone does not.

### Step 3: Test Conditional Chaining

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

### Step 4: Test Schema and Capability Boundaries

You do not select a remote tool from a separate tool menu. Ask the agent in the playground, then expand the activity or approval card to inspect the tool name, arguments, and returned result.

Run:

```
Set the light to purple.
```

The agent should explain that purple is unsupported and should not call `set_color`. Confirm in the playground activity that no write was sent and verify in the lightbulb application that the color did not change.

| Behavior | Assessment |
|---|---|
| Explains the supported colors and makes no call | Correct |
| Calls `set_color` with purple but reports the returned error | The backend prevented the invalid change |
| Claims the light is purple | Incorrect: there is no evidence that the action succeeded |
| Silently chooses another color | Incorrect: the agent changed the user's request |

Think of a remote control with only five color buttons. Asking for purple should not cause the agent to press a different button or pretend a purple button exists. The tool description helps prevent the request, and the backend still validates any call that reaches it.

### Step 5: Review the Tool Design Checklist

This checklist covers **tool design** — what you review before connecting a real MCP server. The operational go-live list is separate, in [Unit 8, Step 3](./unit-8-version-publish-and-operate.md).

- **Schema:** Inputs are narrow, typed, validated, and safely bounded.
- **Description:** Selection guidance is accurate and does not overstate authority.
- **Read/write separation:** Consequential tools are easy to identify and govern.
- **Errors:** Unsupported or unsuccessful actions are reported clearly and never described as successful.

Authentication, authorization, approval, and observability are equally required, but they are enforced by the backend rather than by the tool contract. Unit 6 covers them.

---

## Summary

You've connected one MCP server, used a read tool and write tools, inspected their contracts, and verified the result through visible application state.

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
- **Input Validation** — Checking that a requested value is allowed before changing application state.
