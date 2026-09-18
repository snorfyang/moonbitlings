# moonbitlings

Rustlings-style, offline, exercise-driven practice for the
[MoonBit](https://www.moonbitlang.com/) programming language.

moonbitlings presents a fixed sequence of small exercises. Each exercise is a
standalone MoonBit module with a fill-in-the-blank source file plus a test (or
an expected compile error). You fix the code until `moon check`/`moon test`
passes, then move on. The CLI provides `list`, `verify`, `hint`, and `watch`
commands and tracks progress in a local state file.

> Status: working prototype. The CLI and two exercises run end to end; the
> curriculum is intentionally tiny and will grow.

## Usage

Prerequisites: a MoonBit toolchain with `moon` on your `PATH`.

```bash
git clone <this repository> && cd moonbitlings

moon run cmd/moonbitlings -- list                 # show all exercises and status
moon run cmd/moonbitlings -- hint 01_hello        # print a hint for an exercise
moon run cmd/moonbitlings -- verify 01_hello      # run one exercise's check/test
moon run cmd/moonbitlings -- watch                # watch and advance through all
moon run cmd/moonbitlings -- watch 02_add         # watch one exercise
```

Exit codes: `0` = the exercise passed (or the command completed), `1` = the
exercise still fails, `2` = usage or input error.

Each exercise lives in `exercises/<id>/`. Edit its source, then re-run
`verify <id>`; `watch` re-verifies automatically when you save a source file.

## How it works

- The verifier is the official toolchain. moonbitlings runs `moon check` (for
  `check` exercises) or `moon test` (for `test` exercises) in the exercise's
  own module directory — there is no compiler fork.
- `watch` polls the exercise's `main.mbt`/`main_test.mbt` modification times
  and re-verifies only when a source file changes.
- Progress is stored in `.moonbitlings-state.json` at the repository root,
  separate from the exercise sources.
- Exercise metadata is versioned, human-editable JSON in
  `exercises/manifest.json`.

## Project layout

```
moon.mod                  module definition
manifest.mbt              exercise manifest model and JSON parsing
verifier.mbt              toolchain driver (moon) and result rendering
state.mbt                 progress state and list rendering
cmd/moonbitlings/         the CLI executable
exercises/                exercise modules + manifest.json
test_fixtures/            small passing/failing fixtures used by tests
```

## Features

- `list`, `verify <id>`, `hint <id>`, `watch [id]` commands;
- a progressive curriculum covering (so far) expressions and functions, with
  more language features to come;
- deterministic, offline operation — no network required;
- explicit errors for an unknown exercise, a malformed manifest, or a broken
  state file.

## Non-goals

moonbitlings does not reimplement the MoonBit compiler, bundle or replace the
official toolchain, manage packages or credentials, or claim that completing
the exercises proves language mastery. It is an independent community tool and
is not affiliated with the MoonBit team or with Rustlings.

## License

Apache-2.0.

## Development

```bash
moon fmt --check
moon check --deny-warn
moon test --deny-warn
moon info
git diff --check
scripts/cli_blackbox.sh   # process-level blackbox checks for the CLI
```
