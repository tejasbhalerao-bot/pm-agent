---
name: context-recall
description: >
  Always activate this skill first whenever the PM Agent is triggered. This is the
  mandatory entry point for all PM Agent work — PRD creation, PRD review, objection
  mapping, exec brief writing, and experiment design. Loads org context via the
  Context Agent before any PM skill runs, then routes to the correct PM skill based
  on what the user said. If intent is unclear, asks the user before proceeding.
---

# Context Recall

Entry point for all PM Agent work. Always runs first. Never skipped.

---

## Step 1 — Load org context

Before invoking Context Loader, check for a cross-session context cache. If the
user's current project folder is known (e.g., from a previous save in this session
or from the user mentioning a project name), use the Read tool to look for
`.context-cache.md` in that folder (e.g., `~/Documents/Claude/Projects/[project-name]/.context-cache.md`).

- **Cache file found and contains today's date (`Cache date: YYYY-MM-DD`)** → use
  its manifest contents directly. Do not invoke Context Loader. Proceed to Step 2.
- **No cache file, stale cache, or project folder unknown** → invoke Context Loader
  as normal. Context Loader will emit a CONTEXT LOAD MANIFEST when it finishes —
  that manifest is the signal loading is complete and Step 2 can begin.

**Vertical scope rule:** always instruct Context Loader to fetch Cross-Cutting
in addition to any vertical-specific index the user's request touches on.
Cross-Cutting contains team structure, platform-wide rules, and metric definitions
that are relevant to every PM task regardless of vertical. Do not skip it even
when the request appears narrowly scoped to one vertical.

Do not proceed to Step 2 until the manifest is present in the conversation.

---

## Step 2 — Evaluate the manifest before routing

Read the CONTEXT LOAD MANIFEST emitted by Context Loader. Do not assume the load
was successful just because Context Loader ran.

**If the manifest shows all docs as `empty` or all gaps unfilled:**
Do not silently route to a PM skill. Surface the gap first:

> *"Context Loader ran but found no docs filed for [vertical(s)]. Any PRD,
> review, or objection map produced will be based on general knowledge rather
> than Truemeds-specific context. You have two options:
> 1. Pause and file docs in Drive first (recommended for accurate output).
> 2. Proceed anyway — I'll flag assumptions wherever org context is missing."*

Wait for the user's explicit choice before routing.

**If the manifest shows at least one doc loaded with `full` or `partial` status:**
Proceed to Step 3.

---

## Step 3 — Infer intent and route

Read what the user said and infer which PM skill to invoke next:

| If the user wants to... | Route to |
| --- | --- |
| Write a new PRD, Vision Doc, or Initiative Doc | PRD Creator |
| Review, improve, or fix an existing PRD | PRD Reviewer |
| Anticipate objections to a proposal | Objection Mapper |
| Package a proposal for leadership | Exec Brief Writer |
| Design or scope an experiment or A/B test | Experiment Designer |
| Design test cases from a PRD | Test Case Designer |

**If intent is clear** → route directly. Do not ask.

**If intent is ambiguous** → ask once, concisely:
*"Which would you like to do — create a new doc, review an existing one, map
objections, write an exec brief, or design an experiment?"*

Wait for the user's response before routing.

---

## Edge cases

- **User jumps straight into a task without context** → still run Context Loader
  first, even if the user hasn't explicitly asked for context. It is always needed.
- **Context already loaded in session (manifest exists)** → do not re-fetch.
  Read the existing manifest, evaluate it per Step 2, then route.
- **Context loaded but insufficient for the current prompt** → do not reload
  everything. Identify specifically what is missing (which vertical or doc type),
  fetch only that via Context Loader, wait for an updated manifest, then proceed.
  Partial re-fetching is always preferred over a full reload.
- **User wants to do multiple things** → complete one skill fully before starting
  the next. Do not run skills in parallel.
- **User explicitly chooses to proceed despite empty context** → acknowledge the
  risk inline at the start of the routed skill's output, then proceed. Do not
  re-surface the warning on every response — once is enough.
- **User says "run Pass 2", "run Pass 3", or "continue review"** → before routing
  to prd-reviewer, check context for a `[PASS N HANDOFF]` block. If absent, ask:
  *"I need the Pass N handoff block to track what was flagged in the previous pass.
  Can you paste it, or should I treat this as a fresh Pass 1?"* Do not silently
  start a new pass without it — cross-prompt context loss will make resolved/persists/new
  tracking impossible and the loop guarantee breaks.

## Skill routing — critical note

**PRD Reviewer routing:** When routing to PRD Reviewer, use the Read tool to load
`~/pm-agent/workflows/core/review-prd.md` and follow it directly.

**DO NOT invoke `anthropic-skills:prd-reviewer`** — that is a generic built-in skill
with no 5-pass framework, no DMS domain knowledge, no widget rendering, and no
loop logic. It produces superficially similar but fundamentally inferior output
with no error or warning. The local workflow file is always the correct target.
