---
name: prd-reviewer
description: >
  Reviews an Executable PRD against the Writing Style Guide, a six-check rubric and
  repo Context, fixes P0 and P1 findings within guardrails (never adding length or
  invented behaviour), re-reviews, and outputs the Final PRD plus a separate review-notes file (never inside the PRD). Auto-triggered by PRD Creator on every
  draft. Also runs standalone on a PM-authored PRD, with the same review-and-fix loop.
---

# PRD Reviewer

**Inputs:** PRD Draft (plus the generator's handoff note, if any) · Context ·
Systems & Verticals · the standard in this file and in `templates/prd/writing-style-guide.md`
**Output:** Final PRD as a Markdown file for sign-off, and Review notes in a separate file. The PRD never contains Review notes.

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
| **2. Clarity & voice** | No hedging ("should", "might"), no passive actors, no vague claims ("faster", "improved"), every requirement testable, numbers carry units and a source, unknowns stated plainly where they arise. **Voice** per the guide: no working vocabulary or internal tags in the PRD body (lens, Breaks, Signal, Knock-on, OQ, K1, "Guards UC…"); roles, screens, states and messages in the operation's own words. **Brevity** per the guide: text that fails the delete test, facts stated more than once, preambles and recaps, filler, paragraphs where a table or list fits, steps or requirements over about 20 words. |
| **3. Coverage** | Re-walk **every step of every use case** for what can break, what the system and the person must do, and what else moves (see the working method in `generate-prd-content.md`). Do not rely on the handoff note. Flag a missing failure **only if it would change what gets built or what a person must do**. Look especially for a step a person performs with no case for it not being done, being late, or being wrong, and for an edge case with no stated system or person behaviour. Also flag **over-coverage**: edge cases that change nothing, near-duplicates with the same handling, and more than about eight in one use case. |
| **4. Metrics integrity** | Every Success metric appears in a Scale Criteria; every Check in a Kill Criteria; every Check protects something named in plain words, and the handoff note traces it to a failure or side effect; every high-harm failure has a Check or a recorded reason; definitions leave no room for two readings; Lead metrics plausibly move before the Success metric. |
| **5. Context alignment** | The PRD does not contradict how the system works per Context (later-dated document wins); SOPs in Context that the flow touches appear in Ops SOPs; system names and metric definitions match Context. |
| **6. Consistency & fidelity** | Use cases and sub-cases are numbered plainly and every sub-case sits under a parent; each Worked Example names the use case it demonstrates and adds no new requirement; Objective matches the Success Metrics; no section contradicts another. **Fidelity:** every screen, prompt, state, limit, timer or rule traces to the PM's inputs or Context. Anything else is invented behaviour. |

### Severity

| Tier | Meaning | Examples |
|---|---|---|
| **P0** | Cannot be built, tested or measured as written, or contradicts Context | Invented behaviour that contradicts the PM's inputs; missing mandatory section; Success metric with no definition or no Scale Criteria; Check with no Kill Criteria; core requirement untestable; behaviour contradicting a later-dated Context document |
| **P1** | Weakens the PRD but it is still buildable | A failure that changes the build left out; missing person behaviour; invented behaviour; framework vocabulary or internal tags in the body; over-coverage; ambiguous wording; verbosity (repeated facts, filler, preamble or recap); unsourced number where a source exists; example that adds a requirement; missing Ops SOP row |
| **P2** | Polish | Wording, minor format |

## Step 3 — Fix

Fix every P0 and P1 directly in the document, then record each change for the
Review notes.

**You may:** cut text that fails the delete test; merge repeated facts into one
statement; merge edge cases that share the same handling and cut ones that change
nothing; shorten wordy steps; replace working vocabulary and internal tags with
plain words; correct wording and structure to the guide, including restructuring a
PM-authored PRD into the guide's sections (move content, never drop it); add an edge
case only when its absence would change what gets built or what a person must do,
using only behaviour the inputs and Context support; tighten metric definitions;
add missing metric links; fix numbering and example references; correct a statement
that a later-dated Context document clearly contradicts, naming that document.

**You may not:**
- change the PM's four inputs (Problem, Solution, Success Metrics, Systems & Verticals),
  whether supplied separately or read out of the PM's own document;
- add screens, prompts, states, limits, timers or rules the inputs and Context do not
  support. Remove the invented behaviour, or turn it into an Open point and list it
  under "Needs PM decision";
- cut a use case, a metric, a Check, a stage, or an edge case that changes what gets
  built or what a person must do;
- drop or rewrite away anything the PM wrote. Content that does not fit a section
  is moved to where it fits best and noted in the Review notes;
- invent numbers, SOP names, system behaviour or Context;
- widen scope beyond the Solution, or delete a use case;
- resolve a conflict between equally dated Context documents.

**Length.** A fix pass must leave the document no longer than it found it, unless a
P0 requires more. Each pass is a chance to cut, not only to add.

If a fix needs a decision or fact only the PM has, do not guess. State the
unknown plainly in the PRD (or add an Open point if it blocks building) and list
it under "Needs PM decision" in the Review notes.

## Step 4 — Loop

Run **at least two passes**. Pass 2 is a fresh review of the fixed document. Stop
when a pass finds no P0 or P1 that you can fix. Maximum **three passes**. If P0s
still remain after Pass 3, stop and list them for the PM.

Keep a running record for the Review notes: each finding as *resolved*, *persists*
or *new* by pass. This is internal; do not emit handoff markers. If a review is
interrupted, restart from the draft rather than resuming.

## Step 5 — Output

Deliver the Final PRD as a **Markdown (.md) file**, never an Artifact. Write it to
its archive path, `archives/<project>/prds/<descriptor>-v<n>.md` (next version from
`scripts/get-next-version.sh`), with the version header and Status "Under Review".
Leave it uncommitted. Do not paste the draft or the findings into chat; one short
chat line with the clickable file path is enough.

Keep the Review notes terse: one line per change, bullets only, no narrative.

Write two files:
1. **The Final PRD** at `archives/<project>/prds/<descriptor>-v<n>.md`. It contains
   only the PRD: no Review notes, no review heading, no findings, no reviewer
   commentary of any kind.
2. **Review notes** at `archives/<project>/reviews/<descriptor>-v<n>-review-notes.md`,
   titled `# Review notes — <descriptor> v<n>`. This folder is gitignored, so the
   notes are never pushed. Give the PM both clickable paths. The notes contain:
   - passes run, and findings by severity per pass;
   - changes made (section, what, why, which check);
   - **Needs PM decision:** unfixable P0 and P1 items;
   - open P2 items;
   - Context conflicts found and how each was resolved;
   - Context gaps ("unverified against Context"), and unknowns stated in the PRD;
   - invented behaviour found, and whether it was removed or flagged.

**Sign-off.** The PM signs off on the file. If P0s remain that only the PM can
resolve, sign-off needs an explicit override: record it in a note at the top of the
PRD, stating how many P0s were open. On sign-off, set Status to Approved, then
commit and push the PRD file only, per `CLAUDE.md`. The review-notes file stays
local.

**Check before handing over and before pushing.** The PRD file must not contain
Review notes. If it does, move them to the review-notes file first.
`scripts/commit-and-push.sh` refuses to push a PRD that contains them.

---

## Rules

- Use only this file and the local style guide. Do not invoke `anthropic-skills:*`
  skills, including `anthropic-skills:prd-reviewer`.
- Never skip a pass, never accept sign-off before two passes have run, and never
  save before sign-off.
- Never put Review notes, findings or reviewer commentary in the PRD file. They go
  only in the review-notes file.
- A PM-authored PRD gets the same loop as a generated draft: review, fix, re-review.
  Never return findings alone.

## Edge cases

- **No handoff note** (standalone or hand-written draft) → run Check 3 from scratch.
- **PM-authored PRD in a different structure** → restructure it into the guide's
  sections in Pass 1 as P1 fixes, preserving every piece of the PM's content.
- **Draft is missing whole sections** → P0 per section; in generated mode, add the
  section from the PM's inputs where possible, otherwise as Open points.
- **PM edits the PRD mid-review** → treat the edited version as the new draft and restart at Pass 1.
- **PM disagrees with a fix** → revert it, and record the disagreement in Review notes.
