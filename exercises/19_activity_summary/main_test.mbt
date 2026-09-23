///|
test "counts online users and their messages" {
  let result = summarize_activity([
    Join("Ada"),
    Message("Ada"),
    Join("Lin"),
    Message("Lin"),
  ])
  assert_eq(result.online, 2)
  assert_eq(result.messages, 2)
}

///|
test "ignores duplicate joins and offline activity" {
  let result = summarize_activity([
    Join("Ada"),
    Join("Ada"),
    Leave("Kay"),
    Message("Kay"),
    Message("Ada"),
    Leave("Ada"),
    Message("Ada"),
  ])
  assert_eq(result.online, 0)
  assert_eq(result.messages, 1)
}

///|
test "counts a message after rejoining" {
  let result = summarize_activity([
    Join("Ada"),
    Leave("Ada"),
    Join("Ada"),
    Message("Ada"),
  ])
  assert_eq(result.online, 1)
  assert_eq(result.messages, 1)
}

///|
test "handles no events" {
  let result = summarize_activity([])
  assert_eq(result.online, 0)
  assert_eq(result.messages, 0)
}
