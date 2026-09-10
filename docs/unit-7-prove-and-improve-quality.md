# Unit 7: Prove and Improve Quality

## Overview

In this unit, you'll stop judging the agent by whether one demo went well, and start measuring it.

The loop is:

**trace → diagnose → evaluate → improve → version → compare → monitor**

In plain terms: look at what actually happened, work out why it went wrong, check whether it goes wrong repeatedly, make one small fix, and prove the fix helped.

### What you will actually do

| Part | Needs | Always works? |
|---|---|---|
| Steps 1–3 — read traces, diagnose one failure | Application Insights connected | ✅ Yes |
| Step 4 — read the dataset | Nothing extra | ✅ Yes |
| Steps 5–7 — run and compare evaluations | The **Evaluation** page and a judge model | ⚠️ Usually |
| Step 8 — monitor | Traffic in the project | ✅ Yes |
| Step 9 — Agent Optimizer | Agent Optimizer (**preview**) | ⚠️ Only if shown |

### One term to know: a trace

A **trace** is the recorded receipt of a single request: which model was called, what was retrieved, which tools ran with which arguments, what they returned, how long it took, and what tokens it cost.

A receipt shows what was bought and what it cost. It does not show the shopper's deliberation. In the same way, traces show the model's *observable* steps — they do not expose private hidden chain-of-thought.

---

## Prerequisites

Before starting this unit, make sure you have:

- ✅ Completed [Unit 6](./unit-6-safe-and-governed-actions.md)
- ✅ A working **Lightbulb-Agent** with SmartGlow knowledge, MCP tools, instructions, and safety controls
- ✅ The lightbulb application at **AZURE_WEBAPP_URL**
- ✅ Application Insights connected to the Foundry project
- ✅ Access to traces and monitoring through Azure RBAC
- ✅ [`unit-7-evaluation-prompts.jsonl`](./assets/unit-7-evaluation-prompts.jsonl)
- ✅ A judge model for AI-assisted evaluators — this workshop uses `gpt-5.4-mini`

> **📝 Note:** Keep the evaluation dataset under version control. Update it when requirements or approved knowledge sources change.

---

## Concept: Quality Is a Loop

| Phase | Question |
|---|---|
| **Trace** | What happened? |
| **Diagnose** | What observable behavior caused the failure? |
| **Evaluate** | Does the behavior repeat? |
| **Improve** | What is the smallest useful change? |
| **Version** | What changed, and can it be rolled back? |
| **Compare** | Did the change help without causing regressions? |
| **Monitor** | Does production behavior remain healthy? |

---

## Steps

### Step 1: Open a Trace

1. Open the Foundry project.
2. Select **Build** > **Agents** > **Traces**.
3. Confirm the Application Insights connection.
4. Send one playground request.
5. Wait for telemetry ingestion if needed, then open the trace.

> **⚠️ Important:** Traces can contain prompts, outputs, retrieved content, and tool arguments. Do not include secrets, minimize personal data, and restrict telemetry access.

### Step 2: Trace a Conditional Action

Run:

```text
Check if the light is on. If it is off, turn it on and set it to blue.
```

Confirm that the trace shows:

1. `get_light_state`
2. `toggle_light` only when the light was off
3. `set_color` with `blue`
4. Successful tool results
5. A final response based on those results

Use the trace to verify observable calls and results, not hidden reasoning.

### Step 3: Diagnose a Routing Failure

Run:

```text
What's the maximum brightness of the SmartGlow lightbulb?
```

The correct response should use SmartGlow workshop knowledge and report the documented limitation.

Check:

- Which knowledge source was used
- Whether an unrelated tool ran
- Whether the response used and cited the retrieved evidence
- Whether the trace contains errors, delay, or oversized results

If the wrong source was selected, add or tighten this instruction:

```text
For SmartGlow product features, specifications, and limitations, use the
configured SmartGlow knowledge source before any public web or documentation tool.
```

One successful retry is not enough. Use the evaluation dataset to test the behavior repeatedly.

### Step 4: Review the Dataset

Open [`unit-7-evaluation-prompts.jsonl`](./assets/unit-7-evaluation-prompts.jsonl).

Each row contains:

| Field | Purpose |
|---|---|
| `query` | Prompt sent to the agent |
| `expected_behavior` | Rubric for human or custom evaluation |
| `category` | Group used to compare similar failures |

The dataset contains two scenarios for each category:

| Category | Behavior tested |
|---|---|
| `web_grounding` | Current public information with citations |
| `read_only_tool_use` | Read state without changing it |
| `workshop_knowledge` | SmartGlow facts and limitations |
| `knowledge_precedence` | Use the correct document for the subject |
| `grounding_regression` | Avoid plausible but unsupported answers |
| `conditional_tool_use` | Read state before writing |
| `multi_tool_routing` | Use multiple tools in the correct order |
| `safe_tool_use` | Refuse unsafe actions and ignore embedded instructions |

`expected_behavior` is a rubric, not a fixed answer.

> **⚠️ Important:** Do not map `expected_behavior` to `ground_truth`. Keep it for human review or a custom rubric evaluator.

### Step 5: Run the Baseline Evaluation

A **baseline** is the score you get before you change anything. Without it you cannot prove an improvement later.

1. Open **Build** > **Agents** > **Lightbulb-Agent** > **Evaluation** > **Create**.
2. Select **Agent** and choose `Lightbulb-Agent`.
3. Select **Individual turns**.
4. Select **Existing dataset** and choose `unit-7-evaluation-prompts.jsonl`.
5. Keep the user prompt as `{{item.query}}`.
6. Review the field mapping:

   | Field | Mapping |
   |---|---|
   | `query` | Dataset `query` |
   | `response` | Generated agent response |
   | `tool_definitions` | Connected agent tools |
   | `tool_calls` | Calls made during the run |
   | `context`, `ground_truth` | Leave unused |

   > **⚠️ Check `response` before submitting.** The dataset has no `response` column, because the agent generates it during the run. Whether the portal fills this in automatically for an agent target is not documented, so do not assume it. If it shows **Unassigned**, assign it manually — evaluators fail on unassigned required fields.

7. Select a focused set of evaluators available in your region:

   - Tool Selection
   - Tool Call Success
   - Tool Input Accuracy
   - Tool Output Utilization
   - Response Completeness
   - Intent Resolution or Task Adherence, when available

8. Choose `gpt-5.4-mini` when an evaluator requires a judge model. A **judge model** is a second model that scores the first one's answers.
9. Name the run `Lightbulb-Agent baseline`.
10. Submit the run and inspect aggregate and per-row results.

The run takes several minutes. Read Step 6 while it finishes.

> **⚠️ Two common mistakes:** Select **Individual turns**, not **Full conversations** — the agent evaluators only run on individual turns, and the portal's own tip may suggest the wrong one. And confirm no required field is left **Unassigned**.

A **Partial** result usually means a field mapping or an evaluator failed, not that the agent behaved badly. Open the run details before blaming the agent.

### Step 6: Improve and Version

Group failures by `category`:

| Result | Interpretation |
|---|---|
| Both rows fail | Likely repeatable behavior; investigate first |
| One row fails | Possibly phrasing-sensitive; compare both traces |
| Both rows pass | No evidence that this behavior needs a change |

For a representative failure:

1. Open the trace.
2. Identify the cause.
3. Make the smallest coherent change.
4. Save a new agent or capability version.
5. Record the baseline and candidate version numbers.

| Cause | Typical fix |
|---|---|
| Wrong source | Knowledge configuration or source precedence |
| Wrong tool | Tool description or routing instruction |
| Invalid argument | Schema or backend validation |
| Missing permission | Identity and RBAC or API scope |
| Incomplete response | Response instructions or result handling |
| Safety failure | Guardrail, authorization, or approval policy |

### Step 7: Rerun and Compare

Run the **same dataset** against the candidate version. Changing the dataset and the agent at the same time makes the comparison meaningless.

Compare:

- Aggregate and per-category scores
- Tool selection and success
- Safety behavior
- Latency and token usage
- Any new errors

> **⚠️ Read small differences as noise.** A score change below roughly 0.03 is not evidence of improvement. Resist narrating it as one — that habit is the main thing this unit is trying to break. The same caution applies per category: a change is meaningful when **both rows in a category move the same way**. One row moving is phrasing sensitivity, which is exactly why the dataset has two rows per category.

Promote the candidate only when it clearly improves the behavior you targeted and does not make another category worse. Keep the baseline version so you can roll back.

### Step 8: Monitor

Open the agent's **Monitor** experience and review:

- Run and tool failures
- Model, retrieval, and tool latency
- Token and cost trends
- Evaluation trends
- Safety signals, when configured

Add a dataset scenario whenever a new production failure is found.

### Optional Step 9: Try Agent Optimizer

> **📝 Note:** Skip this step if your agent has no **Optimize** tab. Agent Optimizer is a **preview** capability. It runs real agent requests and **will call your connected tools** — expect the lightbulb to change during the run, and use a test environment.

Agent Optimizer automates the loop you just did by hand:

1. Open **Lightbulb-Agent** and select **Optimize**.
2. Choose the evaluated baseline version.
3. Select the workshop dataset and the same evaluators.
4. Choose the evaluation and candidate models.
5. Review the cost estimate and submit.
6. Compare the candidate scores and the proposed instruction changes.
7. Promote only after reading the diff and checking for regressions.

For prompt agents, it can change instructions, function-tool descriptions, and model selection. It does not optimize Skills — that target applies to hosted agents only.

The automation is convenience. The loop in Steps 6 and 7 is the skill.

### Enterprise Takeaway

Agent quality requires evidence, not a successful demo. Trace behavior, test stable scenarios, make a focused change, compare versions, and monitor the promoted result.

---

## Summary

You've traced agent behavior, diagnosed a routing problem, evaluated a versioned dataset, created a candidate version, compared results, and reviewed monitoring.

### What's Next

In **[Unit 8: Version, Publish, and Operate](./unit-8-version-publish-and-operate.md)**, you'll connect evaluation evidence to a controlled production release.

---

## Key Concepts

- **Trace** — Observable model, retrieval, and tool operations.
- **Evaluation Dataset** — Versioned scenarios used for repeatable testing.
- **Evaluator** — A criterion that scores response or tool behavior.
- **Agent Version** — A reviewable snapshot used for comparison and rollback.
- **Regression** — Behavior that worsens after a change.
- **Monitoring** — Operational and quality signals from production traffic.
- **Agent Optimizer** — A preview capability that creates and scores candidate configurations.
