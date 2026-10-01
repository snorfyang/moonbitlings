{% include nav.html %}

# Setup

## Prerequisites

- macOS or Linux (Windows is not supported yet);
- `moon` from the official MoonBit toolchain on your `PATH`;
- Python 3 (only needed to build the local bundle).

First confirm the toolchain is available:

```bash
moon version
```

## Option 1: source checkout

For people who want to follow updates or contribute:

```bash
git clone https://github.com/snorfyang/moonbitlings
cd moonbitlings
moon run cmd/moonbitlings --
```

The first run compiles the CLI and then enters watch. After that, run all commands from
the repository root, replacing `moonbitlings` with `moon run cmd/moonbitlings --`.

## Option 2: local bundle (recommended for learners)

The bundle packages the native command-line program, the exercises, the topic guides,
the reference answer templates, and an initialization script into a single directory,
then initializes a standalone workspace anywhere. Exercises and progress stay separate
from the repository:

```bash
git clone https://github.com/snorfyang/moonbitlings
cd moonbitlings
python3 scripts/build_bundle.py dist/moonbitlings-local
dist/moonbitlings-local/init.sh ~/moonbitlings-workspace
cd ~/moonbitlings-workspace
./moonbitlings
```

The initialization script refuses to overwrite an existing directory; progress and any
reference answers written after passing stay inside the workspace.

## Editor

In the VS Code integrated terminal, watch opens the current exercise with
`code --reuse-window`. For other editors, use `EDIT_CMD`:

```bash
EDIT_CMD="zed {file}" moon run cmd/moonbitlings --
```

`{file}` is replaced with the relative source path; if no placeholder is present, the
path is appended to the end of the command. You can also use `--no-editor` to disable
automatic opening. See [Watch mode](watch-mode.md) for details.

## Terminal

- Unix-like interactive terminals use raw mode, so single keys work without pressing
  Enter;
- Piped or non-TTY environments automatically fall back to line input and do not emit
  ANSI escapes, which is convenient for scripts and CI;
- Original terminal settings are restored whether you exit normally, hit an error, or
  cancel.

## About network access

moonbitlings itself does not use the network; verification, hints, and progress are all
handled locally. The first compile of the CLI needs to resolve and download the
`moonbitlang/async` dependency from the registry; if the index is stale, run
`moon update` to refresh it. After that, the exercises themselves depend only on the
standard library and work fully offline.

## Next steps

- [Usage](usage.md): the learning loop and command overview;
- [Exercises](exercises.md): the full exercise index;
- [FAQ](faq.md): toolchain, platforms, and troubleshooting.
