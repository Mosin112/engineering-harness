---
name: outside-in-tdd
description: Implement behaviour through outside-in red-green-refactor, one failing test at a time, starting from the consumer-facing seam. Use whenever writing code, writing tests, fixing a failing test, closing a gap against a contract, or fixing a bug (after root cause is known), even when the user only says "implement" or "just make it work".
---

# Outside-In TDD

Build from the consumer inward. Each new unit of code exists because a failing test demanded it.

## The loop (repeat per clause of the contract)

1. **RED.** Write one test at the outermost seam for one contract clause. Run it. Confirm it fails
   **for the expected reason** (missing behaviour, not a typo or import error). A test you never saw
   fail proves nothing.
2. **GREEN.** Write the smallest code that makes that test pass. Hard-coding is allowed if the next
   test will force generalisation. Run the test and the existing suite.
3. **REFACTOR.** Only when the code now shows duplication or branching that is genuinely awkward.
   Extract a unit when observed branching asks for it, not before. Keep all tests green.
4. **Commit** a green, coherent step with a message describing the behaviour gained.

Then pick the next clause. Failure paths are clauses too.

## Where tests live

| Kind | Scope | Dependencies |
| --- | --- | --- |
| Acceptance | One contract clause at the public seam | Real internals, fakes only for systems outside the project |
| Integration | A component with its real collaborators | External services faked |
| Unit | One unit behind the seam, added only when branching earns it | Collaborators replaced |

Prefer the highest-fidelity seam that runs fast enough to use in the loop. If a seam is unreachable
(no way to run the real thing), say so and document what is covered instead.

## Mocking policy
Replace only what you do not own or cannot run deterministically: network, clock, randomness,
third-party services. Do not mock the code under test or your own pure logic.

## Rules
- **Code before a test? Delete it and start from the test.** Keeping it "for reference" means you will adapt it instead of letting the test drive.
- One failing test at a time. Do not write a batch of tests and then implement.
- Do not weaken or delete a test to get green. If a test is wrong, say why and fix the test explicitly.
- Do not add behaviour no contract clause asked for.
- Bug fixes begin with a test that reproduces the bug, written after `root-cause-debugging` finds the cause.

## Quick self-check before moving on
- Did I watch this test fail for the right reason?
- Is this the least code that passes?
- Did I run the whole suite, not only the new test?
- Does every new line trace to a failing test?

## Excuses to reject
| Excuse | Response |
| --- | --- |
| "I'll write the tests after, same result." | After-the-fact tests describe the code; they do not specify behaviour. |
| "It's too small to test first." | Small code takes a minute to test. Do it. |
| "I need to see the design first." | The test is the first design step. Write the call you wish existed. |
| "Mocking everything is faster." | Over-mocked tests pass while the system is broken. Use real internals. |

When the contract is satisfied, continue to `verify-before-done`.
