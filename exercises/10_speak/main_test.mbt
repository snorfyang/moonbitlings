///|
test "a dog speaks" {
  assert_eq(Dog::new().speak(), "woof")
}

///|
test "a cat speaks" {
  assert_eq(Cat::new().speak(), "meow")
}
