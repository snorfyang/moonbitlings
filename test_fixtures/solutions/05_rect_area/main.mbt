///|
pub(all) struct Rect {
  width : Int
  height : Int
}

///|
pub fn area(rect : Rect) -> Int {
  rect.width * rect.height
}
