{% include nav.html %}

# 常见问题

## `moon` 找不到，或版本过旧

moonbitlings 复用官方工具链，不捆绑、不替代它。请确认 `moon` 在 `PATH` 中：

```bash
moon version
```

版本过旧会缺少新语法支持，按官方说明升级即可。

## 构建时报 `registry dependency ... was not found`

registry 索引是旧的。运行一次：

```bash
moon update
```

CI 和 Release 工作流也会在设置工具链后自动执行这一步，因为全新环境的索引是冷的。

## Windows 能用吗？

暂未支持。交互式 watch 依赖终端 raw mode 辅助代码，目前只在 macOS 与 Linux 上验证。

## 我把练习源码改坏了，能恢复吗？

可以。在 watch 的练习列表里按 `r` 并确认，会用随项目发布的原始副本覆盖选中练习的
`main.mbt`，同时把该题标记为待完成；不确认则不会改动任何文件。也可以在本地 bundle
的 `templates/exercises/<id>/main.mbt` 找到原始副本，或从 git checkout 恢复。

## 进度丢了，或者我想重来

进度在 `.moonbitlings-state.json`。删除它只会重置进度和当前选题，不会影响练习源码。
想只重做某几题，用 `reset <id>` 或练习列表里的 `r`。

## `run` 报 "has no executable program"

`run` 只适用于定义了 `fn main` 的可执行练习；对 `check` / `test` 练习运行 `run` 会明确
提示并退出码 `2`。想检查这类练习，用 `verify <id>`。

## 会不会联网？会不会偷偷改动我的源码？

不会联网；判定、提示和进度都在本地完成（首次编译 CLI 需要下载一次依赖）。moonbitlings
只会写入三类文件：进度状态文件、通过后生成的 `solutions/<id>/main.mbt`，以及你在
watch 列表里确认重置后的练习源码。

## 我可以用它做自己的课程吗？

可以。课程由 `exercises/manifest.json` 描述，每道练习是一个独立 module。参考
[参与开发](contribute.md)里的步骤，复制一份 manifest 和维护自己的练习集即可。
