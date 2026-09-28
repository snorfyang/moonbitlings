///|
fn exercise(
  id : String,
  title : String,
  kind : @moonbitlings.ExerciseKind,
) -> @moonbitlings.Exercise {
  { id, title, hint: "hint for \{id}", kind, }
}

///|
test "parse a valid manifest" {
  let text =
    #|{"exercises":[{"id":"01_hello","title":"Hello","hint":"h","kind":"check"},{"id":"02_add","title":"Add","hint":"h2","kind":"test"},{"id":"03_main","title":"Main","hint":"h3","kind":"run"}]}
  let manifest = match @moonbitlings.parse_manifest(text) {
    Ok(manifest) => manifest
    Err(message) => fail(message)
  }
  assert_eq(manifest.exercises.length(), 3)
  assert_eq(manifest.exercises[0].id, "01_hello")
  assert_eq(manifest.exercises[0].title, "Hello")
  assert_eq(manifest.exercises[0].kind, Check)
  assert_eq(manifest.exercises[1].kind, Test)
  assert_eq(manifest.exercises[2].kind, Run)
}

///|
test "parse rejects invalid JSON" {
  assert_true(@moonbitlings.parse_manifest("not json") is Err(_))
}

///|
test "parse rejects a non-object root" {
  assert_true(@moonbitlings.parse_manifest("[1,2]") is Err(_))
}

///|
test "parse rejects a missing kind" {
  let text =
    #|{"exercises":[{"id":"a","title":"A","hint":"h"}]}
  assert_true(@moonbitlings.parse_manifest(text) is Err(_))
}

///|
test "parse rejects an unknown kind" {
  let text =
    #|{"exercises":[{"id":"a","title":"A","hint":"h","kind":"bogus"}]}
  assert_true(@moonbitlings.parse_manifest(text) is Err(_))
}

///|
test "find and index_of" {
  let exercises : Array[@moonbitlings.Exercise] = [
    exercise("a", "A", Check),
    exercise("b", "B", Test),
  ]
  let manifest : @moonbitlings.Manifest = { exercises, }
  match manifest.find("b") {
    Some(found) => assert_eq(found.id, "b")
    None => fail("expected to find exercise b")
  }
  assert_eq(manifest.index_of("a"), Some(0))
  assert_eq(manifest.index_of("zzz"), None)
}

///|
test "exercise_dir uses the id" {
  assert_eq(@moonbitlings.exercise_dir("01_hello"), "exercises/01_hello")
}
