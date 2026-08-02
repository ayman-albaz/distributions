{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import special_functions
import results
import distributions/[base, errors, mathutils]

## F-distribution — ratio of scaled chi-squared variates with
## degrees of freedom ``df1`` and ``df2``.
## <https://en.wikipedia.org/wiki/F-distribution>

type FDistribution*[T: SomeFloat] = object of DistributionContinuous
  ## F-distribution with numerator degrees of freedom ``df1`` and
  ## denominator degrees of freedom ``df2``.
  df1*: int ## Numerator degrees of freedom (``df1 >= 1``).
  df2*: int ## Denominator degrees of freedom (``df2 >= 1``).

func initFDistribution*[T: SomeFloat](
    df1, df2: int
): Result[FDistribution[T], DistError] =
  ## Construct an F-distribution with degrees of freedom `df1` and `df2`.
  ## Both must be >= 1.
  ?validatePositive(df1)
  ?validatePositive(df2)
  ok(FDistribution[T](df1: df1, df2: df2))

func mean*[T: SomeFloat](d: FDistribution[T]): Result[T, DistError] =
  ## Mean: ``df2 / (df2-2)``. Returns error for ``df2 ≤ 2``.
  if d.df2 <= 2:
    return err(DistError.meanUndefined)
  ok(T(d.df2) / T(d.df2 - 2))

func median*[T: SomeFloat](d: FDistribution[T]): T =
  ## Median is the 0.5-quantile via the inverse of the regularized incomplete beta.
  d.ppf(T(0.5))

func mode*[T: SomeFloat](d: FDistribution[T]): Result[T, DistError] =
  ## Mode: ``(df1-2)/df1 · df2/(df2+2)``. Returns error for ``df1 ≤ 2``.
  if d.df1 <= 2:
    return err(DistError.modeUndefined)
  ok((T(d.df1 - 2) / T(d.df1)) * (T(d.df2) / T(d.df2 + 2)))

func variance*[T: SomeFloat](d: FDistribution[T]): Result[T, DistError] =
  ## Variance: ``2·df2²·(df1+df2-2) / (df1·(df2-2)²·(df2-4))``.
  ## Returns error for ``df2 ≤ 4``.
  if d.df2 <= 4:
    return err(DistError.varianceUndefined)
  let fd1 = T(d.df1)
  let fd2 = T(d.df2)
  ok(
    T(2.0) * fd2 * fd2 * (fd1 + fd2 - T(2.0)) /
      (fd1 * (fd2 - T(2.0)) * (fd2 - T(2.0)) * (fd2 - T(4.0)))
  )

func pdf*[T: SomeFloat](d: FDistribution[T], x: T): T =
  ## Probability Density Function (PDF) for FDistribution.
  ## Computed in log-space from the closed form
  ## ``√((df1·x)^df1 · df2^df2 / (df1·x + df2)^(df1+df2)) / (x·B(df1/2, df2/2))``.
  ## `x` is the value at which the density is evaluated.
  if x <= T(0.0):
    if x == T(0.0) and d.df1 == 1:
      return Inf
    if x == T(0.0) and d.df1 == 2:
      return T(1.0)
    return T(0.0)
  let fd1 = T(d.df1)
  let fd2 = T(d.df2)
  let num =
    T(0.5) * (fd1 * ln(fd1 * x) + fd2 * ln(fd2) - (fd1 + fd2) * ln(fd1 * x + fd2))
  let den =
    ln(x) + lgamma(fd1 / T(2.0)) + lgamma(fd2 / T(2.0)) - lgamma((fd1 + fd2) / T(2.0))
  exp(num - den)

func cdf*[T: SomeFloat](d: FDistribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for FDistribution.
  ## `x` is the value at which the CDF is evaluated.
  if x <= T(0.0):
    T(0.0)
  else:
    let fd1 = T(d.df1)
    let fd2 = T(d.df2)
    regularized_lower_incomplete_beta(
      fd1 / T(2.0), fd2 / T(2.0), (fd1 * x) / (fd1 * x + fd2)
    )

func sf*[T: SomeFloat](d: FDistribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for FDistribution.
  ## `x` is the value at which the SF is evaluated.
  T(1.0) - d.cdf(x)

func ppf*[T: SomeFloat](d: FDistribution[T], q: T): T =
  ## Percent Point Function (quantile, inverse CDF) for FDistribution.
  ## `q` is the quantile probability. Returns `0` for `q <= 0`, `Inf` for
  ## `q >= 1`.
  if q <= T(0.0):
    T(0.0)
  elif q >= T(1.0):
    Inf
  else:
    let fd1 = T(d.df1)
    let fd2 = T(d.df2)
    T(d.df2) / T(d.df1) * (
      T(1.0) / inverse_regularized_upper_incomplete_beta(fd2 / T(2.0), fd1 / T(2.0), q) -
      T(1.0)
    )

proc sample*[T: SomeFloat](d: FDistribution[T], r: var Rand): T =
  ## Draw an F(df1, df2) variate as (χ²(df1)/df1) / (χ²(df2)/df2).
  ## `r` is the RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`.
  ## <https://en.wikipedia.org/wiki/F-distribution#Generating_from_a_chi-square_distribution>
  let x1 = standardGamma(r, T(d.df1) * T(0.5)) * T(2.0)
  let x2 = standardGamma(r, T(d.df2) * T(0.5)) * T(2.0)
  (x1 / T(d.df1)) / (x2 / T(d.df2))

{.pop.}
