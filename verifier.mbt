///|
/// The result of running the verifier for a single exercise.
pub(all) struct VerifierResult {
  exit_code : Int
  stdout : String
  stderr : String
}

///|
/// The `moon` subcommand that verifies an exercise of the given kind.
pub fn kind_command(kind : ExerciseKind) -> String {
  match kind {
    Check => "check"
    Test => "test"
  }
}

///|
/// Run the `moon` toolchain in the exercise directory.
///
/// This is the only place the CLI shells out to the toolchain. Everything else
/// interprets an already-computed `VerifierResult`, so the interpretation can be
/// tested with fabricated results and no toolchain.
///
/// Standard output and standard error are drained concurrently while the
/// process runs, so a verbose `moon` cannot deadlock on a full pipe buffer.
pub async fn run_moon(kind : ExerciseKind, dir : String) -> VerifierResult {
  let command = kind_command(kind)
  let (out_r, out_w) = @process.read_from_process()
  let (err_r, err_w) = @process.read_from_process()
  @async.with_task_group() <| group => {
    defer out_r.close()
    defer err_r.close()
    let exit_code = group.spawn(() => {
      @process.run("moon", [command], stdout=out_w, stderr=err_w, cwd=dir)
    })
    let stdout = group.spawn(() => out_r.read_all().text())
    let stderr = group.spawn(() => err_r.read_all().text())
    {
      exit_code: exit_code.wait(),
      stdout: stdout.wait(),
      stderr: stderr.wait(),
    }
  }
}

///|
/// Whether a verifier result means the exercise passed.
///
/// `moon check` and `moon test` both exit `0` on success; any other exit code
/// means the exercise is not yet passing.
pub fn passed(result : VerifierResult) -> Bool {
  result.exit_code == 0
}

///|
/// Renders a verifier result for a single exercise as human-readable text.
pub fn render_verify_result(
  exercise : Exercise,
  result : VerifierResult,
) -> String {
  let buf = StringBuilder()
  if passed(result) {
    buf.write_string("✓ exercise ")
    buf.write_string(exercise.id)
    buf.write_string(" passed")
  } else {
    buf.write_string("✗ exercise ")
    buf.write_string(exercise.id)
    buf.write_string(" still failing (exit ")
    buf.write_string(result.exit_code.to_string())
    buf.write_string(")\n")
    if !result.stdout.is_empty() {
      buf.write_string(result.stdout)
      if !result.stdout.has_suffix("\n") {
        buf.write_char('\n')
      }
    }
    if !result.stderr.is_empty() {
      buf.write_string(result.stderr)
      if !result.stderr.has_suffix("\n") {
        buf.write_char('\n')
      }
    }
  }
  buf.to_string()
}
