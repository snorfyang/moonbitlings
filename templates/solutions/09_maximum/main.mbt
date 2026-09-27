///|
pub fn[T : Compare] maximum(a : T, b : T) -> T {
  if a > b {
    a
  } else {
    b
  }
}
