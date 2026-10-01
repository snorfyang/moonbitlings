{% include nav.html %}

# 使用

## 学习闭环

1. 运行 `moonbitlings`（或 `moon run cmd/moonbitlings --`）进入 watch；
2. watch 显示当前练习、源码路径、状态和总体进度；
3. 在编辑器里修改 `exercises/<id>/main.mbt` 并保存；
4. moonbitlings 自动重新验证，并显示编译或测试输出；
5. 通过后按 `n` 进入下一道待完成练习；卡住时按 `h` 看提示。

每道练习是一个独立的 MoonBit module：`check` 类型只要求通过 `moon check`，`test` 类型
要求 `main_test.mbt` 里的测试全部通过。

## 命令概览

| 命令 | 说明 |
| --- | --- |
| `list` | 列出全部练习与状态（`--pending` / `--done` 过滤）。 |
| `verify [id]` | 检查或测试一道练习；省略 id 时选择下一道待完成。 |
| `hint [id]` | 显示提示与主题导读位置；省略 id 时选择下一道待完成。 |
| `run [id]` | 运行定义了 `fn main` 的可执行练习。 |
| `reset [id]` | 只把练习标记为待完成，不修改源码。 |
| `check-all` | 验证全部练习；仍有待完成时退出码非 0。 |
| `watch [id] [--no-editor]` | 启动交互式会话，可指定起始练习。 |

退出码：`0` 通过或成功，`1` 仍未通过，`2` 用法、清单、状态或输入错误。完整说明见
[CLI 参考](cli-reference.md)。

## 提示与参考解

- 在 watch 里按 `h`，或运行 `hint <id>`，查看当前练习的提示；
- 每题对应 `guides/` 里的一篇主题导读，`hint` 会同时给出位置；
- 练习通过后，参考解会写进工作区的 `solutions/<id>/main.mbt`，方便对照另一种写法；
- `reset` 只重置进度，不会删除已经生成的参考解，也不会覆盖你的源码。

## 进度保存

进度保存在工作区根目录的 `.moonbitlings-state.json`：

```json
{ "version": 2, "done": ["01_hello", "02_add"], "current": "03_sum_to" }
```

它与练习源码分离：删除该文件只会重置进度和当前选题，不会动你的代码；文件损坏或版本
不受支持会明确报错，不会静默跳过。细节见[项目内部机制](project.md)。

## 深入

- [Watch 模式](watch-mode.md)：单键操作与交互式练习列表；
- [CLI 参考](cli-reference.md)：全部命令、参数与退出码；
- [常见问题](faq.md)：工具链、平台与排错。
