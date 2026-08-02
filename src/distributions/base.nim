{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import results
import distributions/errors

## Validation helpers and base distribution types.
##
## Validators return the static `DistError` variant matching the violated
## constraint (`DistError.MustBePositive` / `MustBeNonNegative` /
## `MustBeFraction`, or `DistError.MustNotBeNaN` for a `NaN` argument);
## the string value of the variant is the message (see `errors.nim`).
## Multi-parameter relational constraints use the inline variants
## (`DistError.AMustBeLessThanB`, `DistError.AMustBeAtMostB`).
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
      return err(DistError.MustNotBeNaN)
  ok()

func validatePositive*(x: SomeNumber): Result[void, DistError] =
  ?validateNotNaN(x)
  if x <= 0:
    return err(DistError.MustBePositive)
  ok()

func validateNonNegative*(x: SomeNumber): Result[void, DistError] =
  ?validateNotNaN(x)
  if x < 0:
    return err(DistError.MustBeNonNegative)
  ok()

func validateFraction*(x: SomeNumber): Result[void, DistError] =
  ?validateNotNaN(x)
  if x < 0 or x > 1:
    return err(DistError.MustBeFraction)
  ok()

{.pop.}
