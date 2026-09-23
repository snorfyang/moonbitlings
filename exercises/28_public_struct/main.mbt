///|
/// A point that callers in another package should be able to construct.
/// Change its visibility so the consumer package can create a Point.
pub struct Point {
  x : Int
  y : Int
}

///|
/// Return the sum of the point coordinates.
pub fn coordinate_sum(point : Point) -> Int {
  point.x + point.y
}

///|
/// A point constructed within its defining package.
pub fn origin() -> Point {
  Point::{ x: 0, y: 0, }
}
