///|
test "kind_command maps kinds to moon subcommands" {
  assert_eq(kind_command(Check), "check")
  assert_eq(kind_command(Test), "test")
  assert_eq(kind_command(Run), "run")
}

///|
test "passed is true only for exit code zero" {
  assert_true(passed({ exit_code: 0, stdout: "", stderr: "", }))
  assert_false(passed({ exit_code: 1, stdout: "", stderr: "", }))
  assert_false(passed({ exit_code: 255, stdout: "", stderr: "", }))
}

///|
test "render_verify_result reports success" {
  let exercise : Exercise = {
    id: "01_hello",
    title: "Hello",
    hint: "h",
    kind: Check,
  }
  let rendered = render_verify_result(exercise, {
    exit_code: 0,
    stdout: "",
    stderr: "",
  })
  assert_true(rendered.contains("01_hello"))
  assert_true(rendered.contains("passed"))
}

///|
test "render_verify_result shows diagnostics on failure" {
  let exercise : Exercise = {
    id: "01_hello",
    title: "Hello",
    hint: "h",
    kind: Check,
  }
  let rendered = render_verify_result(exercise, {
    exit_code: 255,
    stdout: "",
    stderr: "boom",
  })
  assert_true(rendered.contains("still failing"))
  assert_true(rendered.contains("boom"))
}

///|
test "render_run_result preserves program output" {
  let exercise : Exercise = {
    id: "03_main",
    title: "Main",
    hint: "h",
    kind: Run,
  }
  let rendered = render_run_result(exercise, {
    exit_code: 0,
    stdout: "hello\n",
    stderr: "",
  })
  assert_eq(rendered, "hello\n")
}

///|
test "render_run_result reports a failed run" {
  let exercise : Exercise = {
    id: "03_main",
    title: "Main",
    hint: "h",
    kind: Run,
  }
  let rendered = render_run_result(exercise, {
    exit_code: 2,
    stdout: "",
    stderr: "boom\n",
  })
  assert_true(rendered.contains("03_main"))
  assert_true(rendered.contains("exit 2"))
  assert_true(rendered.contains("boom"))
}

///|
async test "run_moon passes on a clean fixture" {
  let result = run_moon(Test, "test_fixtures/pass")
  if !passed(result) {
    fail(
      "expected pass, got exit \{result.exit_code}\n\{result.stdout}\{result.stderr}",
    )
  }
}

///|
async test "run_moon fails on a broken fixture" {
  let result = run_moon(Test, "test_fixtures/fail")
  if passed(result) {
    fail("expected failure, but the fixture passed")
  }
}

///|
async test "run_moon runs a main fixture" {
  let result = run_moon(Run, "test_fixtures/run")
  if !passed(result) {
    fail(
      "expected run to pass, got exit \{result.exit_code}\n\{result.stdout}\{result.stderr}",
    )
  }
  assert_true(result.stdout.contains("fixture ran"))
}
