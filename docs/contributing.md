{% include nav.html %}

# 参与开发

欢迎 issue、修正和新练习。改动请保持小步、可测，并与现有分层保持一致。

## 本地检查

提交前运行完整检查：

```bash
moon fmt --check
moon check --deny-warn
moon test --deny-warn
moon info
python3 scripts/gen_exercise_docs.py
git diff --check
scripts/cli_blackbox.sh
python3 scripts/check_curriculum.py
python3 scripts/check_package.py
python3 scripts/bundle_blackbox.py
```

其中：

- `cli_blackbox.sh` 构建原生可执行文件，做进程级黑盒测试（含真实 PTY）；
- `check_curriculum.py` 在临时副本里验证未完成题目按预期失败、参考解必须通过，
  且两者都开启 `--deny-warn`；
- `check_package.py` 拒绝打包公开位置之外的文件；
- `bundle_blackbox.py` 在全新目录里演练 bundle 初始化、watch、通过和重置。

以上检查在 CI 中都会运行。

## 新增一道练习

1. 在 `exercises/<id>/` 建一个独立 module（`moon.mod`、`moon.pkg`、`main.mbt`）；
2. 起步源码必须按预期失败；写一个临时参考解让它通过，然后恢复起步源码；
3. 在 `exercises/manifest.json` **末尾**追加稳定 ID，不要插入或重排；
4. 在 `templates/exercises/<id>/main.mbt` 放一份与起步源码完全一致的副本；
5. 在 `templates/solutions/<id>/main.mbt` 放参考解；
6. 带测试的练习在 `moon.pkg` 里加 `warnings = "-test_unqualified_package"`；
7. 补 hint，必要时补主题导读，并更新课程数量等公开说明；
8. 补聚焦测试和必要的 CLI 黑盒断言；
9. 运行完整检查，审阅 diff 后再提交。

`check_curriculum.py` 会强制校验上述第 2、4、5 步的一致性。

## 目录结构

```text
manifest.mbt / verifier.mbt / state.mbt   核心库：清单、工具链、进度
cmd/moonbitlings/                          CLI 与交互
exercises/                                 练习 module 与 manifest.json
templates/exercises/                       列表重置用的原始副本
templates/solutions/                       通过后揭示的参考解
guides/                                    主题导读
scripts/                                   检查与打包脚本
```

架构与设计取舍见[项目内部机制](project.md)。

## 提交与合规

- 只暂存与当前任务直接相关的公开产品文件；
- 提交信息描述产品行为，不要写内部流程或个人环境；
- 练习与代码均为原创。Rustlings 只借鉴公开交互约定（MIT），不复制源码或题目；
  任何新增的第三方内容都要先核对许可证并记录来源、许可与改写范围。
