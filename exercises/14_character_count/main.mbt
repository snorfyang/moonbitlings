///|
/// Count Unicode code points in `text`. An emoji counts as one.
///
/// `length()` counts UTF-16 code units, which differs for some characters.
/// Replace the body by iterating over the characters.
pub fn character_count(text : String) -> Int {
  text.length()
}
