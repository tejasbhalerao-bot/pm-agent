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

