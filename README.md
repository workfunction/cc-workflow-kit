# claude-dispatch-kit

Working rules and skills for Claude Code: a four-seat dispatch model for
multi-agent work, plus three session skills for leaving the keyboard,
compacting mid-task, and closing out.

## What's inside

| Path | What it does |
|---|---|
| `dispatch/core.md` | The dispatch rules. The main session orchestrates; an **advisor** reviews plans and gives verdicts; a **worker** implements from a complete spec and runs its own acceptance check; a **reviewer** in a fresh context reviews the delivered code. Also covers routing, escalation, and "never self-verify". About 2k tokens when loaded. |
| `dispatch/templates.md` | Prompt templates for dispatching each role (goal / acceptance / report). |
| `dispatch/seat-gate.sh` | Optional prompt hook: a one-line reminder each turn, only in repos that use the rules. |
| `agents/` | `deep-reasoner` (advisor, read-only), `implementer` (worker), `reviewer` (read-only reviewer). |
| `skills/afk` | Before you leave: collects every decision it needs from you, probes resources, lists what you owe, and agrees on what it will and won't touch. While you're away it keeps going and queues anything irreversible. When you return: a short digest. |
| `skills/pre-compact` | Mid-task: writes context-only state to disk, lists running jobs, and gives you a safe `/compact` argument. |
| `skills/wrap-up` | End of work: records outcomes and lessons, commits only this session's files, and lists what's still open. |

## Install

Clone the repo and let Claude Code install it:

```bash
git clone https://github.com/workfunction/claude-dispatch-kit.git
```

Then, in Claude Code:

> Read claude-dispatch-kit/INSTALL.md and install it.

It asks two questions (rules everywhere or per repo; reminder hook yes/no),
checks for name collisions before overwriting anything, and verifies the
result. To install by hand, follow the same file.

## Models

Defaults: main session `opus`, advisor `fable`, worker `sonnet`, reviewer
`opus`. Change them in one place: the §binding table in `dispatch/core.md`
plus the `model:` line of the matching agent file.

## Make it yours

The skills end with a Lessons section. When a step misleads you, Claude
adds a one-line lesson and fixes the step, so the skills adapt to your
workflow over time. Project-specific rules go in that repo's
`.claude/rules/`; they override `core.md` there.

## License

MIT
