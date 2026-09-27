///|
pub fn map(arr : Array[Int], f : (Int) -> Int) -> Array[Int] {
  let result : Array[Int] = []
  for value in arr {
    result.push(f(value))
  }
  result
}
