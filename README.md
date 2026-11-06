# Engineering Harness

A small set of skills that make coding agents work the way a careful engineer does: agree the behaviour
first, build it test-first from the outside in, find root causes instead of guessing, prove claims with
evidence, and keep contracts, tests, code and docs from drifting apart.

It is designed for [Claude Code](https://claude.com/claude-code) as a plugin. The skills are plain
`SKILL.md` folders, so you can also copy them into any agent that reads that format.

## Workflow

```
request ──► contract-first ──► outside-in-tdd ──► verify-before-done ──► drift-sync
                (what?)            (build it)         (prove it)         (reconcile)

bug or failing test ──► root-cause-debugging ──► (fix goes through outside-in-tdd)
```

## Skills

| Skill | Use it when | What it enforces |
| --- | --- | --- |
| `using-engineering-harness` | Every session (loaded automatically by the hook) | Routing: which skill applies, and proportionate ceremony |
| `contract-first` | Someone asks for a feature, change, or removal | Observable-behaviour contract, approved before code |
| `outside-in-tdd` | Writing code or tests | One failing test at a time, from the consumer seam inward |
| `root-cause-debugging` | Something is broken or flaky | No fix without a known cause; stop after three failed hypotheses |
| `verify-before-done` | About to say "done" or "fixed" | Fresh evidence from a command run this turn |
| `drift-sync` | A change is finished, or docs may be stale | Report and resolve gaps between intent, contract, tests, code, docs |

## Install (Claude Code)

```text
/plugin marketplace add Mosin112/engineering-harness
/plugin install engineering-harness@engineering-harness
```

Restart the session. The `SessionStart` hook then loads the routing skill automatically. To check it works,
ask the agent to "add a bookmark endpoint": it should start by clarifying behaviour and drafting a contract,
not by writing code.

### Without the plugin system

Copy the skill folders you want into your project or user skills directory, for example:

```sh
cp -r skills/* ~/.claude/skills/        # all projects
cp -r skills/* .claude/skills/          # this project only
```

You lose the automatic `SessionStart` bootstrap, so mention the skills in `CLAUDE.md` or `AGENTS.md`.

## How the contract format works

Contracts live in `contracts/` in the consuming project and describe only observable behaviour, one clause per line, nested by cause:

```
when a bookmark submission arrives
  while the requester is authenticated
    if the submitted URL is valid
      then the bookmark is stored and returned
    if the submitted URL is invalid
      then the submission is rejected and nothing is stored
```

A full example is in `skills/contract-first/references/example.md`.

## Repository layout

```
.claude-plugin/     plugin.json and marketplace.json
hooks/              SessionStart hook that injects the bootstrap skill
skills/             one folder per skill, each with a SKILL.md
scripts/            personalize.sh (fills in your name and GitHub username)
tests/validate.sh   structural checks, also run in CI
```

## Develop

```sh
bash tests/validate.sh
```

This checks manifest JSON, skill frontmatter (name matches folder, description present and under 1024
characters, body under 500 lines), that the bootstrap skill routes to every other skill, that referenced
files exist, and that the hook emits the expected context.

To add a skill: create `skills/<kebab-name>/SKILL.md` with `name` and `description` frontmatter, add it to
the table in `skills/using-engineering-harness/SKILL.md`, and run the validation. Write the description as
the trigger: say what the skill does **and** the situations that should load it.

## Publish to your GitHub

```sh
bash scripts/personalize.sh <your-github-username> "<Your Name>"
git init -b main
git add .
git commit -m "feat: initial engineering harness"
gh repo create engineering-harness --public --source=. --push
```

Without the GitHub CLI, create an empty repository named `engineering-harness` on GitHub, then:

```sh
git remote add origin git@github.com:<your-github-username>/engineering-harness.git
git push -u origin main
```

## Credits

The harness is an original work that draws on ideas from two projects: the
[Superpowers](https://github.com/obra/superpowers) methodology (MIT licensed), for the gated workflow,
test-first discipline and evidence-over-claims stance; and the behaviour-contract idea of
test trees as living requirements. No text or code is copied from either.

## License

MIT. See [LICENSE](LICENSE).
