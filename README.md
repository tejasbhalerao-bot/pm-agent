# PM Agent

GitHub-backed PM workflow system for Truemeds. Loads Truemeds org context from the repo's `context/` folders, creates and reviews PRDs and experiment designs, enforces quality gates, and auto-versions everything to Git.

---

## How to Use

**In Claude Code:**
1. Open `~/pm-agent` as the working folder
2. Paste a workflow prompt (see [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md) for copy-paste examples)
3. Every workflow starts with the same entry point — include this line:
   ```
   Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
   ```

Claude handles everything from there.

---

## Workflows

| Want to... | Ask Claude |
|---|---|
| Create a PRD | `Create a PRD for [feature]` |
| Review an existing PRD | `Review the PRD for [feature]` |
| Design an A/B experiment | `Design an experiment for [hypothesis]` |
| Review an experiment design | `Review the experiment for [feature]` |
| Map stakeholder objections | `Map objections for [feature]` |
| Write an exec brief | `Write an exec brief for [feature]` |
| Design test cases from a PRD | `Design test cases for [PRD path or pasted content]` |

All prompts route through `workflows/supporting/recall-and-route.md`.

---

## Full Execution Chain

Every workflow follows this chain. All steps are automatic — no user prompts needed between them.

```
recall-and-route
  → context from context/ (one folder per system; verticals are tags)
  → [route to correct skill]

PRD Creation chain:
  prd-creator (orchestrator): four inputs
  → prd-content-generator (reads Writing Style Guide + Context)
  → PRD draft + handoff note
  → review-prd (auto-triggered; reviews, fixes, re-reviews)
  → Final PRD → Artifact sign-off
  → save to archives/ with auto-version → push to GitHub
```

### Gate markers

None. The creator and reviewer no longer emit gate markers; the review loop runs in one session.

---

## File Structure

```
pm-agent/
├── CLAUDE.md                           ← repo rules: archive structure, sign-off, save
├── context/
│   ├── CLAUDE.md                       ← org, team, systems, entry point
│   ├── README.md                       ← how Context is organised and loaded
│   └── allocation/ tracking/ serviceability/ eta/   ← one folder per system
├── workflows/
│   ├── supporting/
│   │   └── recall-and-route.md         ← entry point: intent, systems, Context, route
│   └── core/
│       ├── create-prd.md               ← orchestrator: four inputs → draft → review → Final PRD
│       ├── generate-prd-content.md     ← PRD Content Generator
│       ├── review-prd.md               ← PRD Reviewer: review, fix, re-review
│       ├── design-experiment.md        ← A/B experiment design
│       ├── review-experiment.md        ← experiment design reviewer
│       ├── map-objections.md           ← stakeholder objection mapping
│       ├── write-exec-brief.md         ← exec brief / leadership summary
│       └── design-test-cases.md        ← test case design from a PRD
├── templates/
│   ├── FINAL-STEP-TEMPLATE.md          ← save + push instructions for Claude
│   └── prd/
│       └── writing-style-guide.md      ← Executable PRD sections, rules, tone, format
├── scripts/
│   ├── commit-and-push.sh              ← commits and pushes only the paths you name
│   └── get-next-version.sh             ← prints next <descriptor>-v<n>.md for a folder
└── archives/
    └── <project-name>/                 ← one folder per project (kebab-case slug)
        ├── prds/                       ← Executable PRDs (and any Initiative / Vision Docs you file)
        ├── experiments/                ← Experiment / XP Docs
        ├── objections/                 ← Objection maps
        ├── briefs/                     ← Executive summaries
        └── test-cases/                 ← Functional test case suites
```

---

## Versioning

Files version by descriptor + version number within a project folder:

```
archives/dms/prds/m4-payout-manager-v1.md
archives/dms/prds/m4-payout-manager-v2.md
archives/dms/prds/m4-payout-manager-v3.md
```

`get-next-version.sh` detects the current highest version and increments it. No manual work.

---

## Context Loading

Context lives in `context/`, one folder per system (`allocation`, `tracking`, `serviceability`, `eta`). Business verticals are tags on each document. See [context/README.md](context/README.md).

1. `recall-and-route.md` identifies the systems and verticals in the request
2. Claude reads every document in each system's folder (plus cross-tagged documents), keeping those tagged for the requested verticals
3. If two documents disagree about a system, the later-dated one wins
4. If a system has no documents, Claude asks whether to pause and add some, or proceed with flagged assumptions

---

## PRD Archive — DMS Integration (Locus Migration)

Active project as of May 2026 — replacing Shipsy with Locus across hyperlocal delivery operations.

| Milestone | Latest version | Status |
|---|---|---|
| M2 Geography Setup | v3 (2026-05-27) | Complete |
| M3 Driver Module | v3 (2026-05-27) | Complete |
| M4 Payout Manager | v3 (2026-05-30) | Complete |
| M5 Order Sorting | v3 (2026-05-29) | Complete |
| M6 Planning Engine | v1 (2026-05-20) | Draft |
| M7 Driver App & Execution | v2 (2026-05-30) | Complete |
| M8 Alerts | v2 (2026-05-20) | Draft |

---

## Scripts

```bash
# Commit and push with a message
~/pm-agent/scripts/commit-and-push.sh "Add PRD: feature-name v2" archives/<project>/prds/feature-name-v2.md

# Get next auto-versioned filename for a feature
~/pm-agent/scripts/get-next-version.sh archives/<project>/prds feature-name
# → feature-name-v2.md
```

---

## GitHub

[https://github.com/tejasbhalerao-bot/pm-agent/tree/main/archives](https://github.com/tejasbhalerao-bot/pm-agent/tree/main/archives)

---

See [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md) for copy-paste prompts and worked examples.
