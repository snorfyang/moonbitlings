# moonbitlings

[English](README.md) | [简体中文](README.zh-CN.md)

一个受 Rustlings 启发、离线运行、以练习驱动的
[MoonBit](https://www.moonbitlang.com/) 编程语言学习工具。

moonbitlings 提供原生 CLI、一组渐进式 MoonBit 小练习、基于官方工具链的自动验证、
提示和本地进度记录。

> 当前状态：可运行的原型。CLI 和包含 29 道练习的课程已经可以完整运行，其中有
> 字符串、哈希集合、Option、错误处理、包与可见性及综合练习；后续会继续扩充课程内容。

## 快速开始

前置条件：已经安装 MoonBit 工具链，并且可以在 `PATH` 中找到 `moon`。

在源码仓库根目录运行：

```bash
moon run cmd/moonbitlings --
```

这条命令会启动交互式 watch 会话。修改界面中显示的练习文件并保存，moonbitlings
会自动验证。运行 `moon run cmd/moonbitlings -- --help` 可以查看全部命令。

也可以从当前源码构建本地 bundle，在独立目录中练习：

```bash
python3 scripts/build_bundle.py dist/moonbitlings-local
dist/moonbitlings-local/init.sh dist/my-exercises
cd dist/my-exercises
./moonbitlings
```

bundle 包含原生 CLI、练习、主题导读和重置模板；初始化脚本不会覆盖已有目录。

## 主要特性

- 支持单键操作的交互式 watch 和练习列表；
- 练习源码变化后自动重新验证；
- 主题导读、提示、通过后生成参考解，以及持久化进度；
- VS Code 和自定义编辑器集成；
- 确定性的完全离线运行。

## 文档

完整的学习流程、CLI 参考、watch 操作、编辑器配置、进度状态、架构和开发说明请参阅
[中文文档](docs/index.md)，也可以阅读 [English documentation](docs/en/index.md)。

moonbitlings 是一个独立的社区工具，与 MoonBit 团队或 Rustlings 均无隶属关系；
完成全部练习也不代表已经掌握这门语言。

## 许可证

Apache-2.0。
