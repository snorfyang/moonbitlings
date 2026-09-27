///|
pub fn character_count(text : String) -> Int {
  let mut count = 0
  for _ in text.iter() {
    count += 1
  }
  count
}
