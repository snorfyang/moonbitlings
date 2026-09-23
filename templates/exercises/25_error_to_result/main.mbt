///|
/// Error raised when the divisor is zero.
pub(all) suberror DivisionError {
  DivisionByZero
}

///|
/// Divide, raising an error when `b` is zero.
fn checked_divide(a : Int, b : Int) -> Int raise DivisionError {
  if b == 0 {
    raise DivisionByZero
  }
  a / b
}

///|
/// Represent success as `Ok` and division by zero as `Err`.
/// The current body hides the error by returning `Ok(0)`.
pub fn divide_result(a : Int, b : Int) -> Result[Int, DivisionError] {
  Ok(checked_divide(a, b) catch { DivisionByZero => 0 })
}
