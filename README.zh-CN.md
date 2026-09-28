# moonbitlings

[English](README.md) | [简体中文](README.zh-CN.md)

[![CI](https://github.com/snorfyang/moonbitlings/actions/workflows/ci.yml/badge.svg)](https://github.com/snorfyang/moonbitlings/actions/workflows/ci.yml)
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](LICENSE)

MoonBit 生态的 Rustlings 式离线交互练习工具。

moonbitlings 给出一组固定顺序的小练习。它一次显示一道题，你修改打印出来的源码文件、
保存，然后由**官方 `moon` 工具链**判定。把程序改到能编译并通过，再进入下一题。
工具内置提示、按主题的导读、进度记录和参考解，全程不需要联网。

> 状态：可用原型。29 道练习课程已能端到端运行，覆盖表达式与函数、控制流、递归、
> struct、enum 与模式匹配、`Option`、错误处理、泛型、trait、高阶函数、数组、
> 字符串与 Unicode、哈希 Map/Set，以及包与可见性。

## 主要特性

- 「改—存—验」循环由真实的 `moon` 命令驱动，不重新实现编译器；
- 单键交互 watch 会话，以及可浏览的交互式练习列表；
- 练习源码变化后自动重新验证；
- 提供提示、主题导读，以及通过后写入的参考解；
- 进度保存在本地、带版本号的独立状态文件中，与练习源码分离；
- 确定性、完全离线：非交互输出不含 ANSI 转义，同一输入产生字节一致的输出；
- 源码 checkout 即可运行，另可构建 bundle 在任意目录初始化独立练习工作区。

## 快速开始

前置条件：`PATH` 中有 MoonBit 工具链的 `moon`（macOS 或 Linux）。

从源码 checkout 运行：

```bash
git clone https://github.com/snorfyang/moonbitlings
cd moonbitlings
moon run cmd/moonbitlings --
```

裸命令进入交互式 watch。修改打印出来的练习文件并保存，moonbitlings 会自动验证；
当前题通过后按 `n` 继续。运行 `moon run cmd/moonbitlings -- --help` 查看命令列表。

想把练习放在独立目录：

```bash
python3 scripts/build_bundle.py dist/moonbitlings-local
dist/moonbitlings-local/init.sh dist/my-exercises
cd dist/my-exercises
./moonbitlings
```

bundle 包含原生命令行程序、练习、主题导读和参考解模板；初始化脚本会拒绝覆盖
已存在的目录。

## 演示

下面的会话使用初始化后的 bundle；从源码 checkout 运行时，把 `moonbitlings`
换成 `moon run cmd/moonbitlings --`。

```console
$ moonbitlings list --pending
[pending] 00_intro - Welcome: learn the workflow
[pending] 01_hello - Hello: fix the type error
[pending] 02_add - Add: make the test pass
[pending] 03_sum_to - Sum to n: a loop
...

$ moonbitlings hint 02_add
Hint for 02_add: Implement `add` so that `add(2, 3)` returns 5.
Guide: guides/README.md

$ moonbitlings verify 01_hello
✗ exercise 01_hello still failing (exit 255)
Error: [4014]
   ╭─[ …/exercises/01_hello/main.mbt:7:3 ]
   │   "hello"
   │   ───┬───
   │      ╰───── Expr Type Mismatch
        has type : String
        wanted   : Int

$ moonbitlings verify 01_hello      # 修好 main.mbt 之后
✓ exercise 01_hello passed
Solution: solutions/01_hello/main.mbt
```

## 命令

| 命令 | 说明 |
| --- | --- |
| `list` | 显示全部练习及状态（可用 `--pending` / `--done` 过滤）。 |
| `verify [id]` | 检查或测试一道练习；省略 id 时选择下一道待完成练习。 |
| `hint [id]` | 显示提示与主题导读；省略 id 时选择下一道待完成练习。 |
| `run [id]` | 对可执行练习调用 `moon run`。 |
| `reset [id]` | 将练习标记为待完成，不修改源码。 |
| `check-all` | 验证全部练习；仍有待完成练习时退出码非 0。 |
| `watch [id] [--no-editor]` | 启动交互式 watch 会话。 |

裸 `moonbitlings` 进入 `watch`。退出码：`0` 通过/成功，`1` 仍未通过或仍有待完成，
`2` 用法、清单、状态或输入错误。详见 [CLI 参考](docs/cli-reference.md)。

## 课程

练习顺序固定，ID 与顺序一旦发布即稳定，不会让已有进度静默失效。

| 练习 | 主题 | 导读 |
| --- | --- | --- |
| 00 | 入门 | [getting-started.md](guides/getting-started.md) |
| 01–04 | 表达式与函数 | [functions.md](guides/functions.md) |
| 05–06 | struct、enum 与模式匹配 | [data-types.md](guides/data-types.md) |
| 07–08、20–25 | 缺失值与错误处理 | [options-and-errors.md](guides/options-and-errors.md) |
| 09–10 | 泛型与 trait | [generics-and-traits.md](guides/generics-and-traits.md) |
| 11–12 | 数组与回调 | [arrays.md](guides/arrays.md) |
| 13–15 | 字符串与字符 | [strings.md](guides/strings.md) |
| 16–18 | Map 与 Set | [collections.md](guides/collections.md) |
| 19 | 综合复习 | [review.md](guides/review.md) |
| 26–28 | 包与可见性 | [packages.md](guides/packages.md) |

[学习路径](guides/README.md) 在一个页面里索引全部导读。

## 工作方式

项目把验证、练习元数据、进度状态和 CLI 渲染分为独立层：

- `manifest.mbt` —— 练习清单模型、JSON 解析、稳定 ID 与路径；
- `verifier.mbt` —— 窄接口的 `moon`/`moonc` 驱动与结果解释；
- `state.mbt` —— 带版本号的进度状态与列表渲染；
- `cmd/moonbitlings/` —— 参数解析、命令分派、watch/list 交互与编辑器集成。

每道练习是独立 MoonBit module，因此故意损坏的起始源码不会影响主包。判定只在退出码
为 `0` 时通过；工具链输出模糊时按失败或显式「unknown」处理，绝不静默判过。
详见[项目内部机制](docs/project.md)。

## 支持的平台

macOS 与 Linux 已由测试与 CI 覆盖。原生命令行程序使用终端 raw mode 辅助代码，
暂不支持 Windows。

## 文档

完整文档见[文档首页](docs/index.md)，包含学习流程、CLI 参考、watch 操作、编辑器配置、
进度状态、架构和开发说明。另有 [English documentation](docs/en/index.md)。

## 开发

```bash
moon fmt --check
moon check --deny-warn
moon test --deny-warn
moon info
git diff --check
scripts/cli_blackbox.sh
python3 scripts/check_curriculum.py
python3 scripts/check_package.py
python3 scripts/bundle_blackbox.py
```

以上检查每次 push 都会在 CI 中运行。

## 来源与许可

moonbitlings 是独立的社区工具，与 MoonBit 团队或 Rustlings 均无隶属关系；完成全部
练习也不代表语言精通。交互形态参考了 [Rustlings](https://github.com/rust-lang/rustlings)
（MIT）的公开 UX 惯例，未复制其源码或练习内容，本项目全部练习均为原创。完整的来源
说明见[项目内部机制](docs/project.md)。

采用 [Apache-2.0](LICENSE) 许可证。
