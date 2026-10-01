{% include nav.html %}

# 安装

## 前置条件

- macOS 或 Linux（Windows 暂未支持）；
- `PATH` 中有官方 MoonBit 工具链的 `moon`；
- Python 3（仅在构建本地 bundle 时需要）。

先确认工具链可用：

```bash
moon version
```

## 方式一：源码 checkout

适合想跟着更新、或想参与开发的人：

```bash
git clone https://github.com/snorfyang/moonbitlings
cd moonbitlings
moon run cmd/moonbitlings --
```

第一次运行会编译 CLI，然后进入 watch。之后所有命令都在仓库根目录运行，把
`moonbitlings` 换成 `moon run cmd/moonbitlings --` 即可。

## 方式二：本地 bundle（推荐给学习者）

bundle 会把原生命令行程序、练习、主题导读、参考解模板和初始化脚本打成一个目录，再在
任意位置初始化一个独立工作区，练习和进度都不会和仓库混在一起：

```bash
git clone https://github.com/snorfyang/moonbitlings
cd moonbitlings
python3 scripts/build_bundle.py dist/moonbitlings-local
dist/moonbitlings-local/init.sh ~/moonbitlings-workspace
cd ~/moonbitlings-workspace
./moonbitlings
```

初始化脚本会拒绝覆盖已存在的目录；进度和通过后写出的参考解都留在工作区内。

## 编辑器

在 VS Code 的交互式终端里，watch 会用 `code --reuse-window` 打开当前练习。其它编辑器
可以用 `EDIT_CMD`：

```bash
EDIT_CMD="zed {file}" moon run cmd/moonbitlings --
```

`{file}` 会被替换为相对源码路径；不加占位符则追加到命令末尾。也可以用 `--no-editor`
关闭自动打开。详见 [Watch 模式](watch-mode.md)。

## 终端

- 类 Unix 交互终端使用 raw mode，单键即可操作，无需回车；
- 管道或非 TTY 环境自动回退为按行输入，且不输出 ANSI 转义，便于脚本和 CI；
- 无论正常退出、报错还是取消，都会恢复原始终端设置。

## 关于联网

moonbitlings 自身不联网，判定、提示和进度都在本地完成。首次编译 CLI 时需要从 registry
解析并下载 `moonbitlang/async` 依赖；如遇索引过旧，运行 `moon update` 刷新即可。之后
练习本身只依赖标准库，可完全离线。

## 下一步

- [使用](usage.md)：学习闭环与命令概览；
- [课程](exercises.md)：全部练习索引；
- [常见问题](faq.md)：工具链、平台与排错。
