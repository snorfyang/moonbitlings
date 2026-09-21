#include <moonbit.h>

#ifdef _WIN32

MOONBIT_FFI_EXPORT
int32_t moonbitlings_enable_raw_input(void) {
  return 0;
}

MOONBIT_FFI_EXPORT
void moonbitlings_restore_input(void) {}

#else

#include <stdlib.h>
#include <termios.h>
#include <unistd.h>

static struct termios original_input;
static int input_is_raw = 0;

MOONBIT_FFI_EXPORT
void moonbitlings_restore_input(void) {
  if (input_is_raw) {
    tcsetattr(STDIN_FILENO, TCSANOW, &original_input);
    input_is_raw = 0;
  }
}

MOONBIT_FFI_EXPORT
int32_t moonbitlings_enable_raw_input(void) {
  if (!isatty(STDIN_FILENO)) {
    return 0;
  }
  if (tcgetattr(STDIN_FILENO, &original_input) != 0) {
    return 0;
  }

  struct termios raw = original_input;
  raw.c_lflag &= (tcflag_t)~(ICANON | ECHO);
  raw.c_cc[VMIN] = 1;
  raw.c_cc[VTIME] = 0;
  if (tcsetattr(STDIN_FILENO, TCSANOW, &raw) != 0) {
    return 0;
  }

  input_is_raw = 1;
  atexit(moonbitlings_restore_input);
  return 1;
}

#endif
