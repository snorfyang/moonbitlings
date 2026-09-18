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

EXE="_build/native/debug/build/cmd/moonbitlings/moonbitlings.exe"
if [[ ! -x "$EXE" ]]; then
  echo "error: built executable not found at $EXE" >&2
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
expect "hint prints a hint" 0 --contains "Replace the string" -- hint 01_hello
expect "--help prints usage" 0 --contains "usage:" -- --help
expect "verify a broken check exercise" 1 -- verify 01_hello
expect "verify a broken test exercise" 1 -- verify 02_add
expect "verify an unknown exercise" 2 --contains "unknown exercise" -- verify nope
expect "an unknown command" 2 -- bogus
expect "verify without an id" 2 -- verify

# Pass path: fix an exercise, verify it passes, then restore the broken source
# and the clean state on exit.
cp exercises/01_hello/main.mbt /tmp/moonbitlings-01-main.mbt.bak
trap 'mv /tmp/moonbitlings-01-main.mbt.bak exercises/01_hello/main.mbt; rm -f .moonbitlings-state.json' EXIT

printf '///\npub fn answer() -> Int {\n  42\n}\n' > exercises/01_hello/main.mbt
expect "verify a fixed exercise passes" 0 --contains "passed" -- verify 01_hello
expect "list marks the fixed exercise done" 0 --contains "[done] 01_hello" -- list

if [[ "$fail" -eq 0 ]]; then
  echo "all CLI blackbox checks passed"
else
  echo "$fail CLI blackbox check(s) failed"
  exit 1
fi
