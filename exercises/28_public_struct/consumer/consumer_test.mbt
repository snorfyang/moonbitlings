///|
test "reads a point returned by the defining package" {
  let point = @lesson.origin()
  assert_eq(point.x, 0)
  assert_eq(point.y, 0)
}

///|
test "constructs a point across packages" {
  let point = @lesson.Point::{ x: 3, y: 4, }
  assert_eq(@lesson.coordinate_sum(point), 7)
}

///|
test "constructs a point with negative coordinates" {
  let point = @lesson.Point::{ x: -2, y: 5, }
  assert_eq(@lesson.coordinate_sum(point), 3)
}
