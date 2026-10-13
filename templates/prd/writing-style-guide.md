---
name: prd-writing-style-guide
description: >
  Writing Style Guide for Executable PRDs. Defines the sections, what each must
  contain, voice, tone, and format. Read by the PRD Content Generator; checked
  against by the PRD Reviewer. v2: voice rewrite (2026-10-13).
---

# Writing Style Guide — Executable PRD

An Executable PRD is the unit engineering builds. Write it the way a PM explains a
design to the team that will build it: plain, direct, and in the words the
operation already uses (roles, screens, states, messages). An engineer who was
not in the room must be able to build it, and QA test it, from this doc alone.

## Sections (in this order)

1. Objective
2. Why Now
3. Use Cases
4. Metrics
5. Rollout & Stage Gates
6. Worked Examples
7. Ops SOPs *(include only if Ops flows are touched; otherwise omit the heading)*

---

## Voice (applies to every section)

- **Explain, then qualify.** Say how it works, step by step. Then say what
  happens when it goes wrong. Do not catalogue every conceivable failure.
- **Use the operation's own words:** roles, screens, states, and the exact
  on-screen messages. Do not use the agent's working vocabulary in the PRD (no
  "lens", "Breaks", "Signal", "Knock-on", "Check 2") and no internal tags
  (OQ5, K1, "Guards UC1.6").
- **Specify only what the PM's inputs and Context support.** Do not invent
  screens, prompts, states, limits, timers or rules to settle an ambiguity. Write
  the simplest behaviour the inputs imply. If a decision is not made yet, say so
  plainly (see Unknowns).
- **Prefer the system resolving a case over asking a person to decide it.**

## Global rules (apply to every section)

- **Desired state, not current state.** Describe how the system will behave once
  built. Never describe bugs or current deficiencies as part of the spec. If a fix
  is a prerequisite, one line: *"Assumes [X] is resolved before implementation."*
- **Name the actor.** Every sentence that describes an action names who or what
  does it (customer, ops agent, Promise service). No passive voice.
- **ARD** means Analytics Requirement Document, the separate doc that defines events,
  tables, fields and audit logging. This PRD does not specify them.
- **People are specified too.** Where a person acts, name the role and the action.
  Where they might not act, say who or what notices, after how long, and what
  happens next. "Ops handles it" is not a requirement.
- **Requirements use "must".** Avoid "should", "could", "might", "ideally".
- **Every requirement is testable.** If QA cannot pass or fail it, rewrite it.
- **Numbers carry units and a source.** "p90 delivery time of 26h (Metabase, last 30 days)", not "slow".
- **Name states and fields exactly.** Use the real system, entity, state and field
  names. Do not prescribe architecture, libraries or API design.
- **Define terms on first use** unless they appear in the loaded Context.
- **Parameter values:** where a number is a tunable threshold, state whether it is
  fixed or to be calibrated by experiment.
- **Unknowns are stated plainly, where they arise.** A short sentence: "Baseline
  not yet measured." No tags, no owner labels inside sentences. Anything that
  blocks building goes in the short Open points list (see Use Cases).
- **Brevity (mandatory).** Write the shortest text that still lets engineering build
  it, QA test it, and the team measure it.
  - **Delete test:** if removing a sentence or phrase would not change what gets
    built, tested or measured, remove it.
  - One idea per sentence. Requirements and steps are one action, about 20 words or fewer.
  - **State each fact once.** Do not restate it in another section; refer back by
    the use case's number or title, and only where the reader needs it.
  - No preamble, no summary of what a section is about, no closing recap, no
    meta-commentary ("This section describes…").
  - No filler: drop "in order to", "it is important to note", "basically", and
    adverbs that add no meaning.
  - Explain only what a reader on this team would not already know. Do not explain
    terms found in Context.
  - **Brevity never overrides what the builder needs.** Cut words and low-value
    cases, but do not drop a failure that changes what gets built or what a person
    must do.

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
  - how it works today where that explains the problem (a few plain steps);
  - measured impact today (number + source), or a plain statement that it is not measured;
  - the trigger that makes now the right time (a change in data, operations, or strategy);
  - the cost of waiting.
- **Must not contain:** the solution, or persuasive adjectives ("critical", "huge").
- **Tone:** factual, like a PM making the case to a colleague.
- **Format:** short paragraphs or a short list. The elements above are mandatory;
  the length is not capped. A second sentence only where it changes what gets built
  or measured.

## 3. Use Cases

- **Purpose:** every journey the solution must handle, and what happens when it
  goes wrong, in a form the team can build from.
- **Must contain, per use case:**
  - a heading, "Use Case 1: <what it does>", with sub-cases numbered 1.1, 1.2;
  - who does it and what triggers it, in a line or two (preconditions only if they matter);
  - the main flow as numbered steps, with exact messages and values;
  - the result: the state the order or system ends in;
  - **edge cases** as titled sub-cases ("Use Case 1.3: Edge Case — <the situation
    in plain words>"), each a few numbered steps or bullets saying what the system
    does and what the person must do. Where a person might not act: who or what
    notices, after how long, and what happens next;
  - applicability across verticals where relevant, or an explicit "this vertical only".
- **Choosing edge cases:** include one only if it changes what gets built or what a
  person must do. Merge near-duplicates. Several edge cases with the same
  handling become one. As a rough guide, more than about eight in one use case
  means it is really two use cases, or it holds low-value cases.
- **Lookups:** where behaviour is a lookup (event → state, role → permitted
  action), put it in one table and make that table the main artifact. Do not split
  it across several tables.
- **After all use cases, only if there is something real to say:**
  - **Side effects:** a short list of what else changes when the flow works
    exactly as designed (another flow, a team's workload, a metric).
  - **Open points:** only what blocks building. Each is a question and who decides.
    About five at most; everything else is stated plainly where it arises.
- **Must not contain:** implementation design, audit-trail or logging specs (these
  belong in the ARD), an authorization table, a use case with only a happy path,
  or per-step failure matrices.
- **Tone:** plain and procedural; one action per step.
- **Format:** headed use cases, numbered steps, edge cases as titled sub-cases.
  Tables only for lookups and for open points.

## 4. Metrics

- **Purpose:** name what we will measure, in plain definitions.
- **Must contain:** one row per metric, each tagged with its type:
  - **Success** (supplied by the PM);
  - **Lead** (early indicator that a Success metric is moving);
  - **Check** (guardrail that must not regress).
- **Must contain:** a one-line Definition that leaves no room for two readings:
  the numerator and denominator for a rate, and the population. Where a rate has
  causes worth tracking, list them in the same cell, not as extra rows.
- **Must contain, for every Check:** what it protects, in plain words.
- **Must not contain:** targets, baselines, timeframes or breach thresholds.
  Targets live in Rollout as Scale Criteria; breach thresholds as Kill Criteria.
  Instrumentation detail belongs in the ARD. Internal tags or use-case IDs.
- **Tone:** precise.
- **Format:** one table — Metric Type | Metric | Definition.

## 5. Rollout & Stage Gates

- **Purpose:** how it goes live, and what decides whether to scale or kill.
- **Must contain:** every stage, in order. Scale Criteria and Kill Criteria must be
  measurable and reference metrics named in Section 4. Where a threshold is not
  known, say so plainly ("Threshold to be set from baseline").
- **Must contain:** shadow mode as Stage 1 if the feature is algorithmic or model-driven.
- **Must not contain:** a stage with no Scale or Kill Criteria.
- **Tone:** gate-like.
- **Format:** one table — Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria.

## 6. Worked Examples

- **Purpose:** make the behaviour concrete with real values.
- **Must contain:** at least one example per primary use case, plus at least one
  failure-path example. Each shows the starting state with real values, the steps,
  and the resulting state, so any reader can check the use case by following the numbers.
- **Must not contain:** new requirements. An example illustrates; the Use Cases
  section defines. If an example reveals a missing rule, fix Use Cases.
- **Tone:** concrete, narrative-by-numbers. Keep each to a few lines.
- **Format:** one titled block per example: *Scenario* (one line), *Starting
  state*, *Steps*, *Result*. Name the use case it demonstrates by number.

## 7. Ops SOPs *(optional)*

- **Include only if** an operational flow, role or SOP is touched.
- **Purpose:** show what changes for Ops, and who owns it.
- **Must contain, per SOP:** SOP name (or a plain note that it is not yet filed),
  the step or role affected, what changes (added, changed, removed), the owning
  team, and training or comms needed before launch.
- **Must not contain:** SOPs that are not touched.
- **Tone:** neutral and operational.
- **Format:** table — SOP | Step or role affected | Change | Owner | Readiness needed.
