# Context

Org context that Claude reads when creating a PRD. Organised by **system**.
Business verticals are **tags on documents**, not folders, because a system can
cut across several verticals.

## Folders

| Folder | System |
|---|---|
| `allocation/` | Allocation |
| `tracking/` | Tracking (Actuals) |
| `serviceability/` | Serviceability |
| `eta/` | ETA (also called Promise in older docs) |

A system with an empty folder has no context. Claude records that as an Open
Question in the PRD; it does not fill the gap from general knowledge.

## Document convention

One markdown file per document. Start each file with:

```
---
title: <document name>
type: system-overview | sop | metric-definition | business-rule | past-prd | other
verticals: [all]
systems: []
updated: YYYY-MM-DD
---
```

- **verticals:** use `all`, or any of `hyperlocal-forward`, `hyperlocal-reverse`,
  `courier-forward`, `courier-reverse`, `b2b-forward`, `b2b-reverse`.
- **systems:** only for a document that touches more than one system. File it in
  its primary system's folder, and list the *other* systems here (lowercase folder
  names, e.g. `[tracking, eta]`).
- **updated:** date the content was last confirmed current. Claude flags documents
  older than 90 days.

## How Claude loads it

For the systems named in the PRD request, Claude reads every document in each
system's folder, plus any document in another folder whose `systems:` lists that
system. It keeps documents whose `verticals` include one of the requested
verticals or `all`, and skips the rest.
