{% include nav.html %}

# Usage

## The learning loop

1. Run `moonbitlings` (or `moon run cmd/moonbitlings --`) to enter watch;
2. watch shows the current exercise, source path, status, and overall progress;
3. Edit `exercises/<id>/main.mbt` in your editor and save it;
4. moonbitlings re-verifies automatically and shows the compile or test output;
5. Once it passes, press `n` to move to the next pending exercise; if you get stuck,
   press `h` for a hint.

Each exercise is an independent MoonBit module: `check` exercises only require passing
`moon check`, and `test` exercises require all tests in `main_test.mbt` to pass.

## Command overview

| Command | Description |
| --- | --- |
| `list` | List all exercises and their status (`--pending` / `--done` filters). |
| `verify [id]` | Check or test an exercise; without an ID, selects the next pending exercise. |
| `hint [id]` | Show the hint and the location of the topic guide; without an ID, selects the next pending exercise. |
| `run [id]` | Run an executable exercise that defines `fn main`. |
| `reset [id]` | Mark an exercise pending without modifying its source. |
| `check-all` | Verify every exercise; exit code is non-zero if any are still pending. |
| `watch [id] [--no-editor]` | Start an interactive session, optionally at a starting exercise. |

Exit codes: `0` passed or succeeded, `1` still failing, `2` usage, manifest, state, or
input error. See the [CLI reference](cli-reference.md) for full details.

## Hints and reference answers

- In watch, press `h`, or run `hint <id>`, to see the hint for the current exercise;
- Each exercise corresponds to a topic guide in `guides/`, and `hint` also gives its
  location;
- After an exercise passes, the reference answer is written to
  `solutions/<id>/main.mbt` in the workspace, so you can compare another approach;
- `reset` only resets progress; it does not delete reference answers that have already
  been generated and does not overwrite your source.

## Saving progress

Progress is stored in `.moonbitlings-state.json` at the workspace root:

```json
{ "version": 2, "done": ["01_hello", "02_add"], "current": "03_sum_to" }
```

It is separate from exercise sources: deleting the file only resets progress and the
current selection, without touching your code; a corrupt file or an unsupported version
reports an explicit error instead of silently skipping. See
[Project internals](project.md) for details.

## Going deeper

- [Watch mode](watch-mode.md): single-key controls and the interactive exercise list;
- [CLI reference](cli-reference.md): all commands, arguments, and exit codes;
- [FAQ](faq.md): toolchain, platforms, and troubleshooting.
