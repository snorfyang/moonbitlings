///|
test "counts even numbers" {
  assert_eq(count_even([1, 2, 3, 4]), 2)
}

///|
test "counts zero when there are none" {
  assert_eq(count_even([1, 3]), 0)
}
