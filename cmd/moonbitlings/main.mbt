///|
/// Clean process exit for the native backend.
#cfg(any(target="native", target="llvm"))
extern "c" fn process_exit(code : Int) = "exit"

///|
pub enum Command {
  List(@lib.ListFilter)
  Verify(String?)
  Hint(String?)
  Run(String?)
  Reset(String?)
  CheckAll
  Watch(String?)
  Help
}

///|
let usage =
  #|usage: moonbitlings <list [--pending|--done]|verify [id]|hint [id]|run [id]|reset [id]|check-all|watch [id]>

///|
let manifest_path = "exercises/manifest.json"

///|
let state_path = ".moonbitlings-state.json"

///|
/// Parse the command line into a command.
pub fn parse_command(args : Array[String]) -> Result[Command, String] {
  if args.length() < 2 {
    return Err(
      "expected a command: list, verify, hint, run, reset, check-all, or watch",
    )
  }
  match args[1] {
    "list" =>
      if args.length() < 3 {
        Ok(List(@lib.All))
      } else {
        match args[2] {
          "--pending" => Ok(List(@lib.Pending))
          "--done" => Ok(List(@lib.Done))
          option => Err("unknown list option \"\{option}\"")
        }
      }
    "verify" =>
      if args.length() >= 3 {
        Ok(Verify(Some(args[2])))
      } else {
        Ok(Verify(None))
      }
    "hint" =>
      if args.length() >= 3 {
        Ok(Hint(Some(args[2])))
      } else {
        Ok(Hint(None))
      }
    "run" =>
      if args.length() >= 3 {
        Ok(Run(Some(args[2])))
      } else {
        Ok(Run(None))
      }
    "reset" =>
      if args.length() >= 3 {
        Ok(Reset(Some(args[2])))
      } else {
        Ok(Reset(None))
      }
    "check-all" => Ok(CheckAll)
    "watch" =>
      if args.length() >= 3 {
        Ok(Watch(Some(args[2])))
      } else {
        Ok(Watch(None))
      }
    "--help" | "-h" => Ok(Help)
    other => Err("unknown command \"\{other}\"")
  }
}

///|
async fn main {
  let args = @env.args()
  match parse_command(args) {
    Err(message) => {
      emit("error: \{message}")
      emit(usage)
      process_exit(2)
      return
    }
    Ok(Help) => {
      emit(usage)
      process_exit(0)
      return
    }
    Ok(command) => {
      let manifest = match load_manifest(manifest_path) {
        Err(message) => {
          emit("error: \{message}")
          process_exit(2)
          return
        }
        Ok(manifest) => manifest
      }
      let state = match load_state(state_path) {
        Err(message) => {
          emit("error: \{message}")
          process_exit(2)
          return
        }
        Ok(state) => state
      }
      match command {
        List(filter) => process_exit(run_list(manifest, state, filter))
        Hint(id) => process_exit(run_hint(manifest, state, id))
        Verify(id) => process_exit(run_verify(manifest, state, id))
        Run(id) => process_exit(run_exercise(manifest, state, id))
        Reset(id) => process_exit(run_reset(manifest, state, id))
        CheckAll => process_exit(run_check_all(manifest, state))
        Watch(id) => process_exit(run_watch(manifest, state, id))
        Help => abort("unreachable")
      }
    }
  }
}

///|
fn emit(value : String) -> Unit {
  if value.has_suffix("\n") {
    println(value[:value.length() - 1])
  } else {
    println(value)
  }
}

///|
async fn load_manifest(path : String) -> Result[@lib.Manifest, String] {
  let text = @fs.read_file(path).text() catch {
    err => return Err("cannot read manifest: \{err}")
  }
  @lib.parse_manifest(text)
}

///|
async fn load_state(path : String) -> Result[@lib.State, String] {
  let exists = @fs.exists(path)
  if !exists {
    return Ok(@lib.State::empty())
  }
  let text = @fs.read_file(path).text() catch {
    err => return Err("cannot read state file: \{err}")
  }
  @lib.parse_state(text)
}

///|
async fn save_state(path : String, state : @lib.State) -> Result[Unit, String] {
  try {
    @fs.write_file(path, state.to_json())
    Ok(())
  } catch {
    err => Err("cannot write state file: \{err}")
  }
}

///|
fn run_list(
  manifest : @lib.Manifest,
  state : @lib.State,
  filter : @lib.ListFilter,
) -> Int {
  emit(@lib.render_list_filtered(manifest, state, filter))
  0
}

///|
fn run_hint(manifest : @lib.Manifest, state : @lib.State, id : String?) -> Int {
  match select_exercise(manifest, state, id) {
    Err(message) => {
      emit("error: \{message}")
      2
    }
    Ok(None) => {
      emit("all exercises are already done")
      0
    }
    Ok(Some(exercise)) => {
      emit(@lib.render_hint(exercise))
      0
    }
  }
}

///|
async fn run_verify(
  manifest : @lib.Manifest,
  state : @lib.State,
  id : String?,
) -> Int {
  match select_exercise(manifest, state, id) {
    Err(message) => {
      emit("error: \{message}")
      2
    }
    Ok(None) => {
      emit("all exercises are already done")
      0
    }
    Ok(Some(exercise)) => {
      let result = @lib.run_moon(exercise.kind, @lib.exercise_dir(exercise.id))
      emit(@lib.render_verify_result(exercise, result))
      if @lib.passed(result) {
        match save_state(state_path, state.mark_done(exercise.id)) {
          Ok(_) => 0
          Err(message) => {
            emit("warning: \{message}")
            0
          }
        }
      } else {
        1
      }
    }
  }
}

///|
async fn run_exercise(
  manifest : @lib.Manifest,
  state : @lib.State,
  id : String?,
) -> Int {
  match select_exercise(manifest, state, id) {
    Err(message) => {
      emit("error: \{message}")
      2
    }
    Ok(None) => {
      emit("all exercises are already done")
      0
    }
    Ok(Some(exercise)) => {
      let result = @lib.run_moon(@lib.Run, @lib.exercise_dir(exercise.id))
      emit(@lib.render_run_result(exercise, result))
      if @lib.passed(result) {
        match save_state(state_path, state.mark_done(exercise.id)) {
          Ok(_) => 0
          Err(message) => {
            emit("warning: \{message}")
            0
          }
        }
      } else {
        1
      }
    }
  }
}

///|
async fn run_reset(
  manifest : @lib.Manifest,
  state : @lib.State,
  id : String?,
) -> Int {
  let selected = match id {
    Some(_) => select_exercise(manifest, state, id)
    None =>
      match @lib.current_index(manifest, state) {
        Some(index) => Ok(Some(manifest.exercises[index]))
        None =>
          if manifest.exercises.is_empty() {
            Ok(None)
          } else {
            Ok(Some(manifest.exercises[manifest.exercises.length() - 1]))
          }
      }
  }
  match selected {
    Err(message) => {
      emit("error: \{message}")
      2
    }
    Ok(None) => {
      emit("there are no exercises to reset")
      0
    }
    Ok(Some(exercise)) => {
      if !state.is_done(exercise.id) {
        emit("exercise \{exercise.id} is already pending")
        return 0
      }
      match save_state(state_path, state.mark_pending(exercise.id)) {
        Ok(_) => {
          emit("exercise \{exercise.id} reset")
          0
        }
        Err(message) => {
          emit("error: \{message}")
          2
        }
      }
    }
  }
}

///|
fn select_exercise(
  manifest : @lib.Manifest,
  state : @lib.State,
  id : String?,
) -> Result[@lib.Exercise?, String] {
  match id {
    Some(id) =>
      match manifest.find(id) {
        Some(exercise) => Ok(Some(exercise))
        None => Err("unknown exercise \"\{id}\"")
      }
    None =>
      match @lib.current_index(manifest, state) {
        Some(index) => Ok(Some(manifest.exercises[index]))
        None => Ok(None)
      }
  }
}

///|
async fn run_check_all(manifest : @lib.Manifest, state : @lib.State) -> Int {
  let mut verified = @lib.State::empty()
  let mut updated = state
  for exercise in manifest.exercises {
    let result = @lib.run_moon(exercise.kind, @lib.exercise_dir(exercise.id))
    emit(@lib.render_verify_result(exercise, result))
    if @lib.passed(result) {
      verified = verified.mark_done(exercise.id)
      updated = updated.mark_done(exercise.id)
    }
  }
  match save_state(state_path, updated) {
    Err(message) => emit("warning: \{message}")
    Ok(_) => ()
  }
  emit(@lib.render_check_all_summary(manifest, verified))
  match @lib.current_index(manifest, verified) {
    None => 0
    Some(_) => 1
  }
}

///|
async fn run_watch(
  manifest : @lib.Manifest,
  state : @lib.State,
  start_id : String?,
) -> Int {
  let mut state = state
  let mut index = match start_id {
    Some(id) =>
      match manifest.index_of(id) {
        Some(index) => index
        None => {
          emit("error: unknown exercise \"\{id}\"")
          return 2
        }
      }
    None =>
      match @lib.current_index(manifest, state) {
        Some(index) => index
        None => {
          emit("all exercises are already done")
          return 0
        }
      }
  }
  while index < manifest.exercises.length() {
    let exercise = manifest.exercises[index]
    let dir = @lib.exercise_dir(exercise.id)
    let mut last_output = ""
    let mut result = @lib.run_moon(exercise.kind, dir)
    let mut done = false
    while !done {
      let rendered = @lib.render_verify_result(exercise, result)
      if rendered != last_output {
        emit(rendered)
        last_output = rendered
      }
      if @lib.passed(result) {
        state = state.mark_done(exercise.id)
        match save_state(state_path, state) {
          Ok(_) => done = true
          Err(message) => {
            emit("error: \{message}")
            return 2
          }
        }
      } else {
        // Wait for the exercise sources to change, then re-verify.
        let signature = exercise_signature(dir)
        let mut next = signature
        while next == signature {
          @async.sleep(200)
          next = exercise_signature(dir)
        }
        // Debounce: let the editor finish writing before re-running.
        @async.sleep(300)
        result = @lib.run_moon(exercise.kind, dir)
      }
    }
    index += 1
  }
  emit("all exercises are done 🎉")
  0
}

///|
/// A change-sensitive signature over the exercise's source files.
async fn exercise_signature(dir : String) -> String {
  let buf = StringBuilder()
  for name in ["main.mbt", "main_test.mbt"] {
    let path = "\{dir}/\{name}"
    let exists = @fs.exists(path)
    if exists {
      let (sec, nsec) = @fs.mtime(path) catch { _ => (0L, 0) }
      buf.write_string(name)
      buf.write_char(':')
      buf.write_string(sec.to_string())
      buf.write_char('.')
      buf.write_string(nsec.to_string())
      buf.write_char(';')
    }
  }
  buf.to_string()
}
