---
name: wrap-up
description: End-of-work closeout for a task or session — use whenever the user says wrap up / close this out / done for today / that's it for today / record the lessons / what should we save / 收工 / 結案 / 收尾 / 今天到這 / 記lesson, including combined forms like "wrap up and prepare to compact". Writes durable results into the project's notes, records lessons, commits this session's changes, and reports loose ends (open items, state left on other machines, background jobs). NOT for mid-task compaction where work continues — that is pre-compact.
---

# wrap-up — closing out

Do the steps in order.

## 1. Durable notes

Persist this session's conclusions where the project keeps them (a docs/
or notes dir, a design doc, the task's working file — CLAUDE.md usually
says where):
- Existing note → add an `## Outcome` section (final approach, side
  effects, verification result).
- New note → create it in the project's notes location.
Nothing durable → say "nothing to record this time".

## 2. Lessons

Every trap hit this session: agent-operation traps → the project's lessons
log (CLAUDE.md or `.claude/rules/`); a skill's recipe → that skill's
Lessons; a user preference or correction → auto-memory. None → say
"no lesson".

## 3. Commit

Default on. Skip only if the project's CLAUDE.md says the user commits by
hand — then list the changed files for them instead.

1. `git status --porcelain`; pick ONLY files this session created or
   changed. Confirm each with `git diff --stat -- <path>` (status can be
   "racily clean" for same-size edits within the same second).
2. Never stage: `.env`, secrets or key material, tarballs and other large
   binaries, `*.bak*`, profiling output, paths CLAUDE.md marks as
   user-owned, and files another live session is editing.
3. `git add <explicit paths>` — never `-A` or `.`.
4. Scan `git diff --cached` for token / password shapes before committing.
5. Message: follow the repo's commit convention (check `git log`); one
   line saying what was done, plus any attribution line the harness asks for.
6. Report the SHA plus a "deliberately not committed" list, one reason each.

## 4. Closeout report

1. **Saved**: note paths, where lessons went, commit SHA.
2. **Still open**, two groups: the user's (review, push, ticket updates —
   each with a time estimate) and waiting on others (CI, reviewer approval).
3. **State left outside**: files swapped on remote machines + backup paths;
   extra worktrees or checkouts; background jobs still running. Each with
   its cleanup method. **Cleanup is always asked first**, never done
   unilaterally.

User also said compact (e.g. "wrap up and compact") → after the four
steps, run pre-compact step 4 for the compact argument.

Reply in the user's language.

## Contract

- **No push, nothing outward**: no PR, no ticket edit, no mail. Outward
  actions go under the user's open items.
- **Commit must finish** (unless the project opts out): no SHA in the report
  = not done. Genuinely nothing to commit → say "no changes this session"
  with the `git status` evidence.
- **Only this session's files**; never another session's. Unsure → list
  under "deliberately not committed" and ask.
- **No deletion or cleanup**: remote machines, worktrees and drafts are
  reported only; cleanup needs a user yes.
- **"No lesson" / "nothing to record" must be true**; never invent an entry
  to fill the slot.

## Lessons (≤8 × ≤2 lines, newest first)

- (none yet)

## Lesson & refine rule

A step here failed, misled, or cost >15 min of rework → before the turn ends,
add a dated ≤2-line entry to Lessons and fix the step itself in this file.
