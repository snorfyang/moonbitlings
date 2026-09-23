///|
test "finds the first even number" {
  assert_eq(first_even([1, 4, 2]), Some(4))
}

///|
test "returns none when no number is even" {
  assert_eq(first_even([1, 3, 5]), None)
}

///|
test "returns none for an empty array" {
  assert_eq(first_even([]), None)
}

///|
test "accepts zero and negative even numbers" {
  assert_eq(first_even([1, 0, 2]), Some(0))
  assert_eq(first_even([-3, -4, 2]), Some(-4))
}
