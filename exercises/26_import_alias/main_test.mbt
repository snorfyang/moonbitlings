///|
test "doubles a positive value" {
  assert_eq(double_with_helper(7), 14)
}

///|
test "doubles zero and a negative value" {
  assert_eq(double_with_helper(0), 0)
  assert_eq(double_with_helper(-3), -6)
}
