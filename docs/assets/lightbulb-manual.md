# SmartGlow 101 — Product Manual

**AI-Controlled Smart Lightbulb**

*Version 1.0 | Last Updated: 2025*

---

## Table of Contents

1. [Product Overview](#product-overview)
2. [What's in the Box](#whats-in-the-box)
3. [Technical Specifications](#technical-specifications)
4. [Getting Started](#getting-started)
5. [Usage Guide](#usage-guide)
6. [Supported Colors](#supported-colors)
7. [Troubleshooting FAQ](#troubleshooting-faq)
8. [Safety Information](#safety-information)
9. [Warranty Information](#warranty-information)
10. [Contact & Support](#contact--support)

---

## Product Overview

Welcome to the **SmartGlow 101** — a next-generation smart lightbulb designed to be controlled by AI agents. Unlike traditional smart bulbs that rely on mobile apps or voice assistants, the SmartGlow 101 is built from the ground up to integrate with AI agent platforms using the **Model Context Protocol (MCP)**.

The SmartGlow 101 is part of the **Foundry Agents 150** workshop series, a hands-on educational experience that teaches you how to build AI agents using Microsoft Foundry. Throughout the workshop, you'll connect an AI agent to the SmartGlow 101 and control it using natural language — no buttons, no switches, just conversation.

### Key Features

- **AI-Native Control** — Designed to be operated by AI agents through natural language commands
- **MCP Protocol Integration** — Exposes a standard MCP endpoint for seamless agent connectivity
- **Real-Time Visual Feedback** — A web-based interface shows the lightbulb's state in real time
- **Five Preset Colors** — Choose from red, green, blue, yellow, and white
- **Simple Toggle Operation** — On/off control with a single tool call
- **Zero Configuration** — Deploys automatically as part of the workshop infrastructure

### Intended Use

The SmartGlow 101 is an educational demonstration product used in the AI Agents with Microsoft Foundry workshop. It is deployed as a cloud-hosted web application on Azure App Service and is accessed through a browser. The lightbulb is a virtual representation — there is no physical hardware component.

---

## What's in the Box

The SmartGlow 101 is a software-only product. When you deploy the workshop infrastructure using `azd up`, the following components are automatically provisioned:

- **Python FastAPI Backend** — The server application that manages lightbulb state and exposes the MCP endpoint
- **React Frontend** — A browser-based visual interface that displays the lightbulb and its current state
- **MCP Server Endpoint** — A Streamable HTTP endpoint at `/mcp` that AI agents use to discover and invoke lightbulb tools
- **Azure App Service** — The cloud hosting environment where everything runs

No physical components, batteries, or additional hardware are required.

---

## Technical Specifications

| Specification | Details |
|---|---|
| **Product Name** | SmartGlow 101 |
| **Product Type** | Virtual AI-controlled smart lightbulb |
| **Backend Framework** | Python FastAPI |
| **Frontend Framework** | React |
| **Hosting Platform** | Azure App Service |
| **Protocol** | Model Context Protocol (MCP) via Streamable HTTP |
| **MCP Endpoint** | `{AZURE_WEBAPP_URL}/mcp` |
| **Supported Colors** | Red, Green, Blue, Yellow, White |
| **Power States** | On, Off |
| **Default State** | Off, White |
| **State Persistence** | In-memory only (resets on server restart) |
| **Authentication** | None required for MCP endpoint |
| **Polling Interval** | Frontend polls backend at regular intervals for state updates |

### MCP Tools

The SmartGlow 101 MCP server exposes three tools:

| Tool Name | Type | Description |
|---|---|---|
| `get_light_state` | Read | Returns the current state of the lightbulb, including whether it is on or off and what color it is set to. |
| `toggle_light` | Write | Toggles the lightbulb's power state. If the light is off, it turns on. If the light is on, it turns off. |
| `set_color` | Write | Changes the lightbulb's color to one of the five supported preset colors: red, green, blue, yellow, or white. |

---

## Getting Started

Follow these steps to deploy and access your SmartGlow 101 lightbulb.

### Step 1: Deploy the Workshop Infrastructure

The SmartGlow 101 is deployed automatically as part of the workshop's infrastructure-as-code setup.

1. Clone the **foundry-agents-150** repository to your local machine.
2. Open a terminal and navigate to the repository root.
3. Run the deployment command:
   ```
   azd up
   ```
4. Follow the on-screen prompts to select your Azure subscription and region.
5. Wait for the deployment to complete. This typically takes 5–10 minutes.

### Step 2: Find Your App URL

After deployment completes, locate your SmartGlow 101 application URL:

- The URL is displayed in the `azd up` output as **AZURE_WEBAPP_URL**
- You can also retrieve it later by running:
  ```
  azd env get-values
  ```
- Alternatively, find it in the [Azure Portal](https://portal.azure.com) under your App Service resource.

The URL will look something like: `https://my-lightbulb-app.azurewebsites.net`

### Step 3: Verify the Application

1. Open your browser and navigate to the **AZURE_WEBAPP_URL**.
2. You should see the SmartGlow 101 interface with a visual lightbulb displayed on the page.
3. The lightbulb should be in its default state: **off** and **white**.

If the page loads and the lightbulb is visible, your SmartGlow 101 is ready to go!

### Step 4: Connect Your AI Agent

To control the SmartGlow 101 with an AI agent, add the MCP endpoint to your agent's tool configuration in the Microsoft Foundry portal:

- **Server URL:** `{AZURE_WEBAPP_URL}/mcp`
- **Transport:** Streamable HTTP
- **Authentication:** None required

Once connected, the agent will automatically discover the three available tools (`get_light_state`, `toggle_light`, `set_color`) and can begin controlling the lightbulb through natural language.

---

## Usage Guide

### Checking the Lightbulb State

To find out whether the lightbulb is on or off and what color it is, use the `get_light_state` tool. When connected through an AI agent, you can simply ask:

- "What's the current state of the light?"
- "Is the light on or off?"
- "What color is the light right now?"

The tool returns a response containing the power state (on/off) and the current color.

You can also check the state visually by opening the SmartGlow 101 web interface in your browser.

### Turning the Light On and Off

The `toggle_light` tool switches the lightbulb's power state. If the light is currently off, calling `toggle_light` turns it on. If the light is currently on, calling `toggle_light` turns it off.

Through the AI agent, you can say:

- "Turn on the light."
- "Turn off the light."
- "Toggle the lightbulb."

The agent will call `toggle_light` and confirm the action. The web interface updates in real time to reflect the change.

**Important:** The lightbulb must be turned **on** before you can observe color changes in the web interface. If the light is off and you set a color, the color is stored but the lightbulb will appear dark in the UI until it is turned on.

### Changing the Color

The `set_color` tool changes the lightbulb's color to one of the five supported preset colors. Through the AI agent, you can say:

- "Change the light to blue."
- "Set the color to red."
- "Make the light green."

The agent will call `set_color` with the specified color and confirm the change. The web interface updates to display the new color.

**Important:** Make sure the light is turned on first to see the color change visually. Setting a color while the light is off will update the internal state, but the lightbulb will not appear illuminated in the UI.

---

## Supported Colors

The SmartGlow 101 supports the following five preset colors:

| Color | Value | Description |
|---|---|---|
| 🔴 Red | `red` | A bright, warm red |
| 🟢 Green | `green` | A vivid green |
| 🔵 Blue | `blue` | A cool, calming blue |
| 🟡 Yellow | `yellow` | A warm, sunny yellow |
| ⚪ White | `white` | The default neutral white (also the reset color) |

### Color Limitations

- **Only the five preset colors listed above are supported.** You cannot set a custom color such as purple, orange, pink, or any hex/RGB value.
- **Brightness control is not available.** The lightbulb is either on (at full brightness) or off. There are no intermediate brightness levels.
- If you request an unsupported color, the system will return an error indicating that the color is not valid.

---

## Troubleshooting FAQ

### Q: Why won't my light turn on?

**A:** First, make sure the lightbulb application is deployed and running. Navigate to your **AZURE_WEBAPP_URL** in a browser — if the page loads and you can see the lightbulb interface, the app is running. If the page doesn't load, check your Azure App Service resource in the [Azure Portal](https://portal.azure.com) to verify it's started. You may need to re-run `azd up` if the deployment failed. Also confirm that your AI agent has the MCP connection configured correctly with the right server URL.

### Q: What colors are supported?

**A:** The SmartGlow 101 supports five preset colors: **red**, **green**, **blue**, **yellow**, and **white**. These are the only colors available. See the [Supported Colors](#supported-colors) section for details.

### Q: Can I set a custom color like purple or orange?

**A:** No. The SmartGlow 101 only supports the five preset colors: red, green, blue, yellow, and white. Custom colors, hex values, and RGB values are not supported. If you attempt to set an unsupported color, the system will return an error.

### Q: How do I check the current state of the lightbulb?

**A:** There are two ways to check the lightbulb's state. First, you can ask your AI agent — it will use the `get_light_state` MCP tool to retrieve the current power state and color. Second, you can open the SmartGlow 101 web interface in your browser and observe the lightbulb visually. The web UI polls the backend at regular intervals, so it always reflects the current state.

### Q: The light color didn't change — what happened?

**A:** The most common cause is that the light is turned **off**. When the light is off, you can still set a color (the state updates internally), but the lightbulb will appear dark in the web interface. Make sure you turn the light **on** first using `toggle_light`, and then set the color. Once the light is on, color changes are immediately visible.

### Q: Can I schedule the light to change at a specific time?

**A:** No, scheduling is not currently supported. The SmartGlow 101 responds to commands in real time only. There is no built-in timer, scheduler, or delayed-action capability. If you need time-based behavior, you would need to implement external scheduling logic outside of the lightbulb application.

### Q: Can I control the brightness of the lightbulb?

**A:** No, brightness control is not currently supported. The SmartGlow 101 operates in two states: **on** (full brightness) and **off**. There are no intermediate brightness levels or dimming capabilities. The only controls available are toggling the power state and changing the color.

### Q: What happens if I try to set an invalid color?

**A:** If you attempt to set a color that is not one of the five supported presets (red, green, blue, yellow, white), the `set_color` tool will return an error. The lightbulb's state will remain unchanged — it will keep whatever color it was set to previously. Your AI agent should relay this error to you in its response.

### Q: How do I reset the lightbulb to its default state?

**A:** To reset the lightbulb, toggle it **off** using `toggle_light`. This returns the lightbulb to its default off state. The color resets to **white** when the server restarts. If you want to manually reset the color while the light is on, set the color to **white** using `set_color`.

### Q: Is the lightbulb state persistent across server restarts?

**A:** No. The SmartGlow 101 stores its state **in memory only**. When the Azure App Service restarts (due to redeployment, scaling events, or manual restarts), the lightbulb state resets to its default: **off** and **white**. There is no database or persistent storage backing the lightbulb state. This is by design — the SmartGlow 101 is a demonstration product intended for workshop use.

### Q: The web interface shows a different state than what the agent reports — why?

**A:** This can happen if there is a brief delay between the agent's action and the frontend's next poll. The React frontend polls the backend at regular intervals to check for state changes. If you've just issued a command, wait a moment for the UI to catch up. If the discrepancy persists, try refreshing the browser page.

---

## Safety Information

⚠️ **Important Safety Notice**

The SmartGlow 101 is a **virtual product** — a software application running in the cloud. There is no physical lightbulb, no electrical wiring, and no risk of electrical shock, fire, or burns associated with this product.

However, please observe the following guidelines during workshop use:

- **Cloud Resource Usage** — The SmartGlow 101 runs on Azure App Service. Leaving the application deployed after the workshop may incur Azure charges. Run `azd down` to deprovision all resources when you're finished.
- **No Sensitive Data** — Do not input sensitive, personal, or confidential information into the AI agent during the workshop. The agent's conversation history may be logged.
- **Shared Environments** — If you are participating in a group workshop with shared Azure resources, be aware that other participants may also be controlling the same lightbulb instance. State changes from other users will be visible in your UI.
- **API Endpoint Security** — The SmartGlow 101 MCP endpoint does not require authentication. Do not expose the endpoint to production environments or public-facing applications beyond the workshop context.

**In case of emergency:** There is no emergency. It's a virtual lightbulb. But if your Azure costs are higher than expected, run `azd down` immediately.

---

## Warranty Information

### Limited Warranty

GlowTech Industries (a fictional subsidiary of the Foundry Agents 150 Workshop Series) warrants that the SmartGlow 101 software product will perform substantially in accordance with this manual for a period of **the duration of the workshop** from the date of deployment.

### What Is Covered

- The lightbulb turns on and off when commanded via the MCP `toggle_light` tool
- The lightbulb changes to the correct color when commanded via the MCP `set_color` tool
- The `get_light_state` tool returns accurate state information
- The web interface displays the lightbulb's current state

### What Is NOT Covered

- Physical lightbulb functionality (this is a virtual product)
- Brightness control, dimming, or custom color mixing
- Scheduling, automation, or timer-based functionality
- State persistence across server restarts
- Network connectivity issues between your browser and Azure
- Compatibility with non-MCP agent platforms
- Any use of the product outside the intended workshop context
- Emotional attachment to the virtual lightbulb

### How to Make a Warranty Claim

To file a warranty claim, simply restart your deployment by running `azd up` from the repository root. This resolves most issues. If problems persist, consult the [Troubleshooting FAQ](#troubleshooting-faq) section of this manual.

---

## Contact & Support

The SmartGlow 101 is an open-source educational product. For support:

- **Repository:** Check the [foundry-agents-150](https://github.com/PennStateLefty/foundry-agents-150/) repository for updates and issue tracking
- **Workshop Facilitator:** If you are attending a live workshop, ask your facilitator for help
- **Documentation:** Refer to the unit guides in the `docs/` folder of the repository

Thank you for choosing the SmartGlow 101. Enjoy the workshop, and happy agent building! 💡
