{% include nav.html %}

# 课程

29 道原创练习，按固定顺序排列。ID 与顺序一旦发布即稳定：新增题目只会追加，不会插入
或重排，因此已有进度不会被悄悄作废。

每道题的完成条件是：

- `check` 类型：源码通过 `moon check`；
- `test` 类型：`main_test.mbt` 里的测试全部通过。

每个主题对应 `guides/` 里的一篇导读，见
[学习路径](https://github.com/snorfyang/moonbitlings/blob/main/guides/README.md)。

<!-- BEGIN GENERATED EXERCISE TABLE -->
共 29 道练习。

| 练习 | 标题 | 类型 | 主题 |
| --- | --- | --- | --- |
| `00_intro` | Welcome: learn the workflow | check | [入门](https://github.com/snorfyang/moonbitlings/blob/main/guides/getting-started.md) |
| `01_hello` | Hello: fix the type error | check | [表达式与函数](https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md) |
| `02_add` | Add: make the test pass | test | [表达式与函数](https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md) |
| `03_sum_to` | Sum to n: a loop | test | [表达式与函数](https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md) |
| `04_factorial` | Factorial: recursion | test | [表达式与函数](https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md) |
| `05_rect_area` | Rectangle area: structs | test | [struct、枚举与模式匹配](https://github.com/snorfyang/moonbitlings/blob/main/guides/data-types.md) |
| `06_shape_area` | Shape area: enums and match | test | [struct、枚举与模式匹配](https://github.com/snorfyang/moonbitlings/blob/main/guides/data-types.md) |
| `07_describe_option` | Describe an option: Option and match | test | [缺失值与错误处理](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `08_safe_divide` | Safe divide: error handling | test | [缺失值与错误处理](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `09_maximum` | Maximum: generics | test | [泛型与 trait](https://github.com/snorfyang/moonbitlings/blob/main/guides/generics-and-traits.md) |
| `10_speak` | Speak: traits | test | [泛型与 trait](https://github.com/snorfyang/moonbitlings/blob/main/guides/generics-and-traits.md) |
| `11_map` | Map: higher-order functions | test | [数组与回调](https://github.com/snorfyang/moonbitlings/blob/main/guides/arrays.md) |
| `12_count_even` | Count evens: an array loop | test | [数组与回调](https://github.com/snorfyang/moonbitlings/blob/main/guides/arrays.md) |
| `13_greeting` | Greeting: string interpolation | test | [字符串与字符](https://github.com/snorfyang/moonbitlings/blob/main/guides/strings.md) |
| `14_character_count` | Code point count: Unicode iteration | test | [字符串与字符](https://github.com/snorfyang/moonbitlings/blob/main/guides/strings.md) |
| `15_redact_digits` | Redact digits: text processing | test | [字符串与字符](https://github.com/snorfyang/moonbitlings/blob/main/guides/strings.md) |
| `16_score_lookup` | Score lookup: hash maps | test | [Map 与 Set](https://github.com/snorfyang/moonbitlings/blob/main/guides/collections.md) |
| `17_unique_count` | Unique count: hash sets | test | [Map 与 Set](https://github.com/snorfyang/moonbitlings/blob/main/guides/collections.md) |
| `18_word_frequencies` | Word frequencies: update a hash map | test | [Map 与 Set](https://github.com/snorfyang/moonbitlings/blob/main/guides/collections.md) |
| `19_activity_summary` | Activity summary: review | test | [综合复习](https://github.com/snorfyang/moonbitlings/blob/main/guides/review.md) |
| `20_first_even` | First even: finding an optional value | test | [缺失值与错误处理](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `21_double_option` | Double an option: map | test | [缺失值与错误处理](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `22_add_options` | Add options: bind and map | test | [缺失值与错误处理](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `23_raise_negative` | Raise a typed error | test | [缺失值与错误处理](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `24_catch_division` | Catch an error and use a fallback | test | [缺失值与错误处理](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `25_error_to_result` | Convert a raised error to Result | test | [缺失值与错误处理](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `26_import_alias` | Import a helper package | test | [包与可见性](https://github.com/snorfyang/moonbitlings/blob/main/guides/packages.md) |
| `27_public_function` | Export a function with pub | test | [包与可见性](https://github.com/snorfyang/moonbitlings/blob/main/guides/packages.md) |
| `28_public_struct` | Make a struct constructible across packages | test | [包与可见性](https://github.com/snorfyang/moonbitlings/blob/main/guides/packages.md) |
<!-- END GENERATED EXERCISE TABLE -->

## 难度曲线

课程刻意保持「一次只引入一个概念」：早期是类型、表达式与循环；中段进入数据建模、
泛型与 trait、数组与字符串；后段是 Map/Set、Option 与错误处理；最后用包与可见性收尾，
并以一道综合复习题串起多种概念。每道题都能在一分钟内读完，修改量很小，但足以暴露
一个真实的语言语义点。
