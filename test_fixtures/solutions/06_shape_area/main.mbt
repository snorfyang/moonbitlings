///|
pub(all) enum Shape {
  Circle(Int)
  Square(Int)
}

///|
pub fn area(shape : Shape) -> Int {
  match shape {
    Circle(r) => 3 * r * r
    Square(s) => s * s
  }
}
