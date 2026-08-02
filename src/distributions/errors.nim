{.experimental: "strictFuncs".}
{.push raises: [].}

## String-valued error enum used as the `E` in every
## ``Result[..., DistError]`` in the library.
##
## Each variant carries its static message as the enum value, so
## ``$``/``echo``/``repr`` yield the message directly — there is no
## separate ``msg`` field or custom ``$`` override. Diagnostics are
## recovered by matching on the variant (e.g. ``case e: of
## DistError.MustBePositive: ...``), which replaces the former
## dynamic ``"X must R Y; got Z"`` message convention.

type DistError* {.pure.} = enum
  MustBePositive = "parameter must be positive"
  MustBeNonNegative = "parameter must be non-negative"
  MustBeFraction = "parameter must be in [0, 1]"
  MustNotBeNaN = "parameter must not be NaN"
  AMustBeLessThanB = "a must be < b"
  AMustBeAtMostB = "a must be <= b"
  MeanUndefined = "mean undefined for these parameters"
  ModeUndefined = "mode undefined for these parameters"
  VarianceUndefined = "variance undefined for these parameters"
  NotConverged = "quantile search failed to converge"

{.pop.}
