///|
pub fn add_options(left : Int?, right : Int?) -> Int? {
  left.bind(a => right.map(b => a + b))
}
