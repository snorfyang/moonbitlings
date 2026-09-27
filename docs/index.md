# moonbitlings 文档

[简体中文](index.md) | [English](en/index.md)

## 开始使用

安装 MoonBit 工具链并确认可以在 `PATH` 中找到 `moon`，然后从仓库根目录运行：

```bash
git clone <本仓库地址>
cd moonbitlings
moon run cmd/moonbitlings --
```

每道练习位于 `exercises/<id>/`。watch 会话会显示当前源码路径；修改该文件并保存后，
moonbitlings 会自动重新验证。练习通过后，按 `n` 进入下一道待完成练习。

主题导读见 `guides/README.md`。练习通过后，参考解会写入
`solutions/<id>/main.mbt`。

## 使用手册

- [CLI 参考](cli-reference.md)：命令、参数和退出码。
- [Watch 模式](watch-mode.md)：键盘操作、练习列表和编辑器集成。
- [项目内部机制](project.md)：验证、进度状态、仓库结构、开发检查和发布步骤。

moonbitlings 是交互式练习辅助工具，不是 MoonBit 语言规范或官方教程，也不会捆绑或
替代官方工具链。
