# Project internals

[Documentation home](index.md) | [简体中文](../project.md)

## Verification and metadata

moonbitlings uses the official MoonBit toolchain as its verifier. It runs
`moon check` for `check` exercises or `moon test` for `test` exercises in each
exercise's module directory. It does not fork or reimplement the compiler.

Exercise metadata is stored as versioned, human-editable JSON in
`exercises/manifest.json`.

## Progress state

Progress is stored separately from exercise sources in
`.moonbitlings-state.json` at the repository root:

```json
{ "version": 2, "done": ["01_hello", "02_add"], "current": "03_sum_to" }
```

The `version` field guards the format. Corrupt files and unsupported versions
are reported explicitly. Version 1 files remain readable and gain `current`
when watch next saves them. Deleting the state file resets progress and the
current selection without affecting exercise sources.

## Repository layout

```text
moon.mod                  module definition
manifest.mbt              exercise manifest model and JSON parsing
verifier.mbt              toolchain driver and result rendering
state.mbt                 progress state and list rendering
cmd/moonbitlings/         CLI executable
exercises/                exercise modules and manifest.json
guides/                  short topic notes
templates/solutions/      reference answers copied after passing
solutions/                generated answers (local only)
test_fixtures/            passing and failing fixtures used by tests
```

## Design decisions

- **The toolchain stays behind a narrow interface.** The CLI only needs "run this
  `moon` subcommand in this directory and report the exit code", so tests drive
  real fixtures and the tool contains no compiler knowledge it would have to
  maintain.
- **Only exit code `0` is a pass.** Observed codes differ by command (`moon check`
  can fail with 255, `moon test` with 2), so the rule is deliberately coarse:
  diagnostics are shown, never parsed to manufacture a verdict. Ambiguous output
  is reported as failing or unknown.
- **Metadata is versioned JSON, not a DSL.** Contributors edit plain data, and the
  manifest schema stays small enough to review by eye.
- **Every exercise is its own module.** A deliberately broken starter cannot break
  the main package or CI, and verifying one exercise never builds the others.
- **Exercise ids and order are stable.** Renaming or reordering would invalidate
  saved learner progress, so new exercises are appended.
- **Progress lives in one local, versioned file**, separate from exercise sources;
  deleting it only resets progress and the current selection.
- **Non-interactive output is deterministic and ANSI-free.** That is why colour is
  intentionally not implemented; interactivity is detected from the terminal, and
  scripts always get byte-stable output.
- **Reference answers are revealed after passing** rather than shipped in the
  starter, so the learner attempts the exercise first and can still compare
  approaches afterwards.

## Related project

moonbitlings complements the official
[moonbit/MPI-exercise](https://github.com/moonbit/MPI-exercise) course rather
than duplicating it. That project provides plain `moon test` suites;
moonbitlings adds an interactive CLI, hints, and progress tracking. All
moonbitlings exercises are original.

The information hierarchy of interactive watch mode is informed by public UX
conventions from [Rustlings](https://github.com/rust-lang/rustlings), including
its progress bar, current-file display, single-key prompt, topic notes,
and post-completion answer path. The
implementation and wording are original; no Rustlings source or exercise
content is copied. Rustlings is MIT-licensed.

## Development

Run the complete check suite before committing a release:

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

The curriculum check verifies that each reset template matches its starter,
unfinished starters fail, and reference solutions pass in temporary copies.
The package check rejects files outside the tracked public set. The bundle
check builds a native CLI and exercises watch, verification, and reset from a
fresh workspace.

## Publishing the documentation site

`.github/workflows/pages.yml` builds and deploys GitHub Pages with Jekyll when
content under `docs/` changes on `main`. It can also be run manually from the
Actions tab. Before the first deployment, set Settings → Pages → Source to
GitHub Actions. The site root is Chinese by default; English documentation is
available under `/en/`.

To release, run these checks, bump `version` in `moon.mod`, then create and push
the release tag to the configured remote. Publishing a GitHub Release triggers
`.github/workflows/release.yml`, which builds native Linux and macOS bundles with
`scripts/build_bundle.py` and attaches them to the release.
