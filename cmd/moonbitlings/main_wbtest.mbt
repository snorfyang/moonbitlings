///|
test "parse_command selects each command" {
  assert_true(parse_command(["moonbitlings", "list"]) is Ok(List(@lib.All)))
  assert_true(
    parse_command(["moonbitlings", "list", "--pending"])
    is Ok(List(@lib.Pending)),
  )
  assert_true(
    parse_command(["moonbitlings", "list", "--done"]) is Ok(List(@lib.Done)),
  )
  assert_true(
    parse_command(["moonbitlings", "verify", "01_hello"])
    is Ok(Verify(Some("01_hello"))),
  )
  assert_true(parse_command(["moonbitlings", "verify"]) is Ok(Verify(None)))
  assert_true(
    parse_command(["moonbitlings", "hint", "01_hello"])
    is Ok(Hint(Some("01_hello"))),
  )
  assert_true(parse_command(["moonbitlings", "hint"]) is Ok(Hint(None)))
  assert_true(
    parse_command(["moonbitlings", "run", "01_hello"])
    is Ok(Run(Some("01_hello"))),
  )
  assert_true(parse_command(["moonbitlings", "run"]) is Ok(Run(None)))
  assert_true(
    parse_command(["moonbitlings", "reset", "01_hello"])
    is Ok(Reset(Some("01_hello"))),
  )
  assert_true(parse_command(["moonbitlings", "reset"]) is Ok(Reset(None)))
  assert_true(parse_command(["moonbitlings", "check-all"]) is Ok(CheckAll))
  assert_true(
    parse_command(["moonbitlings", "watch"]) is Ok(Watch(None, false)),
  )
  assert_true(
    parse_command(["moonbitlings", "watch", "01_hello"])
    is Ok(Watch(Some("01_hello"), false)),
  )
  assert_true(
    parse_command(["moonbitlings", "watch", "--no-editor", "01_hello"])
    is Ok(Watch(Some("01_hello"), true)),
  )
  assert_true(
    parse_command(["moonbitlings", "--no-editor"]) is Ok(Watch(None, true)),
  )
  assert_true(parse_command(["moonbitlings", "--help"]) is Ok(Help))
  assert_true(parse_command(["moonbitlings"]) is Ok(Watch(None, false)))
}

///|
test "parse_command rejects malformed input" {
  assert_true(parse_command([]) is Err(_))
  assert_true(parse_command(["moonbitlings", "bogus"]) is Err(_))
  assert_true(parse_command(["moonbitlings", "list", "--bogus"]) is Err(_))
  assert_true(parse_command(["moonbitlings", "watch", "one", "two"]) is Err(_))
}

///|
test "build_editor_command expands the exercise path" {
  let path = "exercises/01_hello/main.mbt"
  let custom = build_editor_command(
    Some("code --reuse-window {file}"),
    false,
    path,
  )
  guard custom is Ok(Some(custom)) else { fail("expected custom command") }
  assert_eq(custom.program, "code")
  assert_eq(custom.arguments, ["--reuse-window", path])

  let appended = build_editor_command(Some("zed"), false, path)
  guard appended is Ok(Some(appended)) else { fail("expected editor command") }
  assert_eq(appended.arguments, [path])

  let vscode = build_editor_command(None, true, path)
  guard vscode is Ok(Some(vscode)) else { fail("expected VS Code command") }
  assert_eq(vscode.program, "code")
  assert_eq(vscode.arguments, ["--reuse-window", path])
  assert_true(build_editor_command(None, false, path) is Ok(None))
  assert_true(build_editor_command(Some("  "), false, path) is Err(_))
}

///|
test "parse_watch_action accepts session commands" {
  assert_true(parse_watch_action("h\n") is ShowHint)
  assert_true(parse_watch_action("recheck") is Recheck)
  assert_true(parse_watch_action("n") is Next)
  assert_true(parse_watch_action("list") is ShowList)
  assert_true(parse_watch_action("c") is CheckAllExercises)
  assert_true(parse_watch_action("q") is Quit)
  assert_true(parse_watch_action("\n") is IgnoreInput)
  assert_true(parse_watch_action("wat") is Unknown("wat"))
}

///|
test "parse_watch_list_action accepts navigation commands" {
  assert_true(parse_watch_list_action("k") is MoveUp)
  assert_true(parse_watch_list_action("down") is MoveDown)
  assert_true(parse_watch_list_action("\n") is Select)
  assert_true(parse_watch_list_action("c") is Select)
  assert_true(parse_watch_list_action("esc") is Back)
  assert_true(parse_watch_list_action("wat") is Ignore)
  assert_eq(move_list_selection(0, -1, 3), 2)
  assert_eq(move_list_selection(2, 1, 3), 0)
}

///|
test "next_pending_index advances and wraps" {
  let manifest : @lib.Manifest = {
    exercises: [
      { id: "a", title: "A", hint: "h", kind: @lib.Check, },
      { id: "b", title: "B", hint: "h", kind: @lib.Check, },
      { id: "c", title: "C", hint: "h", kind: @lib.Check, },
    ],
  }
  let state = @lib.State::empty().mark_done("b")
  assert_eq(next_pending_index(manifest, state, 1), Some(2))
  assert_eq(next_pending_index(manifest, state, 3), Some(0))
  let state = state.mark_done("a").mark_done("c")
  assert_eq(next_pending_index(manifest, state, 1), None)
}

///|
test "watch view shows progress current file and actions" {
  let manifest : @lib.Manifest = {
    exercises: [
      { id: "a", title: "First", hint: "h", kind: @lib.Check, },
      { id: "b", title: "Second", hint: "h", kind: @lib.Check, },
    ],
  }
  let state = @lib.State::empty().mark_done("a")
  let header = render_watch_header(manifest, state, 1, "failing")
  assert_true(header.contains("1/2 done"))
  assert_true(header.contains("b — Second"))
  assert_true(header.contains("exercises/b/main.mbt"))
  assert_true(header.contains("Status: failing"))
  assert_true(render_watch_prompt(false).contains("[h] hint"))
  assert_false(render_watch_prompt(false).contains("[n] next"))
  assert_true(render_watch_prompt(true).contains("[n] next"))
}

///|
test "watch list marks selection and resumes persisted current" {
  let manifest : @lib.Manifest = {
    exercises: [
      { id: "a", title: "First", hint: "h", kind: @lib.Check, },
      { id: "b", title: "Second", hint: "h", kind: @lib.Check, },
    ],
  }
  let state = @lib.State::empty().mark_done("a").with_current("b")
  let rendered = render_watch_list(manifest, state, 1)
  assert_true(rendered.contains("  [done] a - First"))
  assert_true(rendered.contains("> [pending] b - Second"))
  assert_eq(initial_watch_index(manifest, state), Some(1))
  let stale = state.with_current("missing")
  assert_eq(initial_watch_index(manifest, stale), Some(1))
}
