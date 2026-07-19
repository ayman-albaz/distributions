{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import special_functions
import distributions/[base, mathutils]

## Student's t-distribution — continuous distribution with ``df``
## degrees of freedom.
## <https://en.wikipedia.org/wiki/Student%27s_t-distribution>

type
  TDistribution*[T: SomeFloat] = object of DistributionContinuous
    df*: int

func initTDistribution*[T: SomeFloat](df: int): TDistribution[T] {.raises: [ValueError].} =
  ## Construct a Student's t-distribution with `df` degrees of freedom.
  ## `df` must be >= 1.
  validatePositive("df", df)
  result.df = df

func mean*[T: SomeFloat](d: TDistribution[T]): T {.raises: [ValueError].} =
  ## Mean: ``0`` for ``df > 1``. Raises ``ValueError`` for ``df ≤ 1``.
  if d.df > 1:
    T(0.0)
  else:
    raise newException(ValueError, "mean undefined for df <= 1")

func median*[T: SomeFloat](d: TDistribution[T]): T =
  ## Median: ``0``.
  T(0.0)

func mode*[T: SomeFloat](d: TDistribution[T]): T =
  ## Mode: ``0``.
  T(0.0)

func variance*[T: SomeFloat](d: TDistribution[T]): T {.raises: [ValueError].} =
  ## Variance: ``df / (df-2)`` for ``df > 2``. Raises ``ValueError`` for ``df ≤ 2``.
  if d.df <= 2:
    raise newException(ValueError, "variance requires df > 2")
  T(d.df) / T(d.df - 2)

func pdf*[T: SomeFloat](d: TDistribution[T], x: T): T =
  ## Probability Density Function (PDF) for TDistribution.
  let fd = T(d.df)
  let c1 = lgamma((fd + T(1.0)) / T(2.0)) - lgamma(fd / T(2.0))
  let c2 = T(0.5) * ln(T(PI) * fd)
  exp(c1 - c2 - ((fd + T(1.0)) / T(2.0)) * ln(T(1.0) + pow2(x) / fd))

func cdf*[T: SomeFloat](d: TDistribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for TDistribution.
  let fd = T(d.df)
  let s = sqrt(x * x + fd)
  regularized_lower_incomplete_beta(fd / T(2.0), fd / T(2.0), (x + s) / (T(2.0) * s))

func sf*[T: SomeFloat](d: TDistribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for TDistribution.
  T(1.0) - d.cdf(x)

func ppf*[T: SomeFloat](d: TDistribution[T], p: T): T =
  ## Percent Point Function (quantile, inverse CDF) for TDistribution.
  ##
  ## Port of Algorithm 396 (Hill, 1970): Student's t-quantiles.
  ## Returns `-Inf` for `p <= 0`, `Inf` for `p >= 1`.
  if p <= T(0.0):
    return -Inf
  if p >= T(1.0):
    return Inf

  let fd = T(d.df)

  let sign = if p < T(0.5): T(-1.0) else: T(1.0)
  var pmut: T = p
  if p < T(0.5):
    pmut = T(1.0) - pmut

  pmut = T(2.0) * (T(1.0) - pmut)

  if d.df == 2:
    return T(sign * sqrt(T(2.0) / (pmut * (T(2.0) - pmut)) - T(2.0)))

  let halfPi = T(PI) / T(2.0)

  if d.df == 1:
    pmut = pmut * halfPi
    return T(sign * cos(pmut) / sin(pmut))

  var a = T(1.0) / (fd - T(0.5))
  var b = T(48.0) / (a * a)
  var c = ((T(20700.0) * a / b - T(98.0)) * a - T(16.0)) * a + T(96.36)
  var d0 = ((T(94.5) / (b + c) - T(3.0)) / b + T(1.0)) * sqrt(a * halfPi) * fd
  var x = d0 * pmut
  var y = pow(x, T(2.0) / fd)

  if y > T(0.05) + a:
    x = sqrt(T(2.0)) * inverse_erf(pmut - T(1.0))
    y = pow2(x)
    if d.df < 5:
      c += T(0.3) * (fd - T(4.5)) * (x + T(0.6))
    c = (((T(0.05) * d0 * x - T(5.0)) * x - T(7.0)) * x - T(2.0)) * x + b + c
    y = (((((T(0.4) * y + T(6.3)) * y + T(36.0)) * y + T(94.5)) / c - y -
        T(3.0)) / b + T(1.0)) * x
    y = a * y * y
    y = if y > T(0.002): exp(y) - T(1.0) else: T(0.5) * y * y + y
  else:
    y = ((T(1.0) / (((fd + T(6.0)) / (fd * y) - T(0.089) * d0 - T(0.822)) *
        (fd + T(2.0)) * T(3.0)) + T(0.5) / (fd + T(4.0))) * y - T(1.0)) *
        (fd + T(1.0)) / (fd + T(2.0)) + T(1.0) / y

  T(sign * sqrt(fd * y))

{.pop.}
