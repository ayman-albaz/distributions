{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import special_functions
import results
import distributions/[base, errors, mathutils]

## Normal (Gaussian) distribution — continuous distribution with
## mean ``mu`` and standard deviation ``sigma > 0``.
## <https://en.wikipedia.org/wiki/Normal_distribution>

type NormalDistribution*[T: SomeFloat] = object of DistributionContinuous
  ## Normal distribution with mean ``mu`` and standard deviation ``sigma``.
  mu*: T ## Mean (any real).
  sigma*: T ## Standard deviation (``sigma > 0``).

func initNormalDistribution*[T: SomeFloat](
    mu, sigma: T
): Result[NormalDistribution[T], DistError] =
  ## Construct a Normal distribution with mean `mu` and standard deviation `sigma`.
  ## `sigma` must be > 0; rejects NaN.
  ?validateNotNaN(mu)
  ?validatePositive(sigma)
  ok(NormalDistribution[T](mu: mu, sigma: sigma))

func mean*[T: SomeFloat](d: NormalDistribution[T]): T =
  ## Mean: ``mu``.
  d.mu

func median*[T: SomeFloat](d: NormalDistribution[T]): T =
  ## Median: ``mu``.
  d.mu

func mode*[T: SomeFloat](d: NormalDistribution[T]): T =
  ## Mode: ``mu``.
  d.mu

func variance*[T: SomeFloat](d: NormalDistribution[T]): T =
  ## Variance: ``sigma²``.
  pow2(d.sigma)

func pdf*[T: SomeFloat](d: NormalDistribution[T], x: T): T =
  ## Probability Density Function (PDF) for NormalDistribution:
  ## ``exp(-(x-μ)²/(2σ²)) / (σ√(2π))``.
  ## `x` is the value at which the density is evaluated.
  exp(
    -pow2(x - d.mu) / (T(2.0) * pow2(d.sigma)) - ln(d.sigma) -
      T(0.5) * ln(T(2.0) * T(PI))
  )

func cdf*[T: SomeFloat](d: NormalDistribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for NormalDistribution:
  ## ``Φ((x-μ)/σ) = (1 + erf((x-μ)/(σ√2))) / 2``.
  ## `x` is the value at which the CDF is evaluated.
  T(0.5) * (T(1.0) + erf((x - d.mu) / (d.sigma * sqrt(T(2.0)))))

func sf*[T: SomeFloat](d: NormalDistribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for NormalDistribution.
  ## `x` is the value at which the SF is evaluated.
  T(1.0) - d.cdf(x)

func ppf*[T: SomeFloat](d: NormalDistribution[T], q: T): T =
  ## Percent Point Function (quantile, inverse CDF) for NormalDistribution.
  ## `q` is the quantile probability. Returns `-Inf` for `q <= 0`, `Inf` for
  ## `q >= 1`.
  if q <= T(0.0):
    -Inf
  elif q >= T(1.0):
    Inf
  else:
    d.mu + d.sigma * sqrt(T(2.0)) * inverse_erf(T(2.0) * q - T(1.0))

proc sample*[T: SomeFloat](d: NormalDistribution[T], r: var Rand): T =
  ## Draw a random sample from the Normal distribution using the given
  ## `r: var Rand` RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`.
  ##
  ## .. code-block:: nim
  ##   import std/random
  ##   var r = initRand(0xDEADBEEF)
  ##   let d = initNormalDistribution(0.0, 1.0)
  ##   echo d.sample(r)
  T(gauss(r, d.mu, d.sigma))

{.pop.}
