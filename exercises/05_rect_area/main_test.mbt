///|
test "area of a 3 by 4 rectangle" {
  let rect = Rect::{ width: 3, height: 4 }
  assert_eq(area(rect), 12)
}

///|
test "area of a square" {
  let rect = Rect::{ width: 5, height: 5 }
  assert_eq(area(rect), 25)
}
