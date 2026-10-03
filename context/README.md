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

One markdown file per document, per folder. Start each file with:

```
---
title: <document name>
source: <Google Drive link>
type: system-overview | sop | metric-definition | business-rule | past-prd | other
verticals: [all]
systems: [allocation, tracking]
updated: YYYY-MM-DD
---
```

- **verticals:** use `all`, or any of `hyperlocal-forward`, `hyperlocal-reverse`,
  `courier-forward`, `courier-reverse`, `b2b-forward`, `b2b-reverse`.
- **systems:** every system the document touches (lowercase folder names). File an
  identical copy in each of those systems' folders. When a document changes, update
  every copy.
- **updated:** the date the document was last revisited: re-read and confirmed
  current, or revised. Claude uses it to settle conflicts: when two documents
  disagree about a system, the later date wins. Change it only when the document
  was actually revisited. Claude flags documents older than 90 days, and ranks
  undated documents below dated ones.

To add a document from Google Drive, see `workflows/core/add-context.md`.

## How Claude loads it

For the systems named in the PRD request, Claude reads every document in each
system's folder. It keeps documents whose `verticals` include one of the requested
verticals or `all`, and skips the rest. A document filed in more than one folder
(same `source`) is read once.
