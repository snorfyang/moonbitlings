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
pub fn divide_result(a : Int, b : Int) -> Result[Int, DivisionError] {
  Ok(checked_divide(a, b)) catch {
    error => Err(error)
  }
}
