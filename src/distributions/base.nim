{.experimental: "strictFuncs".}
{.push raises: [].}

## Validation helpers and base distribution types.
##
## Validator error messages follow the convention ``"param must be OP VALUE; got X"``
## for single-valued constraints, or ``"a must be < b; got a=..., b=..."`` for
## multi-parameter relational constraints in inline constructors.
##
## The literal ``Inf`` is used without ``T(Inf)`` wrapping — it widens cleanly
## to any ``SomeFloat`` return type and is mathematically unambiguous.
## ``T(0.0)`` and ``T(PI)`` wrapping is used everywhere else.

type
  Distribution* = object of RootObj
  DistributionContinuous* = object of Distribution
  DistributionDiscrete* = object of Distribution

func validatePositive*(name: static string, x: SomeNumber) {.raises: [ValueError].} =
  if x <= 0:
    raise newException(ValueError, name & " must be > 0; got " & $x)

func validateNonNegative*(name: static string, x: SomeNumber) {.raises: [ValueError].} =
  if x < 0:
    raise newException(ValueError, name & " must be >= 0; got " & $x)

func validateFraction*(name: static string, x: SomeNumber) {.raises: [ValueError].} =
  if x < 0 or x > 1:
    raise newException(ValueError, name & " must be in [0,1]; got " & $x)

{.pop.}
