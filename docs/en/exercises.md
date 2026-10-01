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
29 exercises.

| Exercise | Title | Kind | Topic |
| --- | --- | --- | --- |
| `00_intro` | Welcome: learn the workflow | check | [Getting started](https://github.com/snorfyang/moonbitlings/blob/main/guides/getting-started.md) |
| `01_hello` | Hello: fix the type error | check | [Expressions and functions](https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md) |
| `02_add` | Add: make the test pass | test | [Expressions and functions](https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md) |
| `03_sum_to` | Sum to n: a loop | test | [Expressions and functions](https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md) |
| `04_factorial` | Factorial: recursion | test | [Expressions and functions](https://github.com/snorfyang/moonbitlings/blob/main/guides/functions.md) |
| `05_rect_area` | Rectangle area: structs | test | [Structs, enums, and patterns](https://github.com/snorfyang/moonbitlings/blob/main/guides/data-types.md) |
| `06_shape_area` | Shape area: enums and match | test | [Structs, enums, and patterns](https://github.com/snorfyang/moonbitlings/blob/main/guides/data-types.md) |
| `07_describe_option` | Describe an option: Option and match | test | [Missing values and errors](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `08_safe_divide` | Safe divide: error handling | test | [Missing values and errors](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `09_maximum` | Maximum: generics | test | [Generics and traits](https://github.com/snorfyang/moonbitlings/blob/main/guides/generics-and-traits.md) |
| `10_speak` | Speak: traits | test | [Generics and traits](https://github.com/snorfyang/moonbitlings/blob/main/guides/generics-and-traits.md) |
| `11_map` | Map: higher-order functions | test | [Arrays and callbacks](https://github.com/snorfyang/moonbitlings/blob/main/guides/arrays.md) |
| `12_count_even` | Count evens: an array loop | test | [Arrays and callbacks](https://github.com/snorfyang/moonbitlings/blob/main/guides/arrays.md) |
| `13_greeting` | Greeting: string interpolation | test | [Strings and characters](https://github.com/snorfyang/moonbitlings/blob/main/guides/strings.md) |
| `14_character_count` | Code point count: Unicode iteration | test | [Strings and characters](https://github.com/snorfyang/moonbitlings/blob/main/guides/strings.md) |
| `15_redact_digits` | Redact digits: text processing | test | [Strings and characters](https://github.com/snorfyang/moonbitlings/blob/main/guides/strings.md) |
| `16_score_lookup` | Score lookup: hash maps | test | [Maps and sets](https://github.com/snorfyang/moonbitlings/blob/main/guides/collections.md) |
| `17_unique_count` | Unique count: hash sets | test | [Maps and sets](https://github.com/snorfyang/moonbitlings/blob/main/guides/collections.md) |
| `18_word_frequencies` | Word frequencies: update a hash map | test | [Maps and sets](https://github.com/snorfyang/moonbitlings/blob/main/guides/collections.md) |
| `19_activity_summary` | Activity summary: review | test | [Review](https://github.com/snorfyang/moonbitlings/blob/main/guides/review.md) |
| `20_first_even` | First even: finding an optional value | test | [Missing values and errors](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `21_double_option` | Double an option: map | test | [Missing values and errors](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `22_add_options` | Add options: bind and map | test | [Missing values and errors](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `23_raise_negative` | Raise a typed error | test | [Missing values and errors](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `24_catch_division` | Catch an error and use a fallback | test | [Missing values and errors](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `25_error_to_result` | Convert a raised error to Result | test | [Missing values and errors](https://github.com/snorfyang/moonbitlings/blob/main/guides/options-and-errors.md) |
| `26_import_alias` | Import a helper package | test | [Packages and visibility](https://github.com/snorfyang/moonbitlings/blob/main/guides/packages.md) |
| `27_public_function` | Export a function with pub | test | [Packages and visibility](https://github.com/snorfyang/moonbitlings/blob/main/guides/packages.md) |
| `28_public_struct` | Make a struct constructible across packages | test | [Packages and visibility](https://github.com/snorfyang/moonbitlings/blob/main/guides/packages.md) |
<!-- END GENERATED EXERCISE TABLE -->

## Difficulty curve

The curriculum deliberately introduces only one concept at a time: the early exercises
cover types, expressions, and loops; the middle section moves into data modeling,
generics and traits, arrays, and strings; the later section covers Map/Set, Option, and
error handling; and it finishes with packages and visibility, closing with a
comprehensive review exercise that ties several concepts together. Every exercise can
be read in under a minute, and the change required is small, but it is enough to expose
a real point of language semantics.
