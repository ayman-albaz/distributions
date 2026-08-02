{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import special_functions
import results
import distributions/[base, errors, mathutils]

## Poisson distribution — number of events in a fixed interval
## with rate ``lambda > 0``.
## <https://en.wikipedia.org/wiki/Poisson_distribution>

type PoissonDistribution*[T: SomeFloat] = object of DistributionDiscrete
  ## Poisson distribution with rate parameter ``lambda``.
  lambda*: T ## Rate parameter (``lambda > 0``); equals the mean and variance.

func initPoissonDistribution*[T: SomeFloat](
    lambda: T
): Result[PoissonDistribution[T], DistError] =
  ## Construct a Poisson distribution with rate parameter `lambda`.
  ## `lambda` must be > 0.
  ?validatePositive(lambda)
  ok(PoissonDistribution[T](lambda: lambda))

func mean*[T: SomeFloat](d: PoissonDistribution[T]): T =
  ## Mean: ``lambda``.
  d.lambda

proc median*[T: SomeFloat](d: PoissonDistribution[T]): Result[T, DistError] =
  ## Median is the 0.5-quantile via `discretePpf`.
  ## Returns `err(DistError.deNotConverged)` if the quantile search fails to
  ## converge (unreachable for valid monotone cdfs).
  d.ppf(T(0.5)).map(
    proc(k: int): T =
      T(k)
  )

func mode*[T: SomeFloat](d: PoissonDistribution[T]): T =
  ## Mode: ``⌊lambda⌋``.
  floor(d.lambda)

func variance*[T: SomeFloat](d: PoissonDistribution[T]): T =
  ## Variance: ``lambda``.
  d.lambda

func pmf*[T: SomeFloat](d: PoissonDistribution[T], k: int): T =
  ## Probability Mass Function (PMF) for PoissonDistribution:
  ## ``λ^k e^(-λ) / k!``, `0` for ``k < 0``.
  ## `k` is the number of events (``k >= 0``).
  if k < 0:
    return T(0.0)
  exp(T(k) * ln(d.lambda) - d.lambda - T(lfac(k)))

func cdf*[T: SomeFloat](d: PoissonDistribution[T], k: int): T =
  ## Cumulative Distribution Function (CDF) for PoissonDistribution.
  ## `k` is the number of events (``k >= 0``).
  if k < 0:
    T(0.0)
  else:
    regularized_upper_incomplete_gamma(T(k + 1), d.lambda)

func sf*[T: SomeFloat](d: PoissonDistribution[T], k: int): T =
  ## Survival Function (SF): 1 - CDF for PoissonDistribution.
  ## `k` is the number of events (``k >= 0``).
  T(1.0) - d.cdf(k)

proc ppf*[T: SomeFloat](d: PoissonDistribution[T], q: T): Result[int, DistError] =
  ## Percent Point Function (quantile, inverse CDF) for PoissonDistribution.
  ## `q` is the quantile probability. Returns `ok(0)` for `q <= 0`. Returns
  ## `ok(0)` for a `NaN` argument (the discrete `ppf` returns `int`, so
  ## `NaN` has no representation; the low clamp is the deterministic
  ## convention).
  ## Returns `err(DistError.deNotConverged)` if the quantile search fails to
  ## converge (unreachable for valid monotone cdfs).
  if isNaN(q) or q <= T(0.0):
    ok(0)
  else:
    discretePpf(
      proc(k: int): T {.closure, raises: [].} =
        d.cdf(k),
      q,
      start = 0,
    )

proc sample*[T: SomeFloat](d: PoissonDistribution[T], r: var Rand): int =
  ## Draw a Poisson(λ) variate via `mathutils.samplePoisson`.
  ## `r` is the RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`.
  ## <https://en.wikipedia.org/wiki/Poisson_distribution>
  samplePoisson(r, d.lambda)

{.pop.}
