///|
test "finds a score" {
  assert_eq(score_lookup([("Ada", 9), ("Lin", 7)], "Lin"), Some(7))
}

///|
test "returns none for a missing name" {
  assert_eq(score_lookup([("Ada", 9)], "Kay"), None)
}

///|
test "uses the last score for a repeated name" {
  assert_eq(score_lookup([("Ada", 4), ("Ada", 9)], "Ada"), Some(9))
}
