///|
/// A negative input, including the value that caused the error.
pub(all) suberror NegativeValue {
  NegativeValue(Int)
}

///|
/// Return nonnegative values unchanged. Raise `NegativeValue` with
/// the original value for negative inputs. The current body also rejects
/// zero and loses the invalid value.
pub fn require_nonnegative(value : Int) -> Int raise NegativeValue {
  if value <= 0 {
    raise NegativeValue(0)
  }
  value
}
