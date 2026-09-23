///|
/// Return a map from each word to the number of times it appears.
///
/// The current body records only whether a word appeared. Update its count
/// each time it appears instead.
pub fn word_frequencies(words : Array[String]) -> @hashmap.HashMap[String, Int] {
  let counts : @hashmap.HashMap[String, Int] = @hashmap.HashMap([])
  for word in words {
    counts.set(word, 1)
  }
  counts
}
