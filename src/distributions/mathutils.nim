import math

func pow2*[T](x: T): T {.inline.} = x * x
func pow3*[T](x: T): T {.inline.} = x * x * x

func lfac*(k: Natural): float {.inline.} = 
  ##[
    Factorial using Ln to avoid overflow
  ]##
  var total = 0.0
  for i in 1..k:
    total += ln(i.float)
  result = total

func mean*(x: seq[SomeNumber]): float {.inline.} =
  var total: float = 0.0
  for i in x: total += i
  result = total / x.len.float

func variance*(x: seq[SomeNumber]): float {.inline.} = 
  let x_mean: float = mean(x)
  var total: float = 0.0
  for i in x: total += pow2(i - x_mean)
  result = total / x.len.float
