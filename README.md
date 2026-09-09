# Foundry Agents 150

A hands-on workshop for building an enterprise-ready declarative agent in Microsoft Foundry. Participants define a focused agent, ground it in curated enterprise knowledge, route capabilities, take real actions through MCP, apply governance, evaluate quality, and prepare a stable version for distribution.

## Workshop Outcome

The workshop builds a `Lightbulb-Agent` and works through one enterprise agent lifecycle. It covers:

- keeping an agent within a defined business scope and communicating its limits;
- answering from configured SmartGlow files and current public information, with an optional reusable Foundry IQ knowledge base;
- routing requests across knowledge, read-only tools, and action tools;
- controlling a deployed lightbulb application through MCP;
- prepared Toolboxes and Skills **(preview for this workshop scenario)** for reusable capabilities;
- defense in depth across identity, authorization, approvals, and content safety;
- tracing, diagnosing, evaluating, improving, comparing, and monitoring agent quality; and
- versions, publishing, and a stable endpoint as the path to production.

How much of this a given session completes depends on its length and the environment. See the agenda below for timings.

The workshop follows one enterprise agent lifecycle:

**Define -> Ground -> Instruct -> Act -> Govern -> Evaluate -> Ship**

## What You'll Build

The workshop uses a **lightbulb web application** (Python + React) with a Python MCP server. The agent can inspect the light's state, toggle it on or off, and set a supported color. The simple device makes tool selection, authorization, state changes, traces, and evaluation results visible without hiding the enterprise patterns behind application complexity.

## Workshop Agenda

The workshop runs as eight units in order. Each builds on the agent produced by the previous one, so units cannot be reordered or skipped without breaking a later dependency — with the exception of the demo track below, which is designed to be droppable.

| Order | Block |
|---:|---|
| 1 | Opening and environment check |
| 2 | **Unit 1** — Agent scope and boundaries |
| 3 | **Unit 2** — Enterprise knowledge and grounding |
| 4 | **Unit 3** — Instructions and capability routing |
| 5 | Break |
| 6 | **Unit 4** — MCP tools and real-world actions |
| 7 | **Unit 5** — Reusable tools and Skills |
| 8 | **Unit 6** — Safe and governed actions |
| 9 | Break |
| 10 | **Unit 7** — Prove and improve agent quality |
| 11 | **Unit 8** — Version, publish, and operate |
| 12 | Wrap-up and next-capability decision |

Facilitators: session budget, per-unit estimates, cut order, preparation checklist, and per-unit talking points are in the **[instructor demo script](docs/instructor-demo-script.md)**.

### Demo track: where the advanced material lives

A 150-level session should still show participants what sits above the hands-on floor. Three capabilities carry that weight. They are demonstrations rather than participant steps because each has a cost — preview availability, elapsed run time, or pre-session setup — not because the concept is optional. Each is marked in its own unit, and each has a fallback that costs no Azure resources.

| Demo | Advanced concept it makes concrete | Requires | If it can't run live |
|---|---|---|---|
| **Unit 2, Steps 3–4** — Foundry IQ knowledge base | Retrieval as a governed, curated asset that is versioned and shared across agents, rather than files attached to one agent | Azure AI Search S1 and portal agentic retrieval (**preview**) | Continue on the uploaded files from Step 2. Every later unit works unchanged. Discuss the ownership difference using the Step 6 decision table |
| **Unit 5** — Toolboxes and Skills | Tools, credentials, and behavioral guidance as centrally governed, version-promoted assets consumed by many agents | Instructor-prepared toolbox and Skill (**preview**) | Read the unit and discuss the operating model. No later unit depends on it |
| **Unit 7, Step 9** — Agent Optimizer | Closing the evaluate-change-rerun loop automatically, and reading score deltas as evidence rather than as improvement | Agent Optimizer (**preview**); the run issues real tool calls | Read the step. Steps 6–7 already teach the same loop performed manually, which is the transferable skill |

Two further advanced topics are covered by discussion only, with no environment dependency at all:

- **Unit 6** raises indirect prompt injection and the tool-call and tool-response guardrail intervention points.
- **Unit 8, Step 4** maps the capabilities deliberately left out — hosted agents, Memory, Routines, long-running and autopilot patterns, A2A, and human-in-the-loop — to the requirement that would justify each. Read it alongside the [Feature Maturity](#feature-maturity) table below, which records the current status of the same capabilities.

Cutting a demo costs coverage of an advanced concept but never breaks a later unit. The cut order is in the [instructor demo script](docs/instructor-demo-script.md).

## Lab Units

| Unit | Topic | Description |
|---|---|---|
| [Unit 1](docs/unit-1-agent-scope-and-boundaries.md) | Build an Agent with Clear Scope and Boundaries | Create the baseline agent, define its job, and make supported and unsupported behavior explicit. |
| [Unit 2](docs/unit-2-enterprise-knowledge-grounding.md) | Enterprise Knowledge and Grounding | Ground the agent with uploaded SmartGlow files, then optionally build a reusable Foundry IQ knowledge base **(preview)** when Azure AI Search is available. |
| [Unit 3](docs/unit-3-instructions-and-capability-routing.md) | Instructions and Capability Routing | Structure instructions so the agent chooses authoritative knowledge, web grounding, or tools intentionally. |
| [Unit 4](docs/unit-4-mcp-tools-and-actions.md) | MCP Tools and Real-World Actions | Inspect a read-only Microsoft Learn MCP call, then use MCP action tools to read and change lightbulb state. |
| [Unit 5](docs/unit-5-toolboxes-and-skills.md) | Reusable Tools and Skills | Connect a prepared Toolbox and Skill **(preview for this workshop scenario)** to centralize reusable capabilities and behavior. |
| [Unit 6](docs/unit-6-safe-and-governed-actions.md) | Safe and Governed Actions | Apply defense in depth; tool-call/tool-response guardrail intervention points and human-in-the-loop approval are **preview** capabilities. |
| [Unit 7](docs/unit-7-prove-and-improve-quality.md) | Prove and Improve Agent Quality | Run the quality loop and optionally demonstrate Agent Optimizer **(preview)**. |
| [Unit 8](docs/unit-8-version-publish-and-operate.md) | Version, Publish, and Operate | Review versions, publishing, stable endpoints, distribution, and CI/CD without performing a live deployment. |

## Feature Maturity

This workshop intentionally includes recent Microsoft Foundry capabilities. Treat the following labels as part of the learning material, not as production-readiness endorsements. The preview rows marked as demonstrations are covered in the [demo track](#demo-track-where-the-advanced-material-lives); the rows marked *not used* are mapped to the requirement that would justify them in Unit 8, Step 4.

| Component | Status used by this workshop | Impact |
|---|---|---|
| App Service, Application Insights, and Log Analytics | Generally available services | Core infrastructure |
| Grounding with Bing Search | Generally available service | Unit 2 web grounding. The Bing resource is created and owned by the deploying organization. Data sent to it leaves the Azure compliance and Geo boundary, and the Data Protection Addendum does not apply |
| Web search tool | Generally available | Not used by this workshop. An alternative where the Bing resource is managed by Microsoft; contrasted with Grounding with Bing in Unit 2 |
| Grounding with Bing Custom Search | **Preview** | Not used; mentioned only as the domain-restricted option |
| Web IQ | **Limited access** | Not used. A Microsoft IQ capability for public-web retrieval, noted in Unit 2 because of the naming overlap with Foundry IQ |
| Azure AI Search S1 | Generally available service | Optional infrastructure for the Foundry IQ extension in Unit 2; deployment depends on regional capacity |
| Foundry IQ knowledge-base and agentic-retrieval portal experience | **Preview** | Optional Unit 2 extension; uploaded workshop files are the required baseline. Some Foundry IQ features are generally available at certain Search REST API versions, but portal access to agentic retrieval — the path this workshop uses — remains preview |
| Toolboxes and toolbox-based Skill discovery | **Preview for this workshop scenario** | Core Unit 5 concept; screenshots and a directly connected agent are the fallback |
| Guardrail tool-call and tool-response intervention points | **Preview** | Unit 6 demonstration only; agents only, not models; backend authorization remains mandatory |
| Human-in-the-loop approval | **Preview** | Discussed as a control for consequential actions |
| Agent evaluators: Intent Resolution and Task Adherence | **Preview** | Used in Unit 7. The remaining agent evaluators carry no preview marker; labelling varies between Microsoft Learn pages |
| Agent Optimizer | **Preview** | Unit 7 Step 9. Supports prompt agents through the portal **Optimize** tab, with candidates promotable to a new agent version; Skill optimization applies to hosted agents only |
| Memory, Routines, long-running/autopilot patterns, and A2A | **Preview where identified by current documentation** | Mentioned only in the Unit 8 decision map |
| Foundry and Bing Bicep resource APIs | **Preview API versions** (`2025-04-01-preview` and `2025-05-01-preview`) | Required by the current `azd` deployment templates |
| Microsoft Foundry `azd` extensions | **Beta** | Organizer tooling only; participants do not install or invoke it |
| `gensync@1.0.0-beta.2` | **Beta transitive npm dependency** | Frontend build dependency, not a workshop feature or direct dependency |

Preview and beta capabilities can change, have limited regional or tenant availability, and might not include a service-level agreement. Confirm current status and terms in the linked Microsoft Learn documentation before production use.

The workshop's required learning outcomes do not require Azure AI Search. Uploaded SmartGlow files support grounding, citations, source precedence, capability routing, safety exercises, traces, and evaluations; the optional Foundry IQ path adds centralized reuse and lifecycle governance.

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
git clone https://github.com/pkal42/foundry-agents-150.git
cd foundry-agents-150
```

### 2. Provision the workshop environments

```bash
azd auth login
azd env new <environment-name>
azd env set AZURE_SUBSCRIPTION_ID <subscription-id>
azd up
```

`azd up` asks the organizer to select an Azure region when provisioning each new environment. Region selection is required and has no infrastructure default. AZD retains the selected region for later redeployments of that same environment.

Choose a region that has the workshop's models. `gpt-5.4` and `gpt-5.4-mini` are verified present in `centralus`, `eastus`, `eastus2`, `southcentralus`, and `westus3`, and verified absent in `westus2`. Confirm before provisioning:

```bash
az cognitiveservices model list -l <region> --query "[?model.name=='gpt-5.4'].model.name" -o tsv
```

If the App Service plan fails with `No available instances to satisfy this request`, the region is out of capacity for that SKU rather than misconfigured. Raise the SKU and rerun — `azd up` is incremental, so everything already provisioned is retained:

```bash
azd env set AZURE_APP_SERVICE_PLAN_SKU P0V3
azd up
```

The default is `B1`. Allowed values are `B1`, `B2`, `B3`, `S1`, `S2`, `P0V3`, `P1V3`, and `P2V3`. Facilitators should read the [deployment problems](docs/instructor-demo-script.md#deployment-problems-seen-in-practice) table before the first provisioning attempt.

The infrastructure provisions:

- Azure App Service hosting the React UI, REST API, and MCP server;
- Microsoft Foundry resources and project;
- Grounding with Bing;
- Application Insights and Log Analytics; and
- the project connection required for observability.

| Resource | SKU or configuration |
|---|---|
| Linux Azure App Service plan | Basic B1 |
| Microsoft Foundry / Azure AI Services | S0 |
| `gpt-5.4` | Global Standard, version `2026-03-05`, 80K TPM |
| `gpt-5.4-mini` | Global Standard, version `2026-03-17`, 200K TPM |
| Grounding with Bing | G1 |
| Log Analytics | 30-day retention |
| Application Insights | Workspace-based |
| Azure AI Search, when enabled | Standard S1, one replica, one partition, semantic search Standard |

Confirm that the selected region has App Service B1 capacity, both model versions and their required quota, and, when enabled, Azure AI Search S1 capacity. The complete topology, including optional Search, has been validated and deployed successfully in **Central US**. Regional capacity can change, so a successful deployment in one subscription or at an earlier time does not guarantee future availability.

Azure AI Search is optional because S1 capacity can vary by region. To include the Foundry IQ extension, confirm regional capacity, enable it for the selected environment, and deploy:

```bash
azd env set DEPLOY_AZURE_AI_SEARCH true
azd up
```

`DEPLOY_AZURE_AI_SEARCH` is scoped to the selected AZD environment. If it is unset, the deployment defaults to `false` and no Search service or Search connection is created.

When enabled, Azure AI Search is connected to the Foundry project with Microsoft Entra ID authentication. The deployment assigns **Search Index Data Contributor** and **Search Service Contributor** to both the Foundry project identity and the workshop user. It also grants the Search service identity **Cognitive Services User** on the Foundry account.

> **Important:** The required Unit 2 path uses uploaded files and does not require Azure AI Search. Enabling Search provisions the connection, but it does **not** create or ingest a Foundry IQ knowledge base. The organizer must author and ingest the optional knowledge base before the session or reserve it as a guided portal extension. Use:
>
> - `docs/assets/lightbulb-manual.md`
> - `docs/assets/smartglow-support-policy.md`
> - `docs/assets/smartglow-operations-runbook.md`

The deployment grants the deploying user the Foundry and telemetry access required by the labs and grants the Foundry project identity the access needed for connected services.

Before participants arrive, validate sign-in, model availability, uploaded-file grounding, MCP connectivity, traces, the prepared Toolbox and Skill, datasets, and the deployed application with the same identity participants will use. If the optional Foundry IQ path is enabled, also validate Search connectivity and the curated knowledge base.

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
              workshop  |            | MCP         | telemetry
              knowledge |            |             |
                        v            v             v
              +----------------+  +--------------------+  +------------------+
              | Uploaded files |  | Azure App Service  |  | Application      |
              | (required)     |  |                    |  | Insights +       |
              |                |  | Python backend     |  | Log Analytics    |
              +----------------+  | - MCP /mcp         |  +------------------+
                                  | - REST /api/...    |
              +----------------+  | React frontend     |
              | Foundry IQ +   |  +--------------------+
              | Azure AI       |
              | Search S1      |
              | (optional)     |
              +----------------+

Additional capabilities: Grounding with Bing, read-only Microsoft Learn MCP,
and a prepared Toolbox + Skill (preview for this workshop scenario).
```

When the optional Search path is enabled, Foundry and Search use Microsoft Entra ID rather than embedded Search keys. Tool actions still require their own backend authentication and authorization design; connecting an MCP endpoint is not, by itself, an authorization boundary.

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
