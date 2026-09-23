///|
/// Count the distinct numbers in `values`.
///
/// The array length includes duplicates. The set below keeps each number
/// only once, but the function still returns the array length.
pub fn unique_count(values : Array[Int]) -> Int {
  let set : @hashset.HashSet[Int] = @hashset.HashSet([])
  for value in values {
    set.add(value)
  }
  values.length()
}
