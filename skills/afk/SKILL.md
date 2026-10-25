---
name: afk
description: Pre-departure gate + autonomous run-to-completion contract for when the user is about to leave the keyboard; while the user is away the advisor agent stands in as the decider for reversible calls. Use whenever the user says they are leaving and the agent should keep working — going afk / AFK / leaving you overnight / I'll be back later / ask me now then finish it / give me my todo before I go / 我要afk / 準備afk / 放你overnight / 有問題先問我 然後做到底 — or asks what decisions or resources you still need from them before they leave. Covers the blocking-vs-batchable decision list, the pre-departure environment probe, the owner-todo list, the autonomy contract (never-touch list + stop rules), conduct while the user is away, and the return digest.
---

# afk — drain the decisions before they leave, then run to completion

Three phases. Reply in the user's language.

## 1. Pre-departure gate (user still at the keyboard — speed first, target <10 min)

Get everything only the user can give before they go. Four items; do not
release them until all four are done:

1. **Decision list** — two columns: "blocks work now" vs "can be answered
   in a batch later". Each item carries your recommended default and a
   compressed reply format (e.g. "reply with five words: 1 safe 2 even
   3 clamp 4 yes 5 split"). Genuinely nothing pending → say so: "zero
   open decisions; when you return only X will be on your desk".
2. **Resource probe** — probe, don't ask: is the VPN / remote host
   reachable, does the test device answer, are credentials and access in
   place, is the build tree clean. Ask for what is missing now — users
   tend to hand over resources in the same message.
3. **Owner todo** — what THEY owe, not what you will do: a review, a
   one-word "push", pasting a description, asks to other people (hardware,
   a spec). Each with a time estimate. None → "you owe nothing, go".
4. **Autonomy contract** — plan table (item + ETA) + "what I will decide
   on my own" + "what the advisor decides for you" (new forks that come up
   while you're away) + "what I will not touch" + stop rules (when to stop and
   write a report instead of idling or flailing; e.g. a hardware fault →
   stop at once; build or review fails twice in a row → stop that item,
   start the next). Close with: "reply OK, or point at the cell to change".

**Never-touch (irreversible / outward)**: push, opening a merge/pull
request, filing tickets, sending mail or messages, editing tracker items,
publishing anything. All of it goes into the task's queue file (create one
if none exists; tell the user the path); the user releases it on return.

Installing or registering persistent components (input methods, launch
agents, login items, system services) goes on the owner todo at the gate:
the agent builds it and writes the install steps, but does not promise to
install it — auto-mode permission checks usually block that.

## 2. While away — run to completion

- Finish an item, stack the next; irreversible actions go to the queue and
  are **never asked about again** while the user is away.
- A lane is blocked (VPN down, host unreachable, external queue): switch to
  local-only work, arm a probe on the blocked lane — and verify the probe
  against a known-true target first (a broken probe waiting for a timeout
  is the classic time sink) — and write down the user's one-minute unblock
  action.
- Stuck → the pre-declared ladder: retry once with a narrower scope →
  escalate the model tier → stop that item, write the report, move on.
- **The advisor is the decider while the user is away.** A new decision
  the gate did not cover (design fork, direction change, taste call) goes
  to a FRESH `deep-reasoner` (dispatch core §advisor item 4): the question,
  the options, evidence paths, your reasoning, and the user's stated
  preferences from the gate. Act on its verdict and log it in the queue
  file as `ADVISOR-DECIDED: <decision> — <one-line why>`. Irreversible or
  outward actions are never the advisor's to approve; they stay queued.
  No advisor available → the question waits "on the desk" as a written
  pending plan; the other lanes keep running.
- Measurements taken while several workers run in parallel are inflated;
  label them as upper bounds, and take one quiet measurement before any
  design conclusion rests on them.
- Before declaring done, run the hygiene gate: anything outward-facing is
  checked for internal residue, secrets and debug leftovers first.

## 3. On return — the digest

Users often come back with one line ("VPN is up, continue", "where are
we"); the digest must make that line enough. Format:

- 3–5 numbered lines with a glyph: ✅ done / 🕐 waiting on something
  external (with the reason) / ⏸ blocked on you / 👁 monitor armed.
- The first thing to do + a time estimate, ideally just one ("first thing
  when you're back (~1 min): connect the VPN. Everything else is
  automatic").
- State explicitly: "nothing pushed, nothing irreversible", plus the queue
  file path.
- Every `ADVISOR-DECIDED` item, one line each, with what it would take to
  reverse it — the user keeps or overturns each with one word.
- Results table for any artifact; decisions for the user as one-word options.

## Lessons

After each afk run (once the digest is delivered), ask: did the user
correct anything this round? Did a trap cost >15 min? If so, append a
dated one-liner (≤2 lines) below, and if it generalizes, fix the matching
phase rule above. No real lesson → write nothing; never invent one.

- (none yet)
