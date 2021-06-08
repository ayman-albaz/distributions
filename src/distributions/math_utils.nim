import math


proc pow2*[T](x: T): T {.inline.} = x * x
proc pow3*[T](x: T): T {.inline.} = x * x * x


proc lfac*(k: Natural): float {.inline.} = 
    #[
        Factorial using Ln to avoid overflow
    ]#
    var total = 0.0
    for i in 1..k:
        total += ln(i.float)
    return total


proc mean*(x: seq[SomeNumber]): float {.inline.} =
    var total: float = 0.0
    for i in x: total += i
    return total / x.len.float


proc variance*(x: seq[SomeNumber]): float {.inline.} = 
    let x_mean: float = mean(x)
    var total: float = 0.0
    for i in x: total += pow2(i - x_mean)
    return total / x.len.float
