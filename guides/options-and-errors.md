# Missing values and errors · 07–08, 20–25

`Option[T]` represents a present value (`Some`) or no value (`None`). You can
inspect it with `match`, or transform it with `map` and `bind`. `Result[T, E]`
represents success (`Ok`) or failure (`Err`). Later exercises use MoonBit's
`raise` and `catch` to handle typed errors. Watch the return type: a missing
value and a failed computation answer different questions.

See [MoonBit fundamentals](https://docs.moonbitlang.com/en/stable/language/fundamentals.html)
and [error handling](https://docs.moonbitlang.com/en/stable/language/error-handling.html).
