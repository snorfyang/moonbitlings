///|
test "parse_command selects each command" {
  assert_true(parse_command(["moonbitlings", "list"]) is Ok(List))
  assert_true(
    parse_command(["moonbitlings", "verify", "01_hello"])
    is Ok(Verify(Some("01_hello"))),
  )
  assert_true(parse_command(["moonbitlings", "verify"]) is Ok(Verify(None)))
  assert_true(
    parse_command(["moonbitlings", "hint", "01_hello"])
    is Ok(Hint(Some("01_hello"))),
  )
  assert_true(parse_command(["moonbitlings", "hint"]) is Ok(Hint(None)))
  assert_true(parse_command(["moonbitlings", "check-all"]) is Ok(CheckAll))
  assert_true(parse_command(["moonbitlings", "watch"]) is Ok(Watch(None)))
  assert_true(
    parse_command(["moonbitlings", "watch", "01_hello"])
    is Ok(Watch(Some("01_hello"))),
  )
  assert_true(parse_command(["moonbitlings", "--help"]) is Ok(Help))
}

///|
test "parse_command rejects malformed input" {
  assert_true(parse_command([]) is Err(_))
  assert_true(parse_command(["moonbitlings"]) is Err(_))
  assert_true(parse_command(["moonbitlings", "bogus"]) is Err(_))
}
