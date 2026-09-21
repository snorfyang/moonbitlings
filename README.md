# moonbitlings

Rustlings-style, offline, exercise-driven practice for the
[MoonBit](https://www.moonbitlang.com/) programming language.

moonbitlings presents a fixed sequence of small exercises. Each exercise is a
standalone MoonBit module with a fill-in-the-blank source file plus a test (or
an expected compile error). You fix the code until `moon check`/`moon test`
passes, then move on. The CLI provides `list`, `verify`, `hint`, `run`, `reset`,
`check-all`, and `watch` commands and tracks progress in a local state file.

> Status: working prototype. The CLI and a 12-exercise curriculum run end to
> end; the curriculum will keep growing.

## Usage

Prerequisites: a MoonBit toolchain with `moon` on your `PATH`.

```bash
git clone <this repository> && cd moonbitlings

moon run cmd/moonbitlings --                      # start the interactive watch session
moon run cmd/moonbitlings -- list                 # show all exercises and status
moon run cmd/moonbitlings -- list --pending       # show pending exercises only
moon run cmd/moonbitlings -- list --done          # show completed exercises only
moon run cmd/moonbitlings -- hint 01_hello        # print a hint for an exercise
moon run cmd/moonbitlings -- verify 01_hello      # run one exercise's check/test
moon run cmd/moonbitlings -- verify               # verify the next pending exercise
moon run cmd/moonbitlings -- run EXERCISE_ID       # run an executable exercise
moon run cmd/moonbitlings -- reset 01_hello       # reset one exercise's progress
moon run cmd/moonbitlings -- check-all            # verify every exercise
moon run cmd/moonbitlings -- watch                # explicitly start the watch session
moon run cmd/moonbitlings -- watch 02_add         # start at a specific exercise
```

Exit codes: `0` = the requested exercise(s) passed (or the command completed),
`1` = at least one requested exercise still fails, `2` = usage or input error.

Each exercise lives in `exercises/<id>/`. Edit its source, then re-run
`verify [id]`; without an ID, `verify` and `hint` select the next pending
exercise. `watch` re-verifies automatically when you save a source file.
`run [id]` invokes `moon run` for an executable exercise; `reset [id]` changes
only progress state and never overwrites exercise source files.

The watch session keeps the current exercise, source path, status, and progress
visible. Enter `h`, `r`, `n`, `l`, `c`, or `q` followed by Enter to show a hint,
recheck, move to the next exercise after success, list exercises, check all, or
quit. A passing exercise remains current until you enter `n`.

## How it works

- The verifier is the official toolchain. moonbitlings runs `moon check` (for
  `check` exercises) or `moon test` (for `test` exercises) in the exercise's
  own module directory — there is no compiler fork.
- `watch` polls the exercise's `main.mbt`/`main_test.mbt` modification times
  and re-verifies when a source file changes. Input and source changes are
  handled concurrently; closed standard input exits the session cleanly.
- Progress is stored in `.moonbitlings-state.json` at the repository root,
  separate from the exercise sources.
- Exercise metadata is versioned, human-editable JSON in
  `exercises/manifest.json`.

## Progress state

Progress is stored in `.moonbitlings-state.json` at the repository root:

```json
{ "version": 1, "done": ["01_hello", "02_add"] }
```

The `version` field guards the format. A corrupt file or an unsupported
version is reported as an error rather than guessed at. Progress is
reconstructible, so deleting the file simply resets progress — the exercises
are unaffected.

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

- an interactive watch session when invoked without a command;
- `list [--pending|--done]`, `verify [id]`, `hint [id]`, `run [id]`,
  `reset [id]`, `check-all`, `watch [id]` commands;
- a progressive curriculum covering expressions, functions, loops, recursion,
  structs, enums, pattern matching, `Option`, error handling, generics, traits,
  higher-order functions, and array iteration;
- deterministic, offline operation — no network required;
- explicit errors for an unknown exercise, a malformed manifest, or a broken
  state file.

## Non-goals

moonbitlings does not reimplement the MoonBit compiler, bundle or replace the
official toolchain, manage packages or credentials, or claim that completing
the exercises proves language mastery. It is an independent community tool and
is not affiliated with the MoonBit team or with Rustlings.

## Related projects

moonbitlings complements the official
[moonbit/MPI-exercise](https://github.com/moonbit/MPI-exercise) course
exercises rather than duplicating them: those are plain `moon test` suites,
while moonbitlings adds the interactive CLI, hints, and progress tracking. All
moonbitlings exercises are original.

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

## Releasing

1. Run the full Development check suite.
2. Bump `version` in `moon.mod`.
3. Tag the release and push it to the configured remote.
