///|
/// Double a present value while leaving `None` unchanged.
///
/// Replace the placeholder for a present value with a `map` transformation.
pub fn double_option(value : Int?) -> Int? {
  match value {
    Some(_) => Some(0)
    None => None
  }
}
