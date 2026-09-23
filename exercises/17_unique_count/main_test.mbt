///|
test "counts distinct numbers" {
  assert_eq(unique_count([2, 1, 2, 3, 1]), 3)
}

///|
test "counts an empty array" {
  assert_eq(unique_count([]), 0)
}

///|
test "counts a single repeated number once" {
  assert_eq(unique_count([4, 4, 4]), 1)
}
