# moonbitlings Roadmap（路线图）

## 定位

MoonBit 生态的 Rustlings 式离线交互练习工具：一组渐进式练习 + 本地 CLI
（list / verify / hint / watch），复用官方 `moon` 工具链做判定。

对照基准：Rustlings（95 题 / 26 主题 / watch TUI / check-all CI / run / reset /
hint / 自动打开编辑器 / 一条命令安装）。

## 现状快照

- 12 道练习、12 个特性各 1 题，`list`/`verify <id>`/`hint <id>`/`watch [id]`
  四个命令可用，进度状态带版本号，24 个测试 + 进程级黑盒脚本 + GitHub Actions
  全绿。
- 判定器、解析层、状态层已分层；每题是独立 module，不影响主包 CI。

---

## 阶段 0：命令面补齐（对齐 CLI 功能，性价比最高）

目标：把功能层面的差距先拉到最接近，全部小步可测。

### P0-1 check-all（最重要）
- `moonbitlings check-all`：验证全部练习，打印 `done/total` 与
  `N/M pending，第一题是 X` 摘要；有 pending 时退出码非 0（CI 友好）。
- 顺带让 `verify` 支持「无参 = 验证下一道 pending」，与 rustlings 语义一致。
- 验收：黑盒脚本覆盖「全过 exit 0」「有 pending exit 1」。

### P0-2 run / reset / hint 无参语义
- `run [id]`：跑单个练习（无参 = 下一题）；与 `verify` 的区别是「跑」而非
  只判（为将来支持纯 `main` 程序题留口子）。
- `reset [id]`：重置单题进度（无参 = 当前/下一题）。
- `hint` 无参默认下一题提示。
- 验收：各命令黑盒断言 + 无参默认语义测试。

### P0-3 list 过滤与排序
- `list` 支持按状态过滤（`--pending` / `--done`）或直接显示序号。
- 低优先级，可后置。

---

## 阶段 1：课程扩题（对齐内容广度，长期主线）

目标：铺满 MoonBit 可映射的主题，每题 2~3 题、难度递增。

### P1-1 已覆盖主题补深（现 12 题各补到 2~3 题）
struct / enum+模式匹配 / Option / Result / 泛型 / trait / 高阶函数 / 循环。

### P1-2 新主题（按 MoonBit 特性优先级）
1. strings 与字符串操作
2. Map / Set（哈希表）
3. modules / packages / 可见性（pub / priv）
4. iterators / 迭代器与组合子
5. tests（练习里写测试、`inspect`/快照）
6. async（用 moonbitlang/async 的入门练习）
7. 递归与列表处理加深
8. 数值类型与转换（Int/Int64/Double/FixedArray）
9. 错误处理加深（raise / catch / Result 组合）
10. 泛型约束加深（Compare/Eq/Hash/Show）
11. FFI（可选，偏高级）

### P1-3 内容规范
- 每题原创，配 hint + 说明；不引入第三方素材。
- 每题的「坏版本」必须按预期失败、「参考解」必须通过。
- 目标量：先做到 40~60 题，再谈接近 95。

---

## 阶段 2：watch/TUI 体验（对齐交互形态，工程量大）

目标：把 watch 从「顺序轮询」升级为「全屏交互」，对齐 rustlings 的核心体验。

- 全屏 TUI：左侧练习列表 + done/pending 状态，右侧当前练习判定输出。
- 键盘快捷键：`r` 手动重跑、`h` 提示、`n` 下一题、`q` 退出。
- 编辑器集成：用 `EDIT_CMD` / VS Code 打开当前练习文件（对齐 rustlings）。
- 彩色输出、终端文件链接、完成庆祝页。
- 依赖：阶段 0 的命令语义（check-all 的判定逻辑可直接复用）。
- 验收：有终端的交互下人工走查 + 非 TTY 下回退到普通 watch。

---

## 阶段 3：配套与分发（对齐「一条命令装好」）

- SOLUTIONS.md 参考解（与 hint 分层，注明「先自己写再看」）。
- 发布到 Mooncakes：`moon login` + `moon publish`，支持 `moon install` 安装
  （需要 mooncakes.io 账号与发布权限）。
- README/官网完善：安装、使用、题目索引。
- 验收：干净环境能 `moon install` 后直接 `moon run` 开始做题。

---

## 阶段 4：进阶（可选，视情况）

- 自定义/第三方练习：类似 rustlings `init`/`dev`，让用户 fork 自己的题目集。
- 多语言 hint。
- 更多 MoonBit 特性题：JSON、MoonLex/MoonYacc、Wasm 后端、FFI 等。
