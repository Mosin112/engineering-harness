---
name: contract-first
description: Turn a feature request, behaviour change, or removal into an agreed behaviour contract before any code is written. Use whenever the user says "I want", "let's add", "can we make it", "change how X works", or "remove Y", and whenever requirements are loose, even if they do not ask for a spec or design.
---

# Contract First

Agree on **observable behaviour** before touching code. The contract is the shared definition of
"done". Everything later (tests, implementation, review) is measured against it.

The contract describes what a consumer of the system can observe. It never describes how the code works inside.

## Process

### 1. Orient (read before asking)
Read the relevant code, existing contracts in `contracts/`, tests, and recent commits. Do not ask the
user things the repository already answers.

### 2. Clarify (one question at a time)
Ask only what you cannot discover. Prefer multiple-choice questions. Stop when you can state the
behaviour in your own words: who consumes it, what they do, what they observe.

### 3. Name the seam
Decide where the behaviour is observed: an HTTP endpoint, a CLI command, a screen, a public function,
an emitted event. The outermost seam that exists in the project is the right one. State it explicitly.

### 4. Draft the contract tree
One clause per line, nested by cause. Use only these openers:

```
when <trigger arrives>
  while <standing condition holds>
    if <branching condition>
      then <observable outcome>
      and <further observable outcome>
```

Rules for every line:
- It is observable from outside the seam.
- It names no function, class, table, or library.
- A test could pass or fail on it. If you cannot imagine the test, rewrite the line.
- Failure paths get lines too: invalid input, missing permission, dependency down.

See `references/example.md` for a complete example.

### 5. Present in digestible chunks
Show the tree in pieces short enough to read (one `when` block at a time). After each, ask whether it
matches intent. Record non-goals explicitly so scope does not creep.

### 6. Record and hand off
- **Non-trivial change:** save to `contracts/<subject>.contract.md` with the header
  `Contract: <subject> (seam: <where observed>)`.
- **Small change (a few clauses):** agree in chat; no file.

Then continue with `outside-in-tdd`. Do not start implementing until the user has approved.

## Changing an existing contract
Edit the existing file rather than adding a parallel one. Show the diff of clauses (added, removed,
changed) and get approval before code changes. A contract changes only when the user's intent changes.

## Common mistakes
- Writing implementation steps ("add a column", "call the service") instead of outcomes.
- Skipping failure paths because the happy path feels like the whole feature.
- Asking five questions at once. Ask one.
- Treating approval of a vague summary as approval of behaviour. Approve the clauses.
