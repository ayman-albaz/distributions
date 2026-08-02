{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import results
import distributions/[base, errors]

## Bernoulli distribution — discrete distribution with two outcomes:
## ``P(1) = p``, ``P(0) = 1-p``.
## <https://en.wikipedia.org/wiki/Bernoulli_distribution>

type BernoulliDistribution*[T: SomeFloat] = object of DistributionDiscrete
  ## Bernoulli distribution with success probability ``p``.
  p*: T ## Success probability: ``P(X = 1) = p``, ``P(X = 0) = 1 - p``

func initBernoulliDistribution*[T: SomeFloat](
    p: T
): Result[BernoulliDistribution[T], DistError] =
  ## Construct a Bernoulli distribution with success probability `p`.
  ## `p` must be in `[0, 1]`.
  ?validateFraction(p)
  ok(BernoulliDistribution[T](p: p))

func mean*[T: SomeFloat](d: BernoulliDistribution[T]): T =
  ## Mean: ``p``.
  d.p

func median*[T: SomeFloat](d: BernoulliDistribution[T]): T =
  ## Median: ``0`` if ``p < 0.5``, ``1`` if ``p > 0.5``, ``0.5`` if ``p = 0.5``.
  if d.p < T(0.5):
    T(0.0)
  elif d.p > T(0.5):
    T(1.0)
  else:
    T(0.5)

func mode*[T: SomeFloat](d: BernoulliDistribution[T]): Result[T, DistError] =
  ## Mode: ``0`` if ``p < 0.5``, ``1`` if ``p > 0.5``.
  ## Returns error for ``p = 0.5``.
  if d.p < T(0.5):
    ok(T(0.0))
  elif d.p > T(0.5):
    ok(T(1.0))
  else:
    err(DistError.modeUndefined)

func variance*[T: SomeFloat](d: BernoulliDistribution[T]): T =
  ## Variance: ``p·(1-p)``.
  d.p * (T(1.0) - d.p)

func pmf*[T: SomeFloat](d: BernoulliDistribution[T], k: int): T =
  ## Probability Mass Function (PMF) for BernoulliDistribution:
  ## ``P(X = 0) = 1 - p``, ``P(X = 1) = p``, `0` otherwise.
  ## `k` is the outcome (0 or 1).
  if k == 0:
    T(1.0) - d.p
  elif k == 1:
    d.p
  else:
    T(0.0)

func cdf*[T: SomeFloat](d: BernoulliDistribution[T], k: int): T =
  ## Cumulative Distribution Function (CDF) for BernoulliDistribution:
  ## `0` for ``k < 0``, ``1 - p`` for ``0 <= k < 1``, `1` for ``k >= 1``.
  ## `k` is the outcome (0 or 1).
  if k < 0:
    T(0.0)
  elif k == 0:
    T(1.0) - d.p
  else:
    T(1.0)

func sf*[T: SomeFloat](d: BernoulliDistribution[T], k: int): T =
  ## Survival Function (SF): 1 - CDF for BernoulliDistribution.
  ## `k` is the outcome (0 or 1).
  T(1.0) - d.cdf(k)

func ppf*[T: SomeFloat](d: BernoulliDistribution[T], q: T): int =
  ## Percent Point Function (quantile, inverse CDF) for BernoulliDistribution.
  ## `q` is the quantile probability, distinct from the distribution's
  ## success probability `p`. Returns `0` for `q <= 0`, `1` for `q >= 1`.
  ## Returns `0` for a `NaN` argument (the discrete `ppf` returns `int`, so
  ## `NaN` has no representation; the low clamp is the deterministic
  ## convention).
  if isNaN(q) or q <= T(0.0):
    0
  elif q >= T(1.0):
    1
  elif q <= T(1.0) - d.p:
    0
  else:
    1

proc sample*[T: SomeFloat](d: BernoulliDistribution[T], r: var Rand): int =
  ## Draw a Bernoulli variate: 1 with probability p, 0 otherwise.
  ## `r` is the RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`.
  if T(r.rand(1.0)) < d.p:
    result = 1
  else:
    result = 0

{.pop.}
