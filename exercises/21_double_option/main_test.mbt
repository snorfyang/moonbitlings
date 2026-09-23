///|
test "doubles a present value" {
  assert_eq(double_option(Some(3)), Some(6))
}

///|
test "keeps zero" {
  assert_eq(double_option(Some(0)), Some(0))
}

///|
test "doubles a negative value" {
  assert_eq(double_option(Some(-4)), Some(-8))
}

///|
test "keeps none" {
  assert_eq(double_option(None), None)
}
