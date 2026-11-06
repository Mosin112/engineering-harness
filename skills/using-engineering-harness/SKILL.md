---
name: using-engineering-harness
description: Use at the start of any conversation that involves software work. Establishes the harness workflow and tells you which skill applies when. Load it before responding to any request to build, change, fix, review, or ship code, even if the request looks small.
---

# Using the Engineering Harness

This harness gives you a small set of disciplined workflows. They exist because the failure modes of
coding agents are predictable: building before understanding, writing tests after the code, claiming
success without proof, guessing at bugs, and leaving docs and tests behind the code.

## The workflow

```
request ──► contract-first ──► outside-in-tdd ──► verify-before-done ──► drift-sync
                (what?)            (build it)         (prove it)         (reconcile)

bug or failing test ──► root-cause-debugging ──► (fix goes through outside-in-tdd)
```

| Situation | Skill |
| --- | --- |
| Someone wants a feature, behaviour change, or removal | `contract-first` |
| Implementing behaviour, writing tests, fixing a failing test | `outside-in-tdd` |
| Anything is broken, flaky, or failing for an unclear reason | `root-cause-debugging` |
| You are about to say "done", "fixed", "passing", or "ready" | `verify-before-done` |
| A change is complete, or docs/tests/code may disagree | `drift-sync` |

## How to apply it

1. **Check for a matching skill before acting.** If there is even a modest chance one applies, load it and follow it.
2. **Match ceremony to size.** A one-line typo fix does not need a written contract. It still needs
   `verify-before-done`. When you skip a step, say so in one sentence.
3. **Instructions win in this order:** the user's direct requests, then project files such as
   `CLAUDE.md` or `AGENTS.md`, then these skills, then your defaults. If the user says to skip a step, skip it.
4. **Never invent a skill's content from memory.** Load the skill and read it; skills change.

## Thoughts that mean stop and load a skill

| If you think... | The reality |
| --- | --- |
| "This is too simple for a contract." | Simple changes still hide assumptions. Write two lines in chat. |
| "I'll add tests once it works." | Tests written after code only confirm what the code does. Use `outside-in-tdd`. |
| "I know what's wrong, I'll just try a fix." | A guess is not a diagnosis. Use `root-cause-debugging`. |
| "That should pass now." | "Should" is not evidence. Use `verify-before-done`. |
| "The docs can wait." | Drift compounds. Use `drift-sync` before you finish. |
