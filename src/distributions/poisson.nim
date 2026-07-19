{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import special_functions
import distributions/[base, mathutils]

## Poisson distribution — number of events in a fixed interval
## with rate ``lambda > 0``.
## <https://en.wikipedia.org/wiki/Poisson_distribution>

type
  PoissonDistribution*[T: SomeFloat] = object of DistributionDiscrete
    lambda*: T

func initPoissonDistribution*[T: SomeFloat](
    lambda: T): PoissonDistribution[T] {.raises: [ValueError].} =
  ## Construct a Poisson distribution with rate parameter `lambda`.
  ## `lambda` must be > 0.
  validatePositive("lambda", lambda)
  result.lambda = lambda

func mean*[T: SomeFloat](d: PoissonDistribution[T]): T =
  ## Mean: ``lambda``.
  d.lambda

proc median*[T: SomeFloat](d: PoissonDistribution[T]): T {.raises: [ValueError].} =
  ## Median is the 0.5-quantile via `discretePpf`.
  T(d.ppf(T(0.5)))

func mode*[T: SomeFloat](d: PoissonDistribution[T]): T =
  ## Mode: ``⌊lambda⌋``.
  floor(d.lambda)

func variance*[T: SomeFloat](d: PoissonDistribution[T]): T =
  ## Variance: ``lambda``.
  d.lambda

func pmf*[T: SomeFloat](d: PoissonDistribution[T], k: int): T =
  ## Probability Mass Function (PMF) for PoissonDistribution.
  if k < 0:
    return T(0.0)
  exp(T(k) * ln(d.lambda) - d.lambda - lfac(k))

func cdf*[T: SomeFloat](d: PoissonDistribution[T], k: int): T =
  ## Cumulative Distribution Function (CDF) for PoissonDistribution.
  if k < 0:
    T(0.0)
  else:
    regularized_upper_incomplete_gamma(T(k + 1), d.lambda)

func sf*[T: SomeFloat](d: PoissonDistribution[T], k: int): T =
  ## Survival Function (SF): 1 - CDF for PoissonDistribution.
  T(1.0) - d.cdf(k)

proc ppf*[T: SomeFloat](d: PoissonDistribution[T], p: T): int {.raises: [ValueError].} =
  ## Percent Point Function (quantile, inverse CDF) for PoissonDistribution.
  ## Returns `0` for `p <= 0`.
  if p <= T(0.0):
    0
  else:
    discretePpf(proc(k: int): T {.closure, raises: [].} = d.cdf(k), p, start = 0)

proc sample*[T: SomeFloat](d: PoissonDistribution[T], r: var Rand): int {.raises: [CatchableError].} =
  ## Draw a Poisson(λ) variate via `mathutils.samplePoisson`.
  ## <https://en.wikipedia.org/wiki/Poisson_distribution#Generating_Poisson-distributed_random_variables>
  samplePoisson(r, d.lambda)

{.pop.}
