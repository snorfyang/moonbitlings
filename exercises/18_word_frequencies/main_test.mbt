///|
test "counts repeated words" {
  let counts = word_frequencies(["moon", "sun", "moon"])
  assert_eq(counts.get("moon"), Some(2))
  assert_eq(counts.get("sun"), Some(1))
}

///|
test "returns an empty map for empty input" {
  let counts = word_frequencies([])
  assert_eq(counts.length(), 0)
  assert_eq(counts.get("moon"), None)
}

///|
test "counts one word several times" {
  let counts = word_frequencies(["a", "a", "a"])
  assert_eq(counts.get("a"), Some(3))
  assert_eq(counts.length(), 1)
}
