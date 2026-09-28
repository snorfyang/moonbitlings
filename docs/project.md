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
guides/                  主题导读
templates/solutions/      通过后复制的参考解模板
solutions/                本地生成的参考解
test_fixtures/            测试使用的通过和失败样例
```

## 设计决策

- **工具链收敛在一个窄接口后。** CLI 只需要「在某个目录运行这个 `moon` 子命令并
  报告退出码」，因此测试可以用真实 fixture 驱动，工具内部不含需要维护的编译器知识。
- **只有退出码 `0` 判定为通过。** 实测不同命令的失败码不同（`moon check` 可能是
  255，`moon test` 可能是 2），所以规则刻意做得粗：诊断信息照常展示，但绝不解析它
  去凑一个结论；输出模糊时报失败或显式 unknown。
- **元数据使用带版本的 JSON，不引入 DSL。** 贡献者编辑的是普通数据，schema 小到
  可以肉眼审查。
- **每道练习是独立 module。** 故意损坏的起始源码不会影响主包或 CI，验证一道题也
  不会连带构建其它题。
- **练习 ID 与顺序稳定。** 改名或重排会让已保存的学习进度失效，因此新增题目一律
  追加在末尾。
- **进度只存在一个本地、带版本的文件里**，与练习源码分离；删除它只重置进度和当前
  选题。
- **非交互输出确定且不含 ANSI。** 这也是刻意不做颜色的原因：交互性由终端检测决定，
  脚本始终拿到字节稳定的输出。
- **参考解在通过后才揭示**，而不是随起始源码一起给出；学习者先自己尝试，之后再
  对照另一种写法。

## 相关项目

moonbitlings 是对官方 [moonbit/MPI-exercise](https://github.com/moonbit/MPI-exercise)
课程的补充，而不是重复。后者提供直接使用 `moon test` 的测试套件；moonbitlings
增加了交互式 CLI、提示和进度跟踪。moonbitlings 中的全部练习均为原创。

交互式 watch 的信息层级参考了
[Rustlings](https://github.com/rust-lang/rustlings) 的公开 UX 惯例，包括进度条、当前
文件、单键操作提示、主题导读和通过后显示参考解路径。实现与文案均为原创，未复制 Rustlings 源码或练习内容；Rustlings
采用 MIT 许可证。

## 开发

发布前需要运行完整检查：

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

课程检查会核对重置模板与初始源码一致，并在临时副本中验证未完成题目失败、参考解通过。
打包检查会拒绝未纳入公开版本控制的文件；bundle 黑盒检查会在全新目录中验证 watch、
练习通过和源码重置。

## 发布文档站点

`.github/workflows/pages.yml` 会在 `main` 分支的 `docs/` 内容变化后，使用 Jekyll
构建并发布 GitHub Pages；也可以从 Actions 页面手动运行。首次发布前，需要在仓库的
Settings → Pages 中将 Source 设为 GitHub Actions。站点根路径默认显示中文，英文文档
位于 `/en/`。

发布时，先运行上述检查，再更新 `moon.mod` 中的 `version`，最后创建发布标签并推送到
已配置的远程仓库。在 GitHub 上发布 Release 会触发 `.github/workflows/release.yml`：
它用 `scripts/build_bundle.py` 构建 Linux 与 macOS 的本地 bundle，并作为附件上传到该
Release。
