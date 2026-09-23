///|
pub fn score_lookup(scores : Array[(String, Int)], name : String) -> Int? {
  let map = @hashmap.HashMap(scores)
  map.get(name)
}
