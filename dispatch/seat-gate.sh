#!/bin/bash
# UserPromptSubmit hook: per-turn seat reminder, only in repos that opted in
# to the global dispatch core (CLAUDE.md imports dispatch/core.md).
d=${CLAUDE_PROJECT_DIR:-$PWD}
/usr/bin/grep -qs 'dispatch/core.md' "$d/CLAUDE.md" "$d/.claude/CLAUDE.md" "$d/CLAUDE.local.md" \
  && echo '[seat-gate] follow dispatch core — name your seat; orc never descends; plan → ADVISOR, code → REVIEWER.'
exit 0
