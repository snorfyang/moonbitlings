///|
pub fn sum_to(n : Int) -> Int {
  let mut total = 0
  for i = 1; i <= n; i = i + 1 {
    total += i
  }
  total
}
