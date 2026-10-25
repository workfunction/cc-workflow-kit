---
name: pre-compact
description: Mid-task compaction prep — the task is NOT finished, context just got too big. Use whenever the user says prepare to compact / about to compact / context is too big / compact then continue / give me a compact arg / what should we save before compacting / 準備compact / 要compact了 / context太大 / 先compact再繼續, or asks what to save before /compact. Flushes context-only state to disk, records traps hit so far, lists live background jobs, and outputs the preserve-state list plus a description-only /compact argument. NOT the end-of-work closeout — wrap up / close out / 收工 is the wrap-up skill; "wrap up then compact" runs wrap-up first, then this skill's step 4.
---

# pre-compact — compacting in the middle of a task

Work is unfinished; context is just too big. Goal: the post-compact session
continues without re-investigating. **No closeout**: no "done", no cleanup
of machines or worktrees; commit only if the user asks.

## 1. Flush context-only state to disk

The compact summary drops numbers, paths and half-formed conclusions.
Anything found this session that is still needed:
- The task has a working file (a plan, notes or queue file for this task) → write there.
- No working file → a handoff file in a gitignored scratch dir (e.g.
  `scratch/<task>-handoff.md`); report the path.
- Settled direction → record it where the project keeps decisions (the
  working file, a decision log, or an ADR).
- Decisions awaiting the user → in the working file, tagged `PENDING-USER`.

## 2. Record traps now

They are gone after compact. A trap in how the agent operates → the
project's lessons log (wherever CLAUDE.md or `.claude/rules/` keeps one);
a trap in a skill's recipe → that skill's Lessons section. None → say
"no lesson"; don't invent one.

## 3. List what is still running

Background Bash / Monitor task ids, subagent ids that may be resumed, remote
job ids, sentinel file paths, CI pipelines being waited on. These go
verbatim into the step-4 argument.

## 4. Output (this skill's deliverable)

1. **Preserve-state list**, in order: current task + acceptance criteria;
   files modified so far; pending user decisions; the one next step.
2. **Compact argument** in a fenced block the user pastes after `/compact`:
   - Description only: task, conclusions, file paths, IDs (job, thread,
     commit SHA, PR number).
   - **No command lines, shell payloads, host+account pairs, or
     credentials** — an argument carrying them can be flagged by the
     auto-mode safety classifier.
   - ≤15 lines. Details live in the step-1 file; the argument points at the path.
3. Last line: "run `/compact <the block above>`".

Reply in the user's language.

## Contract

- **No closeout**: no cleanup, no "done"; no commit unless asked.
- **Nothing executable in the argument**: no command lines, payloads,
  credentials, or host+account pairs.
- **IDs are mandatory**: a missing job or thread id strands background work
  after compact → step 3 incomplete = no argument.
- **Context-only facts go to disk first**: the argument points at files,
  never replaces them.

## Lessons (≤8 × ≤2 lines, newest first)

- (none yet)

## Lesson & refine rule

A step here failed, misled, or cost >15 min of rework → before the turn ends,
add a dated ≤2-line entry to Lessons and fix the step itself in this file.
