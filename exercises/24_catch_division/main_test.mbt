///|
test "returns a successful quotient unchanged" {
  assert_eq(divide_or(12, 3, 99), 4)
}

///|
test "uses the fallback for a zero divisor" {
  assert_eq(divide_or(12, 0, 99), 99)
}

///|
test "uses zero as an ordinary fallback" {
  assert_eq(divide_or(12, 0, 0), 0)
}

///|
test "supports a negative divisor" {
  assert_eq(divide_or(12, -3, 99), -4)
}
