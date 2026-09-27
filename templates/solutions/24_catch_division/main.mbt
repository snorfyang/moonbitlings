///|
pub(all) suberror DivisionError {
  DivisionByZero
}

///|
fn checked_divide(a : Int, b : Int) -> Int raise DivisionError {
  if b == 0 {
    raise DivisionByZero
  }
  a / b
}

///|
pub fn divide_or(a : Int, b : Int, fallback : Int) -> Int {
  checked_divide(a, b) catch {
    DivisionByZero => fallback
  }
}
