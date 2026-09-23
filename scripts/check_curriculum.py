#!/usr/bin/env python3
"""Check every exercise starter, reset template, and reference solution."""

import json
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
EXERCISES = ROOT / "exercises"
TEMPLATES = ROOT / "templates" / "exercises"
SOLUTIONS = ROOT / "test_fixtures" / "solutions"
INTRO = "00_intro"
ID_PATTERN = re.compile(r"[0-9]{2}_[a-z0-9_]+\Z")


def fail(message: str) -> None:
    raise ValueError(message)


def directories(path: Path) -> set[str]:
    return {
        entry.name
        for entry in path.iterdir()
        if entry.is_dir() and not entry.name.startswith("_")
    }


def check_layout() -> list[dict[str, str]]:
    manifest = json.loads((EXERCISES / "manifest.json").read_text())
    items = manifest["exercises"]
    ids = [item["id"] for item in items]
    if not ids or len(ids) != len(set(ids)):
        fail("manifest has no exercises or contains duplicate IDs")
    for item in items:
        exercise_id = item["id"]
        if not ID_PATTERN.fullmatch(exercise_id):
            fail(f"invalid exercise ID: {exercise_id}")
        if item["kind"] not in {"check", "test"}:
            fail(f"unsupported exercise kind for {exercise_id}: {item['kind']}")
    for label, actual, expected in (
        ("exercise", directories(EXERCISES), set(ids)),
        ("template", directories(TEMPLATES), set(ids)),
        ("solution", directories(SOLUTIONS), set(ids) - {INTRO}),
    ):
        if actual != expected:
            fail(
                f"{label} directories differ from manifest: "
                f"missing={sorted(expected - actual)}, extra={sorted(actual - expected)}"
            )
    for item in items:
        exercise_id = item["id"]
        exercise = EXERCISES / exercise_id
        for filename in ("main.mbt", "moon.mod", "moon.pkg"):
            if not (exercise / filename).is_file():
                fail(f"missing {exercise_id}/{filename}")
        source = (exercise / "main.mbt").read_bytes()
        template = TEMPLATES / exercise_id / "main.mbt"
        if not template.is_file() or source != template.read_bytes():
            fail(f"reset template differs from {exercise_id}/main.mbt")
        if item["kind"] == "test" and not any(
            "_build" not in path.parts for path in exercise.rglob("*_test.mbt")
        ):
            fail(f"missing test file for {exercise_id}")
        if exercise_id != INTRO:
            solution = SOLUTIONS / exercise_id / "main.mbt"
            if not solution.is_file():
                fail(f"missing reference solution for {exercise_id}")
            if source == solution.read_bytes():
                fail(f"reference solution matches unfinished starter for {exercise_id}")
    return items


def run_moon(module: Path, *args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["moon", *args], cwd=module, text=True, capture_output=True, check=False
    )


def require_success(exercise_id: str, phase: str, result: subprocess.CompletedProcess[str]) -> None:
    if result.returncode != 0:
        output = (result.stdout + result.stderr).strip()
        fail(f"{exercise_id}: {phase} failed (exit {result.returncode})\n{output}")


def check_exercise(item: dict[str, str]) -> None:
    exercise_id = item["id"]
    command = "check" if item["kind"] == "check" else "test"
    with tempfile.TemporaryDirectory(prefix=f"moonbitlings-{exercise_id}-") as temporary:
        module = Path(temporary) / exercise_id
        shutil.copytree(EXERCISES / exercise_id, module, ignore=shutil.ignore_patterns("_build"))
        starter = run_moon(module, command, "--deny-warn")
        if exercise_id == INTRO:
            require_success(exercise_id, "introduction", starter)
            return
        if starter.returncode == 0:
            fail(f"{exercise_id}: unfinished starter unexpectedly passed")
        shutil.copyfile(SOLUTIONS / exercise_id / "main.mbt", module / "main.mbt")
        require_success(
            exercise_id, "reference solution", run_moon(module, command, "--deny-warn")
        )


def main() -> int:
    try:
        items = check_layout()
        for item in items:
            check_exercise(item)
            print(f"ok: {item['id']}")
    except (OSError, KeyError, ValueError) as error:
        print(f"curriculum check failed: {error}", file=sys.stderr)
        return 1
    print(f"all {len(items)} exercises passed curriculum checks")
    return 0


if __name__ == "__main__":
    sys.exit(main())
