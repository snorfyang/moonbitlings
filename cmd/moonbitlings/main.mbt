///|
/// Clean process exit for the native backend.
#cfg(any(target="native", target="llvm"))
extern "c" fn process_exit(code : Int) = "exit"

///|
pub enum Command {
  List
  Verify(String)
  Hint(String)
  Watch(String?)
  Help
}

///|
let usage =
  #|usage: moonbitlings <list|verify <id>|hint <id>|watch [id]>

///|
let manifest_path = "exercises/manifest.json"

///|
let state_path = ".moonbitlings-state.json"

///|
/// Parse the command line into a command.
pub fn parse_command(args : Array[String]) -> Result[Command, String] {
  if args.length() < 2 {
    return Err("expected a command: list, verify, hint, or watch")
  }
  match args[1] {
    "list" => Ok(List)
    "verify" =>
      if args.length() >= 3 {
        Ok(Verify(args[2]))
      } else {
        Err("verify needs an exercise id")
      }
    "hint" =>
      if args.length() >= 3 {
        Ok(Hint(args[2]))
      } else {
        Err("hint needs an exercise id")
      }
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
        List => process_exit(run_list(manifest, state))
        Hint(id) => process_exit(run_hint(manifest, id))
        Verify(id) => process_exit(run_verify(manifest, state, id))
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
async fn save_state(path : String, state : @lib.State) -> Unit {
  @fs.write_file(path, state.to_json())
}

///|
fn run_list(manifest : @lib.Manifest, state : @lib.State) -> Int {
  emit(@lib.render_list(manifest, state))
  0
}

///|
fn run_hint(manifest : @lib.Manifest, id : String) -> Int {
  match manifest.find(id) {
    None => {
      emit("error: unknown exercise \"\{id}\"")
      2
    }
    Some(exercise) => {
      emit(@lib.render_hint(exercise))
      0
    }
  }
}

///|
async fn run_verify(
  manifest : @lib.Manifest,
  state : @lib.State,
  id : String,
) -> Int {
  match manifest.find(id) {
    None => {
      emit("error: unknown exercise \"\{id}\"")
      2
    }
    Some(exercise) => {
      let result = @lib.run_moon(exercise.kind, @lib.exercise_dir(exercise.id))
      emit(@lib.render_verify_result(exercise, result))
      if @lib.passed(result) {
        save_state(state_path, state.mark_done(exercise.id))
        0
      } else {
        1
      }
    }
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
        save_state(state_path, state)
        done = true
      } else {
        // Wait for the exercise sources to change, then re-verify.
        let signature = exercise_signature(dir)
        let mut next = exercise_signature(dir)
        while next == signature {
          @async.sleep(200)
          next = exercise_signature(dir)
        }
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
