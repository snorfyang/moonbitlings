# moonbitlings Roadmap（路线图）

## 定位

MoonBit 生态的 Rustlings 式离线交互练习工具：一组渐进式练习 + 本地 CLI
（list / verify / hint / run / reset / check-all / watch），复用官方 `moon`
工具链做判定。

对照基准：Rustlings（95 题 / 26 主题 / watch TUI / check-all CI / run / reset /
hint / 自动打开编辑器 / 一条命令安装）。

## 现状快照

- 1 道入门引导和 12 道主题练习，`list`/`verify [id]`/`hint [id]`/`run [id]`/
  `reset [id]`/`check-all`/`watch [id]` 七个命令可用，进度状态带版本号，
  38 个测试 + 进程级黑盒脚本在本地通过，并由 GitHub Actions 持续验证。
- 判定器、解析层、状态层已分层；每题是独立 module，不影响主包 CI。
- 裸命令进入交互式 watch；会话内可提示、重跑、前进、列题、全量检查和退出。

---

## 阶段 0：命令面补齐（对齐 CLI 功能，性价比最高）

目标：把功能层面的差距先拉到最接近，全部小步可测。

### P0-1 check-all（已完成）
- `moonbitlings check-all`：验证全部练习，打印 `done/total` 与
  `N/M pending，第一题是 X` 摘要；有 pending 时退出码非 0（CI 友好）。
- 顺带让 `verify` 支持「无参 = 验证下一道 pending」，与 rustlings 语义一致。
- 验收：黑盒脚本覆盖「全过 exit 0」「有 pending exit 1」。

### P0-2 run / reset / hint 无参语义（已完成）
- `run [id]`：跑单个练习（无参 = 下一题）；与 `verify` 的区别是「跑」而非
  只判（为将来支持纯 `main` 程序题留口子）。
- `reset [id]`：重置单题进度（无参 = 当前/下一题）。
- `hint` 无参默认下一题提示。
- 验收：各命令黑盒断言 + 无参默认语义测试。

### P0-3 list 过滤与排序（已完成）
- `list` 支持按状态过滤（`--pending` / `--done`）或直接显示序号。
- 低优先级，可后置。

---

## 阶段 1：交互学习体验（优先于扩题）

目标：让学习者在一个持续会话中完成「定位题目 → 修改 → 自动验证 → 求助 →
主动进入下一题」的闭环。

### P1-1 持续 watch 会话（已完成）
- 裸 `moonbitlings` 默认进入 watch，持续显示当前题、文件、状态和进度。
- 保存后自动重验；通过后停留当前题，由学习者输入 `n` 前进。
- 会话内支持 `h` hint、`r` recheck、`n` next、`l` list、`c` check-all、
  `q` quit；Unix-like 交互终端中无需按 Enter，非 TTY 自动回退到行输入。
- stdin 关闭时干净退出；进程级黑盒覆盖默认启动、失败停留、保存重验和主动前进。

### P1-2 交互式练习列表（核心已完成）
- 已支持在 watch 内浏览全部练习及状态、移动选择、切换当前题并返回 watch。
- 「当前题」已与「第一道 pending」分离并持久化；version 2 可读取 version 1。
- 待补：列表状态过滤，以及重置选中题的进度；源码重置须有不可变原始副本后再做。

### P1-3 终端与编辑器体验（核心已完成）
- TTY/raw mode 已完成：支持无需 Enter 的单键操作、非 TTY 回退和安全终端恢复。
- 非 TTY 下保持无 ANSI、确定性的普通输出。
- 已输出终端可识别的相对文件路径；交互式 watch 支持 `EDIT_CMD`、VS Code
  自动打开当前练习和 `--no-editor`，启动失败仅警告。
- 最后再增加颜色、响应式布局、搜索和动画。

---

## 阶段 2：课程扩题（对齐内容广度，长期主线）

目标：铺满 MoonBit 可映射的主题，每题 2~3 题、难度递增。

### P2-1 已覆盖主题补深（现有 12 道主题题各补到 2~3 题）
struct / enum+模式匹配 / Option / Result / 泛型 / trait / 高阶函数 / 循环。

### P2-2 新主题（按 MoonBit 特性优先级）
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

### P2-3 内容规范
- 每题原创，配 hint + 说明；不引入第三方素材。
- 每题的「坏版本」必须按预期失败、「参考解」必须通过。
- 目标量：先做到 40~60 题，再谈接近 95。

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
