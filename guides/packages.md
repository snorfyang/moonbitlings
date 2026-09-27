# Packages and visibility · 26–28

Imports belong in `moon.pkg` and can have an alias such as `@math`. Calling a
function across packages requires it to be public. A public struct type and
publicly constructible fields have different visibility; compare `pub` with
`pub(all)` in the final exercise's consumer test.

See [MoonBit packages](https://docs.moonbitlang.com/en/stable/language/packages.html)
and the [build system tutorial](https://docs.moonbitlang.com/en/stable/toolchain/moon/tutorial.html).
