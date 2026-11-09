#!/usr/bin/env bash
# Claude Code Stop hook: blocks the first attempt to finish a turn and tells
# Claude to run make-no-mistake. The second attempt (stop_hook_active=true)
# is always allowed, so this can never loop forever.

input="$(cat)"

if printf '%s' "$input" | grep -Eq '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

cat <<'JSON'
{"decision":"block","reason":"Before finishing, run the make-no-mistake skill on what you produced this turn. If the turn only answered a question, do the silent 10-second check and stop. Otherwise: verify against the frozen intent contract with evidence, fix failures silently (max 3 rounds), then end with the one-line make-no-mistake result."}
JSON
