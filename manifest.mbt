///|
/// The way an exercise is verified.
pub(all) enum ExerciseKind {
  Check
  Test
  Run
} derive(Eq, @debug.Debug)

///|
/// The `Eq` impl promoted as regular methods for `ExerciseKind`.
pub extend ExerciseKind with Eq::{not_equal, equal}

///|
/// The `Debug` impl promoted as regular methods for `ExerciseKind`.
pub extend ExerciseKind with @debug.Debug::{to_repr}

///|
/// A single exercise as described by `exercises/manifest.json`.
pub(all) struct Exercise {
  id : String
  title : String
  hint : String
  kind : ExerciseKind
}

///|
/// The whole exercise catalog.
pub(all) struct Manifest {
  exercises : Array[Exercise]
}

///|
/// Parse the exercise manifest from JSON text.
pub fn parse_manifest(text : String) -> Result[Manifest, String] {
  let json = @json.parse(text) catch {
    err => return Err("manifest is not valid JSON: \{err}")
  }
  guard json is Object(fields) else {
    return Err("manifest must be a JSON object")
  }
  let items = match fields.get("exercises") {
    Some(Array(items)) => items
    Some(_) => return Err("manifest.exercises must be an array")
    None => return Err("manifest.exercises is required")
  }
  let exercises : Array[Exercise] = []
  let mut index = 0
  while index < items.length() {
    match parse_exercise(items[index]) {
      Ok(exercise) => exercises.push(exercise)
      Err(message) => return Err("exercises[\{index}]: \{message}")
    }
    index += 1
  }
  Ok({ exercises, })
}

///|
fn parse_exercise(json : Json) -> Result[Exercise, String] {
  guard json is Object(fields) else {
    return Err("exercise must be a JSON object")
  }
  let id = match fields.get("id") {
    Some(String(value)) => value
    Some(_) => return Err("id must be a string")
    None => return Err("id is required")
  }
  let title = match fields.get("title") {
    Some(String(value)) => value
    Some(_) => return Err("title must be a string")
    None => return Err("title is required")
  }
  let hint = match fields.get("hint") {
    Some(String(value)) => value
    Some(_) => return Err("hint must be a string")
    None => return Err("hint is required")
  }
  let kind = match fields.get("kind") {
    Some(String(value)) =>
      match value {
        "check" => Check
        "test" => Test
        "run" => Run
        other => return Err("unknown kind \"\{other}\"")
      }
    Some(_) => return Err("kind must be a string")
    None => return Err("kind is required")
  }
  Ok({ id, title, hint, kind, })
}

///|
/// Find an exercise by id.
pub fn Manifest::find(self : Manifest, id : String) -> Exercise? {
  for exercise in self.exercises {
    if exercise.id == id {
      return Some(exercise)
    }
  }
  None
}

///|
/// Position of an exercise by id, or `None` when unknown.
pub fn Manifest::index_of(self : Manifest, id : String) -> Int? {
  for index = 0; index < self.exercises.length(); index = index + 1 {
    if self.exercises[index].id == id {
      return Some(index)
    }
  }
  None
}

///|
/// The directory that holds the sources of an exercise, relative to the
/// repository root.
pub fn exercise_dir(id : String) -> String {
  "exercises/\{id}"
}
