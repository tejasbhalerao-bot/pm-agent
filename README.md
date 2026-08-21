# PM Agent

GitHub-backed PM workflow system for Truemeds. Loads Truemeds org context from Google Drive, creates and reviews PRDs and experiment designs, enforces quality gates, and auto-versions everything to Git.

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
  → context-loader (loads org context from Google Drive; cached same-day)
  → [route to correct skill]

PRD Creation chain:
  prd-creator (draft + 5-pass gap analysis per UC)
  → [SCORE: X/10 gate — STOP if < 8, fill gaps first]
  → [CHAIN] review-prd (Pass 1)
    → [WIDGET GATE] render findings widget
    → [PASS 1 HANDOFF] structured block for loop continuity
    → prd-creator fixes P0s and P1s
    → review-prd (Pass 2)
      → [WIDGET GATE] render findings widget (resolved/persists/new)
      → [PASS 2 HANDOFF] block
      → if no P0s: offer sign-off
      → if P0s remain: loop continues (Pass 3+ requires user confirmation)
  → save to archives/ with auto-version
  → push to GitHub
  → objection-mapper (offered to user post sign-off)
```

### Gate markers

Gates are output as inline markers — they enforce ordering and are visible in the session:

| Marker | Meaning |
|---|---|
| `[5-PASS SCORE: X/10 — Pass N thin: reason]` | Pre-review quality score; STOP if < 8 |
| `[CHAIN: reading review-prd.md → beginning Pass 1]` | Auto-triggers reviewer |
| `[WIDGET GATE: rendering pass summary now]` | Blocks Step 7 routing until widget renders |
| `[PASS N HANDOFF] ... [/PASS N HANDOFF]` | Loop continuity block — required for Pass N+1 |

---

## 5-Pass Gap Analysis Framework

Every PRD is written and reviewed through a 5-pass diagnostic lens (`workflows/core/gap-analysis-5pass.md`). Validated across 6 DMS milestone PRDs (May 2026).

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
│   │   ├── load-context.md             ← loads org context from Google Drive
│   │   ├── answer-context-questions.md ← follow-up Q&A on loaded context
│   │   └── weekly-synthesis-routine.md ← self-improvement pipeline
│   └── core/
│       ├── create-prd.md               ← PRD / Initiative Doc / Vision Doc creation
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
│       └── style-guide-fallback.md     ← style guide when no Drive PRDs found
│
└── scripts/
    ├── commit-and-push.sh              ← git add -A → commit → push
    ├── get-next-version.sh             ← auto-increments vN for a feature
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

Before any workflow, Claude loads Truemeds-specific org context from Google Drive via `load-context.md`:

1. Reads the master index to identify relevant vertical docs
2. Always loads Cross-Cutting (team structure, platform rules, metric definitions)
3. Loads only vertical docs that the current request touches
4. Caches for the session — same-day re-runs skip re-fetching

If context is empty or stale, Claude surfaces a choice before proceeding: pause and file docs, or continue with flagged assumptions.

---

## Changelog System

Every skill has a paired changelog file in `changelogs/`. Changelogs contain dated behavioral amendments that override the core workflow file when they conflict. Later entries take precedence.

**Read order at runtime:** core workflow file → changelog → apply amendments → execute.

**Do not edit changelogs manually.** They are updated by the weekly synthesis pipeline or by post-session analysis (see below).

### Key amendments currently active

**prd-creator:**
- Token-optimised lazy loading of operational learnings and style guide (2026-05-16)
- 5-pass framework applied during UC drafting with visible score gate (2026-05-20)
- Visible `[5-PASS SCORE]` gate; STOP if < 8 (2026-05-30)
- `[CHAIN]` marker auto-triggers reviewer without user instruction (2026-05-30)
- `anthropic-skills:prd-reviewer` explicitly prohibited; must use local `review-prd.md` (2026-05-30)

**prd-reviewer:**
- 5-pass framework used as primary review lens (2026-05-20)
- `[WIDGET GATE]` marker enforces widget render before routing (2026-05-30)
- `[PASS N HANDOFF]` block at end of every pass for loop continuity (2026-05-30)

**recall-and-route:**
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
~/pm-agent/scripts/commit-and-push.sh "Add PRD: feature-name v2"

# Get next auto-versioned filename for a feature
~/pm-agent/scripts/get-next-version.sh "archives/projects" "feature-name"
# → 2026-05-30-feature-name-v2.md
```

---

## GitHub

[https://github.com/tejasbhalerao-bot/pm-agent/tree/main/archives](https://github.com/tejasbhalerao-bot/pm-agent/tree/main/archives)

---

See [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md) for copy-paste prompts and worked examples.
