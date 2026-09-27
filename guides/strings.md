# Strings and characters · 13–15

Interpolation inserts a value in a string with `\{...}`. String length counts
UTF-16 code units, while iterating with `text.iter()` visits Unicode code
points (`Char`). For character-by-character output, append to a
`StringBuilder` and turn it into a string at the end.

See [MoonBit fundamentals](https://docs.moonbitlang.com/en/stable/language/fundamentals.html).
