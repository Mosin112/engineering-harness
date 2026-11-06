---
name: drift-sync
description: Find and resolve drift between intent, contracts, tests, code, and documentation after a change. Use when a task is finished, before a PR, when asked whether things are in sync or what is stale or missing, or when the README, architecture notes, or contracts may no longer match the code.
---

# Drift Sync

Software drifts: code moves, tests lag, docs go stale, contracts stop describing reality. Drift-sync
compares the artefacts, reports the gaps, and closes them without silently rewriting intent.

## Authority order
1. **User intent** (what they said they want)
2. **Contracts** in `contracts/` (agreed behaviour)
3. **Tests** (executable form of the contract)
4. **Code**
5. **Docs** (README, architecture notes, `CLAUDE.md`)

Lower layers are corrected to match higher ones. If code is right and the contract is wrong, the
**user** decides; you propose, you do not rewrite the contract yourself.

## Process

### 1. Gather
Read the contracts, list the tests, read the diff of the current change, and read the README and any architecture or onboarding notes.

### 2. Compare and classify
| Drift type | Meaning |
| --- | --- |
| Uncovered | A contract clause has no test |
| Orphan | A test or code path matches no clause |
| Contradiction | Code or tests disagree with the contract |
| Stale docs | README, setup steps, or architecture notes no longer match |
| Missing model | A new concept or invariant appeared and is written nowhere |

### 3. Report
Produce a short table: `# | type | where | what is wrong | proposed fix`. Keep it to material
drift. Do not list style nits.

### 4. Resolve
- Uncovered clause: write the test through `outside-in-tdd`.
- Orphan test/code: remove it, or ask whether a clause is missing.
- Contradiction: ask the user which side is right, then fix that side.
- Stale docs and missing model notes: update them now; keep edits minimal and factual.
- Contract edits: show the clause diff and get approval first.

### 5. Close
Run `verify-before-done` on anything you changed, then state: drift found, drift resolved, drift
deliberately left (with reasons).

## Scope discipline
If the user asked for a read-only review or a plan, report drift and change nothing. Reconcile only
within the scope of what the user authorised.
