---
name: make-no-mistake
description: Independently verifies any finished AI output (code, scripts, video renders, documents, designs, data) against what the user actually asked for, and silently fixes failures before handing back. Use at the start of every multi-step task to freeze acceptance criteria, and again before declaring any task done.
---

# Make No Mistake

The user should never have to be the tester. Before you call anything done, a verifier that did not do the work checks it against what the user asked for, with evidence, and you fix what fails. The user hears about it in one line at the end, or only when you are truly stuck.

## The loop at a glance

1. **Freeze intent**: write the intent contract from the prompt alone, before or alongside the work.
2. **Build**: do the work as normal.
3. **Scope gate**: decide if this can be checked cheaply. If not, ask the user where to look.
4. **Independent check**: verify every criterion with evidence.
5. **Fix silently**: repair only what failed, re-check, max 3 rounds.
6. **Finish**: one line of results, or escalate if stuck.

---

## Step 0: Skip check (save tokens)

Run the full loop only when the turn produced or changed an artifact: a file, code, a render, a document, a design, a dataset or an action taken in a tool.

For plain conversational answers, do a 10-second silent check instead: re-read the user's message, confirm every question in it got answered and nothing contradicts their stated preferences. No tools, no contract, no output line.

## Step 1: Freeze the intent contract

Write this **from the user's request and context only, before you look at any output**. Writing it first is what makes the check independent. If your environment can run a background or sub-agent, give it this step so it runs in parallel with the build.

```
INTENT CONTRACT
Goal: <one sentence: what the user will DO with this>
Must:
  1. <observable, pass/fail criterion>
  2. ...            (3 to 7 items, most important first)
Must not:
  - <things outside the ask: extra features, changed files, style violations>
Standing preferences that apply:
  - <only the ones relevant to THIS task, from memory / CLAUDE.md / AGENTS.md / custom instructions>
Check method per criterion:
  1 -> <how it will be proven: run X, open Y, measure Z>
```

Rules for criteria:

- **Observable.** "Works well" fails the test. "`npm test` passes and /login redirects to /dashboard" passes it.
- **Include the implicit must-haves** any reasonable user expects: it runs, it opens, no placeholders or TODOs left, nothing the user didn't ask for got removed.
- **Use the user's own words** for the core criteria. Don't upgrade or reinterpret them.
- **Mark guesses** with `(assumed)`. An assumed criterion can't trigger a fix that changes direction. It can only be reported.
- **Ask early, at most once.** If an ambiguity would change what gets built *and* is expensive to redo, ask one question before building. Otherwise take the most reasonable reading and mark it `(assumed)`.
- **The contract is frozen.** After the output exists, never edit it to make the output pass. Only the user can change it.

## Step 2: Build

Do the work. Nothing changes here, except that the contract now exists and the work should aim at it.

## Step 3: Scope gate (token budget)

Before verifying, estimate the cost. Check only what changed (the diff, the new file, the new render), not everything again.

Ask the user one short question instead of scanning when **any** of these is true:

- Verifying would mean reading more than ~20 files or ~2,000 lines you haven't already seen.
- The output is long media you can't sample meaningfully (see `references/checks.md` for sampling).
- The criterion depends on something only the user can see or do: their device, their account, a real customer, a taste call.

Question format: *"I've finished X. To check it without burning through the whole codebase: which flow or file matters most, or is there something you already know is off?"* Then verify that.

Scale depth to stakes. Public, irreversible, money or client-facing work gets every criterion fully proven. Drafts and internal throwaways get the top 3 criteria.

## Step 4: Independent check

**Best: a fresh verifier.** Wherever you can spawn a sub-agent or fresh context (Claude Code Task/Agent tool, Codex, Gemini CLI, Antigravity agents), launch one with the prompt in `references/verifier-prompt.md`. Give it **only**:

- the user's original request, verbatim
- the frozen intent contract
- pointers to the output (paths, URLs, file names)

Do **not** give it your reasoning, your summary of what you did or your explanation of choices. It has to judge the output the way a stranger would.

**Fallback: fresh-eyes mode** (ChatGPT, Claude chat, or any tool without sub-agents). Switch roles out loud in your own reasoning:

1. Re-read the user's original message verbatim, not your memory of it.
2. Re-read the contract.
3. Inspect the output as if someone else made it. Ignore why you made each choice.
4. Assume at least one criterion fails until evidence proves otherwise.

**Evidence rules (both modes):**

- Every criterion gets `PASS`, `FAIL` or `UNVERIFIED`, plus proof: command output, test result, a measured value, a screenshot or frame you looked at, or a quoted line from the file.
- "Looks good" is not evidence. No proof means `UNVERIFIED`, never `PASS`.
- Actually execute: run the code, open the file, render the page, probe the video. Reading source is not running it.
- Type-specific checks live in `references/checks.md`. Load only the section for this output type.

## Step 5: Silent fix loop

If anything is `FAIL`:

1. Fix **only** the failing criteria, with the smallest change that does it. Don't refactor or "improve" along the way.
2. Re-check the failed criteria, plus any passed criterion the fix could have broken.
3. Repeat. **Maximum 3 rounds.**

Don't narrate the fixing to the user. They asked for a working result, not a progress report.

**Stop and escalate early** if:

- the same criterion fails twice for the same reason (you're guessing, not fixing)
- the fix needs information only the user has
- the fix is destructive or irreversible (deleting data, force-pushing, sending, publishing, paying)
- fixing one criterion requires breaking another (a real conflict in the request)

## Step 6: Finish

**All pass:** add one line at the end of your normal reply:

```
✓ make-no-mistake: 6/6 verified (2 fixed silently)
```

**Some unverifiable:** say what and why, in the same line:

```
✓ make-no-mistake: 5/6 verified · unverified: iOS Safari layout (no device here)
```

**Escalation** (3 rounds spent, or an early-stop condition): a short message, no apology paragraph:

```
⚠ make-no-mistake: stuck on 1 of 6.
Failing: <criterion>
Tried: <fix 1>, <fix 2>
Need from you: <the one decision or piece of info that unblocks it>
```

## Hard rules

- Never edit the contract, lower a threshold or reinterpret a criterion to get a pass.
- Never report `PASS` without evidence you produced in this turn.
- Never let the fix loop expand scope. Fixing means meeting the contract, not redesigning.
- Never re-verify untouched work you already proved this session. Spend tokens on what changed.
- The user's later instruction always beats the contract.
