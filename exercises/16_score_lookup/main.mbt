///|
/// Find `name` in the score pairs, returning `None` if it is missing.
/// If a name appears more than once, the last score wins.
///
/// Replace the body so it returns the value stored in the hash map.
pub fn score_lookup(scores : Array[(String, Int)], name : String) -> Int? {
  let map = @hashmap.HashMap(scores)
  map.get(name).map(_ => 0)
}
