{.experimental: "strictFuncs".}
{.push raises: [].}

## String-valued error enum used as the `E` in every
## ``Result[..., DistError]`` in the library.
##
## Each variant carries its static message as the enum value, so
## ``$``/``echo``/``repr`` yield the message directly — there is no
## separate ``msg`` field or custom ``$`` override. Diagnostics are
## recovered by matching on the variant (e.g. ``case e: of
## DistError.deMustBePositive: ...``), which replaces the former
## dynamic ``"X must R Y; got Z"`` message convention.

type DistError* {.pure.} = enum
  deMustBePositive = "parameter must be positive"
  deMustBeNonNegative = "parameter must be non-negative"
  deMustBeFraction = "parameter must be in [0, 1]"
  deMustNotBeNaN = "parameter must not be NaN"
  deAMustBeLessThanB = "a must be < b"
  deAMustBeAtMostB = "a must be <= b"
  deMeanUndefined = "mean undefined for these parameters"
  deModeUndefined = "mode undefined for these parameters"
  deVarianceUndefined = "variance undefined for these parameters"
  deNotConverged = "quantile search failed to converge"

{.pop.}
