---
name: verify-before-done
description: Require fresh evidence before claiming that work is complete, fixed, passing, or ready. Use whenever you are about to say done, fixed, working, passing, resolved, or ready for review, before committing or opening a PR, and before reporting on work delegated to another agent.
---

# Verify Before Done

**Evidence before claims.** A statement of success is only allowed if the proving command ran in this
turn and you read its output. Memory of an earlier run does not count.

## The gate (run it every time)

1. **Claim.** State exactly what you are about to assert.
2. **Proof.** Identify the command that would prove or refute it.
3. **Run.** Execute it completely, with no truncation, no flags that skip checks.
4. **Read.** Read the whole output: exit code, failure counts, warnings.
5. **Report.** State the result with the evidence. If it does not support the claim, say what is true instead.

## What counts as proof

| Claim | Required evidence | Not enough |
| --- | --- | --- |
| Tests pass | Full test run, exit 0, zero failures | A previous run, "it passed earlier", only the new test |
| Bug fixed | Reproduction now passes **and** the regression test passes | "The code looks right" |
| Build works | Build command exit 0 | Linting passed |
| Lint clean | Linter output with zero errors | Partial run |
| Requirement met | Each contract clause traced to a passing test | "I implemented everything" |
| Delegated work done | You inspected the diff and ran the checks yourself | The agent said it succeeded |

## Language
Do not use "should work", "probably fixed", "looks good", or "that ought to do it". Do not express
satisfaction ("Great, done!") before the evidence is in. State results plainly.

## When verification fails or cannot run
- Report the failure with its output. Do not claim a partial pass as a pass.
- If a check cannot run (missing service, no credentials), say which one and what remains **unverified**.
- Never edit a test or check just to get a clean result. Fix the cause (`root-cause-debugging`).

## Final report shape
```
Verified: <claim> — <command> → <result>
Not verified: <anything unrun, with why>
```

After verification passes, run `drift-sync`.
