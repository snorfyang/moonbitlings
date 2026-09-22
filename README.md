# moonbitlings

[English](README.md) | [简体中文](README.zh-CN.md)

Rustlings-style, offline, exercise-driven practice for the
[MoonBit](https://www.moonbitlang.com/) programming language.

moonbitlings provides a native CLI, a progressive set of small MoonBit
exercises, automatic verification with the official toolchain, hints, and local
progress tracking.

> Status: working prototype. The CLI and a 13-exercise curriculum run end to
> end; the curriculum will keep growing.

## Quick start

Prerequisite: a MoonBit toolchain with `moon` on your `PATH`.

```bash
git clone <this repository>
cd moonbitlings
moon run cmd/moonbitlings --
```

The command starts an interactive watch session. Edit the printed exercise
file, save it, and moonbitlings will verify it automatically. Run
`moon run cmd/moonbitlings -- --help` to see the available commands.

## Highlights

- single-key interactive watch and exercise-list navigation;
- automatic re-verification when exercise sources change;
- hints, explicit next-exercise control, and persisted progress;
- VS Code and configurable editor integration;
- deterministic, fully offline operation.

## Documentation

Read the [complete documentation](docs/en/index.md) for the learning workflow,
CLI reference, watch controls, editor setup, progress state, architecture, and
development instructions. [中文文档](docs/index.md) is also available.

moonbitlings is an independent community tool. It is not affiliated with the
MoonBit team or with Rustlings, and completing its exercises is not a claim of
language mastery.

## License

Apache-2.0.
