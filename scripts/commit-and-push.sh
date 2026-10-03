#!/bin/bash
# Commit and push only the files you name. Never stages anything else.
# Usage: ~/pm-agent/scripts/commit-and-push.sh "Commit message" <path> [path...]
# Example: commit-and-push.sh "Add PRD: payout manager (v2)" archives/dms-v2/prds/m4-payout-manager-v2.md

REPO="${PM_AGENT_DIR:-$HOME/pm-agent}"
cd "$REPO" || exit 1

MSG="$1"
shift

if [ -z "$MSG" ] || [ "$#" -eq 0 ]; then
  echo "Error: provide a commit message and at least one path" >&2
  echo "Usage: commit-and-push.sh \"message\" <path> [path...]" >&2
  exit 1
fi

git add -- "$@" || exit 1

if git diff --cached --quiet -- "$@"; then
  echo "Nothing to commit for the given paths" >&2
  exit 1
fi

echo "Committing: $MSG"
git commit -m "$MSG" -- "$@" || exit 1

echo "Pushing to GitHub..."
git push || exit 1

echo "Pushed."
