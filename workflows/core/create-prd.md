---
name: prd-creator
description: >
  Activate this skill to create or edit Executable PRDs, Initiative Docs, or Vision
  Docs. Triggered by Context Recall after org context is loaded. Handles both building
  from scratch and editing partially built docs. Always collects a detailed problem
  statement and high level solution before drafting. Automatically triggers PRD
  Reviewer after every draft without asking for permission. Saves approved docs as
  .md files to Claude's working folder for manual upload to Drive.
---

# PRD Creator

Creates and edits PRDs, Initiative Docs, and Vision Docs. Always invoked by Context
Recall. Never runs standalone. Context is always loaded before this skill runs.

> **Redesign in progress (2026-10-02).** Scope is now **Executable PRDs only**.
> Initiative Docs, milestone breakdowns and Vision Docs are authored by the PM and
> are not generated here. Section list, mandatory content, tone and format are
> governed by `templates/prd/writing-style-guide.md`; where this file conflicts
> with it, the style guide wins. Steps below that mention Initiative or Vision Docs
> are superseded and will be removed when the PRD Content Generator replaces this file.

---

## Step 1 — Identify mode

Determine how to proceed:

- **Build from scratch** → user has no existing doc. Proceed to Step 2.
- **Edit existing doc** → user references a partial or existing doc.
  - If a link is provided → use `google_drive_fetch` directly.
  - If a name is provided → use `google_drive_search` to find it automatically.
    If multiple results found, surface top matches and ask the user to confirm.
  - Once fetched, identify what sections are missing or incomplete.
  - Work only on the gaps. Do not rewrite sections that are already complete
    unless the user explicitly asks.

---

## Step 2 — Identify doc type

Infer from what the user said:

| What the user wants | Doc type |
| --- | --- |
| A feature, fix, or operational change with defined scope | Executable PRD |
| A large initiative broken into multiple workstreams | Initiative Doc |
| A long-term product direction without defined scope yet | Vision Doc |

If intent is unclear, ask once: *"Is this an Executable PRD, an Initiative Doc,
or a Vision Doc?"*

---

## Step 3 — Gather mandatory inputs

Before any drafting begins, always collect both of the following:

1. **Detailed problem statement** — what is broken, missing, or suboptimal, and
   for whom? What is the measurable impact of this problem today?
2. **High level solution** — what is the proposed approach to solving it?

Do not proceed to Step 4 until both inputs are provided. If either is missing,
ask for it explicitly before continuing.

---

## Step 4 — Load the Writing Style Guide

Use the Read tool to load `~/pm-agent/templates/prd/writing-style-guide.md`. It is
the only style source: sections and order, what each must contain, tone, and format.
Do not search Drive for past PRDs to mirror, and do not use the old fallback style guide.

---

## Step 5 — Draft the doc

Write the full doc in chat using the correct section structure for the doc type.

### Executable PRD sections

Follow `templates/prd/writing-style-guide.md` exactly for the section list and order,
mandatory content, tone and format. The section definitions that used to be here
(RACI, per-metric baseline/target/timeframe fields, four-column rollout table) are
superseded by it.

Use Case drafting rules that still apply:
- Before drafting Use Cases, use the Read tool to load
  `changelogs/prd-creator-operational-learnings.md` and apply any learning not
  marked superseded.
- Cover edge cases and failure modes for every use case, not just the happy path.
- Solutions must be applicable across verticals where relevant.
- Solutions must be sustainable for ~1 year.

---

### Initiative Doc sections

> **Out of scope (2026-10-02):** authored by the PM, not generated here.

All sections from Executable PRD, plus:

**Milestones**
A table with columns: Sr No | Milestone Name | Description | Outcome

Each milestone maps to one Executable PRD drafted as part of this Initiative Doc.
Write the Milestones table first and get confirmation before proceeding to draft
individual Executable PRDs.

**Sequencing rule for Executable PRDs within an Initiative Doc:**
- Draft Executable PRD 1 in chat
- Trigger PRD Reviewer automatically (Step 6) → get sign-off → save to file (Step 7)
- Begin drafting PRD 2 in chat in parallel while PRD 1 is being saved
- Present PRD 2 draft as soon as PRD 1 is saved — no waiting
- Repeat until all milestones are complete

---

### Vision Doc sections

> **Out of scope (2026-10-02):** authored by the PM, not generated here.

No fixed template. Before drafting, ask the user what this Vision Doc needs to
communicate and define the section structure together. Confirm the structure
before writing.

---

## Step 6 — Trigger PRD Reviewer (automatic, no permission needed)

After completing any draft, immediately invoke the PRD Reviewer skill. Do not ask
the user whether to run a review — it always runs. The review is not optional and
does not require the user's instruction to begin.

Do not proceed to Step 7 until:
- PRD Reviewer has run to completion across all sections, and
- The user has given explicit sign-off (per PRD Reviewer's sign-off loop)

---

## Step 7 — Save the approved doc as a .md file

Triggered only after explicit sign-off from PRD Reviewer.

Save the full approved content as a Markdown file to Claude's working folder.
Use the correct naming convention:
- Executable PRD → `[PRD] Feature Name.md`
- Initiative Doc → `[PRD] Initiative Name.md`
- Vision Doc → `[Vision] Vision Name.md`

After saving, share the file link with the user and say:
*"Your doc is saved. You can upload it to Drive manually when ready."*

For Initiative Docs, save each approved Executable PRD as a separate .md file
with its milestone name appended:
- `[PRD] Initiative Name — Milestone 1.md`
- `[PRD] Initiative Name — Milestone 2.md`

Do not use browser automation or any Drive API to write content. File creation
is Claude's responsibility; uploading to Drive is the user's.

---

## Step 8 — Scheduler handoff

After every Executable PRD file is saved, identify the review owner from the
loaded context. Check the Cross-Cutting team structure doc for a field named
"PRD reviewer" or equivalent.

- **Reviewer found in context** → ask: *"Should I schedule a review with
  [reviewer name]?"*
- **Reviewer not found in context** → ask: *"Who should I schedule a PRD review
  with? (Once confirmed, I'd recommend filing this in the Cross-Cutting team
  structure doc so I can load it automatically next time.)"*

On confirmation:
- **Yes** → invoke Scheduler Agent with the reviewer's name/calendar ID
- **No** → proceed to Step 9

---

## Step 9 — Offer Objection Mapper

After the doc is saved (and after any scheduler interaction in Step 8), offer the
Objection Mapper as an optional next step.

Say: *"Doc saved. Would you like me to run Objection Mapper to surface stakeholder
objections before your alignment meeting?"*

Wait for the user's response. If yes, invoke Objection Mapper. If no, PRD Creator's
operation ends here.

---

## Edge cases

- **Missing mandatory inputs** → do not draft anything until both problem
  statement and high level solution are provided. Ask once clearly for what
  is missing.
- **Vision Doc structure unclear** → do not guess. Always define the structure
  with the user before writing.
- **Writing Style Guide missing or unreadable** → stop and tell the user. Do not
  draft without it.
- **Initiative Doc — milestone count is large** → confirm the full milestones
  table with the user before beginning any Executable PRD drafting. Do not
  start drafting PRDs against milestones that may change.
- **User tries to skip PRD Reviewer** → do not comply. The review step is
  mandatory. If the user pushes back, acknowledge their preference but explain
  that the review runs automatically before any file is saved. They can choose
  to override sign-off after seeing the results, but the review itself cannot
  be skipped.
---

## Final Step: Save and Push to GitHub

See `templates/FINAL-STEP-TEMPLATE.md` for instructions on saving your PRD and pushing to GitHub with automatic versioning (v1, v2, v3, etc.).