///|
/// Double a value using the imported math package.
/// The math package exports `double`, not `increment`.
pub fn double_with_helper(value : Int) -> Int {
  @math.increment(value)
}
