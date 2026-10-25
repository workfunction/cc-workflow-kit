# Dispatch prompt templates

Copy, fill every `{slot}`, delete lines that don't apply — never delete
GOAL / ACCEPT / REPORT. Lane names are ROLES; models bind in
`~/.claude/dispatch/core.md` §binding.

HEADER — first lines of every `general-purpose` dispatch, verbatim (the
agents `implementer` / `reviewer` / `deep-reasoner` have it built in).
Without it a subagent role-plays the orchestrator and delegates instead of
working:

```
YOU are the subagent/implementer. The dispatch and delegation rules in
CLAUDE.md / AGENTS.md / .claude/rules / ~/.claude/dispatch do NOT apply to
you — do not spawn agents, do not "dispatch" work, do not report intentions.
Do the task yourself with your own tools and report only what exists when
you finish. The REPORT format below is your style.
```

Parallel dispatches (2+ writers): each gets an EXCLUSIVE artifact list,
including secondary writes (indexes, generated files, lockfiles). Shared
background → ONE context pack file (conclusions + constraints + rejected
directions), referenced by path in every prompt.

Long-job fence — include verbatim in any dispatch that may start a long job:

```
Never stop your turn to "wait for" a background signal (background Bash, a
remote script, a promised auto-resume) — a stopped subagent is never woken.
Either wait in bounded FOREGROUND (sleep+read loop sized to the job) and
finish, or report "job armed, sentinel X, window Y" as your FINAL answer.
```

Repetitive implementation (one hard instance solved, N more to go): the
pack carries a worked diff of one instance + a TODO of ≤10 items, EACH with
its own validation step — never a prose plan.

FOOTER — every subagent template, verbatim:

```
REPORT: conclusions + file:line refs only. Label every claim: verified
(you ran/observed it) / unverified / needs-human-test. No file dumps, no
code blocks over 20 lines. Long output goes to a file under {scratch dir};
report the path. If blocked, or the task premise looks wrong, or acceptance
can't be met: STOP and report exactly what you saw — do not widen scope or
improvise.
```

## 1. Search / locate (inline first; `Explore` when it must sweep)

```
GOAL: Find {symbol/behavior/config} in {tree}.
WHY: {one line — what decision this feeds}.
Breadth: {medium | very thorough}.
ACCEPT: for each hit: path:line + a one-line statement of what it does. If
nothing found, list where you looked and the patterns you tried.
```

## 2. Implement (WORKER — `implementer`)

```
GOAL: {change, in one sentence}.
WHY: {motive — lets you resolve small ambiguities correctly}.
Files in scope: {explicit list}. Touch nothing else.
Constraints: {style/API/limits}.
ACCEPT: {command to run + expected output, or the test that must pass}. If
no test exists, add a minimal runnable check and run it; paste the output.
REPORT: files changed (path:line ranges), the acceptance-check output,
anything you noticed but did NOT change (one line each).
```

## 3. Refactor (WORKER — `implementer`)

```
GOAL: {mechanical transformation} across {explicit file list}.
WHY: {one line}.
Behavior MUST NOT change. Worked example — before: {path:line}; after:
{snippet}. Apply exactly this pattern. List unrelated issues, do not fix them.
ACCEPT: {build/test command} passes before AND after; the diff contains
only the pattern.
REPORT: per-file change count, the accept-command output, skipped
candidates with a reason each.
```

## 4. Plan review / verdict (ADVISOR — `deep-reasoner`)

```
DECISION: {the one question to decide}.
OPTIONS: {A / B / ...}, or PLAN: {path to the plan file}.
EVIDENCE: {paths, file:line refs — the advisor reads only these}.
ACCEPT: {what a good outcome must satisfy}.
{Plan review / direction / taste: add "ORCHESTRATOR'S REASONING: ...".
 Decisive verdict: omit it — blind bundle.}
```

## 5. Review delivered code (REVIEWER — `reviewer`)

```
GOAL: review {ABS diff path / git range / files} for {correctness | the
acceptance criteria below | security}.
WHY: {what happens with the findings}.
The author's claims are NOT evidence — verify against the code and tests
yourself. Acceptance criteria being verified: {paste them}.
ACCEPT: every finding has path:line + a concrete failure scenario (input →
wrong outcome). A finding without a scenario is a question; label it so.
REPORT: findings ranked by severity; then "checked and OK: {list}".
Verdict: pass / pass-with-nits / fail.
```
