{% include nav.html %}

# Watch mode

Watch mode keeps the current exercise, source path, verification status, and
overall progress visible. It also re-verifies the exercise when `main.mbt` or
`main_test.mbt` changes.

In an interactive Unix-like terminal, controls work without Enter:

| Key | Action |
| --- | --- |
| `h` | Show the current hint. |
| `r` | Recheck the current exercise. |
| `n` | Move to the next pending exercise after the current one passes. |
| `l` | Open the interactive exercise list. |
| `c` | Check all exercises. |
| `q` | Quit. |

Piped input and unsupported terminals fall back to line input. A passing
exercise remains current until you press `n`.

## Exercise list

Press `l` in watch mode, then use `j`/`k` or the arrow keys to move. Press `a`,
`p`, or `d` to show all, pending, or completed exercises. Press Enter or `c` to
continue at the selected exercise, and `q` or Escape to return. Press `r` and
confirm to overwrite the selected exercise's `main.mbt` with the original copy
shipped with the project and mark it pending. Cancelling leaves the source
unchanged. The selection is restored the next time watch starts.

## Editor integration

In an interactive VS Code terminal, watch opens the current source with
`code --reuse-window`. To use another editor, set `EDIT_CMD`:

```bash
EDIT_CMD="zed {file}" moon run cmd/moonbitlings --
```

`{file}` is replaced with the relative source path. If the placeholder is
absent, the path is appended. The command is split into space-separated
arguments and is not passed through a shell, so arguments containing spaces
are not supported.

The editor opens when watch starts, when `n` advances, and when an exercise is
selected from the list. Launch failures are warnings and do not stop watch.
Use `--no-editor` to disable this behavior. The printed relative `File:` path
can also be clicked in terminals that recognize file paths.

Raw terminal settings are restored on normal exit, errors, and cancellation.
