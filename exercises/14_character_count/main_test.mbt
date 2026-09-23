///|
test "counts ASCII characters" {
  assert_eq(character_count("Moon"), 4)
}

///|
test "counts an emoji as one character" {
  assert_eq(character_count("A👋B"), 3)
}

///|
test "counts combining marks as separate code points" {
  assert_eq(character_count("é"), 2)
}

///|
test "counts an empty string" {
  assert_eq(character_count(""), 0)
}
