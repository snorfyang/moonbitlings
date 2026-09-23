///|
/// Add two optional numbers only when both are present.
/// If either input is `None`, return `None`.
///
/// The current body treats a missing right value as zero. Fix it.
pub fn add_options(left : Int?, right : Int?) -> Int? {
  left.map(a => a + right.unwrap_or(0))
}
