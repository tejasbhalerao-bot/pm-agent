# pm-agent — Working Instructions

## Workflow context (read first)

Before doing any PM work in this repo, always read `context/CLAUDE.md` using the Read tool. It contains the workflow entry point, team structure, logistics systems, and a critical instruction prohibiting the use of built-in skills for any task this repo handles. Do not skip this step even if the task seems simple.

## Archive structure

All documents generated in this project must be saved under:

```
archives/<project-name>/<doc-type>/<descriptor>-v<n>.md
```

| Doc type | Folder |
|----------|--------|
| PRD, Vision Doc, Initiative Doc | `prds/` |

**Rules:**
- `<project-name>` — kebab-case slug (e.g. `dms`, `logistics`, `competitor-intelligence`). Infer from context; ask the user if genuinely ambiguous.
- `<descriptor>` — short description of the specific document within the project. No date prefix.
- `<n>` — version number starting at 1, incrementing on each revision.
- If the project subfolder does not exist, create the full tree before saving.
- Never save documents to the repo root, `archives/projects/`, or any other flat location.

**Current projects:** `dms`, `competitor-intelligence`, `logistics`, `promise-buffer`, `sdd-expansion`, `modular-payment-pending-flow`, `logistics-charter-view`, `eta-ranges-experiment`, `eta-framing-experiment`, `promise-elasticity-experiment`, `roadmap`, `mid-mile-entity`, `urgency-trigger-xp`, `awb-sort-identifier-code`, `handover-validation`, `dms-v2`, `dms-v3`, `address-quality-interventions`, `dynamic-qr-code`, `cod-reconciliation-module`, `minimum-sample-size-courier-allocation`, `rider-flow-in-house`.

`dms-v2` is a clean-slate rebuild — do not carry over problem framing, scope, or docs from `dms`. Treat it as an independent project even though the name is related.

`dms-v3` is likewise a clean-slate project — it does not inherit any context from `dms` or `dms-v2`. Treat it as independent.

## Delivery format for sign-off (all doc types)

Do not draft PRDs, Vision Docs, or Initiative Docs as chat text for review. Once a draft has passed its required review pass(es) (per the relevant workflow file), deliver it as a Markdown (.md) file for the user's sign-off, never as an Artifact and never pasted into chat. Write the file at its archive path (`archives/<project>/prds/<descriptor>-v<n>.md`) with Status "Under Review", leave it uncommitted, and give the user the clickable path. Never put review notes in the PRD file. Write them to a separate file, `archives/<project>/reviews/<descriptor>-v<n>-review-notes.md` (gitignored, never pushed), and give the user both paths. Do not paste the draft or the review findings into chat as the primary review surface — the file is.

Once the user signs off on that file, finalising it (set Status to Approved) and pushing it to GitHub is pre-authorized — proceed with both without asking again for that specific document. State plainly when the push happens (commit message, path) so it stays visible, but do not pause for a separate confirmation.

This does not authorize skipping the review workflow itself (PRD review passes, etc.) — only changes where the reviewable draft lives and removes the extra confirmation step after sign-off.
