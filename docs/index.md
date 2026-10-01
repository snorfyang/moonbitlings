{% include nav.html %}

# moonbitlings

**MoonBit 生态的 Rustlings 式离线交互练习工具。**

[![CI](https://github.com/snorfyang/moonbitlings/actions/workflows/ci.yml/badge.svg)](https://github.com/snorfyang/moonbitlings/actions/workflows/ci.yml)
[![License: Apache-2.0](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](https://github.com/snorfyang/moonbitlings/blob/main/LICENSE)

moonbitlings 给出一组固定顺序的小练习。它一次显示一道题，你修改打印出来的源码文件并
保存，然后由**官方 `moon` 工具链**判定；改到能编译、能通过，再进入下一题。练习、提示、
进度和参考解都在本地，全程不需要联网，也不会重新实现或替换 MoonBit 编译器。

## 为什么做这个

MoonBit 官方提供了文档、浏览器交互导览和公开课，但缺少 Rustlings 那样「本地、按顺序、
改一处错误即过关、带提示与进度」的动手练习工具。moonbitlings 补上这一环：练习内容是
产品核心，判定完全交给官方工具链。

## 主要特性

- **真实工具链判定**：`moon check` / `moon test` / `moon run`，不重写编译器、类型检查器
  或构建系统；
- **渐进式原创课程**：29 道练习，从表达式、函数、控制流到泛型、错误处理、包与可见性；
- **交互式 watch**：保存即自动重验，单键操作，会话内可浏览练习列表；
- **提示与主题导读**：每题有 hint，按主题配一篇导读；
- **通过后揭示参考解**：先自己写，再对照另一种写法；
- **本地进度**：版本化状态文件，与练习源码分离，可安全重建；
- **确定性离线**：非交互输出无 ANSI，同一输入产生字节一致的输出。

## 快速开始

前置条件：`PATH` 中有 MoonBit 工具链的 `moon`（macOS 或 Linux）。

```bash
git clone https://github.com/snorfyang/moonbitlings
cd moonbitlings
moon run cmd/moonbitlings --
```

裸命令进入交互式 watch。修改显示的练习文件并保存即可自动验证；当前题通过后按 `n`
继续。想把练习放到独立目录，见[安装](setup.md)里的本地 bundle。

## 文档地图

| 页面 | 内容 |
| --- | --- |
| [安装](setup.md) | 前置条件、两种获取方式、编辑器与终端 |
| [使用](usage.md) | 学习闭环、命令概览、提示与参考解、进度 |
| [Watch 模式](watch-mode.md) | 单键操作、交互式练习列表、编辑器集成 |
| [CLI 参考](cli-reference.md) | 全部命令、参数与退出码 |
| [课程](exercises.md) | 29 道练习按主题索引 |
| [常见问题](faq.md) | 工具链、平台、进度与排错 |
| [参与开发](contributing.md) | 本地检查、新增练习、合规 |
| [项目内部机制](project.md) | 验证、状态、架构、设计决策与发布 |

## 边界与声明

moonbitlings 是交互式练习辅助工具，不是 MoonBit 语言规范或官方教程，也不会捆绑或替代
官方工具链；与 MoonBit 团队、Rustlings 均无隶属关系。完成全部练习只说明这些知识点被
练过，不代表语言精通。项目采用 [Apache-2.0](https://github.com/snorfyang/moonbitlings/blob/main/LICENSE) 许可。
