#!/usr/bin/env python3
"""Reject local or private files in the MoonBit package archive."""

import json
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    package = subprocess.run(
        ["moon", "package", "--list"], cwd=ROOT, capture_output=True, text=True
    )
    if package.returncode:
        print("moon package --list failed", file=sys.stderr)
        return 1

    tracked = subprocess.run(
        ["git", "ls-files", "-z"], cwd=ROOT, capture_output=True, check=True
    )
    public_files = set(tracked.stdout.decode().strip("\0").split("\0"))
    public_files.add(".moonignore")
    listed = {
        line
        for line in (package.stdout + package.stderr).splitlines()
        if not Path(line).is_absolute() and (ROOT / line).is_file()
    }
    unexpected = listed - public_files
    if unexpected:
        print(
            f"package includes {len(unexpected)} files outside the tracked public set",
            file=sys.stderr,
        )
        return 1
    if any(
        Path(path).suffix.lower() in {".local", ".private"}
        or "prompt" in Path(path).name.lower()
        for path in listed
    ):
        print("package includes a private working file", file=sys.stderr)
        return 1

    manifest = json.loads((ROOT / "exercises/manifest.json").read_text())
    required = {"exercises/manifest.json", "guides/README.md"}
    for item in manifest["exercises"]:
        exercise_id = item["id"]
        required.add(f"exercises/{exercise_id}/main.mbt")
        required.add(f"templates/exercises/{exercise_id}/main.mbt")
        if exercise_id != "00_intro":
            required.add(f"templates/solutions/{exercise_id}/main.mbt")
    if not required <= listed:
        print("package is missing learning assets", file=sys.stderr)
        return 1
    print(f"package contains {len(listed)} tracked public files")
    return 0


if __name__ == "__main__":
    sys.exit(main())
