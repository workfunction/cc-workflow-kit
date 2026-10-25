# INSTALL — instructions for Claude Code

You are Claude Code, asked by your user to install this kit. Follow these
steps in order. All targets live under `~/.claude/`. `KIT` below means the
directory this file is in.

## 0. Ask the user two things first (one message)

1. **Scope of the dispatch rules**: everywhere (import from
   `~/.claude/CLAUDE.md`) or only in specific repos (import from each
   repo's `CLAUDE.md`)? Default: specific repos — the rules assume a
   multi-agent workflow that is overkill for small scripts.
2. **Per-turn reminder hook** (`seat-gate.sh`, ~25 tokens per prompt,
   silent in repos that did not import the rules)? Default: yes.

The skills and agents are installed globally either way; they only load
when triggered or dispatched.

## 1. Check for collisions

For each target below, check whether it already exists:

- `~/.claude/skills/afk/`, `~/.claude/skills/pre-compact/`, `~/.claude/skills/wrap-up/`
- `~/.claude/agents/deep-reasoner.md`, `implementer.md`, `reviewer.md`
- `~/.claude/dispatch/`

Anything that exists → show the user a diff summary and ask
overwrite / skip / back up as `<name>.bak-<date>` then overwrite. Never
overwrite silently.

## 2. Copy

```bash
mkdir -p ~/.claude/skills ~/.claude/agents ~/.claude/dispatch
cp -R "$KIT"/skills/afk "$KIT"/skills/pre-compact "$KIT"/skills/wrap-up ~/.claude/skills/
cp "$KIT"/agents/*.md ~/.claude/agents/
cp "$KIT"/dispatch/core.md "$KIT"/dispatch/templates.md "$KIT"/dispatch/seat-gate.sh ~/.claude/dispatch/
chmod +x ~/.claude/dispatch/seat-gate.sh
```

(Skip any item the user chose to keep in step 1.)

## 3. Wire in the dispatch rules

Add this exact line to the CLAUDE.md file(s) chosen in step 0 (create the
file if missing; do not duplicate the line if it is already there):

```
@~/.claude/dispatch/core.md
```

The first session in each repo shows a one-time approval for the external
import; `/memory` then lists the file.

## 4. Optional hook

If the user said yes in step 0, MERGE this into `~/.claude/settings.json`
under `hooks.UserPromptSubmit` — keep every existing hook and key; read the
file first and write valid JSON back:

```json
{ "hooks": [ { "type": "command", "command": "~/.claude/dispatch/seat-gate.sh", "timeout": 5 } ] }
```

## 5. Models

Read `~/.claude/dispatch/core.md` §binding with the user. Defaults: main
session `opus`, advisor `fable`, worker `sonnet`, reviewer `opus`. If the
user's plan lacks one of these, change the `model:` line in the matching
`~/.claude/agents/*.md` and the same row in `core.md`.

## 6. Verify and report

1. `ls ~/.claude/skills/{afk,pre-compact,wrap-up}/SKILL.md ~/.claude/agents/{deep-reasoner,implementer,reviewer}.md ~/.claude/dispatch/{core.md,templates.md,seat-gate.sh}` — all present.
2. `grep -n 'dispatch/core.md' <each CLAUDE.md you edited>` — one hit each.
3. If the hook was added: `python3 -m json.tool ~/.claude/settings.json >/dev/null` succeeds.
4. Tell the user: restart Claude Code (or start a new session) so the
   skills and agents load; then try "I'm going afk" or "wrap up".

Report what was installed, what was skipped, and any backups made.

## Uninstall

Remove the three skill dirs, the three agent files, `~/.claude/dispatch/`,
the `@~/.claude/dispatch/core.md` line(s), and the seat-gate hook entry.
