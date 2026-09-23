///|
/// An event in a small activity log.
pub(all) enum Activity {
  Join(String)
  Leave(String)
  Message(String)
}

///|
/// The number of online users and messages sent while their sender was online.
pub(all) struct ActivitySummary {
  online : Int
  messages : Int
}

///|
/// Process events in order. Repeated joins do not add another online user;
/// leaving while offline has no effect. Count messages only from online users.
///
/// Complete the leave and message branches so the tests pass.
pub fn summarize_activity(events : Array[Activity]) -> ActivitySummary {
  let online : @hashset.HashSet[String] = @hashset.HashSet([])
  for event in events {
    match event {
      Join(name) => online.add(name)
      Leave(_) => ()
      Message(_) => ()
    }
  }
  ActivitySummary::{ online: online.length(), messages: 0, }
}
