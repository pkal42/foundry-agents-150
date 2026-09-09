# Unit 7: Prove and Improve Quality

## Overview

In this unit, you'll turn observations into a repeatable quality loop:

**trace → diagnose → evaluate → improve → version → rerun → compare → monitor**

Foundry traces expose observable execution data—model spans, retrievals, tool calls and results, timing, token usage, and errors. They do **not** expose private hidden chain-of-thought. You'll use the repository's versioned evaluation dataset to test behavior instead of relying on ad-hoc demos.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed [Unit 6](./unit-6-safe-and-governed-actions.md)
- ✅ **Lightbulb-Agent** has the uploaded SmartGlow files or optional Foundry IQ knowledge base, MCP tools, instructions, and the workshop safety configuration
- ✅ The lightbulb application is available at **AZURE_WEBAPP_URL**
- ✅ Application Insights is provisioned and connected by workshop infrastructure
- ✅ Access to traces and monitoring data through the required Azure RBAC roles
- ✅ The dataset [`docs/assets/unit-7-evaluation-prompts.jsonl`](./assets/unit-7-evaluation-prompts.jsonl) is available locally
- ✅ A deployed judge model when an AI-assisted evaluator requires one — this workshop uses `gpt-5.4-mini`

> **📝 Note:** Treat the dataset as a versioned engineering asset. Change it through review when agent requirements or enterprise knowledge sources change.

The same dataset applies to both supported knowledge paths. Evaluate whether the agent selected and cited the correct SmartGlow document; do not require a Foundry IQ-specific retrieval mechanism.

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
For SmartGlow product features, specifications, and limitations, use the configured SmartGlow knowledge source before any public web or documentation tool.
```

Do not stop at one successful retry. The dataset provides repeatability.

### Step 4: Review the Evaluation Dataset

Open [`docs/assets/unit-7-evaluation-prompts.jsonl`](./assets/unit-7-evaluation-prompts.jsonl). Each JSONL row contains:

| Field | Purpose |
|---|---|
| `query` | Prompt sent to the agent |
| `expected_behavior` | Human-readable rubric for response and tool behavior |
| `category` | Failure grouping for analysis |

The dataset has 16 rows across 8 categories, **two rows per category**:

| Category | What it tests |
|---|---|
| `web_grounding` | Current public information, cited |
| `documentation_grounding` | Microsoft Learn MCP rather than generic web search |
| `workshop_knowledge` | Product manual facts and documented limitations |
| `knowledge_precedence` | Support Policy v2.0 superseding Product Manual v1.0 by subject |
| `grounding_regression` | Documented limitations that a fluent model tends to guess at |
| `conditional_tool_use` | Read state before writing |
| `multi_tool_routing` | Two servers in one request, in the right order |
| `safe_tool_use` | Refusal, and treating retrieved text as evidence rather than instruction |

Two rows per category is the smallest number that distinguishes a pattern from a one-off. With a single row, any failure is indistinguishable from noise, and Step 6's grouping has nothing to group. This is the difference between a demonstration and a regression suite: a demo shows the agent working once; a suite tells you whether a change helped.

`expected_behavior` is deliberately not a fixed answer: web facts and light state can change. It is a **rubric**, not a ground-truth response.

> **📝 Note:** Do not map `expected_behavior` to the `ground_truth` field during setup. It is the one slot that looks like it fits, and it does not. Response Completeness compares an answer against a ground-truth *answer*; these values are instructions such as "use web grounding and cite the sources used." Scoring prose against a rubric that way produces a number with no meaning. Keep the field for human review, or map it to a custom rubric evaluator that is designed to read it.

### Step 5: Run the Baseline Evaluation

The portal evaluation flow has several steps. Two of them decide whether the run returns anything useful, so do not skip them.

1. Open **Build** > **Agents** > **Lightbulb-Agent** > **Evaluation** > **Create**.
2. **Select the evaluation target:** **Agent**, then select `Lightbulb-Agent`.
3. **Select the evaluation scope:** **Individual turns**.

   > **⚠️ Important:** Choose **Individual turns**, not **Full conversations**. Agent evaluators — Intent Resolution, Task Adherence, Tool Call Accuracy, Tool Selection, and Tool Call Success — are available for the **Individual turns** scope only. If you select Full conversations, none of them appear in the testing-criteria list. Full conversations is also a preview scope and evaluates whole multi-turn conversations, which is not what this single-turn dataset contains.

4. **Select the data source:** **Existing dataset**, then choose [`docs/assets/unit-7-evaluation-prompts.jsonl`](./assets/unit-7-evaluation-prompts.jsonl). Upload it to the project's data assets first if it is not already there. Only CSV and JSONL are supported.
5. **Configure agents:** leave the user prompt at its default, `{{item.query}}`. This is how each dataset row is sent to the agent. Change it only if the agent expects a different input shape, which this one does not.
6. **Configure field mapping.** The portal tries to map dataset fields automatically. Check each field before continuing:

   | Field | Required | Where it comes from |
   |---|---|---|
   | `query` | Yes | The dataset's `query` column |
   | `response` | Yes | Generated by the agent during the run, not present in the dataset |
   | `tool_definitions` | No | The agent's connected tools |
   | `tool_calls` | No | The calls the agent makes during the run |
   | `context`, `ground_truth` | No | Not used by this dataset |

   > **⚠️ Important:** Any required field left **Unassigned** causes its evaluators to fail. The dataset intentionally has no `response` column because the agent produces the response during the run. Confirm that `response` resolves rather than showing as Unassigned before you submit. If it does not, tell the instructor — this is an environment question, not a dataset error.

7. **Select testing criteria.** Choose a focused set supported in your region:

   | Evaluator | Category | What it tells you here |
   |---|---|---|
   | Intent Resolution **(preview)** | Agent | Did the agent understand what was asked? |
   | Task Adherence **(preview)** | Agent | Did it follow the routing contract from Unit 3? |
   | Tool Selection | Agent | Did it choose the right tool, including choosing none? |
   | Tool Call Accuracy | Agent | Overall quality of tool selection and arguments |
   | Tool Call Success | Agent | Did the calls execute without technical failure? |
   | Tool Input Accuracy | Agent | Were the arguments correct — for example, a valid `set_color` value? |
   | Tool Output Utilization | Agent | Did the agent actually use what the tool returned? |
   | Response Completeness | Quality | Did the answer fully address the question? |

   Tool Input Accuracy and Tool Output Utilization map closely to two rules this workshop has repeated since Unit 1: validate arguments, and claim success only from tool evidence.

   > **📝 Preview labels:** Microsoft Learn marks Intent Resolution and Task Adherence as preview on the agent-evaluator reference page, while the portal how-to page does not. Expect the label to vary by page and portal build.

8. **Choose the judge model** when an AI-assisted evaluator requires one. Use the workshop's deployed `gpt-5.4-mini` unless your instructor names a different deployment. The judge model consumes model quota, and everyone in the room submits at roughly the same time, so a failed or slow run may be a quota issue rather than an agent problem.
9. `expected_behavior` is not consumed by any built-in evaluator above. Leave it unmapped and use it for human review, or map it to a **custom rubric evaluator** if one is configured. Do not map it to `ground_truth` — see Step 4.
10. **Review and submit.** Name the run:

    ```
    Lightbulb-Agent baseline
    ```

11. Inspect aggregate and per-sample results. Status values are In Progress, Completed, **Partial** (some evaluators failed), and Failed. A **Partial** result usually points at field mapping or judge-model quota, not at the agent.

> **⚠️ Live-data caution:** Judge whether the agent used a current source and cited it; do not ask an evaluator with stale knowledge to assert today's exact fact.

### Step 6: Improve and Version

1. Group failures by `category`. With two rows per category, ask what the pair tells you:

   | Pattern | Reading |
   |---|---|
   | Both rows fail | A real, repeatable problem in that behavior. Fix this first. |
   | One of two fails | Possibly phrasing-sensitive. Read both traces before changing anything. |
   | Both pass | No evidence of a problem here. Do not "improve" it. |

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

### Step 9: Optimize the Agent

> **🧪 Preview:** Agent Optimizer is a preview capability. Confirm it is enabled in your environment. If it is not, read this step and watch the instructor demonstration.

> **🎤 Instructor demonstration:** This step is normally demonstrated rather than performed by participants. The optimization run issues real tool calls against the lightbulb, so expect its state to change. Run it yourself only if your facilitator says the schedule allows.

Steps 6 and 7 had you change one thing, version it, rerun the dataset, and compare. Agent Optimizer runs that same loop automatically: it evaluates a baseline, generates candidate configurations, scores each against the same dataset, and ranks them.

For a **prompt agent** like this one, it runs entirely in the portal and can improve instructions, function-calling tool descriptions, and model selection. It cannot improve Skills — that target applies to hosted agents only.

1. Open **Lightbulb-Agent** and select the **Optimize** tab.
2. Start the optimization wizard and select:
   - the agent version you want as the **baseline** — use the version you evaluated in Step 5;
   - a **dataset** — [`unit-7-evaluation-prompts.jsonl`](./assets/unit-7-evaluation-prompts.jsonl), or a dataset generated from your agent's traces;
   - **evaluation criteria** — the evaluators you used for the baseline, so the comparison is like for like;
   - the **eval** and **candidate models**.
3. Review the cost estimate the portal shows before submitting.
4. Submit the run.
5. When it completes, compare baseline and candidate scores, read the before-and-after instructions, and inspect per-evaluator results.
6. Promote a candidate to a new agent version only after reading the diff.

Interpreting the result matters more than the score itself:

| Score improvement | Reading |
|---|---|
| Less than 0.03 | Noise. Not a meaningful improvement. |
| 0.03 to 0.10 | Moderate. Worth deploying. |
| 0.10 to 0.20 | Significant. |
| Greater than 0.20 | Large — usually a sign the baseline was weak, not that the candidate is exceptional. |

Two things to carry into production use:

- **The optimizer invokes your agent against every task in the dataset, so real tool calls execute.** Watch the lightbulb during the run; it will change repeatedly. Here that is harmless and makes the point visible. An agent that issues refunds, sends mail, or writes to a production system would perform those actions for every task in every candidate evaluation. Use test endpoints or mocked tools.
- **Optimized instructions are often longer**, which can increase token use per response. Judge whether the score improvement justifies the added cost.

Review candidate diffs and promote deliberately. An automated loop that both proposes and promotes its own changes has no review gate.

---

## Summary

You've completed the full quality lifecycle: traced behavior, diagnosed a root cause, evaluated a stable dataset, improved and versioned the agent, reran and compared results, and reviewed production monitoring.

### What's Next

In **[Unit 8: Version, Publish, and Operate](./unit-8-version-publish-and-operate.md)**, the instructor closes the workshop by connecting versions and evidence to a stable production entry point.

---

## Key Concepts

- **Trace** — OpenTelemetry-based evidence of observable model, retrieval, and tool operations. A receipt shows what was bought and when; it does not show why the shopper chose it. The trace is the receipt.
- **Diagnosis** — Identifying the observable root cause rather than judging only the final prose.
- **Evaluation Dataset** — A versioned set of repeatable scenarios and expected behavior.
- **Evaluator** — A built-in or custom scoring criterion for quality, tool use, or safety.
- **Agent Version** — A reviewable snapshot that enables comparison and rollback.
- **Regression** — A behavior that worked in the baseline but worsened in a candidate.
- **Monitoring** — Ongoing operational and quality signals from production traffic.
- **Agent Optimizer** — A preview capability that evaluates a baseline, generates candidate configurations, and ranks them against the same dataset. For prompt agents it runs in the portal and can improve instructions, tool descriptions, and model selection.
