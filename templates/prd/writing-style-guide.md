---
name: prd-writing-style-guide
description: >
  Writing Style Guide for Executable PRDs. Defines the sections, what each must
  contain, tone, and format. Read by the PRD Content Generator; checked against by
  the PRD Reviewer. DRAFT v1 for review.
---

# Writing Style Guide — Executable PRD

An Executable PRD is the unit engineering builds. Write so an engineer who has not
been in any conversation can build it, and QA can test it, from this doc alone.

## Sections (in this order)

1. Objective
2. Why Now
3. Use Cases
4. Metrics
5. Rollout & Stage Gates
6. Worked Examples
7. Ops SOPs *(include only if Ops flows are touched; otherwise omit the heading)*

---

## Global rules (apply to every section)

- **Desired state, not current state.** Describe how the system will behave once
  built. Never describe bugs or current deficiencies as part of the spec. If a fix
  is a prerequisite, one line: *"Assumes [X] is resolved before implementation."*
- **Name the actor.** Every sentence that describes an action names who or what
  does it (customer, ops agent, Promise service). No passive voice.
- **Requirements use "must".** Avoid "should", "could", "might", "ideally".
  Anything uncertain goes in an Open Question, not a hedge.
- **Every requirement is testable.** If QA cannot pass or fail it, rewrite it.
- **Numbers carry units and a source.** "p90 delivery time of 26h (Metabase, last 30 days)", not "slow".
- **Name states and fields exactly.** Use the real system, entity, state and field
  names. Do not prescribe architecture, libraries or API design.
- **Define terms on first use** unless they appear in the loaded Context.
- **Parameter values:** where a number is a tunable threshold, state whether it is
  fixed or to be calibrated by experiment.
- **Unknowns are written, not hidden.** Use `Unknown: <what> — <why> — <owner/by when>`.
- **Brevity.** Cut any sentence that does not change what gets built or measured.

---

## 1. Objective

- **Purpose:** the single outcome this PRD delivers.
- **Must contain:** one outcome statement tied to the primary Success Metric.
- **Must not contain:** the problem, the solution, or how it will be built.
- **Tone:** declarative, outcome-first.
- **Format:** one sentence, 40 words max.

## 2. Why Now

- **Purpose:** the problem, and why it must be solved at this moment.
- **Must contain:**
  - who is affected, and what is broken or missing for them;
  - measured impact today (number + source);
  - the trigger that makes now the right time (a change in data, operations, or strategy);
  - the cost of waiting.
- **Must not contain:** the solution, or persuasive adjectives ("critical", "huge").
- **Tone:** factual, quantified.
- **Format:** short bullets, one per element above, each with a number where one
  exists. The four elements are mandatory; the length is not capped. Use a second
  sentence only where it changes what gets built or measured.

## 3. Use Cases

- **Purpose:** every journey the solution must handle, with expected behaviour.
- **Must contain, per use case:**
  - ID (UC1, UC1.1) for traceability to tests and metrics;
  - actor, trigger and preconditions;
  - main flow as numbered steps;
  - expected outcome, including the resulting system state;
  - named failure and edge cases nested beneath it (UC1.1, UC1.2), each with the
    expected system behaviour;
  - applicability across verticals where relevant, or an explicit "this vertical only".
- **Also must contain, once, after all use cases:** Open Questions, each tagged to
  the use case it blocks.
- **Roles:** the actor in each use case states who does it. Where different roles
  have different rights on the same action, add an unauthorised-actor failure case
  under that use case. No separate authorization table.
- **Must not contain:** implementation design, audit-trail or logging specs (these
  belong in the ARD), or a use case with only a happy path.
- **Tone:** procedural and unambiguous; one action per step.
- **Format:** primary use case as a heading, steps as a numbered list, sub-cases as
  nested numbered items; Open Questions as a table (Question | Blocks | Owner).
- **Coverage depth** (how many failure classes to consider) is the Content
  Generator's job, not this guide's.

## 4. Metrics

- **Purpose:** name what we will measure, in plain definitions.
- **Must contain:** one row per metric, each tagged with its type:
  - **Success** (supplied by the PM);
  - **Lead** (early indicator that a Success metric is moving);
  - **Check** (guardrail that must not regress).
- **Must contain:** a Definition that leaves no room for two readings: numerator
  and denominator for any rate, and the population it is measured over.
- **Must not contain:** targets, baselines, timeframes or breach thresholds.
  Targets live in Rollout as Scale Criteria; breach thresholds as Kill Criteria.
  Instrumentation detail belongs in the ARD.
- **Tone:** precise.
- **Format:** one table — Metric Type | Metric | Definition.

## 5. Rollout & Stage Gates

- **Purpose:** how it goes live, and what decides whether to scale or kill.
- **Must contain:** every stage, in order. Scale Criteria and Kill Criteria must be
  measurable and reference metrics named in Section 4.
- **Must contain:** shadow mode as Stage 1 if the feature is algorithmic or model-driven.
- **Must not contain:** a stage with no Scale or Kill Criteria.
- **Tone:** gate-like.
- **Format:** one table — Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria.

## 6. Worked Examples

- **Purpose:** make the behaviour concrete with real values.
- **Must contain:** at least one example per primary use case, plus at least one
  failure-path example. Each shows starting state with real values, the steps,
  and the resulting state and outputs, so any reader can check the use case by
  following the numbers.
- **Must not contain:** new requirements. An example illustrates; the Use Cases
  section defines. If an example reveals a missing rule, fix Use Cases.
- **Tone:** concrete, narrative-by-numbers.
- **Format:** one titled block per example: *Scenario* (one line), *Starting
  state*, *Steps*, *Result*. Reference the UC ID(s) it demonstrates.

## 7. Ops SOPs *(optional)*

- **Include only if** an operational flow, role or SOP is touched.
- **Purpose:** show what changes for Ops, and who owns it.
- **Must contain, per SOP:** SOP name, the step or role affected, what changes
  (added, changed, removed), the owning team, and training or comms needed before launch.
- **Must not contain:** SOPs that are not touched.
- **Tone:** neutral and operational.
- **Format:** table — SOP | Step or role affected | Change | Owner | Readiness needed.
