///|
pub fn safe_divide(a : Int, b : Int) -> Result[Int, String] {
  if b == 0 {
    Err("division by zero")
  } else {
    Ok(a / b)
  }
}
