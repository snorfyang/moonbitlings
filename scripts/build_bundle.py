#!/usr/bin/env python3
"""Build a local native bundle containing the CLI and public exercise assets."""

import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BUNDLE_README = """# moonbitlings local bundle

Requires the MoonBit `moon` toolchain on your PATH.

Create a fresh workspace:

```sh
./init.sh my-moonbitlings
cd my-moonbitlings
./moonbitlings
```

The initialized directory contains editable exercises, reset templates, and
local progress. Keep it to preserve your work. `init.sh` refuses to overwrite
an existing directory.
"""


def tracked_assets() -> list[Path]:
    result = subprocess.run(
        ["git", "ls-files", "-z", "exercises", "templates/exercises"],
        cwd=ROOT,
        capture_output=True,
        check=True,
    )
    return [Path(path) for path in result.stdout.decode().strip("\0").split("\0")]


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: python3 scripts/build_bundle.py OUTPUT_DIRECTORY", file=sys.stderr)
        return 2
    output = Path(sys.argv[1]).resolve()
    if output.exists():
        print(f"error: output already exists: {output}", file=sys.stderr)
        return 2
    output.parent.mkdir(parents=True, exist_ok=True)

    manifest = json.loads((ROOT / "exercises/manifest.json").read_text())
    ids = {item["id"] for item in manifest["exercises"]}
    expected = {Path("exercises/manifest.json")}
    expected.update(Path("exercises") / exercise_id / "main.mbt" for exercise_id in ids)
    expected.update(Path("templates/exercises") / exercise_id / "main.mbt" for exercise_id in ids)
    assets = []
    for path in tracked_assets():
        if path == Path("exercises/manifest.json"):
            assets.append(path)
        elif len(path.parts) >= 3 and path.parts[0] == "exercises" and path.parts[1] in ids:
            assets.append(path)
        elif len(path.parts) >= 4 and path.parts[:2] == ("templates", "exercises") and path.parts[2] in ids:
            assets.append(path)
    if not expected <= set(assets):
        print("error: exercise sources or reset templates are not tracked", file=sys.stderr)
        return 1

    build = subprocess.run(
        ["moon", "build", "cmd/moonbitlings", "--target", "native"],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    if build.returncode:
        print(build.stdout + build.stderr, file=sys.stderr)
        return 1
    candidates = [
        ROOT / "_build/native/debug/build/cmd/moonbitlings/moonbitlings.exe",
        ROOT / "_build/native/debug/build/cmd/moonbitlings/moonbitlings",
    ]
    executable = next((candidate for candidate in candidates if candidate.is_file()), None)
    if executable is None:
        print("error: built native executable not found", file=sys.stderr)
        return 1

    with tempfile.TemporaryDirectory(prefix="moonbitlings-bundle-") as temporary:
        bundle = Path(temporary) / "bundle"
        bundle.mkdir()
        shutil.copy2(executable, bundle / "moonbitlings")
        shutil.copy2(ROOT / "scripts/init_bundle.sh", bundle / "init.sh")
        (bundle / "README.md").write_text(BUNDLE_README)
        for path in assets:
            destination = bundle / path
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(ROOT / path, destination)
        shutil.move(str(bundle), str(output))
    print(f"Built {output}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
