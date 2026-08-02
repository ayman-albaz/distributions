{.experimental: "strictFuncs".}
{.push raises: [].}

## String-valued error enum used as the `E` in every
## ``Result[..., DistError]`` in the library.
##
## Each variant carries its static message as the enum value, so
## ``$``/``echo``/``repr`` yield the message directly — there is no
## separate ``msg`` field or custom ``$`` override. Diagnostics are
## recovered by matching on the variant (e.g. ``case e: of
## DistError.mustBePositive: ...``), which replaces the former
## dynamic ``"X must R Y; got Z"`` message convention.

type DistError* {.pure.} = enum
  mustBePositive = "parameter must be positive"
  mustBeNonNegative = "parameter must be non-negative"
  mustBeFraction = "parameter must be in [0, 1]"
  mustNotBeNaN = "parameter must not be NaN"
  aMustBeLessThanB = "a must be < b"
  aMustBeAtMostB = "a must be <= b"
  meanUndefined = "mean undefined for these parameters"
  modeUndefined = "mode undefined for these parameters"
  varianceUndefined = "variance undefined for these parameters"
  notConverged = "quantile search failed to converge"

{.pop.}
