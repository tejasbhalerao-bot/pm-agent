---
name: prd-content-generator
description: >
  Transforms four PM inputs (Problem, Solution, Success Metrics, Systems & Verticals)
  into an Executable PRD draft, using the Writing Style Guide and Context as
  references. A four-lens walk of every step is the generator's private working
  method: it finds what can break, who must act, and what else moves. The PRD
  keeps only what changes the build, in the style guide's plain voice. Called by
  Create PRD; its output goes to PRD Reviewer.
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
| Success Metrics | At least one metric, with direction of change. A target value is needed to write Scale Criteria; if absent, say so plainly in the Rollout table. |
| Systems & Verticals | Systems from those with context folders (Allocation, Tracking, Serviceability, ETA, Communications, Address) and verticals from the six (Hyperlocal / Courier / B2B, Forward / Reverse). A system outside the four has no context: tell the PM and continue only if they confirm. |

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
     (`allocation`, `tracking`, `serviceability`, `eta`, `communications`, `address`). A document filed in more
     than one folder (same `source`) is read once.
   - Keep documents whose `verticals` tag includes one of the requested verticals
     or `all`. Skip the rest.
   - If a system's folder is empty, or nothing matches the requested verticals, do
     not fill the gap from general knowledge. Record it as an Open point and list
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
     undated, do not pick one: record an Open point naming both.
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

**Why Now.** From the Problem input only, written as a short narrative per the guide.
Use numbers only if they came from the PM or Context; never invent one. A missing
number is stated plainly in the sentence ("Not yet measured."), with no tags.

**Use Cases.** Derive from the Solution. Number them (Use Case 1, 1.1).

*Working method (private; none of this vocabulary goes in the PRD).* For every use
case, write the main flow first as numbered steps. Then walk **every step**
through the four lenses below, per step and not per use case.

| Lens | Ask, for each step |
|---|---|
| A. What breaks | Is its precondition unmet? Was the step skipped, done out of order, or only half done? Repeated or late? Decided on stale or wrong information? Do two roles each assume the other acts? **For every step a person performs: not done, done late, done incorrectly, or done by the wrong person?** Is a dependency (system, data, partner) unavailable or returning bad data? Is the actor not permitted? |
| B. Expected behaviour | What does the **system** do (detect, block, retry, queue, route)? What does the **person** do: which role, what action, within what time? **When a person fails to act, who or what notices, after how long, and what happens next?** What state do we end in? |
| C. Signal | What would we count to see this happening? Feeds Checks, via the handoff note only. |
| D. Knock-on effects | When the main flow works exactly as designed, what else moves: another flow, metric, vertical, a team's workload? |

External-system failure is one kind of break under lens A, not a separate pass.

*Then filter, before writing anything into the PRD.* Keep an edge case only if it
changes what gets built or what a person must do. Merge cases that share the same
handling into one. Everything else goes in the handoff note as "considered, not
included". If a use case ends with more than about eight edge cases, merge them or
check whether it is really two use cases.

*Write it plainly.* Each kept edge case is a titled sub-case ("Use Case 1.3: Edge
Case — <situation in plain words>") with a few numbered steps or bullets: what the
system does, what the person must do, and where a person might not act, who or what
notices, after how long, and what happens next. Put lookup behaviour (event → state,
role → permitted action) in one table that is the main artifact. Add **Side
effects** and **Open points** after the use cases only if there is something real
to say, with Open points limited to what blocks building (about five at most).

*Do not invent.* When a lens exposes a decision the PM has not made, do not design
a mechanism for it. Specify the simplest behaviour the inputs or Context imply, or
put it in Open points. Never add a screen, prompt, state, limit, timer or rule that
the inputs do not mention. If you make an assumption anyway, list it in the handoff
note under "Assumed — please confirm".

**Metrics.** One table (Metric Type | Metric | Definition).
- *Success:* the PM's metrics, with definitions tightened (numerator, denominator, population). If the PM's definition is ambiguous, write the tightest reading and flag it in the handoff note.
- *Lead:* for each Success metric, 1–3 measurable behaviours that move earlier than it and are caused by the solution.
- *Check:* derived from the Breaks and Knock-on tables, never from a quota. Take each Signal and knock-on effect and keep it as a Check if it harms a customer outcome, money, the delivery promise or SLA, or compliance. Merge duplicates. Record what each Check protects, and which failure or side effect it came from, in the handoff note, not in the PRD. Drop the rest, and list each dropped one in the handoff note with a reason. A Check with no definition in Context is flagged in the handoff note. Keep the table crisp and lean: each Definition is one line holding only the definition (numerator ÷ denominator, population). Do not add what a metric protects, causes, splits, cross-references, measurement method, targets, thresholds, use-case IDs or internal tags.

**Rollout & Stage Gates.** Table (Stage | Intent | Rollout Description | Scale Criteria | Kill Criteria).
- Stage 1 is shadow mode if the intake answer or the solution is algorithmic.
- Then stage by narrowest meaningful slice first (a vertical, a city, a cohort), widening each stage.
- Every Success metric must appear in at least one Scale Criteria, with its target. A missing target is stated plainly ("Target to be set from baseline").
- Every Check must appear in at least one Kill Criteria, with a threshold, or a plain statement that the threshold is not yet set.
- Replacing an existing system → final stage includes its decommission trigger.

**Worked Examples.** One per primary use case, plus at least one failure path.
Use real values from the inputs or Context. Where a value must be invented, label
it `(illustrative)`. Every example step must trace to a use case step; an example
that needs a rule the use cases lack means the use cases are incomplete, so fix them.
Keep each example to a few lines and name the use case by number.

**Ops SOPs.** Include only if a use case has an Ops actor (warehouse, hub, dispatch,
driver, support) or Context holds an SOP for a touched system. Take SOP names from
Context only. If an SOP is implied but not in Context, say plainly in the table that it is not yet filed.

## Step 4 — Consistency pass (before output)

Fix, do not report, anything that fails:
- Every use case and sub-case is numbered plainly (1, 1.1) and every sub-case sits under its parent.
- Every step of every use case was walked through lenses A–D (record in the handoff note).
- Every edge case says what the system does and what the person must do, or that nobody needs to; none ends at "an error is shown".
- Where a person might not act, the edge case says who or what notices, after how long, and what happens next.
- Every kept edge case changes the build or what a person must do; the rest are in the handoff note.
- No framework vocabulary or internal tags in the PRD body (lens, Breaks, Signal, Knock-on, OQ, K1, "Guards UC…").
- No behaviour that the inputs and Context do not support; any assumption is in the handoff note.
- Every Success and Check metric is referenced in Rollout; every Rollout metric exists in Metrics.
- Every Worked Example names the use case it demonstrates.
- Objective contains no problem and no solution; Why Now contains no solution.
- No "should", "could", "might"; no passive actors; no unquantified claims where a number was available.
- Unknowns are plain sentences where they arise; only what blocks building is in Open points, about five at most.
- Brevity: no sentence fails the delete test; no fact is stated twice; no section opens with a preamble or ends with a recap.
- Every Context conflict is either resolved by the later-dated document or logged as an Open point; none is silently resolved.
- Nothing from the "Must not contain" lists (implementation design, audit and logging specs, targets inside the Metrics table).

## Step 5 — Output

Return the PRD draft as the document body, plus a **Generator handoff note** kept
separate from the PRD (not part of the doc):
- Assumptions made, and where Context was missing.
- Conflicts between Context documents, and which one was used.
- Steps walked through lenses A–D, including steps where nothing was found.
- Failures considered but not included in the PRD, with a reason each.
- Each Check, and the failure or side effect it came from; signals and side effects dropped as Checks, with reasons.
- Assumed — please confirm: every behaviour you chose where the inputs were silent.
- Metric definitions the PM should confirm.
- Open points and every unknown stated plainly in the PRD.

Then hand off to PRD Reviewer. Do not paste the draft into chat for review; the
repo's sign-off rules in `CLAUDE.md` apply once the review completes.

---

## Edge cases

- **Solution implies several independent workstreams** (roughly more than 8 top-level use cases, or unrelated actors and systems) → tell the PM it looks like more than one Executable PRD and suggest a split. Do not split it yourself; milestone breakdown is the PM's call. Proceed only if the PM confirms.
- **Several verticals touched** → each use case states whether it applies to all, or to specific ones.
- **Success Metric the Context cannot define** → keep it, flag it, and do not guess a data source.
- **PM answers an intake question with "not sure"** → write the conservative option (shadow mode on; parameter as "to be calibrated") and add an Open point.
- **Existing PRD to revise** → not covered in v1. Ask the PM whether to regenerate from the four inputs.
