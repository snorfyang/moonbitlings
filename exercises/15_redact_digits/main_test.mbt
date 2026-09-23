///|
test "redacts ASCII digits" {
  assert_eq(redact_digits("Room 204"), "Room ***")
}

///|
test "keeps text without ASCII digits" {
  assert_eq(redact_digits("Moon👋"), "Moon👋")
}

///|
test "keeps non-ASCII digits" {
  assert_eq(redact_digits("２ and 2"), "２ and *")
}
