{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import results
import distributions/errors

## Validation helpers and base distribution types.
##
## Validators return the static `DistError` variant matching the violated
## constraint (`DistError.deMustBePositive` / `deMustBeNonNegative` /
## `deMustBeFraction`, or `DistError.deMustNotBeNaN` for a `NaN` argument);
## the string value of the variant is the message (see `errors.nim`).
## Multi-parameter relational constraints use the inline variants
## (`DistError.deAMustBeLessThanB`, `DistError.deAMustBeAtMostB`).
##
## The literal ``Inf`` is used without ``T(Inf)`` wrapping — it widens cleanly
## to any ``SomeFloat`` return type and is mathematically unambiguous.
## ``T(0.0)`` and ``T(PI)`` wrapping is used everywhere else.

type
  Distribution* = object of RootObj
  DistributionContinuous* = object of Distribution
  DistributionDiscrete* = object of Distribution

func validateNotNaN*(x: SomeNumber): Result[void, DistError] =
  when x is SomeFloat:
    if isNaN(x):
      return err(DistError.deMustNotBeNaN)
  ok()

func validatePositive*(x: SomeNumber): Result[void, DistError] =
  ?validateNotNaN(x)
  if x <= 0:
    return err(DistError.deMustBePositive)
  ok()

func validateNonNegative*(x: SomeNumber): Result[void, DistError] =
  ?validateNotNaN(x)
  if x < 0:
    return err(DistError.deMustBeNonNegative)
  ok()

func validateFraction*(x: SomeNumber): Result[void, DistError] =
  ?validateNotNaN(x)
  if x < 0 or x > 1:
    return err(DistError.deMustBeFraction)
  ok()

{.pop.}
