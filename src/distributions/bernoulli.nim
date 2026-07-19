{.experimental: "strictFuncs".}
{.push raises: [].}

import std/random
import distributions/[base]

## Bernoulli distribution — discrete distribution with two outcomes:
## ``P(1) = p``, ``P(0) = 1-p``.
## <https://en.wikipedia.org/wiki/Bernoulli_distribution>

type
  BernoulliDistribution*[T: SomeFloat] = object of DistributionDiscrete
    p*: T

func initBernoulliDistribution*[T: SomeFloat](
    p: T): BernoulliDistribution[T] {.raises: [ValueError].} =
  ## Construct a Bernoulli distribution with success probability `p`.
  ## `p` must be in `[0, 1]`.
  validateFraction("p", p)
  result.p = p

func mean*[T: SomeFloat](d: BernoulliDistribution[T]): T =
  ## Mean: ``p``.
  d.p

func median*[T: SomeFloat](d: BernoulliDistribution[T]): T =
  ## Median: ``0`` if ``p < 0.5``, ``1`` if ``p > 0.5``, ``0.5`` if ``p = 0.5``.
  if d.p < T(0.5): T(0.0)
  elif d.p > T(0.5): T(1.0)
  else: T(0.5)

func mode*[T: SomeFloat](d: BernoulliDistribution[T]): T {.raises: [ValueError].} =
  ## Mode: ``0`` if ``p < 0.5``, ``1`` if ``p > 0.5``.
  ## Raises ``ValueError`` for ``p = 0.5``.
  if d.p < T(0.5):
    T(0.0)
  elif d.p > T(0.5):
    T(1.0)
  else:
    raise newException(ValueError, "mode ambiguous for p=0.5")

func variance*[T: SomeFloat](d: BernoulliDistribution[T]): T =
  ## Variance: ``p·(1-p)``.
  d.p * (T(1.0) - d.p)

func pmf*[T: SomeFloat](d: BernoulliDistribution[T], k: int): T =
  ## Probability Mass Function (PMF) for BernoulliDistribution.
  if k == 0:
    T(1.0) - d.p
  elif k == 1:
    d.p
  else:
    T(0.0)

func cdf*[T: SomeFloat](d: BernoulliDistribution[T], k: int): T =
  ## Cumulative Distribution Function (CDF) for BernoulliDistribution.
  if k < 0:
    T(0.0)
  elif k == 0:
    T(1.0) - d.p
  else:
    T(1.0)

func sf*[T: SomeFloat](d: BernoulliDistribution[T], k: int): T =
  ## Survival Function (SF): 1 - CDF for BernoulliDistribution.
  T(1.0) - d.cdf(k)

func ppf*[T: SomeFloat](d: BernoulliDistribution[T], p: T): int =
  ## Percent Point Function (quantile, inverse CDF) for BernoulliDistribution.
  ## Returns `0` for `p <= 0`, `1` for `p >= 1`.
  if p <= T(0.0):
    0
  elif p >= T(1.0):
    1
  elif p <= T(1.0) - d.p:
    0
  else:
    1

proc sample*[T: SomeFloat](d: BernoulliDistribution[T], r: var Rand): int {.raises: [CatchableError].} =
  ## Draw a Bernoulli variate: 1 with probability p, 0 otherwise.
  if T(r.rand(1.0)) < d.p: 1 else: 0

{.pop.}
