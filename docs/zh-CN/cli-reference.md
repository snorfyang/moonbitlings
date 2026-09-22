# CLI 参考

[文档首页](index.md) | [English](../cli-reference.md)

目前需要从仓库根目录按以下方式运行命令：

```bash
moon run cmd/moonbitlings -- [COMMAND]
```

省略 `COMMAND` 时会启动交互式 watch 会话。

| 命令 | 说明 |
| --- | --- |
| `list` | 显示全部练习及状态。 |
| `list --pending` | 只显示待完成练习。 |
| `list --done` | 只显示已完成练习。 |
| `verify [id]` | 检查或测试一道练习；省略 ID 时选择下一道待完成练习。 |
| `hint [id]` | 显示提示；省略 ID 时选择下一道待完成练习。 |
| `run [id]` | 对可执行练习调用 `moon run`。 |
| `reset [id]` | 将练习标记为待完成，不修改源码。 |
| `check-all` | 验证全部练习。 |
| `watch [id]` | 启动 watch，也可以指定起始练习。 |
| `watch [id] --no-editor` | 启动 watch，但不打开编辑器。 |
| `--help` | 显示命令行用法。 |

退出码：

- `0`：请求的练习已经通过，或命令成功完成；
- `1`：至少有一道请求的练习尚未通过；
- `2`：用法、输入、练习清单或状态文件错误。

`reset` 只修改 `.moonbitlings-state.json`，不会覆盖练习源码。
