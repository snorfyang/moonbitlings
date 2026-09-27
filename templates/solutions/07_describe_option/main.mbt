///|
pub fn describe(opt : Int?) -> String {
  match opt {
    Some(value) => "some: \{value}"
    None => "none"
  }
}
