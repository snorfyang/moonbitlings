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
test_fixtures/            passing and failing fixtures used by tests
```

## Related project

moonbitlings complements the official
[moonbit/MPI-exercise](https://github.com/moonbit/MPI-exercise) course rather
than duplicating it. That project provides plain `moon test` suites;
moonbitlings adds an interactive CLI, hints, and progress tracking. All
moonbitlings exercises are original.

The information hierarchy of interactive watch mode is informed by public UX
conventions from [Rustlings](https://github.com/rust-lang/rustlings), including
its progress bar, current-file display, and single-key prompt. The
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
```

The curriculum check verifies that each reset template matches its starter,
unfinished starters fail, and reference solutions pass in temporary copies.

## Publishing the documentation site

`.github/workflows/pages.yml` builds and deploys GitHub Pages with Jekyll when
content under `docs/` changes on `main`. It can also be run manually from the
Actions tab. Before the first deployment, set Settings → Pages → Source to
GitHub Actions. The site root is Chinese by default; English documentation is
available under `/en/`.

To release, run these checks, bump `version` in `moon.mod`, then create and push
the release tag to the configured remote.
