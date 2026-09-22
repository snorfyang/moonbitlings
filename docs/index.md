# moonbitlings documentation

[English](index.md) | [简体中文](zh-CN/index.md)

## Getting started

Install the MoonBit toolchain and make sure `moon` is on your `PATH`, then run
moonbitlings from the repository root:

```bash
git clone <this repository>
cd moonbitlings
moon run cmd/moonbitlings --
```

Each exercise lives in `exercises/<id>/`. The watch session prints the current
source path. Edit that file and save it; moonbitlings re-verifies the exercise
automatically. Once it passes, press `n` to move to the next pending exercise.

## Manual

- [CLI reference](cli-reference.md): commands, arguments, and exit codes.
- [Watch mode](watch-mode.md): keyboard controls, exercise list, and editor
  integration.
- [Project internals](project.md): verification, progress state, repository
  layout, development checks, and release steps.

moonbitlings is an interactive practice companion, not a MoonBit language
specification or an official tutorial. It does not bundle or replace the
official toolchain.
