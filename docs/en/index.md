{% include nav.html %}

# moonbitlings

**A Rustlings-style offline interactive practice tool for the MoonBit ecosystem.**

[![CI](https://github.com/snorfyang/moonbitlings/actions/workflows/ci.yml/badge.svg)](https://github.com/snorfyang/moonbitlings/actions/workflows/ci.yml)
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](https://github.com/snorfyang/moonbitlings/blob/main/LICENSE)

moonbitlings presents a fixed sequence of small exercises. It shows one at a time;
you edit the printed source file and save it, and the **official `moon` toolchain**
decides whether it passes. Keep editing until it compiles and passes, then move on to
the next exercise. Exercises, hints, progress, and reference answers all live locally;
no network access is required, and the MoonBit compiler is never reimplemented or
replaced.

## Why this exists

The MoonBit team provides documentation, a browser-based interactive tour, and public
courses, but there is no hands-on practice tool in the style of Rustlings — local,
ordered, pass by fixing one mistake, with hints and progress. moonbitlings fills that
gap: the exercise content is the core of the product, and verification is handed
entirely to the official toolchain.

## Main features

- **Verification by the real toolchain**: `moon check` / `moon test` / `moon run`; the
  compiler, type checker, and build system are not rewritten;
- **A progressive, original curriculum**: 29 exercises, from expressions, functions,
  and control flow to generics, error handling, packages, and visibility;
- **Interactive watch**: saving re-verifies automatically, single-key controls, and an
  in-session exercise list;
- **Hints and topic introductions**: each exercise has a hint, and each topic has an
  accompanying guide;
- **Reference answers revealed after passing**: try it yourself first, then compare
  another approach;
- **Local progress**: a versioned state file, separate from exercise sources, that can
  be safely recreated;
- **Deterministic and offline**: no ANSI in non-interactive output; the same input
  produces byte-identical output.

## Quick start

Prerequisite: `moon` from the MoonBit toolchain on your `PATH` (macOS or Linux).

```bash
git clone https://github.com/snorfyang/moonbitlings
cd moonbitlings
moon run cmd/moonbitlings --
```

A bare command starts interactive watch. Edit the displayed exercise file and save it
to verify automatically; once the current exercise passes, press `n` to continue. To
put the exercises in a separate directory, see the local bundle in
[Setup](setup.md).

## Documentation map

| Page | Contents |
| --- | --- |
| [Setup](setup.md) | Prerequisites, two ways to get it, editor and terminal |
| [Usage](usage.md) | The learning loop, command overview, hints and reference answers, progress |
| [Watch mode](watch-mode.md) | Single-key controls, interactive exercise list, editor integration |
| [CLI reference](cli-reference.md) | All commands, arguments, and exit codes |
| [Exercises](exercises.md) | The 29 exercises indexed by topic |
| [FAQ](faq.md) | Toolchain, platforms, progress, and troubleshooting |
| [Contributing](contribute.md) | Local checks, adding exercises, compliance |
| [Project internals](project.md) | Verification, state, architecture, design decisions, and releases |

## Boundaries and disclaimers

moonbitlings is an interactive practice companion, not a MoonBit language specification
or an official tutorial, and it does not bundle or replace the official toolchain; it
is not affiliated with the MoonBit team or with Rustlings. Completing every exercise
only means these topics have been practiced, not that the language has been mastered.
The project is licensed under
[Apache-2.0](https://github.com/snorfyang/moonbitlings/blob/main/LICENSE).
