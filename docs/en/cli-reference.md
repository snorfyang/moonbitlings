# CLI reference

[Documentation home](index.md) | [简体中文](../cli-reference.md)

Commands are currently run from the repository root with:

```bash
moon run cmd/moonbitlings -- [COMMAND]
```

Omitting `COMMAND` starts the interactive watch session.

| Command | Description |
| --- | --- |
| `list` | Show every exercise and its status. |
| `list --pending` | Show pending exercises only. |
| `list --done` | Show completed exercises only. |
| `verify [id]` | Check or test an exercise; without an ID, select the next pending exercise. |
| `hint [id]` | Print a hint; without an ID, select the next pending exercise. |
| `run [id]` | Invoke `moon run` for an executable exercise. |
| `reset [id]` | Mark an exercise pending without changing its source. |
| `check-all` | Verify every exercise. |
| `watch [id]` | Start watch mode, optionally at a specific exercise. |
| `watch [id] --no-editor` | Start watch mode without opening an editor. |
| `--help` | Print command-line usage. |

Exit codes:

- `0`: the requested exercise passed, or the command completed successfully;
- `1`: at least one requested exercise still fails;
- `2`: usage, input, manifest, or state error.

`reset` changes only `.moonbitlings-state.json`; it never overwrites exercise
source files.

`hint` also points to the topic guides. A passing verification writes a reference
answer under `solutions/<id>/main.mbt` and prints its path. `reset` keeps any
answer already revealed.
