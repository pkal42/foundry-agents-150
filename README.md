# Foundry Agents 150

A three-hour, hands-on workshop for building an enterprise-ready declarative agent in Microsoft Foundry. Participants define a focused agent, ground it in curated enterprise knowledge, route capabilities, take real actions through MCP, apply governance, evaluate quality, and prepare a stable version for distribution.

## Workshop Outcome

Participants leave with a `Lightbulb-Agent` that can:

- stay within a clear business scope and communicate its limits;
- answer from a curated SmartGlow knowledge base and current public information;
- route requests across knowledge, read-only tools, and action tools;
- control a deployed lightbulb application through MCP;
- use prepared Toolboxes and Skills **(preview for this workshop scenario)** for reusable capabilities;
- apply defense in depth to identity, authorization, approvals, and content safety;
- trace, diagnose, evaluate, improve, compare, and monitor agent quality; and
- use versions, publishing, and a stable endpoint as the path to production.

The workshop follows one enterprise agent lifecycle:

**Define -> Ground -> Instruct -> Act -> Govern -> Evaluate -> Ship**

## What You'll Build

The workshop uses a **lightbulb web application** (Python + React) with a Python MCP server. The agent can inspect the light's state, toggle it on or off, and set a supported color. The simple device makes tool selection, authorization, state changes, traces, and evaluation results visible without hiding the enterprise patterns behind application complexity.

## Workshop Agenda

The agenda is exactly 180 minutes. Clock times below assume a **1:00 PM-4:00 PM** session.

| Elapsed | Clock | Block | Min |
|---|---|---|---:|
| 0:00-0:05 | 1:00-1:05 PM | Opening and environment check | 5 |
| 0:05-0:17 | 1:05-1:17 PM | **Unit 1** | 12 |
| 0:17-0:42 | 1:17-1:42 PM | **Unit 2** | 25 |
| 0:42-1:00 | 1:42-2:00 PM | **Unit 3** | 18 |
| 1:00-1:08 | 2:00-2:08 PM | Break | 8 |
| 1:08-1:38 | 2:08-2:38 PM | **Unit 4** | 30 |
| 1:38-1:55 | 2:38-2:55 PM | **Unit 5** | 17 |
| 1:55-2:15 | 2:55-3:15 PM | **Unit 6** | 20 |
| 2:15-2:23 | 3:15-3:23 PM | Break | 8 |
| 2:23-2:50 | 3:23-3:50 PM | **Unit 7** | 27 |
| 2:50-2:55 | 3:50-3:55 PM | **Unit 8** | 5 |
| 2:55-3:00 | 3:55-4:00 PM | Wrap-up and next-capability decision | 5 |

## Lab Units

| Unit | Topic | Description |
|---|---|---|
| [Unit 1](docs/unit-1-agent-scope-and-boundaries.md) | Build an Agent with Clear Scope and Boundaries | Create the baseline agent, define its job, and make supported and unsupported behavior explicit. |
| [Unit 2](docs/unit-2-enterprise-knowledge-grounding.md) | Enterprise Knowledge and Grounding | Use the connected Azure AI Search service to build a curated Foundry IQ knowledge base **(preview)** from the SmartGlow manual, support policy, and operations runbook. |
| [Unit 3](docs/unit-3-instructions-and-capability-routing.md) | Instructions and Capability Routing | Structure instructions so the agent chooses authoritative knowledge, web grounding, or tools intentionally. |
| [Unit 4](docs/unit-4-mcp-tools-and-actions.md) | MCP Tools and Real-World Actions | Inspect a read-only Microsoft Learn MCP call, then use MCP action tools to read and change lightbulb state. |
| [Unit 5](docs/unit-5-toolboxes-and-skills.md) | Reusable Tools and Skills | Connect a prepared Toolbox and Skill **(preview for this workshop scenario)** to centralize reusable capabilities and behavior. |
| [Unit 6](docs/unit-6-safe-and-governed-actions.md) | Safe and Governed Actions | Apply defense in depth; tool-call/tool-response guardrail intervention points and human-in-the-loop approval are **preview** capabilities. |
| [Unit 7](docs/unit-7-prove-and-improve-quality.md) | Prove and Improve Agent Quality | Run the quality loop and optionally demonstrate Agent Optimizer **(preview)**. |
| [Unit 8](docs/unit-8-version-publish-and-operate.md) | Version, Publish, and Operate | Review versions, publishing, stable endpoints, distribution, and CI/CD without performing a live deployment. |

## Feature Maturity

This workshop intentionally includes recent Microsoft Foundry capabilities. Treat the following labels as part of the learning material, not as production-readiness endorsements:

| Component | Status used by this workshop | Impact |
|---|---|---|
| Azure AI Search S1, App Service, Application Insights, and Log Analytics | Generally available services | Core infrastructure |
| Foundry IQ knowledge-base and agentic-retrieval portal experience | **Preview** | Core Unit 2 experience; use the prepared fallback if unavailable |
| Toolboxes and toolbox-based Skill discovery | **Preview for this workshop scenario** | Core Unit 5 concept; screenshots and a directly connected agent are the fallback |
| Guardrail tool-call and tool-response intervention points | **Preview** | Unit 6 demonstration only; backend authorization remains mandatory |
| Human-in-the-loop approval | **Preview** | Discussed as a control for consequential actions |
| Agent Optimizer | **Preview** | Optional instructor demonstration; not required to complete Unit 7 |
| Memory, Routines, long-running/autopilot patterns, and A2A | **Preview where identified by current documentation** | Mentioned only in the Unit 8 decision map |
| Foundry and Bing Bicep resource APIs | **Preview API versions** (`2025-04-01-preview` and `2025-05-01-preview`) | Required by the current `azd` deployment templates |
| Microsoft Foundry `azd` extensions | **Beta** | Organizer tooling only; participants do not install or invoke it |
| `gensync@1.0.0-beta.2` | **Beta transitive npm dependency** | Frontend build dependency, not a workshop feature or direct dependency |

Preview and beta capabilities can change, have limited regional or tenant availability, and might not include a service-level agreement. Confirm current status and terms in the linked Microsoft Learn documentation before production use.

## Environment Model

### Participants

Participants receive a **preprovisioned environment** and direct links to their assigned Foundry project and lightbulb application. They do not install `azd`, run `azd up`, or provision Azure resources during the workshop.

Participants need:

- a supported browser;
- the workshop identity supplied by the organizer;
- access to the assigned Microsoft Foundry project and lightbulb application; and
- this repository for unit instructions and workshop assets.

### Organizers

Organizers deploy and validate environments before the session. Organizer workstations need:

- an Azure subscription and permission to deploy and assign required roles;
- [Azure Developer CLI (`azd`) 1.33 or later](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd);
- [Python 3.11+](https://www.python.org/downloads/);
- [uv](https://docs.astral.sh/uv/getting-started/installation/);
- [Node.js 18+](https://nodejs.org/); and
- access to [Microsoft Foundry](https://ai.azure.com).

Check the organizer CLI version with:

```bash
azd version
```

If it is older than 1.33, use the platform-specific package-manager or installer update command in the official [Install or update Azure Developer CLI](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd) guide.

## Organizer Setup

### 1. Clone the repository

```bash
git clone https://github.com/PennStateLefty/foundry-agents-150.git
cd foundry-agents-150
```

### 2. Provision the workshop environments

```bash
azd auth login
azd up
```

The infrastructure provisions:

- the existing Azure App Service hosting the React UI, REST API, and MCP server;
- Microsoft Foundry resources and project;
- Grounding with Bing;
- Azure AI Search at the **S1** tier;
- Application Insights and Log Analytics; and
- the project connections required for Search and observability.

Azure AI Search is connected to the Foundry project with Microsoft Entra ID authentication. The deployment assigns **Search Index Data Contributor** and **Search Service Contributor** to both the Foundry project identity and the workshop user.
It also grants the Search service identity **Cognitive Services User** on the Foundry account so Foundry IQ can use the deployed models for agentic retrieval and integrated vectorization.

> **Important:** Bicep provisions and connects Azure AI Search, but it does **not** create or ingest a Foundry IQ knowledge base. The organizer must author and ingest the curated knowledge base before the session, or reserve Unit 2 as a guided portal action. Use:
>
> - `docs/assets/lightbulb-manual.md`
> - `docs/assets/smartglow-support-policy.md`
> - `docs/assets/smartglow-operations-runbook.md`

The deployment also grants the workshop user the Foundry and telemetry access required by the labs, and grants the Foundry project identity the access needed for connected services. If a different workshop user needs access, pass that user's object ID:

```bash
azd up --parameter foundryUserPrincipalId=<USER_OBJECT_ID>
```

Before participants arrive, validate sign-in, model availability, Search connectivity, the curated knowledge base, MCP connectivity, traces, the prepared Toolbox and Skill, datasets, and the deployed application with the same identity participants will use.

### 3. Start the workshop

Open [Unit 1](docs/unit-1-agent-scope-and-boundaries.md).

## Architecture

```text
                             Microsoft Foundry
                    +--------------------------------+
Participant ------> | Lightbulb-Agent               |
                    |                                |
                    | Define / Instruct / Govern     |
                    | Version / Publish / Evaluate   |
                    +---+------------+-------------+-+
                        |            |             |
               curated  |            | MCP         | telemetry
              knowledge |            |             |
                        v            v             v
              +----------------+  +--------------------+  +------------------+
              | Foundry IQ     |  | Azure App Service  |  | Application      |
              | knowledge base |  |                    |  | Insights +       |
              | (preview)      |  |                    |  | Log Analytics    |
              +-------+--------+  | Python backend     |  +------------------+
                      |           | - MCP /mcp         |
                      v           | - REST /api/...    |
              +----------------+  | React frontend     |
              | Azure AI      |  +--------------------+
              | Search S1     |
              | curated index |
              +----------------+

Additional capabilities: Grounding with Bing, read-only Microsoft Learn MCP,
and a prepared Toolbox + Skill (preview for this workshop scenario).
```

Foundry and Search use Microsoft Entra ID rather than embedded Search keys. Tool actions still require their own backend authentication and authorization design; connecting an MCP endpoint is not, by itself, an authorization boundary.

Observability records the spans emitted for model calls, tool calls and results, retrieval operations, errors, latency, token usage, and final responses. Traces expose these **recorded model/tool/retrieval spans**; they do not reveal a model's private chain-of-thought.

## Project Structure

```text
foundry-agents-150/
|-- azure.yaml              # Azure Developer CLI project configuration
|-- infra/                  # Bicep infrastructure as code
|-- src/app/
|   |-- backend/            # Python FastAPI + MCP server
|   `-- frontend/           # React lightbulb UI
`-- docs/                   # Public unit guides and lab assets
```

## Local Development

Local development is optional and is not part of the participant workshop flow. Run the backend and frontend in **separate terminals**. The Vite development server proxies `/api` and `/mcp` requests to the backend.

### Backend

```bash
cd src/app/backend
uv venv
source .venv/bin/activate   # Windows PowerShell: .venv\Scripts\Activate.ps1
uv pip install -r requirements.txt
uvicorn main:app --reload
```

### Frontend

```bash
cd src/app/frontend
npm install
npm run dev
```

Open the Vite URL, normally `http://localhost:5173`. Proxied API and MCP requests reach the backend at `http://localhost:8000`.

## MCP Tools Reference

The lightbulb MCP server at `/mcp` exposes:

| Tool | Type | Description |
|---|---|---|
| `get_light_state` | Read | Return the current on/off state and color. |
| `toggle_light` | Write | Toggle the lightbulb on or off. |
| `set_color` | Write | Set the color to red, green, blue, yellow, or white. |

The workshop intentionally uses a simple stateful application. Production action tools should add workload identity, least-privilege authorization, validation, audit logging, idempotency where needed, and human approval for consequential operations.

## Organizer Redeployment

After application code changes, organizers can redeploy the prepared environment with:

```bash
azd deploy
```

Participants do not run this command.
