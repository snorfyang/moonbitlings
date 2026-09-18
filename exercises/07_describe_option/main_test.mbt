///|
test "describes a present value" {
  assert_eq(describe(Some(42)), "some: 42")
}

///|
test "describes an absent value" {
  assert_eq(describe(None), "none")
}
