# Workflow Guide

Copy-paste prompts into Claude Code. Claude handles the chain automatically.

---

## How the chain works

Every prompt goes through the same execution chain. Gates are enforced inline — you see them in the output.

```
recall-and-route (entry point)
  → context-loader (Google Drive; skips if ~/pm-agent/.context-cache.md exists and is dated today)
  → [route to skill]

PRD creation chain:
  prd-creator (draft + 5-pass gap analysis per UC)
  → [5-PASS SCORE: X/10 gate — STOP if < 8]
  → [CHAIN: reading review-prd.md → beginning Pass 1]
    → [WIDGET GATE: render findings widget]
    → [PASS 1 HANDOFF] block
    → prd-creator fixes P0s/P1s
    → [CHAIN: Pass 2]
      → [WIDGET GATE]
      → [PASS 2 HANDOFF] block
      → if no P0s: offer sign-off
  → save to archives/ with auto-version
  → push to GitHub
  → offer Objection Mapper
```

**Gate markers** (visible in session output):

| Marker | What it enforces |
|---|---|
| `[5-PASS SCORE: X/10 — Pass N thin: reason]` | Score must be ≥ 8 before review starts |
| `[CHAIN: reading review-prd.md → beginning Pass N]` | Auto-triggers reviewer — no user instruction needed |
| `[WIDGET GATE: rendering pass summary now]` | Reviewer blocks Step 7 routing until widget renders |
| `[PASS N HANDOFF] ... [/PASS N HANDOFF]` | Source of truth for pass-to-pass continuity |

---

## Context loading

**In Cowork:** Google Drive MCP is available. Context Loader fetches org docs automatically.

**In Claude Code:** Google Drive MCP is NOT available. Context Loader will fail silently.
- If `~/pm-agent/.context-cache.md` exists and is dated today, it is used directly.
- If no cache: Claude proceeds with flagged assumptions. File org docs in Drive first for accurate output.

Cache is written to `~/pm-agent/.context-cache.md` immediately after Cross-Cutting loads (Step 3) and overwritten with full context at Step 8.

---

## Prompts

### Create a PRD

```
Create a PRD.
Feature: [Feature name]
Problem: [What is broken or missing, and for whom?]
Solution: [Proposed approach]
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
```

**Example:**
```
Create a PRD.
Feature: Driver Shift Start OTP Confirmation
Problem: Drivers start shifts without confirmation, causing ghost availability in the dispatch system.
Solution: Require OTP-verified shift start before driver is marked active in Locus.
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
```

Output saved to: `archives/<project-name>/prds/<descriptor>-v1.md`

---

### Review an existing PRD

```
Review the PRD for [feature].
[Paste PRD content or provide Drive link]
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
```

**Resuming Pass 2:** If continuing from a previous session, paste the `[PASS 1 HANDOFF]` block. Without it, Claude cannot track resolved/persists/new — it will ask before starting.

---

### Design an experiment

```
Design an experiment.
Hypothesis: [What do you believe will happen?]
Target Metric: [What are you measuring?]
Current Value: [Baseline]
Target Value: [What improvement matters?]
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
```

Output saved to: `archives/<project-name>/experiments/<descriptor>-v1.md`

---

### Map stakeholder objections

```
Map objections for [feature].
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
```

Output saved to: `archives/<project-name>/objections/<descriptor>-v1.md`

---

### Write an executive brief

```
Write an executive brief.
Feature: [Feature name]
Audience: [CEO / COO / Board / Finance]
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
```

Output saved to: `archives/<project-name>/briefs/<descriptor>-v1.md`

---

### Design test cases from a PRD

```
Design test cases for [feature].
[Paste PRD content or provide Drive link]
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
```

Output saved to: `archives/<project-name>/test-cases/<descriptor>-v1.md`

---

### Revise an existing doc (new version)

```
Revise the PRD for [feature-name].
Changes: [What's different in this version?]
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
```

Claude detects the existing version and auto-saves as the next version. Both versions remain in `archives/` and on GitHub.

---

## Manual operations

### Commit and push manually

```bash
~/pm-agent/scripts/commit-and-push.sh "Add PRD: feature-name v2"
```

### Check saved files

```bash
ls ~/pm-agent/archives/<project-name>/prds/
ls ~/pm-agent/archives/<project-name>/experiments/
ls ~/pm-agent/archives/<project-name>/objections/
ls ~/pm-agent/archives/<project-name>/briefs/
```

### Check GitHub

https://github.com/tejasbhalerao-bot/pm-agent/tree/main/archives

---

## Common issues

| Symptom | Cause | Fix |
|---|---|---|
| Context Loader runs but loads nothing | Google Drive MCP not available in Claude Code | Expected — Claude flags assumptions and proceeds |
| "I need the Pass N handoff block" | Resuming a review across sessions without the handoff block | Paste the `[PASS N HANDOFF]` block from the previous session |
| Wrong reviewer skill used | Model invokes `anthropic-skills:prd-reviewer` instead of local file | Blocked by `recall-and-route.md` and changelogs — if it happens, say "use ~/pm-agent/workflows/core/review-prd.md" |
| Score stuck below 8 | Pass 2 or Pass 3 genuinely thin | Claude names specific gaps — fill them before proceeding |
