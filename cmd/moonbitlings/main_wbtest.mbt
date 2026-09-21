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
  assert_true(parse_command(["moonbitlings", "watch"]) is Ok(Watch(None)))
  assert_true(
    parse_command(["moonbitlings", "watch", "01_hello"])
    is Ok(Watch(Some("01_hello"))),
  )
  assert_true(parse_command(["moonbitlings", "--help"]) is Ok(Help))
  assert_true(parse_command(["moonbitlings"]) is Ok(Watch(None)))
}

///|
test "parse_command rejects malformed input" {
  assert_true(parse_command([]) is Err(_))
  assert_true(parse_command(["moonbitlings", "bogus"]) is Err(_))
  assert_true(parse_command(["moonbitlings", "list", "--bogus"]) is Err(_))
}

///|
test "parse_watch_action accepts session commands" {
  assert_true(parse_watch_action("h\n") is ShowHint)
  assert_true(parse_watch_action("recheck") is Recheck)
  assert_true(parse_watch_action("n") is Next)
  assert_true(parse_watch_action("list") is ShowList)
  assert_true(parse_watch_action("c") is CheckAllExercises)
  assert_true(parse_watch_action("q") is Quit)
  assert_true(parse_watch_action("wat") is Unknown("wat"))
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
