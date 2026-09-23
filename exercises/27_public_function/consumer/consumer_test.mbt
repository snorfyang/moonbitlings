///|
test "public wrapper is accessible" {
  assert_eq(@lesson.double_from_here(3), 6)
}

///|
test "calls the exported function across packages" {
  assert_eq(@lesson.double(7), 14)
  assert_eq(@lesson.double(-3), -6)
}
