///|
/// Learner progress: the ids of completed exercises.
pub(all) struct State {
  done : Array[String]
}

///|
pub fn State::empty() -> State {
  { done: [], }
}

///|
pub fn State::is_done(self : State, id : String) -> Bool {
  for done_id in self.done {
    if done_id == id {
      return true
    }
  }
  false
}

///|
/// Returns a new state with `id` marked as done.
pub fn State::mark_done(self : State, id : String) -> State {
  if self.is_done(id) {
    return self
  }
  let done : Array[String] = []
  for done_id in self.done {
    done.push(done_id)
  }
  done.push(id)
  { done, }
}

///|
/// Parse a state file from JSON text.
pub fn parse_state(text : String) -> Result[State, String] {
  let json = @json.parse(text) catch {
    err => return Err("state is not valid JSON: \{err}")
  }
  guard json is Object(fields) else {
    return Err("state must be a JSON object")
  }
  let done = match fields.get("done") {
    Some(Array(items)) => {
      let ids : Array[String] = []
      for item in items {
        match item {
          String(id) => ids.push(id)
          _ => return Err("state.done must contain only strings")
        }
      }
      ids
    }
    Some(_) => return Err("state.done must be an array")
    None => return Err("state.done is required")
  }
  Ok({ done, })
}

///|
/// Serialize the state to JSON text.
pub fn State::to_json(self : State) -> String {
  let done_json : Array[Json] = []
  for id in self.done {
    done_json.push(Json::string(id))
  }
  let map : Map[String, Json] = { "done": Json::array(done_json) }
  Json::object(map).stringify()
}

///|
/// The first exercise that is not yet done, or `None` when all are done.
///
/// Index of the first exercise that is not yet done, or `None` when all are done.
pub fn current_index(manifest : Manifest, state : State) -> Int? {
  for index = 0; index < manifest.exercises.length(); index = index + 1 {
    if !state.is_done(manifest.exercises[index].id) {
      return Some(index)
    }
  }
  None
}

///|
/// Renders the exercise list with per-exercise status.
pub fn render_list(manifest : Manifest, state : State) -> String {
  let buf = StringBuilder()
  for exercise in manifest.exercises {
    let status = if state.is_done(exercise.id) { "done" } else { "pending" }
    buf.write_string("[")
    buf.write_string(status)
    buf.write_string("] ")
    buf.write_string(exercise.id)
    buf.write_string(" - ")
    buf.write_string(exercise.title)
    buf.write_char('\n')
  }
  buf.to_string()
}

///|
pub fn render_hint(exercise : Exercise) -> String {
  "Hint for \{exercise.id}: \{exercise.hint}"
}
