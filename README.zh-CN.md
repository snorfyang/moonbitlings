# moonbitlings

[English](README.md) | [简体中文](README.zh-CN.md)

一个受 Rustlings 启发、离线运行、以练习驱动的
[MoonBit](https://www.moonbitlang.com/) 编程语言学习工具。

moonbitlings 提供一组顺序固定的小型练习。每道练习都是独立的 MoonBit
模块，包含需要补全的源码文件，以及测试或预期的编译错误。你需要不断修改代码，
直到 `moon check` 或 `moon test` 通过，然后再进入下一题。CLI 提供 `list`、
`verify`、`hint`、`run`、`reset`、`check-all` 和 `watch` 命令，并将学习进度
保存在本地状态文件中。

> 当前状态：可运行的原型。CLI 和包含 12 道练习的课程已经可以完整运行，后续会继续
> 扩充课程内容。

## 使用方法

前置条件：已经安装 MoonBit 工具链，并且可以在 `PATH` 中找到 `moon`。

```bash
git clone <本仓库地址> && cd moonbitlings

moon run cmd/moonbitlings --                      # 启动交互式 watch 会话
moon run cmd/moonbitlings -- list                 # 显示全部练习及状态
moon run cmd/moonbitlings -- list --pending       # 只显示待完成练习
moon run cmd/moonbitlings -- list --done          # 只显示已完成练习
moon run cmd/moonbitlings -- hint 01_hello        # 显示一道练习的提示
moon run cmd/moonbitlings -- verify 01_hello      # 检查或测试指定练习
moon run cmd/moonbitlings -- verify               # 验证下一道待完成练习
moon run cmd/moonbitlings -- run EXERCISE_ID      # 运行可执行练习
moon run cmd/moonbitlings -- reset 01_hello       # 重置一道练习的进度
moon run cmd/moonbitlings -- check-all            # 验证全部练习
moon run cmd/moonbitlings -- watch                # 显式启动 watch 会话
moon run cmd/moonbitlings -- watch 02_add         # 从指定练习开始
moon run cmd/moonbitlings -- watch --no-editor    # 不自动打开编辑器
```

退出码：`0` 表示请求的练习已经通过或命令成功完成，`1` 表示至少有一道请求的练习
尚未通过，`2` 表示用法或输入错误。

每道练习都位于 `exercises/<id>/`。修改源码后，再运行 `verify [id]`；不指定 ID
时，`verify` 和 `hint` 会选择下一道待完成练习。保存源码后，`watch` 会自动重新
验证。`run [id]` 会对可执行练习调用 `moon run`；`reset [id]` 只修改进度状态，
不会覆盖练习源码。

watch 会话会持续显示当前练习、源码路径、状态和总体进度。在类 Unix 的交互式终端
中，按 `h`、`r`、`n`、`l`、`c` 或 `q`，可以分别查看提示、重新检查、在通过后
进入下一题、查看练习列表、检查全部练习或退出，无需按 Enter。管道输入和不支持的
终端会自动回退为按行输入。练习通过后仍会停留在当前题，直到你按下 `n`。

按 `l` 可以打开交互式练习列表。使用 `j`/`k` 或方向键移动，按 Enter 或 `c`
继续选中的练习，按 `q` 或 Escape 返回。下次启动 watch 时会恢复上次选中的练习。

在 VS Code 的交互式终端中，watch 会通过 `code --reuse-window` 打开当前练习。
可以设置 `EDIT_CMD` 使用其他编辑器，例如 `EDIT_CMD="zed {file}"`。`{file}` 会被
替换为相对源码路径；如果没有占位符，路径会自动追加到命令末尾。命令不会经过 shell，
而是按空格拆分参数，因此暂不支持包含空格的参数。编辑器启动失败只会显示警告，不会
中断 watch。可以使用 `--no-editor` 禁用自动打开，也可以在支持识别文件路径的终端中
点击输出的相对 `File:` 路径。

## 工作原理

- 验证工作由官方工具链完成。moonbitlings 会在每道练习自己的模块目录中运行
  `moon check`（`check` 类型练习）或 `moon test`（`test` 类型练习），不会复制或
  修改编译器。
- `watch` 会轮询练习目录中 `main.mbt` 和 `main_test.mbt` 的修改时间，并在源码
  发生变化后重新验证。用户输入和源码变化会并发处理；标准输入关闭时，会话会正常
  退出。无论正常退出、发生错误还是任务取消，原始终端设置都会恢复。
- 进度保存在仓库根目录的 `.moonbitlings-state.json` 中，与练习源码分离。
- 练习元数据位于 `exercises/manifest.json`，使用带版本、便于人工编辑的 JSON
  格式。

## 进度状态

进度保存在仓库根目录的 `.moonbitlings-state.json` 中：

```json
{ "version": 2, "done": ["01_hello", "02_add"], "current": "03_sum_to" }
```

`version` 字段用于保护文件格式。文件损坏或版本不受支持时会明确报错，而不会猜测
内容。版本 1 的状态文件仍然可以读取，并会在 watch 下次保存时增加 `current`。
进度可以重新计算，因此删除该文件只会重置完成进度和当前选题，不会影响练习源码。

## 项目结构

```text
moon.mod                  模块定义
manifest.mbt              练习清单模型和 JSON 解析
verifier.mbt              工具链驱动（moon）和结果渲染
state.mbt                 进度状态和列表渲染
cmd/moonbitlings/         CLI 可执行程序
exercises/                练习模块和 manifest.json
test_fixtures/            测试使用的小型通过/失败样例
```

## 功能

- 不带命令运行时，启动交互式 watch 会话和可导航的练习列表；
- 提供 `list [--pending|--done]`、`verify [id]`、`hint [id]`、`run [id]`、
  `reset [id]`、`check-all` 和 `watch [id]` 命令；
- 渐进式课程涵盖表达式、函数、循环、递归、结构体、枚举、模式匹配、`Option`、
  错误处理、泛型、trait、高阶函数和数组迭代；
- 确定性的离线运行，无需网络；
- 对未知练习、格式错误的清单和损坏的状态文件给出明确错误。

## 非目标

moonbitlings 不会重新实现 MoonBit 编译器，不会捆绑或替代官方工具链，不会管理包或
凭据，也不会声称完成全部练习就代表掌握了这门语言。它是一个独立的社区工具，与
MoonBit 团队或 Rustlings 均无隶属关系。

## 相关项目

moonbitlings 是对官方 [moonbit/MPI-exercise](https://github.com/moonbit/MPI-exercise)
课程练习的补充，而不是重复：后者是直接使用 `moon test` 的测试套件，moonbitlings
则增加了交互式 CLI、提示和进度跟踪。moonbitlings 中的全部练习均为原创。

## 许可证

Apache-2.0。

## 开发

```bash
moon fmt --check
moon check --deny-warn
moon test --deny-warn
moon info
git diff --check
scripts/cli_blackbox.sh   # CLI 进程级黑盒检查
```

## 发布

1. 运行“开发”一节中的完整检查。
2. 更新 `moon.mod` 中的 `version`。
3. 创建发布标签，并推送到已配置的远程仓库。
