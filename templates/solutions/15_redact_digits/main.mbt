///|
pub fn redact_digits(text : String) -> String {
  let builder = StringBuilder()
  for char in text.iter() {
    builder.write_char(if char.is_ascii_digit() { '*' } else { char })
  }
  builder.to_string()
}
