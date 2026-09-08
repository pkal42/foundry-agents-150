# Unit 7: Prove and Improve Quality

## Overview

In this 27-minute unit, you'll turn observations into a repeatable quality loop:

**trace → diagnose → evaluate → improve → version → rerun → compare → monitor**

Foundry traces expose observable execution data—model spans, retrievals, tool calls and results, timing, token usage, and errors. They do **not** expose private hidden chain-of-thought. You'll use the repository's versioned evaluation dataset to test behavior instead of relying on ad-hoc demos.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed [Unit 6](./unit-6-safe-and-governed-actions.md)
- ✅ **Lightbulb-Agent** has knowledge, MCP tools, instructions, and the workshop safety configuration
- ✅ The lightbulb application is available at **AZURE_WEBAPP_URL**
- ✅ Application Insights is provisioned and connected by workshop infrastructure
- ✅ Access to traces and monitoring data through the required Azure RBAC roles
- ✅ The dataset [`docs/assets/unit-7-evaluation-prompts.jsonl`](./assets/unit-7-evaluation-prompts.jsonl) is available locally
- ✅ A deployed judge model when an AI-assisted evaluator requires one

> **📝 Note:** Treat the dataset as a versioned engineering asset. Change it through review when agent requirements or enterprise knowledge sources change.

---

## Concept: Quality Is a Lifecycle

| Phase | Question | Evidence |
|---|---|---|
| **Trace** | What happened? | Spans, retrievals, calls, results, errors, latency |
| **Diagnose** | Why did the observable path fail? | Wrong source, arguments, sequence, permission, or response use |
| **Evaluate** | Does the failure repeat across scenarios? | Versioned dataset and evaluators |
| **Improve** | What smallest change addresses the cause? | Instruction, description, source, schema, permission, or code |
| **Version** | What changed and can we roll back? | Immutable agent/capability version |
| **Rerun** | Did the same tests improve? | Evaluation against the same dataset version |
| **Compare** | Did quality improve without unacceptable tradeoffs? | Scores, failures, latency, tokens, safety |
| **Monitor** | Does production behavior stay healthy? | Application Insights and monitoring trends |

---

## Steps

### Step 1: Open Traces

1. Open the Foundry project.
2. Select **Build** > **Agents** > **Traces**.
3. Confirm the workshop Application Insights connection.
4. Send one playground request, wait for telemetry ingestion if necessary, then open its trace.

> **🔒 Privacy:** Traces can contain prompts, outputs, retrieved content, and tool arguments or results. Do not place secrets in prompts or tool calls. Minimize personal data and restrict telemetry access with Azure RBAC.

### Step 2: Trace a Conditional Action

Run:

```
Check if the light is on. If it is off, turn it on and set it to blue.
```

Inspect the observable path:

1. `get_light_state`
2. Its returned power and color state
3. Conditional `toggle_light` only if required
4. `set_color` with `blue`
5. Tool results and final response

Verify the condition by comparing the state result with subsequent calls. Do not describe hidden reasoning or claim the trace reveals chain-of-thought.

### Step 3: Diagnose a Source-Routing Failure

Run:

```
What's the maximum brightness of the SmartGlow lightbulb?
```

A correct run should use SmartGlow workshop knowledge and report the documented limitation. Diagnose:

- Did retrieval use the intended knowledge source?
- Did another tool run unnecessarily?
- Did the response cite and accurately use retrieved evidence?
- Were there errors, excessive latency, or large tool responses?

If routing is wrong, add or tighten:

```
For SmartGlow product features, specifications, and limitations, use the curated SmartGlow knowledge source before any public web or documentation tool.
```

Do not stop at one successful retry. The dataset provides repeatability.

### Step 4: Review the Evaluation Dataset

Open [`docs/assets/unit-7-evaluation-prompts.jsonl`](./assets/unit-7-evaluation-prompts.jsonl). Each JSONL row contains:

| Field | Purpose |
|---|---|
| `query` | Prompt sent to the agent |
| `expected_behavior` | Human-readable rubric for response and tool behavior |
| `category` | Failure grouping for analysis |

The scenarios cover web and documentation grounding, curated-knowledge retrieval and precedence, conditional tool use, multi-tool routing, grounding regression, and safe tool behavior.

`expected_behavior` is deliberately not a fixed answer: web facts and light state can change. Built-in evaluators might not consume this field, so retain it for human review or map it to a custom rubric evaluator.

### Step 5: Run the Baseline Evaluation

1. Open **Build** > **Agents** > **Lightbulb-Agent** > **Evaluation**.
2. Create an agent-target evaluation using [`docs/assets/unit-7-evaluation-prompts.jsonl`](./assets/unit-7-evaluation-prompts.jsonl).
3. Map the user prompt to `{{item.query}}`.
4. Select a focused set supported in your region, such as:
   - Intent Resolution
   - Task Adherence
   - Tool Call Accuracy
   - Tool Selection
   - Tool Call Success
   - Response Completeness
5. If available, configure a custom rubric using `{{item.expected_behavior}}`.
6. Choose the deployed judge model when required.
7. Name the run:

   ```
   Lightbulb-Agent baseline
   ```

8. Submit and inspect aggregate and per-sample results.

> **⚠️ Live-data caution:** Judge whether the agent used a current source and cited it; do not ask an evaluator with stale knowledge to assert today's exact fact.

### Step 6: Improve and Version

1. Group failures by `category`.
2. Open traces for representative failures.
3. Classify the root cause:

   | Cause | Typical fix |
   |---|---|
   | Wrong source | Source precedence or knowledge configuration |
   | Wrong tool | Tool description or routing contract |
   | Invalid argument | Schema and backend validation |
   | Missing permission | Identity and RBAC/API scope |
   | Incomplete response | Response contract or result handling |
   | Safety failure | Guardrail, authorization, or approval policy |

4. Make the smallest coherent change.
5. Save it as a new agent or capability version. Record the baseline version and the candidate version.

### Step 7: Rerun and Compare

Rerun the **same dataset version** against the candidate. Compare:

- Aggregate and per-category quality
- Tool-selection and tool-success regressions
- Safety behavior
- Latency and token usage
- New operational errors

Promote only when the candidate improves the target behavior without unacceptable regressions. If it fails, keep the baseline available for rollback.

### Step 8: Monitor

Open the agent's **Monitor** experience and review:

- Run success and tool failures
- Latency by model, retrieval, and tool spans
- Token usage and cost trends
- Available evaluation trends
- Safety and red-team signals where configured

Scheduled or continuous evaluations, red-team scans, and alerts can be preview or region-dependent. Treat the evaluation dataset as a living regression suite: add a scenario when a new failure is found.

### Step 9: Instructor Preview — Agent Optimizer

> **🧪 Instructor-led preview:** Agent Optimizer is demonstrated only if enabled in the environment. It is not required for participant completion.

The instructor shows how Agent Optimizer can generate and evaluate candidate changes, then emphasizes:

- Start from a versioned baseline and explicit evaluation criteria.
- Review candidate diffs; do not auto-promote.
- Apply a selected candidate to source or configuration through a reviewable workflow.
- Rerun the same evaluation suite before deployment.
- Agent Optimizer support and setup depend on agent type and runtime; the hosted Python optimization workflow does not automatically apply to this portal-first prompt agent.

---

## Summary

You've completed the full quality lifecycle: traced behavior, diagnosed a root cause, evaluated a stable dataset, improved and versioned the agent, reran and compared results, and reviewed production monitoring.

### What's Next

In **[Unit 8: Version, Publish, and Operate](./unit-8-version-publish-and-operate.md)**, the instructor closes the workshop by connecting versions and evidence to a stable production entry point.

---

## Key Concepts

- **Trace** — OpenTelemetry-based evidence of observable model, retrieval, and tool operations.
- **Diagnosis** — Identifying the observable root cause rather than judging only the final prose.
- **Evaluation Dataset** — A versioned set of repeatable scenarios and expected behavior.
- **Evaluator** — A built-in or custom scoring criterion for quality, tool use, or safety.
- **Agent Version** — A reviewable snapshot that enables comparison and rollback.
- **Regression** — A behavior that worked in the baseline but worsened in a candidate.
- **Monitoring** — Ongoing operational and quality signals from production traffic.
- **Agent Optimizer** — A capability for generating and testing candidate improvements; availability and supported workflows vary.
