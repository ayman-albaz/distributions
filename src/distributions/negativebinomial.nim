{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import special_functions
import distributions/[base, mathutils]

## Negative binomial distribution — number of failures ``k``
## before ``r`` successes with success probability ``p``
## (mean = ``r·(1-p)/p``).
## <https://en.wikipedia.org/wiki/Negative_binomial_distribution>

type
  NegativeBinomialDistribution*[T: SomeFloat] = object of DistributionDiscrete
    r*: int
    p*: T

func initNegativeBinomialDistribution*[T: SomeFloat](
    r: int, p: T): NegativeBinomialDistribution[T] {.raises: [ValueError].} =
  ## Construct a Negative Binomial distribution with `r` failures before stopping
  ## and success probability `p`.  `r` must be >= 1; `p` must be in `[0, 1]`.
  validatePositive("r", r)
  validateFraction("p", p)
  result.r = r
  result.p = p

func mean*[T: SomeFloat](d: NegativeBinomialDistribution[T]): T =
  ## Mean: ``r·(1-p)/p``.
  T(d.r) * (T(1.0) - d.p) / d.p

proc median*[T: SomeFloat](d: NegativeBinomialDistribution[T]): T {.raises: [ValueError].} =
  ## Median is the 0.5-quantile via `discretePpf`.
  T(d.ppf(T(0.5)))

func mode*[T: SomeFloat](d: NegativeBinomialDistribution[T]): T =
  ## Mode: ``(r-1)·(1-p)/p`` for ``r > 1``, ``0`` for ``r = 1``.
  if d.r <= 1:
    T(0.0)
  else:
    T(d.r - 1) * (T(1.0) - d.p) / d.p

func variance*[T: SomeFloat](d: NegativeBinomialDistribution[T]): T =
  ## Variance: ``r·(1-p)/p²``.
  T(d.r) * (T(1.0) - d.p) / pow2(d.p)

func pmf*[T: SomeFloat](d: NegativeBinomialDistribution[T], k: int): T =
  ## Probability Mass Function (PMF) for NegativeBinomialDistribution.
  ##
  ## Counts failures `k` before `r` successes with success probability `p`.
  ## PMF(k) = C(k+r-1, k) · p^r · (1-p)^k.
  if k < 0:
    return T(0.0)
  if d.p == T(0.0):
    return T(0.0)
  exp(lfac(k + d.r - 1) - lfac(k) - lfac(d.r - 1) +
      T(d.r) * ln(d.p) + T(k) * ln(T(1.0) - d.p))

func cdf*[T: SomeFloat](d: NegativeBinomialDistribution[T], k: int): T =
  ## Cumulative Distribution Function (CDF) for NegativeBinomialDistribution.
  ## CDF is 1 - I_p(k+1, r), equivalently I_{1-p}(r, k+1).
  if k < 0:
    T(0.0)
  else:
    T(1.0) - regularized_lower_incomplete_beta(float(k + 1), float(d.r), d.p)

func sf*[T: SomeFloat](d: NegativeBinomialDistribution[T], k: int): T =
  ## Survival Function (SF): 1 - CDF for NegativeBinomialDistribution.
  T(1.0) - d.cdf(k)

proc ppf*[T: SomeFloat](d: NegativeBinomialDistribution[T], p: T): int {.raises: [ValueError].} =
  ## Percent Point Function (quantile, inverse CDF) for NegativeBinomialDistribution.
  ## Returns `0` for `p <= 0`.
  if p <= T(0.0):
    0
  else:
    discretePpf(proc(k: int): T {.closure, raises: [].} = d.cdf(k), p, start = 0)

{.pop.}
