///|
test "kind_command maps kinds to moon subcommands" {
  assert_eq(kind_command(Check), "check")
  assert_eq(kind_command(Test), "test")
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
