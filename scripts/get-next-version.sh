#!/bin/bash
# Print the next versioned filename for a document. No date prefix.
# Usage: ~/pm-agent/scripts/get-next-version.sh <archive-dir> <descriptor>
# Example: get-next-version.sh archives/dms-v2/prds m4-payout-manager
#          -> m4-payout-manager-v2.md   (if -v1 already exists)

REPO="${PM_AGENT_DIR:-$HOME/pm-agent}"
ARCHIVE_DIR="$1"
DESCRIPTOR="$2"

if [ -z "$ARCHIVE_DIR" ] || [ -z "$DESCRIPTOR" ]; then
  echo "Usage: get-next-version.sh <archive-dir> <descriptor>" >&2
  exit 1
fi

case "$ARCHIVE_DIR" in
  /*) DIR="$ARCHIVE_DIR" ;;
  *)  DIR="$REPO/$ARCHIVE_DIR" ;;
esac

LATEST=$(ls "$DIR" 2>/dev/null | sed -n "s/^${DESCRIPTOR}-v\([0-9][0-9]*\)\.md$/\1/p" | sort -n | tail -1)
NEXT=$(( ${LATEST:-0} + 1 ))

echo "${DESCRIPTOR}-v${NEXT}.md"
