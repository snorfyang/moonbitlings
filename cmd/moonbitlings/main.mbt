///|
/// Clean process exit for the native backend.
#cfg(any(target="native", target="llvm"))
extern "c" fn process_exit(code : Int) = "exit"

///|
extern "C" fn enable_raw_input() -> Int = "moonbitlings_enable_raw_input"

///|
extern "C" fn restore_input() -> Unit = "moonbitlings_restore_input"

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
enum WatchAction {
  ShowHint
  Recheck
  Next
  ShowList
  CheckAllExercises
  Quit
  Unknown(String)
}

///|
enum WatchEvent {
  Input(String?)
  SourceChanged(String)
}

///|
let usage =
  #|usage: moonbitlings [list [--pending|--done]|verify [id]|hint [id]|run [id]|reset [id]|check-all|watch [id]]

///|
let manifest_path = "exercises/manifest.json"

///|
let state_path = ".moonbitlings-state.json"

///|
/// Parse the command line into a command.
pub fn parse_command(args : Array[String]) -> Result[Command, String] {
  if args.is_empty() {
    return Err("cannot read command line")
  }
  if args.length() == 1 {
    return Ok(Watch(None))
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
        CheckAll => process_exit(run_check_all(manifest))
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
async fn run_check_all(manifest : @lib.Manifest) -> Int {
  let mut verified = @lib.State::empty()
  for exercise in manifest.exercises {
    let result = @lib.run_moon(exercise.kind, @lib.exercise_dir(exercise.id))
    emit(@lib.render_verify_result(exercise, result))
    if @lib.passed(result) {
      verified = verified.mark_done(exercise.id)
    }
  }
  match save_state(state_path, verified) {
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
fn parse_watch_action(line : String) -> WatchAction {
  let action = line.trim().to_owned()
  match action {
    "h" | "hint" => ShowHint
    "r" | "recheck" => Recheck
    "n" | "next" => Next
    "l" | "list" => ShowList
    "c" | "check-all" => CheckAllExercises
    "q" | "quit" => Quit
    other => Unknown(other)
  }
}

///|
fn next_pending_index(
  manifest : @lib.Manifest,
  state : @lib.State,
  start : Int,
) -> Int? {
  for index = start; index < manifest.exercises.length(); index = index + 1 {
    if !state.is_done(manifest.exercises[index].id) {
      return Some(index)
    }
  }
  let end = if start < manifest.exercises.length() {
    start
  } else {
    manifest.exercises.length()
  }
  for index = 0; index < end; index = index + 1 {
    if !state.is_done(manifest.exercises[index].id) {
      return Some(index)
    }
  }
  None
}

///|
fn render_watch_header(
  manifest : @lib.Manifest,
  state : @lib.State,
  index : Int,
  status : String,
) -> String {
  let mut done = 0
  for exercise in manifest.exercises {
    if state.is_done(exercise.id) {
      done += 1
    }
  }
  let exercise = manifest.exercises[index]
  "moonbitlings — \{done}/\{manifest.exercises.length()} done\n\n" +
  "Current: \{exercise.id} — \{exercise.title}\n" +
  "File:    \{@lib.exercise_dir(exercise.id)}/main.mbt\n" +
  "Status: \{status}"
}

///|
fn render_watch_prompt(passed : Bool) -> String {
  if passed {
    "[h] hint  [r] recheck  [n] next  [l] list  [c] check all  [q] quit"
  } else {
    "[h] hint  [r] recheck  [l] list  [c] check all  [q] quit"
  }
}

///|
async fn read_watch_input(
  events : @aqueue.Queue[WatchEvent],
  raw_input : Bool,
) -> Unit {
  try {
    if raw_input {
      while @stdio.stdin.read_some(max_len=1) is Some(input) {
        let action = match input[0] {
          b'h' => Some("h")
          b'r' => Some("r")
          b'n' => Some("n")
          b'l' => Some("l")
          b'c' => Some("c")
          b'q' => Some("q")
          _ => None
        }
        if action is Some(action) {
          events.put(Input(Some(action)))
        }
      }
    } else {
      while @stdio.stdin.read_until("\n") is Some(line) {
        events.put(Input(Some(line)))
      }
    }
  } catch {
    err if @async.is_cancellation_error(err) => raise err
    _ => ()
  }
  events.put(Input(None))
}

///|
async fn watch_source_changes(
  events : @aqueue.Queue[WatchEvent],
  watched_dir : Ref[String],
) -> Unit {
  let mut dir = watched_dir.val
  let mut signature = exercise_signature(dir)
  for ;; {
    @async.sleep(200)
    if watched_dir.val != dir {
      dir = watched_dir.val
      signature = exercise_signature(dir)
      continue
    }
    let next = exercise_signature(dir)
    if next != signature {
      @async.sleep(300)
      if watched_dir.val == dir {
        signature = exercise_signature(dir)
        events.put(SourceChanged(dir))
      }
    }
  }
}

///|
async fn verify_watch_exercise(
  manifest : @lib.Manifest,
  state : @lib.State,
  index : Int,
) -> Result[(@lib.State, Bool), String] {
  let exercise = manifest.exercises[index]
  emit("checking \{exercise.id}...")
  let result = @lib.run_moon(exercise.kind, @lib.exercise_dir(exercise.id))
  let did_pass = @lib.passed(result)
  let was_done = state.is_done(exercise.id)
  let state = if did_pass {
    state.mark_done(exercise.id)
  } else {
    state.mark_pending(exercise.id)
  }
  if did_pass != was_done {
    match save_state(state_path, state) {
      Err(message) => return Err(message)
      Ok(_) => ()
    }
  }
  emit(@lib.render_verify_result(exercise, result))
  let status = if did_pass { "passed" } else { "failing" }
  emit(render_watch_header(manifest, state, index, status))
  emit(render_watch_prompt(did_pass))
  Ok((state, did_pass))
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
  let watched_dir = Ref(@lib.exercise_dir(manifest.exercises[index].id))
  let events : @aqueue.Queue[WatchEvent] = @aqueue.Queue(kind=@aqueue.Unbounded)
  let raw_input = enable_raw_input() == 1
  defer restore_input()
  @async.with_task_group <| group => {
    group.spawn_bg(() => read_watch_input(events, raw_input))
    group.spawn_bg(() => watch_source_changes(events, watched_dir))
    let initial = match verify_watch_exercise(manifest, state, index) {
      Err(message) => {
        emit("error: \{message}")
        group.return_immediately(2)
        (state, false)
      }
      Ok(value) => value
    }
    state = initial.0
    let mut current_passed = initial.1
    for ;; {
      match events.get() {
        Input(None) => group.return_immediately(0)
        SourceChanged(dir) =>
          if dir == watched_dir.val {
            match verify_watch_exercise(manifest, state, index) {
              Err(message) => {
                emit("error: \{message}")
                group.return_immediately(2)
              }
              Ok(value) => {
                state = value.0
                current_passed = value.1
              }
            }
          }
        Input(Some(line)) =>
          match parse_watch_action(line) {
            ShowHint => {
              emit(@lib.render_hint(manifest.exercises[index]))
              emit(render_watch_prompt(current_passed))
            }
            Recheck =>
              match verify_watch_exercise(manifest, state, index) {
                Err(message) => {
                  emit("error: \{message}")
                  group.return_immediately(2)
                }
                Ok(value) => {
                  state = value.0
                  current_passed = value.1
                }
              }
            Next => {
              if !current_passed {
                emit("finish the current exercise before moving on")
                emit(render_watch_prompt(false))
                continue
              }
              match next_pending_index(manifest, state, index + 1) {
                None => {
                  emit("all exercises are done 🎉")
                  group.return_immediately(0)
                }
                Some(next_index) => {
                  index = next_index
                  watched_dir.val = @lib.exercise_dir(
                    manifest.exercises[index].id,
                  )
                  match verify_watch_exercise(manifest, state, index) {
                    Err(message) => {
                      emit("error: \{message}")
                      group.return_immediately(2)
                    }
                    Ok(value) => {
                      state = value.0
                      current_passed = value.1
                    }
                  }
                }
              }
            }
            ShowList => {
              emit(@lib.render_list(manifest, state))
              emit(render_watch_prompt(current_passed))
            }
            CheckAllExercises => {
              ignore(run_check_all(manifest))
              match load_state(state_path) {
                Err(message) => {
                  emit("error: \{message}")
                  group.return_immediately(2)
                }
                Ok(updated) => state = updated
              }
              current_passed = state.is_done(manifest.exercises[index].id)
              let status = if current_passed { "passed" } else { "failing" }
              emit(render_watch_header(manifest, state, index, status))
              emit(render_watch_prompt(current_passed))
            }
            Quit => group.return_immediately(0)
            Unknown(action) => {
              emit("unknown watch action \"\{action}\"")
              emit(render_watch_prompt(current_passed))
            }
          }
      }
    }
  }
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
