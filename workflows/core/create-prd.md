---
name: prd-creator
description: >
  Orchestrator for creating an Executable PRD. Takes four PM inputs (Problem,
  Solution, Success Metrics, Systems & Verticals), calls the PRD Content Generator,
  and auto-triggers PRD Reviewer on the draft. Triggered by Context Recall.
  Executable PRDs only; Initiative Docs, milestone breakdowns and Vision Docs are
  authored by the PM.
---

# PRD Creator

A thin orchestrator. It does no drafting and no review itself.

```
Problem · Solution · Success Metrics · Systems & Verticals
        → PRD Content Generator   (reads: Writing Style Guide, Context)
        → PRD Draft
        → PRD Reviewer            (auto-triggered)
        → Final PRD
```

One run produces one Executable PRD, the unit engineering builds. If the PM's
request spans several workstreams, the generator will say so; splitting into
milestones is the PM's call.

---

## Step 1 — Collect the four inputs

Take Problem, Solution, Success Metrics and Systems & Verticals from the PM's
message. Pass them through as given; do not rewrite them.

If none are present, ask for all four in one message. If some are present, hand
over what exists. The generator validates each input against its minimum bar and
asks for what is missing.

## Step 2 — Call the PRD Content Generator

Use the Read tool to load `~/pm-agent/workflows/core/generate-prd-content.md` and
follow it, passing the four inputs. The generator reads the Writing Style Guide
(`templates/prd/writing-style-guide.md`) and Context itself. The output is a PRD
draft plus a short handoff note.

## Step 3 — Trigger PRD Reviewer (automatic, no permission needed)

When the draft exists, load `~/pm-agent/workflows/core/review-prd.md` and follow it,
passing the draft and the handoff note. Do not ask whether to review; the review
always runs and cannot be skipped. PRD Reviewer owns its own loop and its own
output. Create PRD does not manage passes, fixes or findings.

## Step 4 — Sign-off and save

The reviewed Final PRD is delivered and saved per `CLAUDE.md` (Artifact for
sign-off; after sign-off, save under `archives/<project>/prds/` with the version
header from `templates/FINAL-STEP-TEMPLATE.md`, then push). Nothing is saved before
sign-off. Create PRD ends here.

---

## Rules

- Use only the local workflow files above. Do not invoke `anthropic-skills:*` skills,
  including `anthropic-skills:prd-creator` and `anthropic-skills:prd-reviewer`.
- Do not draft sections yourself and do not paste the draft into chat for review.
- Do not generate Initiative Docs or Vision Docs. If asked, say they are authored
  by the PM and offer to generate an Executable PRD for one milestone.
- If the PM asks to skip the review, decline: the review runs before anything is
  saved. They can override at sign-off after seeing the result.
- If the PM supplies an existing PRD to revise, ask whether to regenerate from the
  four inputs. Edit mode is not supported.
