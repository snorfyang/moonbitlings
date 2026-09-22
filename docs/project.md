# 项目内部机制

[文档首页](index.md) | [English](en/project.md)

## 验证与元数据

moonbitlings 使用官方 MoonBit 工具链进行验证。它会在每道练习自己的模块目录中，
对 `check` 类型练习运行 `moon check`，对 `test` 类型练习运行 `moon test`，不会
复制或重新实现编译器。

练习元数据位于 `exercises/manifest.json`，使用带版本、便于人工编辑的 JSON 格式。

## 进度状态

进度与练习源码分离，保存在仓库根目录的 `.moonbitlings-state.json` 中：

```json
{ "version": 2, "done": ["01_hello", "02_add"], "current": "03_sum_to" }
```

`version` 字段用于保护文件格式。文件损坏或版本不受支持时会明确报错。版本 1 的状态
文件仍然可以读取，并会在 watch 下次保存时增加 `current`。删除状态文件只会重置
完成进度和当前选题，不会影响练习源码。

## 仓库结构

```text
moon.mod                  模块定义
manifest.mbt              练习清单模型和 JSON 解析
verifier.mbt              工具链驱动和结果渲染
state.mbt                 进度状态和列表渲染
cmd/moonbitlings/         CLI 可执行程序
exercises/                练习模块和 manifest.json
test_fixtures/            测试使用的通过和失败样例
```

## 相关项目

moonbitlings 是对官方 [moonbit/MPI-exercise](https://github.com/moonbit/MPI-exercise)
课程的补充，而不是重复。后者提供直接使用 `moon test` 的测试套件；moonbitlings
增加了交互式 CLI、提示和进度跟踪。moonbitlings 中的全部练习均为原创。

## 开发

发布前需要运行完整检查：

```bash
moon fmt --check
moon check --deny-warn
moon test --deny-warn
moon info
git diff --check
scripts/cli_blackbox.sh
```

发布时，先运行上述检查，再更新 `moon.mod` 中的 `version`，最后创建发布标签并推送到
已配置的远程仓库。
