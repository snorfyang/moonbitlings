///|
test "state starts empty" {
  let state = State::empty()
  assert_false(state.is_done("01_hello"))
}

///|
test "mark_done records an id and is idempotent" {
  let state = State::empty().mark_done("01_hello")
  assert_true(state.is_done("01_hello"))
  assert_false(state.is_done("02_add"))
  let again = state.mark_done("01_hello")
  assert_eq(again.done.length(), 1)
}

///|
test "parse_state reads done ids" {
  let text =
    #|{"version":1,"done":["01_hello","02_add"]}
  let state = match parse_state(text) {
    Ok(state) => state
    Err(message) => fail(message)
  }
  assert_true(state.is_done("01_hello"))
  assert_true(state.is_done("02_add"))
  assert_eq(state.done.length(), 2)
}

///|
test "parse_state rejects malformed shapes" {
  assert_true(parse_state("not json") is Err(_))
  assert_true(parse_state("{\"version\":1,\"done\":\"nope\"}") is Err(_))
  assert_true(parse_state("{\"version\":1,\"done\":[1,2]}") is Err(_))
  assert_true(parse_state("{}") is Err(_))
}

///|
test "parse_state rejects a missing or unsupported version" {
  assert_true(parse_state("{\"done\":[]}") is Err(_))
  assert_true(parse_state("{\"version\":2,\"done\":[]}") is Err(_))
  assert_true(parse_state("{\"version\":\"1\",\"done\":[]}") is Err(_))
}

///|
test "state round-trips through JSON" {
  let state = State::empty().mark_done("02_add").mark_done("01_hello")
  let text = state.to_json()
  assert_true(text.contains("\"version\":1"))
  let parsed = match parse_state(text) {
    Ok(parsed) => parsed
    Err(message) => fail(message)
  }
  assert_true(parsed.is_done("01_hello"))
  assert_true(parsed.is_done("02_add"))
}

///|
test "current_index skips done exercises" {
  let manifest = manifest_of(["a", "b", "c"])
  let state = State::empty()
  assert_eq(current_index(manifest, state), Some(0))
  let state = state.mark_done("a")
  assert_eq(current_index(manifest, state), Some(1))
  let state = state.mark_done("b").mark_done("c")
  assert_eq(current_index(manifest, state), None)
}

///|
test "render_list marks done exercises" {
  let manifest = manifest_of(["a", "b"])
  let state = State::empty().mark_done("a")
  let rendered = render_list(manifest, state)
  assert_true(rendered.contains("[done] a"))
  assert_true(rendered.contains("[pending] b"))
}

///|
test "render_hint names the exercise" {
  let exercise : Exercise = {
    id: "a",
    title: "A",
    hint: "do the thing",
    kind: Check,
  }
  let rendered = render_hint(exercise)
  assert_true(rendered.contains("a"))
  assert_true(rendered.contains("do the thing"))
}

///|
test "render_check_all_summary reports the first pending exercise" {
  let manifest = manifest_of(["a", "b", "c"])
  let state = State::empty().mark_done("a")
  assert_eq(
    render_check_all_summary(manifest, state),
    "1/3 done\n2/3 pending; first pending: b",
  )
}

///|
test "render_check_all_summary reports completion" {
  let manifest = manifest_of(["a", "b"])
  let state = State::empty().mark_done("a").mark_done("b")
  assert_eq(render_check_all_summary(manifest, state), "2/2 done\n0/2 pending")
}

///|
fn manifest_of(ids : Array[String]) -> Manifest {
  let exercises : Array[Exercise] = []
  for id in ids {
    exercises.push({ id, title: id, hint: "hint", kind: Check, })
  }
  { exercises, }
}
