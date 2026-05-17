# PM Agent

GitHub-backed PM workflow system. Create PRDs → get reviewed → anticipate objections → push to GitHub. Automatically versioned.

## Use It

**In Claude Desktop:**
1. Click **Code**
2. **File → Open Folder** → `/Users/tejasbhalerao/pm-agent`
3. Paste this:Create a PRD for [feature name].
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
Create a PRD for [feature name].
Entry point: ~/pm-agent/workflows/supporting/recall-and-route.md
Claude handles everything:
- ✅ Loads context
- ✅ Creates PRD
- ✅ Reviews it
- ✅ Maps objections
- ✅ Saves to `archives/projects/[date]-[feature]-v1.md`
- ✅ Pushes to GitHub

## Workflows

| Want to... | Ask Claude |
|-----------|-----------|
| Create a PRD | "Create a PRD for [feature]" |
| Design an experiment | "Design an experiment for [hypothesis]" |
| Anticipate objections | "Map objections for [feature]" |
| Write for leadership | "Write an executive brief for [feature]" |

## Where Files Go
archives/projects/        → PRDs
archives/experiments/     → Experiment designs
archives/objections/      → Objection analysis (auto-linked to PRD versions)
archives/briefs/          → Executive summaries

## Versioning

First PRD: `v1`
Revise it: `v2`
Revise again: `v3`

Auto-detected. No manual work.

## View on GitHub

https://github.com/tejasbhalerao-bot/pm-agent/tree/main/archives

---

See **WORKFLOW_GUIDE.md** for detailed examples.
