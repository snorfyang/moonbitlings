# moonbitlings

[English](README.md) | [简体中文](README.zh-CN.md)

[![CI](https://github.com/snorfyang/moonbitlings/actions/workflows/ci.yml/badge.svg)](https://github.com/snorfyang/moonbitlings/actions/workflows/ci.yml)
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

Rustlings-style, offline, exercise-driven practice for the
[MoonBit](https://www.moonbitlang.com/) programming language.

moonbitlings gives you a fixed sequence of small MoonBit exercises. It shows one
exercise at a time, you edit the displayed file, save, and the **official `moon`
toolchain** verifies it. Fix the program until it compiles and passes, then move
on to the next exercise. Hints, per-exercise topic guides, progress tracking and
reference answers are included; nothing needs network access.

> Status: working prototype. A 29-exercise curriculum runs end to end, covering
> expressions and functions, control flow, recursion, structs, enums and pattern
> matching, `Option`, error handling, generics, traits, higher-order functions,
> arrays, strings and Unicode, hash maps and sets, and packages/visibility.

## Highlights

- Edit-save-verify loop driven by the real `moon` command, never a reimplemented
  compiler;
- single-key interactive watch session and an interactive exercise list;
- automatic re-verification when exercise sources change;
- hints, per-topic guides, and reference answers written after you pass;
- local, versioned progress state kept separate from the exercise sources;
- deterministic, fully offline: non-interactive output has no ANSI escapes and
  the same input produces byte-identical output;
- install-free source checkout, plus a bundle that initializes a standalone
  practice workspace anywhere.

## Quick start

Prerequisite: a MoonBit toolchain with `moon` on `PATH` (macOS or Linux).

From a source checkout:

```bash
git clone https://github.com/snorfyang/moonbitlings
cd moonbitlings
moon run cmd/moonbitlings --
```

The bare command starts an interactive watch session. Edit the printed exercise
file, save it, and moonbitlings verifies it automatically. Press `n` to continue
once the current exercise passes. Run `moon run cmd/moonbitlings -- --help` for
the command list.

To keep your work in a separate directory:

```bash
python3 scripts/build_bundle.py dist/moonbitlings-local
dist/moonbitlings-local/init.sh dist/my-exercises
cd dist/my-exercises
./moonbitlings
```

The bundle contains the native CLI, exercises, topic guides and reference-answer
templates. The initializer refuses to overwrite an existing workspace.

## Demo

The session below uses the initialized bundle; from a source checkout, replace
`moonbitlings` with `moon run cmd/moonbitlings --`.

```console
$ moonbitlings list --pending
[pending] 00_intro - Welcome: learn the workflow
[pending] 01_hello - Hello: fix the type error
[pending] 02_add - Add: make the test pass
[pending] 03_sum_to - Sum to n: a loop
...

$ moonbitlings hint 02_add
Hint for 02_add: Implement `add` so that `add(2, 3)` returns 5.
Guide: guides/README.md

$ moonbitlings verify 01_hello
✗ exercise 01_hello still failing (exit 255)
Error: [4014]
   ╭─[ …/exercises/01_hello/main.mbt:7:3 ]
   │   "hello"
   │   ───┬───
   │      ╰───── Expr Type Mismatch
        has type : String
        wanted   : Int

$ moonbitlings verify 01_hello      # after fixing main.mbt
✓ exercise 01_hello passed
Solution: solutions/01_hello/main.mbt
```

## Commands

| Command | Description |
| --- | --- |
| `list` | Show all exercises and their status (`--pending` / `--done` filter). |
| `verify [id]` | Check or test one exercise; without an id, the next pending one. |
| `hint [id]` | Show the hint and topic guide; without an id, the next pending one. |
| `run [id]` | Run an executable exercise with `moon run`. |
| `reset [id]` | Mark an exercise pending without touching its source. |
| `check-all` | Verify every exercise; exits non-zero while any remain pending. |
| `watch [id] [--no-editor]` | Start the interactive watch session. |

Bare `moonbitlings` starts `watch`. Exit codes: `0` passed/succeeded, `1` still
failing or pending, `2` usage, manifest, state or input error. See the
[CLI reference](docs/en/cli-reference.md) for details.

## Curriculum

Exercises are ordered, and ids/order are stable once published so learner
progress is never silently invalidated.

| Exercises | Topic | Guide |
| --- | --- | --- |
| 00 | Getting started | [getting-started.md](guides/getting-started.md) |
| 01–04 | Expressions and functions | [functions.md](guides/functions.md) |
| 05–06 | Structs, enums, and patterns | [data-types.md](guides/data-types.md) |
| 07–08, 20–25 | Missing values and errors | [options-and-errors.md](guides/options-and-errors.md) |
| 09–10 | Generics and traits | [generics-and-traits.md](guides/generics-and-traits.md) |
| 11–12 | Arrays and callbacks | [arrays.md](guides/arrays.md) |
| 13–15 | Strings and characters | [strings.md](guides/strings.md) |
| 16–18 | Maps and sets | [collections.md](guides/collections.md) |
| 19 | Review: activity summary | [review.md](guides/review.md) |
| 26–28 | Packages and visibility | [packages.md](guides/packages.md) |

The [learning path](guides/README.md) links every guide from one page.

## How it works

The project keeps verification, exercise metadata, progress state and CLI
rendering in separate layers:

- `manifest.mbt` — exercise catalog model, JSON parsing, stable ids and paths;
- `verifier.mbt` — a narrow `moon`/`moonc` driver and result interpretation;
- `state.mbt` — versioned progress state and list rendering;
- `cmd/moonbitlings/` — argument parsing, command dispatch, watch/list
  interaction, and editor integration.

Each exercise is its own MoonBit module, so a deliberately broken starter never
breaks the main package. Verification only treats exit code `0` as a pass;
ambiguous toolchain output is reported as failing or "unknown", never silently
accepted. See [project internals](docs/en/project.md) for details.

## Supported platforms

macOS and Linux are exercised by the test suite and CI. The native CLI uses a
terminal raw-mode helper, so Windows is not supported yet.

## Documentation

Read the [complete documentation](docs/en/index.md) for the learning workflow,
CLI reference, watch controls, editor setup, progress state, architecture and
development instructions. [中文文档](docs/index.md) is also available.

## Development

```bash
moon fmt --check
moon check --deny-warn
moon test --deny-warn
moon info
git diff --check
scripts/cli_blackbox.sh
python3 scripts/check_curriculum.py
python3 scripts/check_package.py
python3 scripts/bundle_blackbox.py
```

All of these run in CI on every push.

## Provenance and license

moonbitlings is an independent community tool. It is not affiliated with the
MoonBit team or with Rustlings, and completing its exercises is not a claim of
language mastery. Its interaction model follows the public UX conventions of
[Rustlings](https://github.com/rust-lang/rustlings) (MIT); no Rustlings source or
exercise content is copied, and all exercises here are original. See
[project internals](docs/en/project.md) for the full provenance note.

Licensed under [Apache-2.0](LICENSE).
