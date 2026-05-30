---
name: prd-reviewer-changelog
description: >
  Behavioral amendments for prd-reviewer. Read at runtime before executing core
  skill steps. Updated by the weekly skill improvement pipeline — do not edit manually.
---

# prd-reviewer_changelog.md

Amendments to prd-reviewer.md. Read this file before running the core skill steps.
Apply any amendments listed below. Later entries override earlier ones where they conflict.
If this file is empty below this line, no amendments have been made yet.

---

## 2026-05-16 — Token optimisation: cap review loop + compress rubrics

**Changes applied to prd-reviewer.md:**

1. **Review loop capped at Pass 2 by default** — the loop previously ran
   indefinitely until no P0s or P1s remained, causing 3+ full PRD re-drafts to
   accumulate in context. New routing in Step 7: after Pass 2, if no P0s remain
   (even with open P1s), sign-off is offered immediately. P1s are listed as open
   items; the user decides whether to fix them or proceed. Pass 3+ only runs if
   P0s persist past Pass 2, and requires explicit user confirmation. Saves
   ~9,000–18,000 tokens for PRDs that previously needed 3 passes.

2. **Rubric definitions compressed to a table** — the three rubrics were rewritten
   from verbose prose (414 tokens) to a compact 3-column table (Rubric | What it
   checks | Fails if). Same information, ~40% fewer tokens (~250 token saving).

3. **Edge case added** — "P1s remain after Pass 2 → do not auto-loop. Surface
   as open items and offer sign-off."

---

## 2026-05-20 — Use 5-pass framework as review lens

**Amendment:** When reviewing a PRD, load `workflows/core/gap-analysis-5pass.md`
and use it as the primary diagnostic lens.

**How to apply during review:**

1. Score the PRD against the 5-pass framework first (which passes are present/absent?)
2. Surface Pass-level gaps before individual line-item gaps — "Pass 3 is entirely
   absent from UC2" is more actionable than listing 5 individual missing scenarios
3. Use the rating heuristic from gap-analysis-5pass.md to assign a score and state
   clearly which passes are needed to reach 9/10
4. For each absent pass, provide 2–3 concrete examples of what's missing — do not
   just say "Pass 3 is absent"; name the actual external systems that need failure specs

**Minimum bar before sign-off:**
- Passes 1 and 2: fully covered for all UCs
- Pass 3: present for any UC that calls an external system
- Pass 5: authorization matrix present, audit trail events listed, open questions table present
- Passes 3 (non-external-system UCs) and 4: can be explicitly noted as "out of scope"
  if the spec author has consciously decided to exclude them

---

## 2026-05-30 — Enforce widget rendering + structured pass handoff

### F5 — Widget render is a hard STOP

**Amendment to review-prd.md Step 6:** The instruction to "immediately render a visual
summary using `show_widget`" gets skipped when context is heavy.

**New requirement:** After presenting findings in text (Step 5), output:

> `[WIDGET GATE: rendering pass summary now — Step 7 routing blocked until widget is rendered]`

Then render the widget. Do not output Step 7 routing text until the widget is rendered.
Widget is mandatory. If `show_widget` is unavailable, output the table in raw HTML in
a code block — do not skip it.

---

### F4/F7 — Structured pass handoff block (loop continuity)

**New requirement:** At the end of every pass — after the widget, before Step 7 routing —
output a structured handoff block:

```
[PASS N HANDOFF]
Doc version reviewed: vN
P0s: 
  1. <Section> — <issue summary>
  2. ...
P1s:
  1. <Section> — <issue summary>
  2. ...
P2s: <count> (not listed — see widget)
Next action: prd-creator fixes P0s and P1s → Pass N+1 runs automatically
[/PASS N HANDOFF]
```

If no P0s or P1s: write `P0s: none` / `P1s: none`.

**Purpose:** This block is the source of truth for the loop. Pass N+1 opens by
reading this block and maps every finding to `resolved / persists / new`.
Without this block, cross-prompt context loss makes `resolved/persists/new`
tracking impossible — Pass N+1 becomes a cold-start review, not a verification pass.

