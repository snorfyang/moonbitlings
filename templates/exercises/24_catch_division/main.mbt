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
/// Return the quotient, or `fallback` when division raises an error.
/// The current body adds the fallback to successful quotients.
pub fn divide_or(a : Int, b : Int, fallback : Int) -> Int {
  let quotient = checked_divide(a, b) catch { DivisionByZero => 0 }
  quotient + fallback
}
