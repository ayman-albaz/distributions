{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import special_functions
import results
import distributions/[base, errors, mathutils]

## Chi-squared distribution — sum of squares of ``df`` independent
## standard normal random variables.
## <https://en.wikipedia.org/wiki/Chi-squared_distribution>

type Chi2Distribution*[T: SomeFloat] = object of DistributionContinuous
  ## Chi-squared distribution with ``df`` degrees of freedom.
  df*: int ## Degrees of freedom (positive integer, ``df >= 1``).

func initChi2Distribution*[T: SomeFloat](
    df: int
): Result[Chi2Distribution[T], DistError] =
  ## Construct a Chi-squared distribution with `df` degrees of freedom.
  ## `df` must be >= 1.
  ?validatePositive(df)
  ok(Chi2Distribution[T](df: df))

func mean*[T: SomeFloat](d: Chi2Distribution[T]): T =
  ## Mean: ``df``.
  T(d.df)

func median*[T: SomeFloat](d: Chi2Distribution[T]): T =
  ## Median is the 0.5-quantile via ``inverse_regularized_lower_incomplete_gamma``.
  d.ppf(T(0.5))

func mode*[T: SomeFloat](d: Chi2Distribution[T]): T =
  ## Mode: ``max(df-2, 0)``.
  max(T(d.df - 2), T(0.0))

func variance*[T: SomeFloat](d: Chi2Distribution[T]): T =
  ## Variance: ``2·df``.
  T(2.0) * T(d.df)

func pdf*[T: SomeFloat](d: Chi2Distribution[T], x: T): T =
  ## Probability Density Function (PDF) for Chi2Distribution:
  ## ``x^(df/2 - 1) e^(-x/2) / (2^(df/2) Γ(df/2))``.
  ## `x` is the value at which the density is evaluated.
  if x <= T(0.0):
    if x == T(0.0) and d.df == 1:
      return Inf
    if x == T(0.0) and d.df == 2:
      return T(0.5)
    return T(0.0)
  let df2 = T(d.df) / T(2.0)
  exp((df2 - T(1.0)) * ln(x) - x / T(2.0) - lgamma(df2) - df2 * ln(T(2.0)))

func cdf*[T: SomeFloat](d: Chi2Distribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for Chi2Distribution:
  ## ``P(df/2, x/2)`` (regularized lower incomplete gamma).
  ## `x` is the value at which the CDF is evaluated.
  if x <= T(0.0):
    T(0.0)
  else:
    regularized_lower_incomplete_gamma(T(d.df) / T(2.0), x / T(2.0))

func sf*[T: SomeFloat](d: Chi2Distribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for Chi2Distribution.
  ## `x` is the value at which the SF is evaluated.
  T(1.0) - d.cdf(x)

func ppf*[T: SomeFloat](d: Chi2Distribution[T], q: T): T =
  ## Percent Point Function (quantile, inverse CDF) for Chi2Distribution.
  ## `q` is the quantile probability. Returns `0` for `q <= 0`, `Inf` for
  ## `q >= 1`.
  if q <= T(0.0):
    T(0.0)
  elif q >= T(1.0):
    Inf
  else:
    inverse_regularized_lower_incomplete_gamma(T(d.df) / T(2.0), q) * T(2.0)

proc sample*[T: SomeFloat](d: Chi2Distribution[T], r: var Rand): T =
  ## Draw a χ²(df) variate as Gamma(df/2, 2).
  ## `r` is the RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`.
  ## <https://en.wikipedia.org/wiki/Chi-square_distribution#Computational_methods>
  standardGamma(r, T(d.df) * T(0.5)) * T(2.0)

{.pop.}
