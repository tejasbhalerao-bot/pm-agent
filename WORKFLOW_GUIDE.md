# Workflow Guide

Copy-paste prompts into Claude Code. Claude handles the chain automatically.

---

## How the chain works

Every prompt goes through the same execution chain. Gates are enforced inline — you see them in the output.

```
recall-and-route (entry point)
  → context from context/ (one folder per system; verticals are tags)
  → [route to skill]

PRD creation chain:
  prd-creator (orchestrator): four inputs
  → prd-content-generator (reads Writing Style Guide + Context)
  → PRD draft + handoff note
  → review-prd (auto-triggered; reviews, fixes, re-reviews)
  → Final PRD → Artifact sign-off
  → save to archives/ with auto-version
  → push to GitHub
```

**Gate markers:** none. The creator and reviewer run in one session and emit no markers.

---

## Context loading

Context lives in `~/pm-agent/context/`: one folder per system (`allocation`, `tracking`, `serviceability`, `eta`), with verticals as tags on each document. Add documents there; conventions are in `context/README.md`.

- Claude reads the folders for the systems named in your request.
- If a system's folder is empty, Claude asks once whether to pause and add documents, or proceed with assumptions flagged.
- If two documents conflict, the later `updated` date wins.

---

## Prompts

### Create a PRD

```
Create a PRD.
Problem: [Who is affected, what is broken or missing, and the measured impact]
Solution: [What changes in the system or process]
Success Metrics: [Metrics you want to move, with direction and target if known]
Systems & Verticals: [e.g. Promise, Allocation / Hyperlocal Forward]
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
```

One run produces one Executable PRD. Initiative Docs and milestone breakdowns are yours.

**Example:**
```
Create a PRD.
Problem: Drivers start shifts without confirmation, causing ghost availability in dispatch; ~X% of assignments are made to drivers who are not on shift.
Solution: Require OTP-verified shift start before a driver is marked active in Locus.
Success Metrics: Reduce assignments to inactive drivers from X% to under Y%.
Systems & Verticals: Allocation, 3rd Party Rails (Locus) / Hyperlocal Forward
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
```

Output saved to: `archives/<project-name>/prds/<descriptor>-v1.md`

---

### Review an existing PRD

```
Review the PRD for [feature].
[Paste the PRD, or give its path in this repo]
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
```

Claude reviews the PRD, fixes it, and returns the Final PRD for your sign-off.

**Interrupted review:** a review that stops mid-way restarts from the draft; there is no resume block.

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
[Paste the PRD, or give its path in this repo]
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
```

Output saved to: `archives/<project-name>/test-cases/<descriptor>-v1.md`

---

### Revise an existing PRD (new version)

Send the updated four inputs in the same format as **Create a PRD**. Claude regenerates the PRD and saves it as the next version (v2, v3, ...). Both versions stay in `archives/` and on GitHub.

To change a PRD you wrote yourself, use **Review an existing PRD** instead.

---

## Manual operations

### Commit and push manually

```bash
~/pm-agent/scripts/commit-and-push.sh "Add PRD: feature-name v2" archives/<project>/prds/feature-name-v2.md
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
| Claude asks whether to proceed without context | The system's folder under `context/` is empty, or no document is tagged for your vertical | Add documents to `context/<system>/` (see `context/README.md`), or reply "proceed" to continue with flagged assumptions |
| Wrong reviewer skill used | Model invokes `anthropic-skills:prd-reviewer` instead of local file | Blocked by `recall-and-route.md` and `create-prd.md` — if it happens, say "use ~/pm-agent/workflows/core/review-prd.md" |
