///|
test "adds two present values" {
  assert_eq(add_options(Some(2), Some(3)), Some(5))
}

///|
test "returns none when the right value is missing" {
  assert_eq(add_options(Some(2), None), None)
}

///|
test "returns none when the left value is missing" {
  assert_eq(add_options(None, Some(3)), None)
}

///|
test "returns none when both values are missing" {
  assert_eq(add_options(None, None), None)
}

///|
test "keeps zero as a present value" {
  assert_eq(add_options(Some(0), Some(3)), Some(3))
}
