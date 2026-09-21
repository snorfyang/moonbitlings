#!/usr/bin/env python3
"""Verify single-key watch/list navigation and Unix terminal restoration."""

import fcntl
import os
import pty
import select
import signal
import sys
import termios
import time


def read_available(fd: int) -> bytes:
    try:
        return os.read(fd, 4096)
    except OSError:
        return b""


def wait_for(fd: int, output: bytes, marker: bytes, timeout: float) -> bytes:
    deadline = time.monotonic() + timeout
    while marker not in output and time.monotonic() < deadline:
        if select.select([fd], [], [], 0.1)[0]:
            output += read_available(fd)
    return output


def stop_child(pid: int) -> None:
    try:
        os.kill(pid, signal.SIGKILL)
    except ProcessLookupError:
        pass
    os.waitpid(pid, 0)


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: cli_tty_blackbox.py EXE", file=sys.stderr)
        return 2

    executable = os.path.abspath(sys.argv[1])
    master, slave = pty.openpty()
    original = termios.tcgetattr(slave)
    pid = os.fork()
    if pid == 0:
        os.close(master)
        os.setsid()
        fcntl.ioctl(slave, termios.TIOCSCTTY, 0)
        for fd in (0, 1, 2):
            os.dup2(slave, fd)
        if slave > 2:
            os.close(slave)
        environment = os.environ.copy()
        environment["EDIT_CMD"] = "/bin/echo editor-open {file}"
        os.execve(executable, [executable, "watch"], environment)

    os.close(slave)
    output = wait_for(master, b"", b"[q] quit", 10)
    if b"[q] quit" not in output:
        stop_child(pid)
        print("FAIL: TTY watch did not reach its prompt", file=sys.stderr)
        return 1
    if b"editor-open exercises/01_hello/main.mbt" not in output:
        stop_child(pid)
        print("FAIL: TTY watch did not open the current exercise", file=sys.stderr)
        return 1

    os.write(master, b"l")
    output = wait_for(master, output, b"[Enter/c] continue", 2)
    os.write(master, b"\x1b[B")
    output = wait_for(master, output, b"> [pending] 02_add", 2)
    if b"> [pending] 02_add" not in output:
        stop_child(pid)
        print("FAIL: TTY watch list did not handle the down arrow", file=sys.stderr)
        return 1
    os.write(master, b"\r")
    output = wait_for(master, output, b"Current: 02_add", 10)
    if b"Current: 02_add" not in output:
        stop_child(pid)
        print("FAIL: TTY watch list did not select with Enter", file=sys.stderr)
        return 1
    output = wait_for(
        master, output, b"editor-open exercises/02_add/main.mbt", 2
    )
    if b"editor-open exercises/02_add/main.mbt" not in output:
        stop_child(pid)
        print("FAIL: TTY watch did not open the selected exercise", file=sys.stderr)
        return 1

    os.write(master, b"q")
    deadline = time.monotonic() + 2
    status = None
    while time.monotonic() < deadline:
        if select.select([master], [], [], 0.05)[0]:
            output += read_available(master)
        waited, child_status = os.waitpid(pid, os.WNOHANG)
        if waited == pid:
            status = child_status
            break
    if status is None:
        stop_child(pid)
        print("FAIL: TTY watch did not accept q without Enter", file=sys.stderr)
        return 1
    if os.waitstatus_to_exitcode(status) != 0:
        print("FAIL: TTY watch exited unsuccessfully", file=sys.stderr)
        return 1

    restored = termios.tcgetattr(master)
    local_flags = termios.ICANON | termios.ECHO
    if (restored[3] & local_flags) != (original[3] & local_flags):
        print("FAIL: TTY watch did not restore terminal flags", file=sys.stderr)
        return 1

    os.close(master)
    print(
        "ok: TTY watch opens exercises, navigates with single keys, "
        "and restores terminal flags"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
