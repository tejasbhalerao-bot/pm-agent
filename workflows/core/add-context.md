---
name: add-context
description: >
  Adds a Google Drive document to Context. Takes a Drive link, the systems and
  verticals it touches, and the date it was last revisited. Writes it verbatim as
  markdown with a header, files an identical copy in each touched system's folder
  under context/, and pushes.
---

# Add Context

**Inputs (PM-supplied):** Drive link · Systems touched · Verticals touched · Date revisited
**Output:** one markdown file per touched system, in `context/<system>/`, pushed to GitHub

---

## Step 1 — Validate inputs

All four are required. If any is missing or invalid, ask for everything missing in
one message, then stop.
- **Systems:** from `allocation`, `tracking`, `serviceability`, `eta`. For any other
  system (for example 3rd Party Rails), tell the PM no folder exists and ask what to do.
- **Verticals:** from `hyperlocal-forward`, `hyperlocal-reverse`, `courier-forward`,
  `courier-reverse`, `b2b-forward`, `b2b-reverse`, or `all`.
- **Date revisited:** `YYYY-MM-DD`. Use the date the PM gives, never today's date.

## Step 2 — Read the document

Take the file ID from the link (the segment after `/d/`). Read it with the Google
Drive connector's `read_file_content` tool (load it via ToolSearch if it is
deferred). If the document cannot be read, say so and stop; do not guess its contents.

## Step 3 — Write the markdown

- Copy the content **verbatim**. Do not summarise, rewrite, shorten or correct it.
- Keep headings, lists and tables as markdown.
- Start the file with the header from `context/README.md`: `title` (the document's
  own title), `source` (the Drive link), `type`, `verticals`, `systems` (all of them),
  `updated` (the date given).
- Infer `type` from the content (`system-overview`, `sop`, `metric-definition`,
  `business-rule`, `past-prd`, `other`) and tell the PM what you chose.

## Step 4 — File it

Write an identical copy to `context/<system>/<kebab-case-title>.md` for **each**
system touched. If a file with that name already exists, show the PM what differs
and ask before overwriting.

## Step 5 — Push

Push only the new files:

```bash
~/pm-agent/scripts/commit-and-push.sh "Add context: <title> (<systems>)" <path> [<path>...]
```

Pushing context documents is pre-authorized by the PM; no separate confirmation.
State plainly when it happens (commit message, paths).

## Step 6 — Report, briefly

List the files written, the inferred `type`, and anything that did not convert
(images, drawings, comments and similar are not carried over).

---

## Rules

- Never alter the document's content. A conversion limitation is reported, not fixed.
- Do not read or load Context for this task; it only adds to it.
