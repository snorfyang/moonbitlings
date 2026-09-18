///|
/// A geometric shape.
pub(all) enum Shape {
  Circle(Int)
  Square(Int)
}

///|
/// Return the area of the shape.
///
/// Use `match` to handle each variant:
/// - `Circle(r)` => `3 * r * r` (3 stands in for pi here)
/// - `Square(s)` => `s * s`
///
/// Replace the body so the tests pass.
pub fn area(shape : Shape) -> Int {
  0
}
