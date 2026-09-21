#!/usr/bin/env bash
# Process-level black-box test for the moonbitlings CLI.
#
# Builds the native executable and runs it as a real subprocess, asserting
# exit codes and output for the success, failure, and error paths.
#
# Usage: scripts/cli_blackbox.sh
set -euo pipefail

cd "$(dirname "$0")/.."

moon build cmd/moonbitlings --target native >/dev/null

# The native executable name carries a `.exe` suffix on some platforms and not
# on others; locate it rather than assuming one name.
EXE=""
for candidate in \
  _build/native/debug/build/cmd/moonbitlings/moonbitlings.exe \
  _build/native/debug/build/cmd/moonbitlings/moonbitlings; do
  if [[ -x "$candidate" ]]; then
    EXE="$candidate"
    break
  fi
done
if [[ -z "$EXE" ]]; then
  echo "error: built executable not found under _build/native/debug/build" >&2
  exit 1
fi

rm -f .moonbitlings-state.json

fail=0

# expect <desc> <expected_exit> [--contains <needle>] -- <args...>
expect() {
  local desc="$1"
  shift
  local expected="$1"
  shift
  local needle=""
  if [[ "${1:-}" == "--contains" ]]; then
    needle="$2"
    shift 2
  fi
  shift # consume "--"
  local out code
  set +e
  out="$("$EXE" "$@" 2>&1)"
  code=$?
  set -e
  if [[ "$code" -ne "$expected" ]]; then
    echo "FAIL: $desc — expected exit $expected, got $code"
    printf '%s\n' "$out" | sed 's/^/    /'
    fail=$((fail + 1))
    return
  fi
  if [[ -n "$needle" ]] && ! printf '%s' "$out" | grep -qF "$needle"; then
    echo "FAIL: $desc — output missing \"$needle\""
    printf '%s\n' "$out" | sed 's/^/    /'
    fail=$((fail + 1))
    return
  fi
  echo "ok: $desc"
}

expect "list shows both exercises pending" 0 --contains "[pending] 01_hello" -- list
expect "list filters pending exercises" 0 --contains "[pending] 01_hello" -- list --pending
expect "list accepts an empty done filter" 0 -- list --done
expect "hint prints a hint" 0 --contains "Replace the string" -- hint 01_hello
expect "--help prints usage" 0 --contains "usage:" -- --help
expect "verify a broken check exercise" 1 -- verify 01_hello
expect "verify a broken test exercise" 1 -- verify 02_add
expect "verify without an id checks the next exercise" 1 -- verify
expect "hint without an id shows the next exercise" 0 --contains "Hint for 01_hello" -- hint
expect "run rejects a non-main exercise" 1 --contains "failed to run" -- run 01_hello
expect "run without an id selects the next exercise" 1 --contains "failed to run" -- run
expect "reset without an id selects the next exercise" 0 --contains "already pending" -- reset
expect "check-all reports pending exercises" 1 --contains "pending; first pending: 01_hello" -- check-all
expect "verify an unknown exercise" 2 --contains "unknown exercise" -- verify nope
expect "run an unknown exercise" 2 --contains "unknown exercise" -- run nope
expect "reset an unknown exercise" 2 --contains "unknown exercise" -- reset nope
expect "list rejects an unknown option" 2 --contains "unknown list option" -- list --bogus
expect "an unknown command" 2 -- bogus

# Pass path: fix an exercise, verify it passes, then restore the broken source
# and the clean state on exit.
TMP_DIR="$(mktemp -d)"
cp exercises/01_hello/main.mbt "$TMP_DIR/main.mbt"
cp exercises/01_hello/moon.pkg "$TMP_DIR/moon.pkg"
cp exercises/manifest.json "$TMP_DIR/manifest.json"
trap 'cp "$TMP_DIR/main.mbt" exercises/01_hello/main.mbt; cp "$TMP_DIR/moon.pkg" exercises/01_hello/moon.pkg; cp "$TMP_DIR/manifest.json" exercises/manifest.json; rm -rf "$TMP_DIR"; rm -f .moonbitlings-state.json' EXIT

printf '///\npub fn answer() -> Int {\n  42\n}\n' > exercises/01_hello/main.mbt
expect "verify a fixed exercise passes" 0 --contains "passed" -- verify 01_hello
expect "list marks the fixed exercise done" 0 --contains "[done] 01_hello" -- list
expect "list filters done exercises" 0 --contains "[done] 01_hello" -- list --done
expect "reset marks an exercise pending" 0 --contains "01_hello reset" -- reset 01_hello
expect "list shows a reset exercise pending" 0 --contains "[pending] 01_hello" -- list

printf '///\nfn main {\n  println("exercise ran")\n}\n' > exercises/01_hello/main.mbt
printf '// Exercise 01_hello package.\npkgtype(kind: "executable")\n' > exercises/01_hello/moon.pkg
printf '{"exercises":[{"id":"01_hello","title":"Hello","hint":"hint","kind":"run"}]}\n' > exercises/manifest.json
expect "run executes a main exercise" 0 --contains "exercise ran" -- run 01_hello
expect "check-all exits zero when all exercises pass" 0 --contains "1/1 done" -- check-all
expect "verify without an id handles completion" 0 --contains "already done" -- verify
expect "hint without an id handles completion" 0 --contains "already done" -- hint
expect "reset without an id reopens the last exercise" 0 --contains "01_hello reset" -- reset
expect "list shows the reopened exercise pending" 0 --contains "[pending] 01_hello" -- list

if [[ "$fail" -eq 0 ]]; then
  echo "all CLI blackbox checks passed"
else
  echo "$fail CLI blackbox check(s) failed"
  exit 1
fi
