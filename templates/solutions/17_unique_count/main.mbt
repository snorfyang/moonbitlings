///|
pub fn unique_count(values : Array[Int]) -> Int {
  let set : @hashset.HashSet[Int] = @hashset.HashSet([])
  for value in values {
    set.add(value)
  }
  set.length()
}
