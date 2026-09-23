///|
test "greets a name" {
  assert_eq(greeting("MoonBit"), "Hello, MoonBit!")
}

///|
test "greets an empty name" {
  assert_eq(greeting(""), "Hello, !")
}
