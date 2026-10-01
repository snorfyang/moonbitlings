{% include nav.html %}

# Contributing

Issues, fixes, and new exercises are welcome. Keep changes small and testable, and
consistent with the existing layering.

## Local checks

Run the full check suite before committing:

```bash
moon fmt --check
moon check --deny-warn
moon test --deny-warn
moon info
python3 scripts/gen_exercise_docs.py
git diff --check
scripts/cli_blackbox.sh
python3 scripts/check_curriculum.py
python3 scripts/check_package.py
python3 scripts/bundle_blackbox.py
```

Where:

- `cli_blackbox.sh` builds the native executable and runs process-level black-box tests
  (including a real PTY);
- `check_curriculum.py` verifies in temporary copies that unfinished exercises fail as
  expected and reference solutions must pass, both with `--deny-warn` enabled;
- `check_package.py` rejects files outside the published locations;
- `bundle_blackbox.py` rehearses bundle initialization, watch, passing, and reset in a
  fresh directory.

All of these checks run in CI.

## Adding an exercise

1. Create an independent module in `exercises/<id>/` (`moon.mod`, `moon.pkg`,
   `main.mbt`);
2. The starter source must fail as expected; write a temporary reference solution that
   makes it pass, then restore the starter source;
3. Append a stable ID to the **end** of `exercises/manifest.json`; do not insert or
   reorder;
4. Put a copy identical to the starter source in
   `templates/exercises/<id>/main.mbt`;
5. Put the reference solution in `templates/solutions/<id>/main.mbt`;
6. For exercises with tests, add `warnings = "-test_unqualified_package"` to
   `moon.pkg`;
7. Add a hint, add a topic guide if needed, and update public descriptions such as the
   exercise count;
8. Add focused tests and any necessary CLI black-box assertions;
9. Run the full checks, review the diff, then commit.

`check_curriculum.py` enforces consistency for steps 2, 4, and 5 above.

## Directory structure

```text
manifest.mbt / verifier.mbt / state.mbt   core library: manifest, toolchain, progress
cmd/moonbitlings/                          CLI and interactivity
exercises/                                 exercise modules and manifest.json
templates/exercises/                       original copies used for list reset
templates/solutions/                       reference answers revealed after passing
guides/                                    topic guides
scripts/                                   check and packaging scripts
```

See [Project internals](project.md) for the architecture and design trade-offs.

## Commits and compliance

- Stage only public product files directly related to the current task;
- Commit messages should describe product behavior, not internal process or personal
  environment;
- Exercises and code are original. Rustlings is only a reference for public
  interaction conventions (MIT); its source or exercises are not copied. Any new
  third-party content must first be checked for its license, and its source, license,
  and scope of adaptation recorded.
