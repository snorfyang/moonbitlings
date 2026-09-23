///|
test "returns a positive value" {
  assert_eq(require_nonnegative(7) catch { NegativeValue(_) => -1 }, 7)
}

///|
test "returns zero" {
  assert_eq(require_nonnegative(0) catch { NegativeValue(_) => -1 }, 0)
}

///|
test "raises the negative input" {
  let result : Result[Int, NegativeValue] = Ok(require_nonnegative(-3)) catch {
    error => Err(error)
  }
  match result {
    Err(NegativeValue(value)) => assert_eq(value, -3)
    Ok(_) => fail("expected a NegativeValue error")
  }
}
