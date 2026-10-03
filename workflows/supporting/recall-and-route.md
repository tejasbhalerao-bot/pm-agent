---
name: context-recall
description: >
  Always activate this skill first whenever the PM Agent is triggered. This is the
  mandatory entry point for all PM Agent work. Infers intent, identifies the
  systems and verticals the request touches, loads Context from the repo's
  context/ folders, then routes to the correct PM workflow. If intent is unclear,
  asks the user before proceeding.
---

# Context Recall

Entry point for all PM Agent work. Always runs first. Never skipped.

Context lives in `~/pm-agent/context/`: one folder per system (`allocation`,
`tracking`, `serviceability`, `eta`), with business verticals as tags on each
document. Loading rules are in `context/README.md`. There is no other source of
Context: no Drive, no cache file.

---

## Step 1 — Infer intent

Read what the user said and infer which workflow to run:

| If the user wants to... | Route to |
| --- | --- |
| Write a new Executable PRD (Initiative and Vision Docs are PM-authored) | PRD Creator |
| Review, improve, or fix an existing PRD | PRD Reviewer |
| Anticipate objections to a proposal | Objection Mapper |
| Package a proposal for leadership | Exec Brief Writer |
| Design or scope an experiment or A/B test | Experiment Designer |
| Design test cases from a PRD | Test Case Designer |

**If intent is clear** → continue. Do not ask.

**If intent is ambiguous** → ask once, concisely:
*"Which would you like to do — create a new PRD, review an existing one, map
objections, write an exec brief, or design an experiment?"*

Wait for the response before continuing.

---

## Step 2 — Identify systems and verticals

From the request, identify:
- **Systems touched**, from: Allocation, Tracking, Serviceability, ETA.
- **Verticals touched**, from: Hyperlocal Forward, Hyperlocal Reverse, Courier Forward,
  Courier Reverse, B2B Forward, B2B Reverse.

If either is not stated and cannot be read from the request, ask once for both.
**Exception:** for PRD creation, do not ask here. PRD Creator collects Systems &
Verticals together with the other three inputs, and the PRD Content Generator loads
Context once it has them.

If the request names a system outside the four, say so: *"There is no context folder
for [system]. Do you want to proceed without context for it?"* Continue only on a yes.

---

## Step 3 — Load Context

Skip this step for PRD creation when Systems & Verticals are not yet known (see
Step 2); the generator loads Context itself.

Otherwise, load per the rules in `context/README.md`: for each system, read every
document in `context/<system>/`, plus any document elsewhere whose `systems:` tag
lists it, keeping documents whose `verticals` tag includes a requested vertical or
`all`. Then output a short block so downstream workflows can see what is loaded:

```
[CONTEXT LOADED]
Systems: <list>   Verticals: <list>
Loaded: <path> (<type>, updated <date>) ...
Empty or no match: <system / vertical> ...
Older than 90 days: <path> ...
[/CONTEXT LOADED]
```

**If a requested system has no usable documents:** do not silently continue. Surface
it once:

> *"There are no context documents for [system] covering [vertical(s)]. Any output
> will be based on general knowledge there. You can either:
> 1. Pause and add documents under `context/[system]/` (recommended), or
> 2. Proceed anyway — I'll flag assumptions wherever Context is missing."*

Wait for the user's choice. If they proceed, acknowledge the risk once at the start
of the routed workflow's output, and do not repeat it.

---

## Step 4 — Route

Use the Read tool to load the matching workflow file from `~/pm-agent/workflows/core/`
and follow it. Do not invoke `anthropic-skills:*` skills for any task this repo
handles; they lack the local logic and fail silently. In particular, never invoke
`anthropic-skills:prd-reviewer`; always load `~/pm-agent/workflows/core/review-prd.md`.

---

## Edge cases

- **Context already loaded in session** (a `[CONTEXT LOADED]` block exists) → do not
  reload. If the new request touches a system or vertical not yet loaded, load only
  that, then output an updated block.
- **User jumps straight into a task** → still run Steps 1–3. Context is always loaded
  before routing, except the PRD-creation exception above.
- **User wants to do multiple things** → complete one workflow fully before starting
  the next. Do not run workflows in parallel.
- **User says "run Pass 2", "run Pass 3", or "continue review"** → before routing to
  PRD Reviewer, check context for a `[PASS N HANDOFF]` block. If absent, ask:
  *"I need the Pass N handoff block to track what was flagged in the previous pass.
  Can you paste it, or should I treat this as a fresh Pass 1?"* Do not silently start
  a new pass without it. *(Pending the PRD Reviewer redesign.)*
