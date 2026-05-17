---
name: context-loader
description: >
  Activate this skill whenever the user asks anything about how Truemeds works
  internally. This includes questions about products, operational processes, business
  verticals (hyperlocal-forward, hyperlocal-reverse, courier-forward, courier-reverse,
  B2B-forward, B2B-reverse), SOPs, business rules, team structure, metric definitions,
  integration docs, or any org-wide process. If the question requires internal knowledge
  about Truemeds to answer accurately, always use this skill before responding.
---

# Context Loader

Fetches org context from Google Drive to answer questions about Truemeds products,
processes, and operations. Always ends by emitting a load manifest so downstream
skills (Context Q&A, PRD Creator, Objection Mapper) know exactly what was loaded.

---

## Step 1 — Check the session load manifest

Before fetching anything, check whether a load manifest exists in this conversation.
A load manifest is a block emitted at the end of a previous Context Loader run in
this session in the format described in Step 7.

- **Manifest exists and fully covers the question** → skip to Step 7 and re-emit
  the existing manifest unchanged. Do not re-fetch anything.
- **Manifest exists but partially covers the question** → identify which vertical(s)
  or doc type(s) are missing. Fetch only those (Steps 2–6), then merge the new docs
  into the existing manifest before emitting in Step 7.
- **No manifest exists** → proceed to Step 2.

---

## Step 2 — Fetch the master index

Use `google_drive_fetch` with this link:

```
https://docs.google.com/document/d/1hBjvDB6NS-fYrA4EZUhjpMbvXkveBSRxcI06PlV9Ork/edit
```

This returns a table mapping each vertical to its index doc link:
Cross-Cutting, Hyperlocal Forward, Hyperlocal Reverse, Courier Forward,
Courier Reverse, B2B Forward, B2B Reverse.

---

## Step 3 — Identify the relevant vertical(s)

Based on the question, determine which vertical(s) to fetch:

- **Cross-cutting** → org-wide questions, team structure, platform-wide rules, questions
  that span more than one vertical
- **Specific vertical** → any question scoped to one vertical's product, process, or rules
- **Multiple verticals** → fetch all relevant vertical indices if the question spans more
  than one

When in doubt, start with Cross-Cutting.

**Default rule for PM Agent tasks:** always fetch Cross-Cutting in addition to any
vertical-specific index. Cross-Cutting contains team structure, platform-wide rules,
and metric definitions that are relevant to PRD authoring and objection mapping
regardless of which vertical the work touches. Skipping it risks missing constraints
that cut across verticals.

---

## Step 4 — Fetch the vertical index

Use `google_drive_fetch` with the document ID from the master index for each chosen
vertical.

Each vertical index is a table with these columns:
`Doc Name | Type | Drive Link | Description`

Types include: Product Flow, SOP, Business Rules, Metric Definitions, Integration Docs,
and any other type filed over time.

**If the vertical index returns an empty table** → do not proceed silently. Surface
this immediately before continuing:

> "No docs have been filed for [vertical] yet. Any output I produce will be based
> on general knowledge rather than Truemeds-specific rules. Should I proceed anyway,
> or would you prefer to pause and file docs first?"

Wait for the user's response before moving to Step 5.

---

## Step 5 — Identify the relevant doc(s)

Scan the vertical index table. Match the question to the most relevant doc(s) using
Doc Name, Type, and Description.

When multiple docs could apply, use this priority order:

| Priority | Type | Use for |
|---|---|---|
| 1 | Business Rules | What is/isn't allowed, constraints, decision logic |
| 2 | Product Flow | How a process works end-to-end |
| 3 | Metric Definitions | Measurement, KPIs, data questions |
| 4 | SOP | How a team executes a process operationally |

If no doc clearly matches, load the closest-matching doc and flag the gap in Step 7.

---

## Step 6 — Fetch the specific doc(s)

Use `google_drive_fetch` with the document ID from the vertical index for each
relevant doc.

**Handling truncated docs:** if the fetched content appears to end mid-sentence,
mid-table, or without a clear conclusion, treat it as truncated. When you detect
truncation:

- Flag it inline immediately after the affected content:
  [Note: this doc appears truncated — content below may be incomplete.]
- Mark the doc's status as `partial` in the load manifest (Step 7).
- Do not silently treat partial content as complete. Downstream skills (PRD Creator,
  Objection Mapper) need to know when they are working from incomplete source material.

---

## Step 7 — Emit the load manifest

After all fetches are complete, always emit a load manifest before answering or
handing off. Use this exact format:

```
CONTEXT LOAD MANIFEST
Verticals covered: [comma-separated list]
Docs loaded:
  - [Doc Name] | [Vertical] | [Type] | [status: full / partial / empty]
  - ...
Gaps: [list any verticals or doc types that were needed but not found, or "None"]
```

Emit this even if only one doc was loaded, and even if all statuses are `empty`.
Context Q&A, PRD Creator, and Objection Mapper read this manifest to understand
what context is available without re-scanning the full conversation. A missing or
incomplete manifest forces those skills to guess.

**Write the cross-session cache:** After emitting the manifest, write a cache file
to persist today's context for reuse across sessions on the same project. Use the
Write tool to save `.context-cache.md` at `[project_folder]/.context-cache.md`
with the following contents:

```
Cache date: [today's date in YYYY-MM-DD format]
[full CONTEXT LOAD MANIFEST block]
```

The project folder is the same folder where PRD files are being saved for this
project (e.g., `~/Documents/Claude/Projects/DMS/`). If no project folder has been
established in this session, skip this step. If the Write tool returns an access
error, skip silently — the cache is a performance optimisation, not required for
correct operation.

---

## Step 8 — Answer or hand off

**Invoked standalone** (user asked a direct question about Truemeds):
Answer now using the fetched content. Cite which doc each claim comes from. Then stop.

**Invoked as part of the PM Agent chain** (triggered by Context Recall):
Stop after emitting the manifest. Do not answer. Return control to Context Recall
for routing to the appropriate PM skill.

---

## Edge cases

- **All vertical indexes are empty** → emit the manifest with all doc statuses as
  `empty`. Surface the gap clearly and ask whether to proceed or pause. Do not
  silently continue into a PM skill with zero context.
- **No doc matches the question** → load the closest-matching doc anyway. Flag
  what is missing inline and record the gap in the manifest. Do not return nothing.
- **Question spans verticals** → fetch Cross-Cutting + all relevant vertical indices.
  Do not stop at one vertical when the question clearly touches more than one.
- **Manifest exists, question already covered** → never re-fetch. Re-emit the
  existing manifest and proceed.
- **Manifest exists, new vertical needed** → fetch only the new vertical, add its
  docs to the manifest, re-emit the updated manifest. Do not reload docs already
  present.
