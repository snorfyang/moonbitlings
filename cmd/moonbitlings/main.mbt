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
  Watch(String?, Bool)
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
  IgnoreInput
  Unknown(String)
}

///|
enum WatchEvent {
  Input(String?)
  SourceChanged(String)
}

///|
enum WatchListAction {
  MoveUp
  MoveDown
  Select
  Back
  SetFilter(@lib.ListFilter)
  Ignore
}

///|
enum WatchListResult {
  Selected(Int)
  Returned
  InputClosed
}

///|
struct EditorCommand {
  program : String
  arguments : Array[String]
}

///|
let usage =
  #|usage: moonbitlings [--no-editor|list [--pending|--done]|verify [id]|hint [id]|run [id]|reset [id]|check-all|watch [id] [--no-editor]]

///|
let manifest_path = "exercises/manifest.json"

///|
let state_path = ".moonbitlings-state.json"

///|
let watch_welcome =
  #|==================================================
  #|  moonbitlings
  #|  Learn MoonBit one small exercise at a time.
  #|==================================================
  #|
  #|Edit the current file and save it to check your work.

///|
/// Parse the command line into a command.
pub fn parse_command(args : Array[String]) -> Result[Command, String] {
  if args.is_empty() {
    return Err("cannot read command line")
  }
  if args.length() == 1 {
    return Ok(Watch(None, false))
  }
  match args[1] {
    "--no-editor" => parse_watch_options(args, 1)
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
    "watch" => parse_watch_options(args, 2)
    "--help" | "-h" => Ok(Help)
    other => Err("unknown command \"\{other}\"")
  }
}

///|
fn parse_watch_options(
  args : Array[String],
  start : Int,
) -> Result[Command, String] {
  let mut id : String? = None
  let mut no_editor = false
  for index = start; index < args.length(); index = index + 1 {
    match args[index] {
      "--no-editor" => no_editor = true
      value =>
        if id is None {
          id = Some(value)
        } else {
          return Err("unexpected watch argument \"\{value}\"")
        }
    }
  }
  Ok(Watch(id, no_editor))
}

///|
fn build_editor_command(
  edit_cmd : String?,
  in_vscode : Bool,
  path : String,
) -> Result[EditorCommand?, String] {
  match edit_cmd {
    Some(value) => {
      let parts : Array[String] = []
      for part in value.trim().split(" ") {
        if !part.is_empty() {
          parts.push(part.to_owned())
        }
      }
      if parts.is_empty() {
        return Err("EDIT_CMD is empty")
      }
      let arguments : Array[String] = []
      let mut has_file = false
      for index = 1; index < parts.length(); index = index + 1 {
        if parts[index].contains("{file}") {
          has_file = true
        }
        arguments.push(parts[index].replace_all(old="{file}", new=path))
      }
      if !has_file {
        arguments.push(path)
      }
      Ok(Some({ program: parts[0], arguments, }))
    }
    None =>
      if in_vscode {
        Ok(Some({ program: "code", arguments: ["--reuse-window", path], }))
      } else {
        Ok(None)
      }
  }
}

///|
async fn maybe_open_editor(
  id : String,
  no_editor : Bool,
  interactive : Bool,
) -> Unit {
  if no_editor || !interactive {
    return
  }
  let in_vscode = @env.get_env_var("TERM_PROGRAM") == Some("vscode") ||
    @env.get_env_var("VSCODE_PID") is Some(_)
  let path = "\{@lib.exercise_dir(id)}/main.mbt"
  match build_editor_command(@env.get_env_var("EDIT_CMD"), in_vscode, path) {
    Err(message) => emit("warning: cannot open editor: \{message}")
    Ok(None) => ()
    Ok(Some(command)) =>
      ignore(@process.spawn_orphan(command.program, command.arguments)) catch {
        err => emit("warning: cannot open editor: \{err}")
      }
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
        Watch(id, no_editor) =>
          process_exit(run_watch(manifest, state, id, no_editor))
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
  let mut verified = match state.current {
    Some(id) => @lib.State::empty().with_current(id)
    None => @lib.State::empty()
  }
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
    "" => IgnoreInput
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
fn initial_watch_index(manifest : @lib.Manifest, state : @lib.State) -> Int? {
  match state.current {
    Some(id) =>
      match manifest.index_of(id) {
        Some(index) => Some(index)
        None => @lib.current_index(manifest, state)
      }
    None => @lib.current_index(manifest, state)
  }
}

///|
fn render_progress_bar(done : Int, total : Int) -> String {
  let width = 24
  let filled = if total == 0 { 0 } else { done * width / total }
  let buf = StringBuilder()
  buf.write_char('[')
  for index = 0; index < width; index = index + 1 {
    buf.write_char(if index < filled { '#' } else { '-' })
  }
  buf.write_char(']')
  buf.to_string()
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
  "--------------------------------------------------\n" +
  "Progress: \{render_progress_bar(done, manifest.exercises.length())} " +
  "\{done}/\{manifest.exercises.length()} done\n" +
  "Current: \{exercise.id} — \{exercise.title}\n" +
  "File:    \{@lib.exercise_dir(exercise.id)}/main.mbt\n" +
  "Status: \{status}"
}

///|
fn render_watch_prompt(passed : Bool) -> String {
  if passed {
    "h:hint / r:recheck / n:next / l:list / c:check all / q:quit"
  } else {
    "h:hint / r:recheck / l:list / c:check all / q:quit"
  }
}

///|
fn parse_watch_list_action(line : String) -> WatchListAction {
  match line.trim().to_owned() {
    "k" | "up" => MoveUp
    "j" | "down" => MoveDown
    "" | "enter" | "c" | "continue" => Select
    "q" | "esc" | "back" => Back
    "a" | "all" => SetFilter(@lib.All)
    "p" | "pending" => SetFilter(@lib.Pending)
    "d" | "done" => SetFilter(@lib.Done)
    _ => Ignore
  }
}

///|
fn move_list_selection(index : Int, delta : Int, length : Int) -> Int {
  let next = index + delta
  if next < 0 {
    length - 1
  } else if next >= length {
    0
  } else {
    next
  }
}

///|
fn watch_list_indices(
  manifest : @lib.Manifest,
  state : @lib.State,
  filter : @lib.ListFilter,
) -> Array[Int] {
  let indices : Array[Int] = []
  for index = 0; index < manifest.exercises.length(); index = index + 1 {
    let is_done = state.is_done(manifest.exercises[index].id)
    let visible = match filter {
      @lib.All => true
      @lib.Pending => !is_done
      @lib.Done => is_done
    }
    if visible {
      indices.push(index)
    }
  }
  indices
}

///|
fn watch_list_cursor(indices : Array[Int], selected : Int) -> Int {
  for index = 0; index < indices.length(); index = index + 1 {
    if indices[index] == selected {
      return index
    }
  }
  0
}

///|
fn render_watch_list(
  manifest : @lib.Manifest,
  state : @lib.State,
  indices : Array[Int],
  cursor : Int,
  filter : @lib.ListFilter,
) -> String {
  let buf = StringBuilder()
  let filter_name = match filter {
    @lib.All => "all"
    @lib.Pending => "pending"
    @lib.Done => "done"
  }
  buf.write_string("Exercises — \{filter_name}\n\n")
  if indices.is_empty() {
    buf.write_string("  No exercises match this filter.\n")
  }
  for position = 0; position < indices.length(); position = position + 1 {
    let index = indices[position]
    let exercise = manifest.exercises[index]
    let marker = if position == cursor { ">" } else { " " }
    let status = if state.is_done(exercise.id) { "done" } else { "pending" }
    buf.write_string(
      "\{marker} [\{status}] \{exercise.id} - \{exercise.title}\n",
    )
  }
  buf.write_string(
    "\n[a] all  [p] pending  [d] done\n" +
    "[j/k or ↑/↓] move  [Enter/c] continue  [q/Esc] back",
  )
  buf.to_string()
}

///|
async fn run_watch_list(
  events : @aqueue.Queue[WatchEvent],
  manifest : @lib.Manifest,
  state : @lib.State,
  current : Int,
) -> WatchListResult {
  let mut selected = current
  let mut filter = @lib.All
  let mut indices = watch_list_indices(manifest, state, filter)
  let mut cursor = watch_list_cursor(indices, selected)
  emit(render_watch_list(manifest, state, indices, cursor, filter))
  for ;; {
    match events.get() {
      Input(None) => return InputClosed
      SourceChanged(_) => ()
      Input(Some(input)) =>
        match parse_watch_list_action(input) {
          MoveUp =>
            if !indices.is_empty() {
              cursor = move_list_selection(cursor, -1, indices.length())
              selected = indices[cursor]
              emit(render_watch_list(manifest, state, indices, cursor, filter))
            }
          MoveDown =>
            if !indices.is_empty() {
              cursor = move_list_selection(cursor, 1, indices.length())
              selected = indices[cursor]
              emit(render_watch_list(manifest, state, indices, cursor, filter))
            }
          Select => if !indices.is_empty() { return Selected(selected) }
          Back => return Returned
          SetFilter(next_filter) => {
            filter = next_filter
            indices = watch_list_indices(manifest, state, filter)
            cursor = watch_list_cursor(indices, selected)
            if !indices.is_empty() {
              selected = indices[cursor]
            }
            emit(render_watch_list(manifest, state, indices, cursor, filter))
          }
          Ignore => ()
        }
    }
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
          b'j' => Some("j")
          b'k' => Some("k")
          b'a' => Some("a")
          b'p' => Some("p")
          b'd' => Some("d")
          b'\r' | b'\n' => Some("")
          b'\x1b' => {
            let second = @async.with_timeout_opt(50, () => {
              @stdio.stdin.read_some(max_len=1)
            })
            match second {
              Some(Some(bytes)) if bytes[0] == b'[' => {
                let third = @async.with_timeout_opt(50, () => {
                  @stdio.stdin.read_some(max_len=1)
                })
                match third {
                  Some(Some(bytes)) if bytes[0] == b'A' => Some("up")
                  Some(Some(bytes)) if bytes[0] == b'B' => Some("down")
                  _ => Some("esc")
                }
              }
              _ => Some("esc")
            }
          }
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
  let was_current = state.current == Some(exercise.id)
  let state = (if did_pass {
    state.mark_done(exercise.id)
  } else {
    state.mark_pending(exercise.id)
  }).with_current(exercise.id)
  if did_pass != was_done || !was_current {
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
  no_editor : Bool,
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
      match initial_watch_index(manifest, state) {
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
  if raw_input {
    emit(watch_welcome)
  }
  maybe_open_editor(manifest.exercises[index].id, no_editor, raw_input)
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
                  maybe_open_editor(
                    manifest.exercises[index].id,
                    no_editor,
                    raw_input,
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
              match run_watch_list(events, manifest, state, index) {
                InputClosed => group.return_immediately(0)
                Selected(selected) => {
                  index = selected
                  watched_dir.val = @lib.exercise_dir(
                    manifest.exercises[index].id,
                  )
                  maybe_open_editor(
                    manifest.exercises[index].id,
                    no_editor,
                    raw_input,
                  )
                }
                Returned => ()
              }
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
            CheckAllExercises => {
              ignore(run_check_all(manifest, state))
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
            IgnoreInput => ()
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
