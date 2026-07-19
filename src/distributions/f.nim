{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import special_functions
import distributions/[base]

## F-distribution — ratio of scaled chi-squared variates with
## degrees of freedom ``df1`` and ``df2``.
## <https://en.wikipedia.org/wiki/F-distribution>

type
  FDistribution*[T: SomeFloat] = object of DistributionContinuous
    df1*: int
    df2*: int

func initFDistribution*[T: SomeFloat](df1, df2: int): FDistribution[T] {.raises: [ValueError].} =
  ## Construct an F-distribution with degrees of freedom `df1` and `df2`.
  ## Both must be >= 1.
  validatePositive("df1", df1)
  validatePositive("df2", df2)
  result.df1 = df1
  result.df2 = df2

func mean*[T: SomeFloat](d: FDistribution[T]): T {.raises: [ValueError].} =
  ## Mean: ``df2 / (df2-2)``. Raises ``ValueError`` for ``df2 ≤ 2``.
  if d.df2 <= 2:
    raise newException(ValueError, "mean requires df2 > 2")
  T(d.df2) / T(d.df2 - 2)

func median*[T: SomeFloat](d: FDistribution[T]): T =
  ## Median is the 0.5-quantile via the inverse of the regularized incomplete beta.
  d.ppf(T(0.5))

func mode*[T: SomeFloat](d: FDistribution[T]): T {.raises: [ValueError].} =
  ## Mode: ``(df1-2)/df1 · df2/(df2+2)``. Raises ``ValueError`` for ``df1 ≤ 2``.
  if d.df1 <= 2:
    raise newException(ValueError, "mode defined only for df1 > 2")
  (T(d.df1 - 2) / T(d.df1)) * (T(d.df2) / T(d.df2 + 2))

func variance*[T: SomeFloat](d: FDistribution[T]): T {.raises: [ValueError].} =
  ## Variance: ``2·df2²·(df1+df2-2) / (df1·(df2-2)²·(df2-4))``.
  ## Raises ``ValueError`` for ``df2 ≤ 4``.
  if d.df2 <= 4:
    raise newException(ValueError, "variance requires df2 > 4")
  let fd1 = T(d.df1)
  let fd2 = T(d.df2)
  T(2.0) * fd2 * fd2 * (fd1 + fd2 - T(2.0)) /
    (fd1 * (fd2 - T(2.0)) * (fd2 - T(2.0)) * (fd2 - T(4.0)))

func pdf*[T: SomeFloat](d: FDistribution[T], x: T): T =
  ## Probability Density Function (PDF) for FDistribution.
  if x <= T(0.0):
    return T(0.0)
  let fd1 = T(d.df1)
  let fd2 = T(d.df2)
  let num = T(0.5) * (fd1 * ln(fd1 * x) + fd2 * ln(fd2) -
      (fd1 + fd2) * ln(fd1 * x + fd2))
  let den = ln(x) + lgamma(fd1 / T(2.0)) + lgamma(fd2 / T(2.0)) -
      lgamma((fd1 + fd2) / T(2.0))
  exp(num - den)

func cdf*[T: SomeFloat](d: FDistribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for FDistribution.
  if x <= T(0.0):
    T(0.0)
  else:
    let fd1 = T(d.df1)
    let fd2 = T(d.df2)
    regularized_lower_incomplete_beta(
      fd1 / T(2.0), fd2 / T(2.0), (fd1 * x) / (fd1 * x + fd2))

func sf*[T: SomeFloat](d: FDistribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for FDistribution.
  T(1.0) - d.cdf(x)

func ppf*[T: SomeFloat](d: FDistribution[T], p: T): T =
  ## Percent Point Function (quantile, inverse CDF) for FDistribution.
  if p <= T(0.0):
    T(0.0)
  elif p >= T(1.0):
    Inf
  else:
    let fd1 = T(d.df1)
    let fd2 = T(d.df2)
    T(d.df2) / T(d.df1) * (
      T(1.0) / inverse_regularized_upper_incomplete_beta(
        fd2 / T(2.0), fd1 / T(2.0), p) - T(1.0))

{.pop.}
