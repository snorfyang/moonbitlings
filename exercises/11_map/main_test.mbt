///|
test "doubles every element" {
  assert_eq(map([1, 2, 3], fn(x) { x * 2 }), [2, 4, 6])
}

///|
test "negates every element" {
  assert_eq(map([1, -2], fn(x) { 0 - x }), [-1, 2])
}
