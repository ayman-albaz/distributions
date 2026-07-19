{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import special_functions
import distributions/[base, mathutils]

## Gamma distribution — continuous distribution with shape ``k``
## and scale ``theta`` (mean = ``k·theta``).
## <https://en.wikipedia.org/wiki/Gamma_distribution>

type
  GammaDistribution*[T: SomeFloat] = object of DistributionContinuous
    k*: T
    theta*: T

func initGammaDistribution*[T: SomeFloat](
    k, theta: T): GammaDistribution[T] {.raises: [ValueError].} =
  ## Construct a Gamma distribution with shape `k` and scale `theta`.
  ## Both must be > 0.
  validatePositive("k", k)
  validatePositive("theta", theta)
  result.k = k
  result.theta = theta

func mean*[T: SomeFloat](d: GammaDistribution[T]): T =
  ## Mean: ``k·theta``.
  d.k * d.theta

func median*[T: SomeFloat](d: GammaDistribution[T]): T =
  ## Median is the 0.5-quantile via `inverse_regularized_lower_incomplete_gamma`.
  d.ppf(T(0.5))

func mode*[T: SomeFloat](d: GammaDistribution[T]): T =
  ## Returns `T(0.0)` for `k < 1` (pdf diverges to infinity at 0;
  ## we return 0 as the limiting boundary point).
  if d.k < T(1.0):
    T(0.0)
  else:
    d.theta * (d.k - T(1.0))

func variance*[T: SomeFloat](d: GammaDistribution[T]): T =
  ## Variance: ``k·theta²``.
  d.k * pow2(d.theta)

func pdf*[T: SomeFloat](d: GammaDistribution[T], x: T): T =
  ## Probability Density Function (PDF) for GammaDistribution.
  if x < T(0.0):
    return T(0.0)
  if x == T(0.0):
    if d.k == T(1.0):
      return T(1.0) / d.theta
    return T(0.0)
  exp((d.k - T(1.0)) * ln(x) - x / d.theta - lgamma(d.k) - d.k * ln(d.theta))

func cdf*[T: SomeFloat](d: GammaDistribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for GammaDistribution.
  if x <= T(0.0):
    T(0.0)
  else:
    regularized_lower_incomplete_gamma(d.k, x / d.theta)

func sf*[T: SomeFloat](d: GammaDistribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for GammaDistribution.
  T(1.0) - d.cdf(x)

func ppf*[T: SomeFloat](d: GammaDistribution[T], p: T): T =
  ## Percent Point Function (quantile, inverse CDF) for GammaDistribution.
  if p <= T(0.0):
    T(0.0)
  elif p >= T(1.0):
    Inf
  else:
    let v = inverse_regularized_lower_incomplete_gamma(d.k, p)
    if v <= T(0.0):
      Inf
    else:
      v * d.theta

{.pop.}
