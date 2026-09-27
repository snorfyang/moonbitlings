#!/usr/bin/env python3
"""Exercise a native bundle in a fresh workspace."""

import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Optional


ROOT = Path(__file__).resolve().parents[1]


def run(
    args: list[str], cwd: Path, input_text: Optional[str] = None
) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        args, cwd=cwd, input=input_text, text=True, capture_output=True, timeout=30
    )


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> int:
    with tempfile.TemporaryDirectory(prefix="moonbitlings-bundle-test-") as temporary:
        parent = Path(temporary)
        bundle = parent / "bundle"
        workspace = parent / "workspace"
        built = run([sys.executable, str(ROOT / "scripts/build_bundle.py"), str(bundle)], ROOT)
        require(built.returncode == 0, f"bundle build failed: {built.stderr}")
        initialized = run([str(bundle / "init.sh"), str(workspace)], parent)
        require(initialized.returncode == 0, f"workspace init failed: {initialized.stderr}")
        require((workspace / "exercises/manifest.json").is_file(), "manifest missing")
        require(
            (workspace / "templates/exercises/28_public_struct/main.mbt").is_file(),
            "reset template missing",
        )
        require(not (workspace / "test_fixtures").exists(), "developer fixtures entered workspace")

        executable = str(workspace / "moonbitlings")
        watch = run([executable, "watch", "00_intro", "--no-editor"], workspace, "q\n")
        require(watch.returncode == 0 and "Current: 00_intro" in watch.stdout, "watch failed")

        starter = (workspace / "exercises/01_hello/main.mbt").read_bytes()
        shutil.copyfile(
            ROOT / "test_fixtures/solutions/01_hello/main.mbt",
            workspace / "exercises/01_hello/main.mbt",
        )
        verified = run([executable, "verify", "01_hello"], workspace)
        require(
            verified.returncode == 0 and "01_hello passed" in verified.stdout,
            "verification failed",
        )
        reset = run(
            [executable, "watch", "01_hello", "--no-editor"],
            workspace,
            "l\nr\ny\nq\nq\n",
        )
        require(reset.returncode == 0, "interactive reset failed")
        require(
            (workspace / "exercises/01_hello/main.mbt").read_bytes() == starter,
            "source was not restored",
        )

        repeated = run([str(bundle / "init.sh"), str(workspace)], parent)
        require(repeated.returncode != 0, "init overwrote an existing workspace")
    print("bundle initializes, watches, verifies, and resets in a fresh workspace")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (AssertionError, OSError, subprocess.TimeoutExpired) as error:
        print(f"bundle blackbox failed: {error}", file=sys.stderr)
        sys.exit(1)
