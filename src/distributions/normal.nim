{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import special_functions
import distributions/[base, mathutils]

## Normal (Gaussian) distribution — continuous distribution with
## mean ``mu`` and standard deviation ``sigma > 0``.
## <https://en.wikipedia.org/wiki/Normal_distribution>

type
  NormalDistribution*[T: SomeFloat] = object of DistributionContinuous
    mu*: T
    sigma*: T

func initNormalDistribution*[T: SomeFloat](
    mu, sigma: T): NormalDistribution[T] {.raises: [ValueError].} =
  ## Construct a Normal distribution with mean `mu` and standard deviation `sigma`.
  ## `sigma` must be > 0.
  validatePositive("sigma", sigma)
  result.mu = mu
  result.sigma = sigma

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
  ## Probability Density Function (PDF) for NormalDistribution.
  exp(-pow2(x - d.mu) / (T(2.0) * pow2(d.sigma)) -
      ln(d.sigma) - T(0.5) * ln(T(2.0) * T(PI)))

func cdf*[T: SomeFloat](d: NormalDistribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for NormalDistribution.
  T(0.5) * (T(1.0) + erf((x - d.mu) / (d.sigma * sqrt(T(2.0)))))

func sf*[T: SomeFloat](d: NormalDistribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for NormalDistribution.
  T(1.0) - d.cdf(x)

func ppf*[T: SomeFloat](d: NormalDistribution[T], p: T): T =
  ## Percent Point Function (quantile, inverse CDF) for NormalDistribution.
  if p <= T(0.0):
    -Inf
  elif p >= T(1.0):
    Inf
  else:
    d.mu + d.sigma * sqrt(T(2.0)) * inverse_erf(T(2.0) * p - T(1.0))

proc sample*[T: SomeFloat](d: NormalDistribution[T], r: var Rand): T {.raises: [CatchableError].} =
  ## Draw a random sample from the Normal distribution using the given `r` RNG.
  ##
  ## .. code-block:: nim
  ##   import std/random
  ##   var r = initRand(0xDEADBEEF)
  ##   let d = initNormalDistribution(0.0, 1.0)
  ##   echo d.sample(r)
  T(gauss(r, d.mu, d.sigma))

{.pop.}
