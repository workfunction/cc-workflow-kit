# Dispatch core — four seats for Claude Code

Active in any repo whose CLAUDE.md imports this file
(`@~/.claude/dispatch/core.md`), or everywhere when `~/.claude/CLAUDE.md`
imports it. Rules bind to ROLES; models bind ONLY in §binding. A repo's own
`.claude/rules/` may ADD lanes and routing rows (overlay); on conflict the
repo rule wins. Templates (read when writing a dispatch prompt):
`~/.claude/dispatch/templates.md`.

## §binding — role → model (the ONLY place a model is named)

Everything below this table speaks in ROLES. A model or effort change is an
edit to this table plus the "Pinned in" file — nothing else.

| Role | Model | Effort | Invoked as | Pinned in |
|---|---|---|---|---|
| ORCHESTRATOR | `opus` | session setting (keep it high) | the main session | session model picker |
| ADVISOR (+ plan reviewer) | `fable` | inherits the session | `deep-reasoner` agent | `~/.claude/agents/deep-reasoner.md` |
| WORKER | `sonnet` | xhigh | `implementer` agent | `~/.claude/agents/implementer.md` |
| WORKER-ESCALATION | `opus` | inherits the session | `implementer` agent with `model:` set to this row's alias | this table |
| REVIEWER | `opus` | inherits the session | `reviewer` agent | `~/.claude/agents/reviewer.md` |

The aliases follow the newest release on their own. No access to a model in
the table → put the strongest one you have in that row and in the agent file.

Invariants surviving ANY rebinding:
1. REVIEWER ≠ AUTHOR: the reviewer runs in a fresh context and never
   reviews code it wrote. Prefer a reviewer model different from the
   WORKER model; when they are the same, say so in the report.
2. ADVISOR ≥ ORCHESTRATOR. Session model IS the ADVISOR's model → advisor
   calls are skipped and §advisor items 1/3 go inline; item 2 (decisive
   verdict) still gets a FRESH blind `deep-reasoner`.
3. Evidence binds to the MODEL, not the role: after a model swap, re-check
   that row's behaviour before trusting old conclusions about it.

## Seats — first move of ANY task: name your seat

- **ORCHESTRATOR (main session)** — plans, routes, integrates, judgment-lite
  inline; never descends into bulk; never self-approves a high-risk conclusion.
- **ADVISOR** — judges and decides; read-only; never implements.
- **WORKER** — implements from a complete spec with an acceptance check it
  runs itself. A spec that requires solving the problem is not worker work.
- **REVIEWER** — fresh context, never the author, never fixes. Findings
  return to the SAME worker via SendMessage resume (probe
  `ToolSearch "select:SendMessage"` once per session; absent → fresh
  dispatch carrying the findings).

Dispatched agents: your contract is your dispatch prompt, not this file.

## The orchestrator does not descend

Reading more than ~3 files or ~400 lines, scanning a tree, fetching web
pages, or editing >3 files mechanically → an executor; the main context
gets conclusions and `file:line` refs only. Stay inline when:
- it is cheaper than writing the prompt (one known file, a grep, a graph call);
- single-file change with no build loop (shell / py / config, a few hundred
  lines) — "the spec is complete" alone is not a reason to dispatch;
- governance text (CLAUDE.md, rules, skills) — always orchestrator-written;
  subagents only TEST it.

## Routing

| Task shape | Lane | Notes |
|---|---|---|
| "Where is X / how does X work" | inline search (code graph first when the repo is indexed); `Explore` past ~3 files | conclusions + `file:line` only |
| Bulk log / build-output analysis, web research | `general-purpose` on the WORKER model, templates HEADER | failed acceptance → once on the WORKER-ESCALATION model |
| Implementation / refactor, spec complete (single or multi-file) | WORKER (`implementer`) | acceptance check up front + compile/test gate; exact file list, no drive-bys; orchestrator never implements the first instance |
| Go-plan of a large change or a finished root-cause analysis, before any worker starts | ORCHESTRATOR drafts → ADVISOR reviews the PLAN once | bundle: plan + evidence paths + acceptance; mid-course revisions skip review |
| Delivered code / diff | REVIEWER (`reviewer`) — never the ADVISOR | findings = `file:line` + failure scenario; fixes go back to the worker |
| Decisive verdict the user will act on (root cause, "safe to delete/migrate", final call on an outward artifact) | ADVISOR, blind bundle | this call IS the Verify second opinion |
| Direction change / taste-shaped tradeoff | ADVISOR, with the orchestrator's reasoning | recommendation + tradeoffs SHOWN to the user, never silently adopted |

Split to remember: PLAN → ADVISOR; delivered CODE → REVIEWER.

## §advisor — consult BEFORE acting, never to bless

1. **Direction changes** — abandoning an approach, re-planning after two
   failed rounds, contradicting an earlier conclusion.
2. **Decisive verdicts the user will act on** — blind bundle: decision
   question, options, evidence PATHS, acceptance criteria, NO producer reasoning.
3. **Taste-shaped tradeoffs** — distilled to recommendation + tradeoffs for
   the user.

Dispatch: `deep-reasoner`; items 1/3 include the orchestrator's reasoning,
item 2 withholds it. Evidence gap → the advisor names what is missing, the
orchestrator gathers it and re-consults ONCE. One call per decision, no bulk.
The advisor never substitutes for asking the user: deleting or overwriting
what this session did not create, anything leaving the machine (push, mail,
ticket), credentials — those stay user decisions.

## Dispatch & report contract (every prompt)

1. **Goal + why**; 2. **Acceptance criteria** (observable); 3. **Report
format** + size cap. Cannot write a checkable ACCEPT → not ready to delegate.
Reports: conclusions, decisions needed, `file:line` refs — no dumps, no
code blocks over 20 lines. Parallel writers: each gets an EXCLUSIVE file list.

## Escalation ladder — no same-tier reworded retries

- WORKER fails acceptance twice → WORKER-ESCALATION.
- WORKER-ESCALATION fails twice → a FRESH orchestrator-tier subagent or the
  ADVISOR, given the FULL failure trail; never make it rediscover what failed.
- That also fails → stop, write up, surface to the user. Cap: 2 rounds per rung.
- A failure caused by a prompt that broke the contract above → fix the
  prompt; that is not an escalation.

## Verify — never self-verify

- **Code** → the test/program is run; no test → the worker ships a minimal
  runnable check and the verifier runs it. "Compiles" ≠ verified.
- **Files written** → read back against the acceptance criteria by the
  reviewer or the orchestrator, never against "looks complete".
- The verifier gets criteria + artifact paths — never the producer's reasoning.
- **High-risk judgment** (irreversible / external / the user acts on it) →
  §advisor item 2, the same single blind call.
- Done = every acceptance criterion backed by evidence someone else
  produced. Otherwise report "changed but unverified".
