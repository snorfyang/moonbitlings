{% include nav.html %}

# FAQ

## `moon` is not found, or the version is too old

moonbitlings reuses the official toolchain and neither bundles nor replaces it. Make
sure `moon` is on your `PATH`:

```bash
moon version
```

An old version lacks support for newer syntax; upgrade it following the official
instructions.

## The build fails with `registry dependency ... was not found`

The registry index is stale. Run once:

```bash
moon update
```

The CI and Release workflows also run this step automatically after setting up the
toolchain, because the index is cold in a fresh environment.

## Does Windows work?

Not yet. Interactive watch depends on terminal raw-mode helper code, which is currently
only verified on macOS and Linux.

## I broke an exercise's source. Can I restore it?

Yes. In the watch exercise list, press `r` and confirm; this overwrites the selected
exercise's `main.mbt` with the original copy shipped with the project and marks that
exercise pending. If you do not confirm, no files are changed. You can also find the
original copy in the local bundle at `templates/exercises/<id>/main.mbt`, or restore it
from a git checkout.

## I lost my progress, or I want to start over

Progress is in `.moonbitlings-state.json`. Deleting it only resets progress and the
current selection; it does not affect exercise sources. To redo only a few exercises,
use `reset <id>` or press `r` in the exercise list.

## `run` reports "has no executable program"

`run` only applies to executable exercises that define `fn main`; running `run` on a
`check` / `test` exercise reports this clearly and exits with code `2`. To check
exercises of that kind, use `verify <id>`.

## Does it use the network? Does it secretly modify my source?

It does not use the network; verification, hints, and progress are all handled locally
(the first compile of the CLI needs to download dependencies once). moonbitlings writes
only three kinds of files: the progress state file, the `solutions/<id>/main.mbt`
generated after passing, and exercise source you confirmed resetting in the watch list.

## Can I use it for my own curriculum?

Yes. The curriculum is described by `exercises/manifest.json`, and each exercise is an
independent module. See the steps in [Contributing](contribute.md); copy a manifest
and maintain your own exercise set.
