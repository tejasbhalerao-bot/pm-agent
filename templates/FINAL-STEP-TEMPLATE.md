# Final Step: Auto-Save and Push to GitHub

## 0. Add version history header to the document

Before saving, prepend the following block to the top of the approved document:

```markdown
---
**Document:** [Feature Name]
**Type:** [Executable PRD / XP Doc / Executive Brief / Objection Map / Test Cases]
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

Infer the project slug from context (or ask if ambiguous). Then use the correct doc-type subfolder:

- **PRD**: `archives/<project-name>/prds/<descriptor>-v#.md`
- **Experiment**: `archives/<project-name>/experiments/<descriptor>-v#.md`
- **Objections**: `archives/<project-name>/objections/<descriptor>-v#.md`
- **Executive Brief**: `archives/<project-name>/briefs/<descriptor>-v#.md`
- **Test Cases**: `archives/<project-name>/test-cases/<descriptor>-v#.md`

If the project subfolder does not exist, create the full tree before saving.

Get the next filename with `~/pm-agent/scripts/get-next-version.sh archives/<project-name>/<doc-type-folder> <descriptor>`. It prints `<descriptor>-v<n>.md` with no date prefix.

## 2. Save the file to disk
I will write the final document directly to the correct archive folder. Save the document body only: do not include the Review notes section. If the PM signed off with open P0s, put the override note at the top.

## 3. Run the commit-and-push script
I will execute:
```bash
~/pm-agent/scripts/commit-and-push.sh "Add [DOC-TYPE]: [feature-name] (v#)" <saved-file-path>
```

## 4. Verify success
Your document will be:
- ✅ Saved with auto-incremented version
- ✅ In the correct archive folder (projects, experiments, objections, briefs)
- ✅ Committed to git with version history
- ✅ Pushed to GitHub

**Fully automated. Zero manual steps.**