{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import special_functions
import results
import distributions/[base, errors, mathutils]

## Gamma distribution — continuous distribution with shape ``k``
## and scale ``theta`` (mean = ``k·theta``).
## <https://en.wikipedia.org/wiki/Gamma_distribution>

type GammaDistribution*[T: SomeFloat] = object of DistributionContinuous
  ## Gamma distribution with shape ``k`` and scale ``theta``.
  k*: T ## Shape parameter (``k > 0``).
  theta*: T ## Scale parameter (``theta > 0``).

func initGammaDistribution*[T: SomeFloat](
    k, theta: T
): Result[GammaDistribution[T], DistError] =
  ## Construct a Gamma distribution with shape `k` and scale `theta`.
  ## Both must be > 0.
  ?validatePositive(k)
  ?validatePositive(theta)
  ok(GammaDistribution[T](k: k, theta: theta))

func mean*[T: SomeFloat](d: GammaDistribution[T]): T =
  ## Mean: ``k·theta``.
  d.k * d.theta

func median*[T: SomeFloat](d: GammaDistribution[T]): T =
  ## Median is the 0.5-quantile via `inverse_regularized_lower_incomplete_gamma`.
  d.ppf(T(0.5))

func mode*[T: SomeFloat](d: GammaDistribution[T]): T =
  ## Mode: ``theta·(k-1)`` for ``k > 1``. Returns `0` for `k <= 1`
  ## (density is unbounded at 0; `0` is the boundary convention).
  if d.k < T(1.0):
    T(0.0)
  else:
    d.theta * (d.k - T(1.0))

func variance*[T: SomeFloat](d: GammaDistribution[T]): T =
  ## Variance: ``k·theta²``.
  d.k * pow2(d.theta)

func pdf*[T: SomeFloat](d: GammaDistribution[T], x: T): T =
  ## Probability Density Function (PDF) for GammaDistribution:
  ## ``x^(k-1) e^(-x/θ) / (θ^k Γ(k))``.
  ## `x` is the value at which the density is evaluated.
  if x < T(0.0):
    return T(0.0)
  if x == T(0.0):
    if d.k < T(1.0):
      return Inf
    if d.k == T(1.0):
      return T(1.0) / d.theta
    return T(0.0)
  exp((d.k - T(1.0)) * ln(x) - x / d.theta - lgamma(d.k) - d.k * ln(d.theta))

func cdf*[T: SomeFloat](d: GammaDistribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for GammaDistribution:
  ## ``P(k, x/θ)`` (regularized lower incomplete gamma).
  ## `x` is the value at which the CDF is evaluated.
  if x <= T(0.0):
    T(0.0)
  else:
    regularized_lower_incomplete_gamma(d.k, x / d.theta)

func sf*[T: SomeFloat](d: GammaDistribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for GammaDistribution.
  ## `x` is the value at which the SF is evaluated.
  T(1.0) - d.cdf(x)

func ppf*[T: SomeFloat](d: GammaDistribution[T], q: T): T =
  ## Percent Point Function (quantile, inverse CDF) for GammaDistribution.
  ## `q` is the quantile probability. Returns `0` for `q <= 0`, `Inf` for
  ## `q >= 1`.
  if q <= T(0.0):
    T(0.0)
  elif q >= T(1.0):
    Inf
  else:
    inverse_regularized_lower_incomplete_gamma(d.k, q) * d.theta

proc sample*[T: SomeFloat](d: GammaDistribution[T], r: var Rand): T =
  ## Draw a Gamma(k, θ) variate via Marsaglia-Tsang, scaled by θ.
  ## `r` is the RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`.
  ## <https://en.wikipedia.org/wiki/Gamma_distribution>
  standardGamma(r, d.k) * d.theta

{.pop.}
