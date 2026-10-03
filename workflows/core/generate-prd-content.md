---
name: prd-content-generator
description: >
  Transforms four PM inputs (Problem, Solution, Success Metrics, Systems & Verticals)
  into an Executable PRD draft, using the Writing Style Guide and Context as
  references. A four-lens walk of every step (what breaks, expected behaviour of
  systems and people, signal, knock-on effects) replaces the old 5-pass score gate
  and feeds the guardrail Checks. Called by Create PRD; its output goes to PRD Reviewer. DRAFT v1 for review.
---

# PRD Content Generator

Produces one Executable PRD draft per run. One run = one PRD the engineering team
builds. Does not write Initiative Docs, milestone breakdowns or Vision Docs.

**Inputs (PM-supplied):** Problem · Solution · Success Metrics · Systems & Verticals
**References:** `templates/prd/writing-style-guide.md` · Context
**Output:** PRD Draft (+ a short handoff note for the reviewer)

---

## Step 1 — Validate inputs

Check each input against its minimum bar. If any fails, ask for everything missing
in **one** message, then stop. Do not draft on guesses.

| Input | Minimum bar |
|---|---|
| Problem | Who is affected, what is broken or missing, and any measured impact. Impact may be marked unknown, but must be stated as unknown. |
| Solution | What changes in the system or process, specific enough to derive use cases. |
| Success Metrics | At least one metric, with direction of change. A target value is needed to write Scale Criteria; if absent it becomes an `Unknown:`. |
| Systems & Verticals | Systems from those with context folders (Allocation, Tracking, Serviceability, ETA, Communications) and verticals from the six (Hyperlocal / Courier / B2B, Forward / Reverse). A system outside the four has no context: tell the PM and continue only if they confirm. |

In the same message, ask only the intake questions that apply:
- A specific parameter value was given (e.g. a threshold) → fixed value, or calibrate by experiment?
- The solution is algorithmic or model-driven → run in shadow mode first?
- Logic is defined at one level of a hierarchy (city, state, country) → are the parent and sibling levels needed?

## Step 2 — Load references

1. Read `templates/prd/writing-style-guide.md`. It is required. If it cannot be read, stop and tell the PM.
2. Load Context from `~/pm-agent/context/` (conventions in `context/README.md`). If a
   `[CONTEXT LOADED]` block already covers these systems and verticals, reuse it; load
   only what is missing:
   - For each system in the Systems input, read every document in `context/<system>/`
     (`allocation`, `tracking`, `serviceability`, `eta`, `communications`). A document filed in more
     than one folder (same `source`) is read once.
   - Keep documents whose `verticals` tag includes one of the requested verticals
     or `all`. Skip the rest.
   - If a system's folder is empty, or nothing matches the requested verticals, do
     not fill the gap from general knowledge. Record it as an Open Question and list
     it in the handoff note.
   - Flag any document whose `updated` date is more than 90 days old in the handoff note.
   - **Latest document wins.** Read each document's `updated` date as you load it.
     Systems evolve, so an older document (a PRD from January) may describe
     behaviour a newer one (a PRD or SOP from September) has replaced. Where two
     loaded documents describe the same system behaving differently, take the one
     with the later `updated` date as the source of truth and write the PRD from it.
     Still read the older one for history, but do not use its conflicting statement.
   - A document with no `updated` date ranks below any dated document. If the
     conflicting documents have the same date, or the only conflicting one is
     undated, do not pick one: record an Open Question naming both.
   - Record every conflict in the handoff note: the system, both documents with
     their dates, and which statement was used.

---

## Step 3 — Write the sections, in the guide's order

**Write tersely from the first draft.** Apply the style guide's Brevity rules while
writing, not as a later trim: delete test, one idea per sentence, each fact stated
once, no preamble or recap. Cut words, never coverage. Your questions to the PM
(Step 1) and the handoff note (Step 5) follow the same rule.

Follow the guide's Must contain, Must not contain, Tone and Format for every
section. The rules below say how to derive each section from the inputs.

**Objective.** One outcome sentence from the Solution, tied to the primary Success Metric.

**Why Now.** From the Problem input only. Use numbers only if they came from the PM
or Context; never invent one. Missing number → `Unknown: <what> — <why> — <owner>`.

**Use Cases.** Derive from the Solution. Number them (UC1, UC1.1). For every use
case, write the main flow first as numbered steps, then walk **every step** through
the four lenses below *before* writing the use case's breaks. Do this per step, not
per use case; a lens applied to the use case as a whole is too shallow to count.

| Lens | Ask, for each step | Lands in the PRD as |
|---|---|---|
| A. What breaks | Is its precondition unmet? Was the step skipped, done out of order, or only half done? Is it repeated or late? Is the decision made on stale or wrong information? Do two roles each assume the other acts? **For every step a person performs: is it not done, done late, done incorrectly, or done by the wrong person?** Each of these is its own break. Is a dependency (system, data, partner) unavailable or returning bad data? Is the actor not permitted? | A row in the use case's Breaks table |
| B. Expected behaviour | What does the **system** do (detect, block, retry, queue, route)? What does the **person** do: which role, what action, within what time, what fallback or escalation? **When a person fails to act, who or what notices (a timer, an ageing queue, another role), after how long, and what happens next?** What state do we end in? | System, Person and Resulting state columns. If no person is involved, write "None: system resolves". No row may end at "an error is shown". |
| C. Signal | What would we count to see this break happening? | The Signal column. Candidates for Checks. |
| D. Knock-on effects | Once the main flow works exactly as designed, what else moves: another flow, another metric, another vertical, another team's workload? | The Knock-on effects table, once, after all use cases |

External-system failure is one kind of break under lens A, not a separate pass.
Not every lens produces a row for every step. Record steps walked with nothing
found in the handoff note (see Step 5), so the reviewer can see the walk happened.

**Metrics.** One table (Metric Type | Metric | Definition).
- *Success:* the PM's metrics, with definitions tightened (numerator, denominator, population). If the PM's definition is ambiguous, write the tightest reading and flag it in the handoff note.
- *Lead:* for each Success metric, 1–3 measurable behaviours that move earlier than it and are caused by the solution.
- *Check:* derived from the Breaks and Knock-on tables, never from a quota. Take each Signal and knock-on effect and keep it as a Check if it harms a customer outcome, money, the delivery promise or SLA, or compliance. Merge duplicates. Each Check's Definition names the source it guards (e.g. "Guards UC2.3") and gives the population measured. Drop the rest, and list each dropped one in the handoff note with a reason. A Check with no definition in Context is flagged as an `Unknown:`. Do not put targets or thresholds in this table.

**Rollout & Stage Gates.** Table (Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria).
- Stage 1 is shadow mode if the intake answer or the solution is algorithmic.
- Then stage by narrowest meaningful slice first (a vertical, a city, a cohort), widening each stage.
- Every Success metric must appear in at least one Scale Criteria, with its target. Missing target → `Unknown:`.
- Every Check must appear in at least one Kill Criteria, with a threshold. Missing threshold → `Unknown:`.
- Replacing an existing system → final stage includes its decommission trigger.

**Worked Examples.** One per primary use case, plus at least one failure path.
Use real values from the inputs or Context. Where a value must be invented, label
it `(illustrative)`. Every example step must trace to a use case step; an example
that needs a rule the use cases lack means the use cases are incomplete, so fix them.

**Ops SOPs.** Include only if a use case has an Ops actor (warehouse, hub, dispatch,
driver, support) or Context holds an SOP for a touched system. Take SOP names from
Context only. If an SOP is implied but not in Context, add an Open Question.

## Step 4 — Consistency pass (before output)

Fix, do not report, anything that fails:
- Every use case has an ID; every sub-case sits under a parent.
- Every step of every use case was walked through lenses A–D (record in the handoff note).
- Every Breaks row has a Person behaviour, or "None: system resolves"; none ends at "an error is shown".
- Every step performed by a person has rows for not done, late, wrong, and wrong person (or a recorded reason one does not apply); each names who notices and after how long.
- Every Check cites the break or knock-on effect it guards; every high-harm Signal has a Check or a dropped-with-reason entry.
- Every Success and Check metric is referenced in Rollout; every Rollout metric exists in Metrics.
- Every Worked Example cites the UC IDs it demonstrates.
- Objective contains no problem and no solution; Why Now contains no solution.
- No "should", "could", "might"; no passive actors; no unquantified claims where a number was available.
- Every unknown is written in the `Unknown:` format; none are silently blank.
- Brevity: no sentence fails the delete test; no fact is stated twice; no section opens with a preamble or ends with a recap. Cut anything that does, without removing any use case, Breaks row, metric, Check or stage.
- Every Context conflict is either resolved by the later-dated document or logged as an Open Question; none is silently resolved.
- Nothing from the "Must not contain" lists (implementation design, audit and logging specs, targets inside the Metrics table).

## Step 5 — Output

Return the PRD draft as the document body, plus a **Generator handoff note** kept
separate from the PRD (not part of the doc):
- Assumptions made, and where Context was missing.
- Conflicts between Context documents, and which one was used.
- Steps walked through lenses A–D, including steps where nothing was found.
- Signals and knock-on effects dropped as Checks, with reasons.
- Metric definitions the PM should confirm.
- All `Unknown:` items.

Then hand off to PRD Reviewer. Do not paste the draft into chat for review; the
repo's sign-off rules in `CLAUDE.md` apply once the review completes.

---

## Edge cases

- **Solution implies several independent workstreams** (roughly more than 8 top-level use cases, or unrelated actors and systems) → tell the PM it looks like more than one Executable PRD and suggest a split. Do not split it yourself; milestone breakdown is the PM's call. Proceed only if the PM confirms.
- **Several verticals touched** → each use case states whether it applies to all, or to specific ones.
- **Success Metric the Context cannot define** → keep it, flag it, and do not guess a data source.
- **PM answers an intake question with "not sure"** → write the conservative option (shadow mode on; parameter as "to be calibrated") and add an Open Question.
- **Existing PRD to revise** → not covered in v1. Ask the PM whether to regenerate from the four inputs.
