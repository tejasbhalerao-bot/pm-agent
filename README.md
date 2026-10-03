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
| Design test cases from a PRD | `Design test cases for [PRD Drive link]` |

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

## 5-Pass Gap Analysis Framework

*Superseded for PRD creation (2026-10-02) by the four-lens walk in `generate-prd-content.md`; kept as reference.*

Every PRD was written and reviewed through a 5-pass diagnostic lens (`workflows/core/gap-analysis-5pass.md`). Validated across 6 DMS milestone PRDs (May 2026).

| Pass | Question | What it catches |
|---|---|---|
| 1 | What happens when everything works? | Thin happy path specs written as feature names |
| 2 | What happens when each step fails directly? | Missing duplicate handling, wrong-state actions, race conditions |
| 3 | What happens when external systems fail? | Missing retry policy, circuit breaker, recovery trigger |
| 4 | What happens when two valid states collide? | State intersections across UCs, cutover conflicts |
| 5 | What applies to all UCs? | Auth matrix, audit trail, concurrency model, PII, metrics thresholds, rollout plan |

**Minimum bar before review:**
- Passes 1–2: fully covered for all UCs
- Pass 3: present for any UC that calls an external system
- Pass 5: authorization matrix, audit trail events, open questions table

**Rating heuristic:**

| What's present | Score |
|---|---|
| Pass 1 only | 3–4/10 |
| Pass 1 + partial Pass 2 | 5–6/10 |
| Pass 1 + full Pass 2 | 7/10 |
| Pass 1 + Pass 2 + Pass 3 | 7.5–8/10 |
| All 5 passes | 9–10/10 |

---

## File Structure

```
pm-agent/
├── workflows/
│   ├── supporting/
│   │   ├── recall-and-route.md         ← entry point for all workflows
│   │   ├── load-context.md             ← (legacy; Drive-based, not used for PRDs)
│   │   ├── answer-context-questions.md ← (legacy; depends on the old Context Loader)
│   │   └── weekly-synthesis-routine.md ← self-improvement pipeline
│   └── core/
│       ├── create-prd.md               ← PRD / Initiative Doc / Vision Doc creation
│       ├── generate-prd-content.md     ← PRD Content Generator (inputs → draft)
│       ├── review-prd.md               ← multi-pass PRD reviewer with widget output
│       ├── gap-analysis-5pass.md       ← 5-pass coverage framework
│       ├── design-experiment.md        ← A/B experiment design
│       ├── review-experiment.md        ← experiment design reviewer
│       ├── map-objections.md           ← stakeholder objection mapping
│       ├── write-exec-brief.md         ← exec brief / leadership summary
│       └── design-test-cases.md        ← test case design from PRD
│
├── changelogs/
│   ├── prd-creator_changelog.md        ← behavioral amendments to prd-creator
│   ├── prd-reviewer_changelog.md       ← behavioral amendments to prd-reviewer
│   ├── prd-creator-operational-learnings.md  ← principles from real sessions
│   ├── context-loader_changelog.md
│   ├── context-recall_changelog.md
│   ├── context-qna_changelog.md
│   ├── exec-brief-writer_changelog.md
│   ├── experiment-designer_changelog.md
│   ├── experiment-reviewer_changelog.md
│   └── objection-mapper_changelog.md
│
├── archives/
│   └── <project-name>/               ← one folder per project (kebab-case slug)
│       ├── prds/                     ← PRDs, Initiative Docs, Vision Docs
│       ├── experiments/              ← Experiment / XP Docs
│       ├── objections/               ← Objection maps
│       ├── briefs/                   ← Executive summaries
│       └── test-cases/               ← Functional test case suites
│
├── templates/
│   ├── FINAL-STEP-TEMPLATE.md          ← save + push instructions for Claude
│   └── prd/
│       ├── operational-learnings.md    ← (legacy; now in changelogs/)
│       ├── writing-style-guide.md      ← Executable PRD sections, rules, tone, format (current)
│       └── style-guide-fallback.md     ← (legacy; superseded by writing-style-guide.md)
│
└── scripts/
    ├── commit-and-push.sh              ← commits and pushes only the paths you name
    ├── get-next-version.sh             ← prints next <descriptor>-v<n>.md for a folder
    └── weekly_synthesis.py            ← changelog self-improvement pipeline
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

## Changelog System

Every skill has a paired changelog file in `changelogs/`. Changelogs contain dated behavioral amendments that override the core workflow file when they conflict. Later entries take precedence.

**Read order at runtime:** core workflow file → changelog → apply amendments → execute.

**Do not edit changelogs manually.** They are updated by the weekly synthesis pipeline or by post-session analysis (see below).

### Key amendments currently active

**prd-creator** *(entries below superseded 2026-10-02 by the orchestrator redesign; see `changelogs/prd-creator_changelog.md`)*:
- Token-optimised lazy loading of operational learnings and style guide (2026-05-16)
- 5-pass framework applied during UC drafting with visible score gate (2026-05-20)
- Visible `[5-PASS SCORE]` gate; STOP if < 8 (2026-05-30)
- `[CHAIN]` marker auto-triggers reviewer without user instruction (2026-05-30)
- `anthropic-skills:prd-reviewer` explicitly prohibited; must use local `review-prd.md` (2026-05-30)

**prd-reviewer** *(entries below superseded 2026-10-03 by the review-and-fix redesign; see `changelogs/prd-reviewer_changelog.md`)*:
- 5-pass framework used as primary review lens (2026-05-20)
- `[WIDGET GATE]` marker enforces widget render before routing (2026-05-30)
- `[PASS N HANDOFF]` block at end of every pass for loop continuity (2026-05-30)

**recall-and-route** *(entries below superseded 2026-10-03: no handoff resume rule; Context now loads from `context/`)*:
- Resumption guard: "run Pass 2" requires `[PASS N HANDOFF]` block or explicit confirm (2026-05-30)
- `anthropic-skills:prd-reviewer` prohibited; local workflow file is always the target (2026-05-30)

---

## Self-Learning Pipeline

`scripts/weekly_synthesis.py` (triggered via `scripts/run-synthesis.js`) runs weekly:

1. Reads the last 7 days of git diffs
2. Calls Claude API to extract new learnings from corrections and patterns
3. Appends them to the relevant changelog file — deduplicated, no manual edits needed

The agent improves based on actual usage. Corrections made during sessions become rules that apply in future sessions.

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
