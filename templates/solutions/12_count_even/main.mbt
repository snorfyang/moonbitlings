///|
pub fn count_even(arr : Array[Int]) -> Int {
  let mut count = 0
  for value in arr {
    if value % 2 == 0 {
      count += 1
    }
  }
  count
}
