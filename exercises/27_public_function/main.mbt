///|
/// Double a value for callers in other packages.
/// The consumer package cannot call this function while it is private.
fn double(value : Int) -> Int {
  value * 2
}

///|
/// A public wrapper shows that the private function works in this package.
pub fn double_from_here(value : Int) -> Int {
  double(value)
}
