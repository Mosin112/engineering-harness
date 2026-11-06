---
name: root-cause-debugging
description: Find the actual cause of a bug, test failure, flaky behaviour, or unexpected output before changing code. Use whenever something is broken, failing, flaky, slow for no clear reason, or a previous fix did not work, and especially when you are tempted to "just try" a change.
---

# Root-Cause Debugging

**No fix without a known cause.** Guess-and-patch cycles hide bugs, create new ones, and waste time.
Work through the phases in order. Skipping ahead is the failure this skill exists to prevent.

## Phase 1: Reproduce
- Read the full error: message, stack trace, exit code, logs. Do not skim.
- Find the smallest reliable reproduction. Record the exact command and input.
- If it is not reproducible, gather more data (logs, environment, timing). Do not guess a fix.
- Check what changed: recent commits, dependency updates, config, environment.

## Phase 2: Gather evidence
- Trace the bad value backwards: where did it come from, and who passed it in?
- In multi-component systems (API to service to database, CI to build to deploy), add temporary
  logging at **each boundary** to see where the data first goes wrong. Run once, read the evidence,
  then decide.
- Find a working example nearby and list every difference from the broken case.

## Phase 3: Hypothesise
- State one hypothesis: "The failure occurs because X, which would also mean Y."
- Test it with the smallest possible experiment that could **disprove** it. Change one variable at a time.
- If disproved, record what you learned and form the next hypothesis from the evidence. Do not stack changes.

## Phase 4: Fix at the root
1. Write a failing test that reproduces the bug (use `outside-in-tdd`).
2. Apply a single fix at the cause, not the symptom.
3. Run the new test and the full suite.
4. Remove temporary instrumentation.

## Phase 5: Close out
Run `verify-before-done`. In your report give: symptom, cause (with the evidence), fix, and the test that now guards it.

## Escalation rule
After **three failed hypotheses**, stop patching. Each failure that reveals a new problem somewhere else
is a sign the assumed design is wrong. Summarise what you have learned and discuss the structure with the user before trying more.

## Red flags
- "Quick fix now, investigate later."
- Changing several things at once to "see what sticks."
- Adding a retry, sleep, or null-check without knowing why it is needed.
- Proposing a fix before you can explain the failure in one sentence.
- Treating a flaky test as "just flaky". Flakiness has a cause (timing, shared state, ordering). Find it.
