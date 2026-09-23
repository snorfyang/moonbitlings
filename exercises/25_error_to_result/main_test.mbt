///|
test "wraps a successful quotient" {
  match divide_result(12, 3) {
    Ok(value) => assert_eq(value, 4)
    Err(_) => fail("expected a successful quotient")
  }
}

///|
test "returns the division error" {
  match divide_result(12, 0) {
    Err(DivisionByZero) => ()
    Ok(_) => fail("expected DivisionByZero")
  }
}

///|
test "supports a negative divisor" {
  match divide_result(12, -3) {
    Ok(value) => assert_eq(value, -4)
    Err(_) => fail("expected a successful quotient")
  }
}
