///|
pub fn word_frequencies(words : Array[String]) -> @hashmap.HashMap[String, Int] {
  let counts : @hashmap.HashMap[String, Int] = @hashmap.HashMap([])
  for word in words {
    counts.set(word, counts.get(word).unwrap_or(0) + 1)
  }
  counts
}
