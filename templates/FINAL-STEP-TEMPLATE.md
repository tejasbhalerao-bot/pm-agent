# Final Step: Auto-Save and Push to GitHub

## 0. Add version history header to the document

Before saving, prepend the following block to the top of the approved document:

```markdown
---
**Document:** [Feature Name]
**Type:** [Executable PRD / Initiative Doc / Vision Doc]
**Version:** vN
**Date:** YYYY-MM-DD
**Status:** [Draft / Under Review / Approved]
**Author:** Tejas Bhalerao

| Version | Date | Changes |
|---|---|---|
| v1 | YYYY-MM-DD | Initial draft |
| vN | YYYY-MM-DD | [Summary of changes from previous version] |
---
```

Fill in the version table accurately. For v1, only one row is needed.


Once your document is complete and approved, I will:

## 1. Determine the correct archive path and next version
- **PRD**: `archives/projects/[DATE]-[feature-name]-v#.md`
- **Experiment**: `archives/experiments/[DATE]-[feature-name]-v#.md`
- **Objections**: `archives/objections/[DATE]-[feature-name]-v#-objections.md`
- **Executive Brief**: `archives/briefs/[DATE]-[feature-name]-v#-brief.md`

I will use `~/pm-agent/scripts/get-next-version.sh` to auto-increment versions.

## 2. Save the file to disk
I will write the final document directly to the correct archive folder.

## 3. Run the commit-and-push script
I will execute:
```bash
~/pm-agent/scripts/commit-and-push.sh "Add [DOC-TYPE]: [feature-name] (v#)"
```

## 4. Verify success
Your document will be:
- ✅ Saved with auto-incremented version
- ✅ In the correct archive folder (projects, experiments, objections, briefs)
- ✅ Committed to git with version history
- ✅ Pushed to GitHub

**Fully automated. Zero manual steps.**