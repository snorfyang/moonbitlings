{% include nav.html %}

# Exercises

29 original exercises in a fixed order. IDs and order are stable once released: new
exercises are only appended, never inserted or reordered, so existing progress is never
silently invalidated.

An exercise is complete when:

- `check` exercises: the source passes `moon check`;
- `test` exercises: all tests in `main_test.mbt` pass.

Each topic corresponds to a guide in `guides/`; see the
[learning path](https://github.com/snorfyang/moonbitlings/blob/main/guides/README.md).

<!-- BEGIN GENERATED EXERCISE TABLE -->

<p>29 exercises.</p>

<table>
<thead>
<tr><th>Exercise</th><th>Title</th><th>Kind</th><th>Topic</th></tr>
</thead>
<tbody>
<tr><td><code>00_intro</code></td><td>Welcome: learn the workflow</td><td><code>check</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/getting-started.md">Getting started</a></td></tr>
<tr><td><code>01_hello</code></td><td>Hello: fix the type error</td><td><code>check</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md">Expressions and functions</a></td></tr>
<tr><td><code>02_add</code></td><td>Add: make the test pass</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md">Expressions and functions</a></td></tr>
<tr><td><code>03_sum_to</code></td><td>Sum to n: a loop</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md">Expressions and functions</a></td></tr>
<tr><td><code>04_factorial</code></td><td>Factorial: recursion</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md">Expressions and functions</a></td></tr>
<tr><td><code>05_rect_area</code></td><td>Rectangle area: structs</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/data-types.md">Structs, enums, and patterns</a></td></tr>
<tr><td><code>06_shape_area</code></td><td>Shape area: enums and match</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/data-types.md">Structs, enums, and patterns</a></td></tr>
<tr><td><code>07_describe_option</code></td><td>Describe an option: Option and match</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">Missing values and errors</a></td></tr>
<tr><td><code>08_safe_divide</code></td><td>Safe divide: error handling</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">Missing values and errors</a></td></tr>
<tr><td><code>09_maximum</code></td><td>Maximum: generics</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/generics-and-traits.md">Generics and traits</a></td></tr>
<tr><td><code>10_speak</code></td><td>Speak: traits</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/generics-and-traits.md">Generics and traits</a></td></tr>
<tr><td><code>11_map</code></td><td>Map: higher-order functions</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/arrays.md">Arrays and callbacks</a></td></tr>
<tr><td><code>12_count_even</code></td><td>Count evens: an array loop</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/arrays.md">Arrays and callbacks</a></td></tr>
<tr><td><code>13_greeting</code></td><td>Greeting: string interpolation</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/strings.md">Strings and characters</a></td></tr>
<tr><td><code>14_character_count</code></td><td>Code point count: Unicode iteration</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/strings.md">Strings and characters</a></td></tr>
<tr><td><code>15_redact_digits</code></td><td>Redact digits: text processing</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/strings.md">Strings and characters</a></td></tr>
<tr><td><code>16_score_lookup</code></td><td>Score lookup: hash maps</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/collections.md">Maps and sets</a></td></tr>
<tr><td><code>17_unique_count</code></td><td>Unique count: hash sets</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/collections.md">Maps and sets</a></td></tr>
<tr><td><code>18_word_frequencies</code></td><td>Word frequencies: update a hash map</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/collections.md">Maps and sets</a></td></tr>
<tr><td><code>19_activity_summary</code></td><td>Activity summary: review</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/review.md">Review</a></td></tr>
<tr><td><code>20_first_even</code></td><td>First even: finding an optional value</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">Missing values and errors</a></td></tr>
<tr><td><code>21_double_option</code></td><td>Double an option: map</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">Missing values and errors</a></td></tr>
<tr><td><code>22_add_options</code></td><td>Add options: bind and map</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">Missing values and errors</a></td></tr>
<tr><td><code>23_raise_negative</code></td><td>Raise a typed error</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">Missing values and errors</a></td></tr>
<tr><td><code>24_catch_division</code></td><td>Catch an error and use a fallback</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">Missing values and errors</a></td></tr>
<tr><td><code>25_error_to_result</code></td><td>Convert a raised error to Result</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md">Missing values and errors</a></td></tr>
<tr><td><code>26_import_alias</code></td><td>Import a helper package</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/packages.md">Packages and visibility</a></td></tr>
<tr><td><code>27_public_function</code></td><td>Export a function with pub</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/packages.md">Packages and visibility</a></td></tr>
<tr><td><code>28_public_struct</code></td><td>Make a struct constructible across packages</td><td><code>test</code></td><td><a href="https://github.com/snorfyang/moonbitlings/blob/main/guides/packages.md">Packages and visibility</a></td></tr>
</tbody>
</table>

<!-- END GENERATED EXERCISE TABLE -->

## Difficulty curve

The curriculum deliberately introduces only one concept at a time: the early exercises
cover types, expressions, and loops; the middle section moves into data modeling,
generics and traits, arrays, and strings; the later section covers Map/Set, Option, and
error handling; and it finishes with packages and visibility, closing with a
comprehensive review exercise that ties several concepts together. Every exercise can
be read in under a minute, and the change required is small, but it is enough to expose
a real point of language semantics.
