# moonbitlings

Rustlings-style, offline, exercise-driven practice for the
[MoonBit](https://www.moonbitlang.com/) programming language.

moonbitlings presents a fixed sequence of small exercises. Each exercise is a
fill-in-the-blank MoonBit source file with a test (or an expected compiler
error). You fix the code until `moon check`/`moon test` passes, then move on.
The CLI provides `watch`, `verify`, `list`, `run`, and `hint` commands and
tracks progress in a local state file.

> Status: planning / pre-release. The repository currently contains the design
> and roadmap only; there is no runnable tool yet.

## Why

MoonBit ships excellent docs, a browser language tour, and course materials, but
the ecosystem lacks a local, exercise-driven companion like Rustlings. Existing
course exercise repositories are plain test suites without an interactive CLI,
hints, or progress tracking, and Exercism has no MoonBit track. moonbitlings
aims to fill that gap.

## Planned features

- A progressive curriculum: expressions, functions, control flow, structs,
  enums, pattern matching, traits/interfaces, generics, error handling, testing.
- Reuses the official `moon`/`moonc` toolchain as the verifier — no compiler fork.
- `watch` mode that re-runs the current exercise on file changes.
- `hint` for graded hints and `list` for progress.
- Deterministic, offline operation; no network required.

## Design principles

- The verifier is the official toolchain; moonbitlings only orchestrates,
  renders, and interprets results.
- Exercise metadata is simple, versioned JSON; no new DSL.
- Progress lives in a separate local state file, never in exercise sources.
- Stable exercise IDs and ordering; missing or duplicate exercises fail loudly.

## Non-goals

moonbitlings does not reimplement the MoonBit compiler, bundle or replace the
official toolchain, manage packages or credentials, or claim that completing the
exercises proves language mastery. It is an independent community tool and is
not affiliated with the MoonBit team or with Rustlings.

## License

Apache-2.0 (to be added with the first code release).
