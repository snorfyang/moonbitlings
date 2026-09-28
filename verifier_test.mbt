///|
test "kind_command maps kinds to moon subcommands" {
  assert_eq(@moonbitlings.kind_command(Check), "check")
  assert_eq(@moonbitlings.kind_command(Test), "test")
  assert_eq(@moonbitlings.kind_command(Run), "run")
}

///|
test "passed is true only for exit code zero" {
  assert_true(@moonbitlings.passed({ exit_code: 0, stdout: "", stderr: "", }))
  assert_false(@moonbitlings.passed({ exit_code: 1, stdout: "", stderr: "", }))
  assert_false(
    @moonbitlings.passed({ exit_code: 255, stdout: "", stderr: "", }),
  )
}

///|
test "render_verify_result reports success" {
  let exercise : @moonbitlings.Exercise = {
    id: "01_hello",
    title: "Hello",
    hint: "h",
    kind: Check,
  }
  let rendered = @moonbitlings.render_verify_result(exercise, {
    exit_code: 0,
    stdout: "",
    stderr: "",
  })
  assert_true(rendered.contains("01_hello"))
  assert_true(rendered.contains("passed"))
}

///|
test "render_verify_result shows diagnostics on failure" {
  let exercise : @moonbitlings.Exercise = {
    id: "01_hello",
    title: "Hello",
    hint: "h",
    kind: Check,
  }
  let rendered = @moonbitlings.render_verify_result(exercise, {
    exit_code: 255,
    stdout: "",
    stderr: "boom",
  })
  assert_true(rendered.contains("still failing"))
  assert_true(rendered.contains("boom"))
}

///|
test "render_run_result preserves program output" {
  let exercise : @moonbitlings.Exercise = {
    id: "03_main",
    title: "Main",
    hint: "h",
    kind: Run,
  }
  let rendered = @moonbitlings.render_run_result(exercise, {
    exit_code: 0,
    stdout: "hello\n",
    stderr: "",
  })
  assert_eq(rendered, "hello\n")
}

///|
test "render_run_result reports a failed run" {
  let exercise : @moonbitlings.Exercise = {
    id: "03_main",
    title: "Main",
    hint: "h",
    kind: Run,
  }
  let rendered = @moonbitlings.render_run_result(exercise, {
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
  let result = @moonbitlings.run_moon(Test, "test_fixtures/pass")
  if !@moonbitlings.passed(result) {
    fail(
      "expected pass, got exit \{result.exit_code}\n\{result.stdout}\{result.stderr}",
    )
  }
}

///|
async test "run_moon fails on a broken fixture" {
  let result = @moonbitlings.run_moon(Test, "test_fixtures/fail")
  if @moonbitlings.passed(result) {
    fail("expected failure, but the fixture passed")
  }
}

///|
async test "run_moon runs a main fixture" {
  let result = @moonbitlings.run_moon(Run, "test_fixtures/run")
  if !@moonbitlings.passed(result) {
    fail(
      "expected run to pass, got exit \{result.exit_code}\n\{result.stdout}\{result.stderr}",
    )
  }
  assert_true(result.stdout.contains("fixture ran"))
}
