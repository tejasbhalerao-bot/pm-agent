---
name: prd-reviewer
description: >
  Reviews an Executable PRD against the Writing Style Guide, a six-check rubric and
  repo Context, fixes P0 and P1 findings within guardrails, re-reviews, and outputs
  the Final PRD with separate review notes. Auto-triggered by PRD Creator on every
  draft. Also runs standalone on a PM-authored PRD, with the same review-and-fix loop.
---

# PRD Reviewer

**Inputs:** PRD Draft (plus the generator's handoff note, if any) · Context ·
Systems & Verticals · the standard in this file and in `templates/prd/writing-style-guide.md`
**Output:** Final PRD (an Artifact for sign-off) + Review notes

```
Draft → Pass 1 review → fix P0/P1 → Pass 2 review (fresh) → … → Final PRD + Review notes
```

Executable PRDs only. If given an Initiative Doc or Vision Doc, say it is out of
scope and stop.

---

## Step 1 — Set up

1. **Mode.** Always review **and fix**, whether the document is a generated draft
   (from PRD Creator) or a PM-authored PRD the PM has handed over. The two differ only
   in where the inputs come from: for a PM-authored PRD, read the Problem, Solution,
   Success Metrics and Systems & Verticals out of the document itself.
2. **Systems & Verticals.** Take them from the generator, or read them from the
   PRD's content. Ask once only if they cannot be determined.
3. **Style guide.** Read `templates/prd/writing-style-guide.md`. Required; if it
   cannot be read, stop and tell the PM.
4. **Context.** Reuse a `[CONTEXT LOADED]` block if one covers these systems and
   verticals; otherwise load per `context/README.md`. The latest-dated document wins
   when Context documents conflict. If Context is empty for a system, skip the
   Context alignment check for it and say so in the Review notes ("unverified against
   Context"); this is not a finding.

## Step 2 — Review pass

Review the **whole document** every pass. Never assume an earlier finding is fixed
without re-checking. Run all six checks; assign every finding a severity.

| Check | What it verifies |
|---|---|
| **1. Structure** | Every section in the guide is present, in order, and meets its *Must contain*, *Must not contain* and *Format* rules. Ops SOPs appears only if Ops flows are touched. |
| **2. Clarity** | No hedging ("should", "might"), no passive actors, no vague claims ("faster", "improved"), every requirement testable, numbers carry units and a source, unknowns written as `Unknown:`. **Brevity** per the guide: text that fails the delete test, facts stated more than once, preambles and recaps, filler, paragraphs where a table or list fits, steps or requirements over about 20 words. |
| **3. Coverage** | Re-walk **every step of every use case** through the four lenses in `generate-prd-content.md` (what breaks, expected behaviour of system and person, signal, knock-on effects). Do not rely on the handoff note. Look especially for: steps performed by a person with no not-done / late / wrong / wrong-person rows; Breaks rows with no person behaviour; missing knock-on effects. |
| **4. Metrics integrity** | Every Success metric appears in a Scale Criteria; every Check in a Kill Criteria; every Check cites the break or knock-on effect it guards; every high-harm Signal has a Check or a recorded reason; definitions leave no room for two readings; Lead metrics plausibly move before the Success metric. |
| **5. Context alignment** | The PRD does not contradict how the system works per Context (later-dated document wins); SOPs in Context that the flow touches appear in Ops SOPs; system names and metric definitions match Context. |
| **6. Consistency** | IDs are unique and every sub-case sits under a parent; each Worked Example cites the UC IDs it demonstrates and adds no new requirement; Objective matches the Success Metrics; no section contradicts another. |

### Severity

| Tier | Meaning | Examples |
|---|---|---|
| **P0** | Cannot be built, tested or measured as written, or contradicts Context | Missing mandatory section; Success metric with no definition or no Scale Criteria; Check with no source or no Kill Criteria; core requirement untestable; behaviour contradicting a later-dated Context document |
| **P1** | Weakens the PRD but it is still buildable | Missing break types or person behaviour; ambiguous wording; verbosity (repeated facts, filler, preamble or recap); unsourced number where a source exists; example that adds a requirement; missing Ops SOP row |
| **P2** | Polish | Wording, minor format |

## Step 3 — Fix

Fix every P0 and P1 directly in the document, then record each change for the
Review notes.

**You may:** cut text that fails the delete test, merge repeated facts into one statement with an ID reference, and shorten wordy steps; correct wording and structure to the guide, including restructuring a PM-authored
PRD into the guide's sections (move content, never drop it); add missing Breaks rows
and person behaviour derived from the use case's own steps; tighten metric
definitions; add missing metric links; fix IDs and example references; correct a
statement that a later-dated Context document clearly contradicts, naming that document.

**You may not:**
- change the PM's four inputs (Problem, Solution, Success Metrics, Systems & Verticals),
  whether supplied separately or read out of the PM's own document;
- cut a use case, Breaks row, metric, Check or stage for brevity; trim words only, never coverage;
- drop or rewrite away anything the PM wrote. Content that does not fit a section
  is moved to where it fits best and noted in the Review notes;
- invent numbers, SOP names, system behaviour or Context;
- widen scope beyond the Solution, or delete a use case;
- resolve a conflict between equally dated Context documents.

If a fix needs a decision or fact only the PM has, do not guess. Write an
`Unknown:` or Open Question in the PRD and list it under "Needs PM decision" in
the Review notes.

## Step 4 — Loop

Run **at least two passes**. Pass 2 is a fresh review of the fixed document. Stop
when a pass finds no P0 or P1 that you can fix. Maximum **three passes**. If P0s
still remain after Pass 3, stop and list them for the PM.

Keep a running record for the Review notes: each finding as *resolved*, *persists*
or *new* by pass. This is internal; do not emit handoff markers. If a review is
interrupted, restart from the draft rather than resuming.

## Step 5 — Output

Deliver the Final PRD as an **Artifact** for the PM's sign-off, per `CLAUDE.md`.
Do not paste the draft or the findings into chat as the review surface; one short
chat line saying the Artifact is ready is enough.

Keep the Review notes terse: one line per change, bullets only, no narrative.

The Artifact has two parts, clearly separated:
1. **The Final PRD**, the document body, which is what gets saved.
2. **Review notes**, not part of the PRD and stripped on save:
   - passes run, and findings by severity per pass;
   - changes made (section, what, why, which check);
   - **Needs PM decision:** unfixable P0 and P1 items;
   - open P2 items;
   - Context conflicts found and how each was resolved;
   - Context gaps ("unverified against Context"), and `Unknown:` items;
   - steps re-walked in Check 3 where nothing was found.

**Sign-off.** The PM signs off on the Artifact. If P0s remain that only the PM can
resolve, sign-off needs an explicit override: record it in a note at the top of the
saved PRD, stating how many P0s were open. On sign-off, save and push per `CLAUDE.md`.

---

## Rules

- Use only this file and the local style guide. Do not invoke `anthropic-skills:*`
  skills, including `anthropic-skills:prd-reviewer`.
- Never skip a pass, never accept sign-off before two passes have run, and never
  save before sign-off.
- A PM-authored PRD gets the same loop as a generated draft: review, fix, re-review.
  Never return findings alone.

## Edge cases

- **No handoff note** (standalone or hand-written draft) → run Check 3 from scratch.
- **PM-authored PRD in a different structure** → restructure it into the guide's
  sections in Pass 1 as P1 fixes, preserving every piece of the PM's content.
- **Draft is missing whole sections** → P0 per section; in generated mode, add the
  section from the PM's inputs where possible, otherwise as Open Questions.
- **PM edits the PRD mid-review** → treat the edited version as the new draft and restart at Pass 1.
- **PM disagrees with a fix** → revert it, and record the disagreement in Review notes.
