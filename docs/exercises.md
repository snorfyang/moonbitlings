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

<p>共 29 道练习。</p>

<table>
<thead>
<tr><th>练习</th><th>标题</th><th>类型</th><th>主题</th></tr>
</thead>
<tbody>
<tr><td><code>00_intro</code></td><td>Welcome: learn the workflow</td><td><code>check</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/getting-started.md">入门</a></td></tr>
<tr><td><code>01_hello</code></td><td>Hello: fix the type error</td><td><code>check</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md">表达式与函数</a></td></tr>
<tr><td><code>02_add</code></td><td>Add: make the test pass</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md">表达式与函数</a></td></tr>
<tr><td><code>03_sum_to</code></td><td>Sum to n: a loop</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md">表达式与函数</a></td></tr>
<tr><td><code>04_factorial</code></td><td>Factorial: recursion</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md">表达式与函数</a></td></tr>
<tr><td><code>05_rect_area</code></td><td>Rectangle area: structs</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/data-types.md">struct、枚举与模式匹配</a></td></tr>
<tr><td><code>06_shape_area</code></td><td>Shape area: enums and match</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/data-types.md">struct、枚举与模式匹配</a></td></tr>
<tr><td><code>07_describe_option</code></td><td>Describe an option: Option and match</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">缺失值与错误处理</a></td></tr>
<tr><td><code>08_safe_divide</code></td><td>Safe divide: error handling</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">缺失值与错误处理</a></td></tr>
<tr><td><code>09_maximum</code></td><td>Maximum: generics</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/generics-and-traits.md">泛型与 trait</a></td></tr>
<tr><td><code>10_speak</code></td><td>Speak: traits</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/generics-and-traits.md">泛型与 trait</a></td></tr>
<tr><td><code>11_map</code></td><td>Map: higher-order functions</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/arrays.md">数组与回调</a></td></tr>
<tr><td><code>12_count_even</code></td><td>Count evens: an array loop</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/arrays.md">数组与回调</a></td></tr>
<tr><td><code>13_greeting</code></td><td>Greeting: string interpolation</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/strings.md">字符串与字符</a></td></tr>
<tr><td><code>14_character_count</code></td><td>Code point count: Unicode iteration</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/strings.md">字符串与字符</a></td></tr>
<tr><td><code>15_redact_digits</code></td><td>Redact digits: text processing</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/strings.md">字符串与字符</a></td></tr>
<tr><td><code>16_score_lookup</code></td><td>Score lookup: hash maps</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/collections.md">Map 与 Set</a></td></tr>
<tr><td><code>17_unique_count</code></td><td>Unique count: hash sets</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/collections.md">Map 与 Set</a></td></tr>
<tr><td><code>18_word_frequencies</code></td><td>Word frequencies: update a hash map</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/collections.md">Map 与 Set</a></td></tr>
<tr><td><code>19_activity_summary</code></td><td>Activity summary: review</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/review.md">综合复习</a></td></tr>
<tr><td><code>20_first_even</code></td><td>First even: finding an optional value</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">缺失值与错误处理</a></td></tr>
<tr><td><code>21_double_option</code></td><td>Double an option: map</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">缺失值与错误处理</a></td></tr>
<tr><td><code>22_add_options</code></td><td>Add options: bind and map</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">缺失值与错误处理</a></td></tr>
<tr><td><code>23_raise_negative</code></td><td>Raise a typed error</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">缺失值与错误处理</a></td></tr>
<tr><td><code>24_catch_division</code></td><td>Catch an error and use a fallback</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">缺失值与错误处理</a></td></tr>
<tr><td><code>25_error_to_result</code></td><td>Convert a raised error to Result</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">缺失值与错误处理</a></td></tr>
<tr><td><code>26_import_alias</code></td><td>Import a helper package</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/packages.md">包与可见性</a></td></tr>
<tr><td><code>27_public_function</code></td><td>Export a function with pub</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/packages.md">包与可见性</a></td></tr>
<tr><td><code>28_public_struct</code></td><td>Make a struct constructible across packages</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/packages.md">包与可见性</a></td></tr>
</tbody>
</table>

<!-- END GENERATED EXERCISE TABLE -->

## 难度曲线

课程刻意保持「一次只引入一个概念」：早期是类型、表达式与循环；中段进入数据建模、
泛型与 trait、数组与字符串；后段是 Map/Set、Option 与错误处理；最后用包与可见性收尾，
并以一道综合复习题串起多种概念。每道题都能在一分钟内读完，修改量很小，但足以暴露
一个真实的语言语义点。
