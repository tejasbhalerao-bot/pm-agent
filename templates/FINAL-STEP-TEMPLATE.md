# Final Step: Auto-Save and Push to GitHub

Once your document is complete and approved, I will:

## 1. Determine the next version automatically
I will check existing files in `archives/[ARCHIVE-TYPE]/` and auto-increment:
- If `2026-05-17-promise-buffer-v1.md` exists
- I'll save as `2026-05-17-promise-buffer-v2.md`
- Next iteration? Auto-saves as `v3.md`, and so on.

**No manual version tracking needed!**

## 2. Save the file to disk
I will write the final document directly to the archive folder with the correct version.

## 3. Run the commit-and-push script
I will execute:
```bash
~/pm-agent/scripts/commit-and-push.sh "Add [DOC-TYPE]: [feature-name] (v#)"
```

## 4. Verify success
Your document will be:
- ✅ Saved with auto-incremented version
- ✅ Committed to git with version history
- ✅ Pushed to GitHub
- ✅ Accessible at: https://github.com/tejasbhalerao-bot/pm-agent/tree/main/archives/[ARCHIVE-TYPE]/

**Fully automated. Zero manual steps.**
