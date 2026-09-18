///|
test "normal division" {
  assert_eq(safe_divide(6, 2), Ok(3))
}

///|
test "division by zero" {
  assert_eq(safe_divide(6, 0), Err("division by zero"))
}
