///|
pub(all) enum Activity {
  Join(String)
  Leave(String)
  Message(String)
}

///|
pub(all) struct ActivitySummary {
  online : Int
  messages : Int
}

///|
pub fn summarize_activity(events : Array[Activity]) -> ActivitySummary {
  let online : @hashset.HashSet[String] = @hashset.HashSet([])
  let mut messages = 0
  for event in events {
    match event {
      Join(name) => online.add(name)
      Leave(name) => online.remove(name)
      Message(name) => if online.contains(name) { messages += 1 }
    }
  }
  ActivitySummary::{ online: online.length(), messages, }
}
