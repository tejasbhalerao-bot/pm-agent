# Final Step: Save and Push to GitHub

Once your document is complete and approved:

## Save to Archives
- Save to: `~/pm-agent/archives/[ARCHIVE-TYPE]/[YYYY-MM-DD]-[feature-name]-v1.md`
- Replace `[ARCHIVE-TYPE]` with: `projects`, `experiments`, or `briefs`
- Example: `2026-05-17-promise-reduction-v1.md`

## Push to GitHub
In your Mac Terminal:
```bash
~/pm-agent/scripts/commit-and-push.sh "Add [DOC-TYPE]: [feature-name]"
```

Replace `[DOC-TYPE]` with: `PRD`, `Experiment Design`, or `Objection Analysis`

**Example:**
```bash
~/pm-agent/scripts/commit-and-push.sh "Add PRD: Promise Reduction Initiative"
```

This will:
- ✅ Stage all changes
- ✅ Commit with your message  
- ✅ Push to GitHub
- ✅ Version your document!
