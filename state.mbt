///|
/// Learner progress and the last exercise selected in watch mode.
pub(all) struct State {
  done : Array[String]
  current : String?
}

///|
/// Which exercises to include in list output.
pub(all) enum ListFilter {
  All
  Pending
  Done
} derive(Eq, @debug.Debug)

///|
pub fn State::empty() -> State {
  { done: [], current: None, }
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
  { done, current: self.current, }
}

///|
/// Returns a new state with `id` marked as pending.
pub fn State::mark_pending(self : State, id : String) -> State {
  let done : Array[String] = []
  for done_id in self.done {
    if done_id != id {
      done.push(done_id)
    }
  }
  { done, current: self.current, }
}

///|
/// Returns a new state with the selected watch exercise.
pub fn State::with_current(self : State, id : String) -> State {
  { done: self.done, current: Some(id), }
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
  let version = match fields.get("version") {
    Some(Number(value, ..)) => {
      if value != 1.0 && value != 2.0 {
        return Err(
          "unsupported state version; delete the state file to start over",
        )
      }
      value
    }
    Some(_) => return Err("state.version must be a number")
    None => return Err("state.version is required")
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
  let current = if version == 1.0 {
    None
  } else {
    match fields.get("current") {
      Some(String(id)) => Some(id)
      Some(Null) => None
      Some(_) => return Err("state.current must be a string or null")
      None => return Err("state.current is required")
    }
  }
  Ok({ done, current, })
}

///|
/// Serialize the state to JSON text.
pub fn State::to_json(self : State) -> String {
  let done_json : Array[Json] = []
  for id in self.done {
    done_json.push(Json::string(id))
  }
  let map : Map[String, Json] = {
    "version": Json::number(2.0, repr="2"),
    "done": Json::array(done_json),
    "current": match self.current {
      Some(id) => Json::string(id)
      None => Json::null()
    },
  }
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
  render_list_filtered(manifest, state, All)
}

///|
/// Renders exercises matching the requested status filter.
pub fn render_list_filtered(
  manifest : Manifest,
  state : State,
  filter : ListFilter,
) -> String {
  let buf = StringBuilder()
  for exercise in manifest.exercises {
    let is_done = state.is_done(exercise.id)
    let visible = match filter {
      All => true
      Pending => !is_done
      Done => is_done
    }
    if !visible {
      continue
    }
    let status = if is_done { "done" } else { "pending" }
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

///|
/// Renders the result summary for a complete verification run.
pub fn render_check_all_summary(manifest : Manifest, state : State) -> String {
  let total = manifest.exercises.length()
  let mut done = 0
  for exercise in manifest.exercises {
    if state.is_done(exercise.id) {
      done += 1
    }
  }
  let pending = total - done
  let summary = "\{done}/\{total} done\n\{pending}/\{total} pending"
  match current_index(manifest, state) {
    Some(index) => "\{summary}; first pending: \{manifest.exercises[index].id}"
    None => summary
  }
}
