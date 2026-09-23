///|
/// Return the first even number in `values`, or `None` if there is none.
///
/// The current body returns the first number without checking whether
/// it is even. Replace it so the tests pass.
pub fn first_even(values : Array[Int]) -> Int? {
  if values.length() == 0 {
    None
  } else {
    Some(values[0])
  }
}
