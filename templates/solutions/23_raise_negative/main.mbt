///|
pub(all) suberror NegativeValue {
  NegativeValue(Int)
}

///|
pub fn require_nonnegative(value : Int) -> Int raise NegativeValue {
  if value < 0 {
    raise NegativeValue(value)
  }
  value
}
