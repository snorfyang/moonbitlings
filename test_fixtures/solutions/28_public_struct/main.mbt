///|
pub(all) struct Point {
  x : Int
  y : Int
}

///|
pub fn coordinate_sum(point : Point) -> Int {
  point.x + point.y
}

///|
pub fn origin() -> Point {
  Point::{ x: 0, y: 0, }
}
