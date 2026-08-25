# pm-agent — Working Instructions

## Workflow context (read first)

Before doing any PM work in this repo, always read `context/Claude.md` using the Read tool. It contains the workflow entry point, team structure, logistics systems, and a critical instruction prohibiting the use of built-in skills for any task this repo handles. Do not skip this step even if the task seems simple.

## Archive structure

All documents generated in this project must be saved under:

```
archives/<project-name>/<doc-type>/<descriptor>-v<n>.md
```

| Doc type | Folder |
|----------|--------|
| PRD, Vision Doc, Initiative Doc | `prds/` |
| Executive brief | `briefs/` |
| Experiment / XP Doc | `experiments/` |
| Objection map | `objections/` |

**Rules:**
- `<project-name>` — kebab-case slug (e.g. `dms`, `logistics`, `competitor-intelligence`). Infer from context; ask the user if genuinely ambiguous.
- `<descriptor>` — short description of the specific document within the project. No date prefix.
- `<n>` — version number starting at 1, incrementing on each revision.
- If the project subfolder does not exist, create the full tree before saving.
- Never save documents to the repo root, `archives/projects/`, or any other flat location.

**Current projects:** `dms`, `competitor-intelligence`, `logistics`, `promise-buffer`, `sdd-expansion`, `modular-payment-pending-flow`, `logistics-charter-view`, `eta-ranges-experiment`, `eta-framing-experiment`, `promise-elasticity-experiment`.

## Delivery format for sign-off (all doc types)

Do not draft PRDs, Vision Docs, Initiative Docs, XP Docs, exec briefs, or objection maps as chat text for review. Once a draft has passed its required review pass(es) (per the relevant workflow file), present it as a standalone document (a published Artifact, not a chat message) for the user's sign-off. Do not paste the draft or the review findings into chat as the primary review surface — the document is.

Once the user signs off on that document, saving to the archive path and pushing to GitHub is pre-authorized — proceed with both without asking again for that specific document. State plainly when the push happens (commit message, path) so it stays visible, but do not pause for a separate confirmation.

This does not authorize skipping the review workflow itself (5-pass gap analysis, 2-pass experiment review, etc.) — only changes where the reviewable draft lives and removes the extra confirmation step after sign-off.
