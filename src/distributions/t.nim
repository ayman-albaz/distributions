{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import special_functions
import results
import distributions/[base, errors, mathutils]

## Student's t-distribution — continuous distribution with fractional
## degrees of freedom ``df``.
## <https://en.wikipedia.org/wiki/Student%27s_t-distribution>

type TDistribution*[T: SomeFloat] = object of DistributionContinuous
  ## Student's t-distribution with ``df`` degrees of freedom.
  df*: T ## Degrees of freedom (``df > 0``; may be non-integer).

func initTDistribution*[T: SomeFloat](df: T): Result[TDistribution[T], DistError] =
  ## Construct a Student's t-distribution with `df` degrees of freedom
  ## (may be non-integer). `df` must be > 0.
  ?validatePositive(df)
  ok(TDistribution[T](df: df))

func mean*[T: SomeFloat](d: TDistribution[T]): Result[T, DistError] =
  ## Mean: ``0`` for ``df > 1``. Returns error for ``df ≤ 1``.
  if d.df > T(1.0):
    ok(T(0.0))
  else:
    err(DistError.deMeanUndefined)

func median*[T: SomeFloat](d: TDistribution[T]): T =
  ## Median: ``0``.
  T(0.0)

func mode*[T: SomeFloat](d: TDistribution[T]): T =
  ## Mode: ``0``.
  T(0.0)

func variance*[T: SomeFloat](d: TDistribution[T]): Result[T, DistError] =
  ## Variance: ``df / (df-2)`` for ``df > 2``. Returns error for ``df ≤ 2``.
  if d.df <= T(2.0):
    return err(DistError.deVarianceUndefined)
  ok(d.df / (d.df - T(2.0)))

func pdf*[T: SomeFloat](d: TDistribution[T], x: T): T =
  ## Probability Density Function (PDF) for TDistribution:
  ## ``Γ((df+1)/2) / (√(df·π) · Γ(df/2)) · (1 + x²/df)^(-(df+1)/2)``.
  ## `x` is the value at which the density is evaluated.
  ## Supports non-integer degrees of freedom.
  let c1 = lgamma((d.df + T(1.0)) / T(2.0)) - lgamma(d.df / T(2.0))
  let c2 = T(0.5) * ln(T(PI) * d.df)
  exp(c1 - c2 - ((d.df + T(1.0)) / T(2.0)) * ln(T(1.0) + pow2(x) / d.df))

func cdf*[T: SomeFloat](d: TDistribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for TDistribution.
  ## `x` is the value at which the CDF is evaluated.
  ## Supports non-integer degrees of freedom via the incomplete-beta
  ## identity ``I_x(df/2, df/2)``.
  let s = sqrt(x * x + d.df)
  regularized_lower_incomplete_beta(
    d.df / T(2.0), d.df / T(2.0), (x + s) / (T(2.0) * s)
  )

func sf*[T: SomeFloat](d: TDistribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for TDistribution.
  ## `x` is the value at which the SF is evaluated.
  T(1.0) - d.cdf(x)

func ppfBisect[T: SomeFloat](d: TDistribution[T], p: T): T =
  ## Percent Point Function for ``df < 1`` via bisection on the (correct)
  ## CDF. Hill's Algorithm 396 assumes ``df >= 1``; for smaller ``df`` the
  ## quantile is bracketed from the ``df = 1`` (Cauchy) closed form and
  ## bisected ~60 iterations to ~1e-12 relative tolerance.
  let sign =
    if p < T(0.5):
      T(-1.0)
    else:
      T(1.0)
  let pt =
    if p < T(0.5):
      T(1.0) - p
    else:
      p
  var lo = tan(T(PI) * (pt - T(0.5)))
  if lo == T(0.0):
    return T(0.0)
  var hi = lo
  while d.cdf(hi) < pt:
    hi = hi * T(2.0)
  for iter in 0 ..< 60:
    let mid = T(0.5) * (lo + hi)
    if d.cdf(mid) < pt:
      lo = mid
    else:
      hi = mid
    if hi - lo <= T(1e-12) * (T(1.0) + abs(mid)):
      break
  sign * T(0.5) * (lo + hi)

func ppf*[T: SomeFloat](d: TDistribution[T], q: T): T =
  ## Percent Point Function (quantile, inverse CDF) for TDistribution.
  ## `q` is the quantile probability.
  ##
  ## Port of Algorithm 396 (Hill, 1970): Student's t-quantiles.
  ## Supports non-integer degrees of freedom.
  ## Returns `-Inf` for `q <= 0`, `Inf` for `q >= 1`.
  ## For ``df < 1`` uses bisection on the CDF (Algorithm 396 assumes
  ## ``df >= 1``).
  if q <= T(0.0):
    return -Inf
  if q >= T(1.0):
    return Inf
  if d.df < T(1.0):
    return d.ppfBisect(q)

  let sign =
    if q < T(0.5):
      T(-1.0)
    else:
      T(1.0)
  var pmut: T = q
  if q < T(0.5):
    pmut = T(1.0) - pmut

  pmut = T(2.0) * (T(1.0) - pmut)

  if d.df == T(2.0):
    return T(sign * sqrt(T(2.0) / (pmut * (T(2.0) - pmut)) - T(2.0)))

  let halfPi = T(PI) / T(2.0)

  if d.df == T(1.0):
    pmut = pmut * halfPi
    return T(sign * cos(pmut) / sin(pmut))

  var a = T(1.0) / (d.df - T(0.5))
  var b = T(48.0) / (a * a)
  var c = ((T(20700.0) * a / b - T(98.0)) * a - T(16.0)) * a + T(96.36)
  var d0 = ((T(94.5) / (b + c) - T(3.0)) / b + T(1.0)) * sqrt(a * halfPi) * d.df
  var x = d0 * pmut
  var y = pow(x, T(2.0) / d.df)

  if y > T(0.05) + a:
    x = sqrt(T(2.0)) * inverse_erf(pmut - T(1.0))
    y = pow2(x)
    if d.df < T(5.0):
      c += T(0.3) * (d.df - T(4.5)) * (x + T(0.6))
    c = (((T(0.05) * d0 * x - T(5.0)) * x - T(7.0)) * x - T(2.0)) * x + b + c
    y =
      (
        ((((T(0.4) * y + T(6.3)) * y + T(36.0)) * y + T(94.5)) / c - y - T(3.0)) / b +
        T(1.0)
      ) * x
    y = a * y * y
    y =
      if y > T(0.002):
        exp(y) - T(1.0)
      else:
        T(0.5) * y * y + y
  else:
    y =
      (
        (
          T(1.0) / (
            ((d.df + T(6.0)) / (d.df * y) - T(0.089) * d0 - T(0.822)) * (d.df + T(2.0)) *
            T(3.0)
          ) + T(0.5) / (d.df + T(4.0))
        ) * y - T(1.0)
      ) * (d.df + T(1.0)) / (d.df + T(2.0)) + T(1.0) / y

  T(sign * sqrt(d.df * y))

proc sample*[T: SomeFloat](d: TDistribution[T], r: var Rand): T =
  ## Draw a t(df) variate as Z / sqrt(V/df), Z ~ N(0,1), V ~ χ²(df).
  ## `r` is the RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`.
  ## <https://en.wikipedia.org/wiki/Student%27s_t-distribution#Generating_random_variates>
  let z = T(gauss(r, 0.0, 1.0))
  let v = standardGamma(r, d.df * T(0.5)) * T(2.0)
  z / sqrt(v / d.df)

{.pop.}
