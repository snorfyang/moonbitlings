///|
pub fn first_even(values : Array[Int]) -> Int? {
  for value in values {
    if value % 2 == 0 {
      return Some(value)
    }
  }
  None
}
