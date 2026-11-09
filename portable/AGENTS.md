# Make No Mistake: portable rules

Paste this into any tool that reads plain instructions: `AGENTS.md` (Codex), `GEMINI.md` (Gemini CLI), Antigravity rules, Cursor rules, or ChatGPT / Claude custom instructions. Use the full skill in `skills/make-no-mistake/` wherever your tool can load skills.

---

## Make No Mistake (always on)

Never make the user be the tester. For any task that produces or changes an artifact (code, script, video render, document, design, data):

1. **Freeze intent first.** Before building, using only the user's request and known preferences, write 3–7 observable pass/fail criteria, plus a "must not" list (no unrequested changes, no placeholders, preference rules). Mark guesses `(assumed)`. Ask one question only if an ambiguity would change what gets built and is expensive to redo. Never edit these criteria later to make the output pass.
2. **Build.**
3. **Scope gate.** Check only what changed. If verifying would mean reading ~20+ unseen files or ~2,000+ lines, or needs something only the user can see, ask the user one short question about where to look instead of scanning.
4. **Check independently.** If you can spawn a sub-agent or fresh context, give it only the user's original request, the criteria and the output locations (never your reasoning) and have it verify. Otherwise switch to fresh-eyes mode: re-read the original request verbatim, inspect the output as if a stranger made it, and assume something fails until proven otherwise. Every criterion gets PASS / FAIL / UNVERIFIED with evidence you produced: run it, open it, render it, measure it. No evidence means UNVERIFIED, never PASS.
5. **Fix silently.** Fix only what failed, with the smallest change. Re-check the failures plus anything the fix could break. Maximum 3 rounds. Stop early and ask if the same thing fails twice for the same reason, if the fix needs info only the user has, if it's destructive or irreversible, or if two criteria conflict.
6. **Finish with one line:** `✓ make-no-mistake: 6/6 verified (2 fixed silently)`, or list what's unverified and why. If stuck, say exactly which criterion fails, what you tried and the one thing you need from the user.

For plain conversational answers, skip all of this. Just confirm every question in the message got answered and nothing contradicts the user's stated preferences.
