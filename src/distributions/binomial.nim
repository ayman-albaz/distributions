{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import special_functions
import distributions/[base, mathutils]

## Binomial distribution — number of successes in ``n`` trials
## with success probability ``p ∈ [0,1]``.
## <https://en.wikipedia.org/wiki/Binomial_distribution>

type
  BinomialDistribution*[T: SomeFloat] = object of DistributionDiscrete
    n*: int
    p*: T

func initBinomialDistribution*[T: SomeFloat](
    n: int, p: T): BinomialDistribution[T] {.raises: [ValueError].} =
  ## Construct a Binomial distribution with `n` trials and success probability `p`.
  ## `n` must be >= 0; `p` must be in `[0, 1]`.
  validateNonNegative("n", n)
  validateFraction("p", p)
  result.n = n
  result.p = p

func mean*[T: SomeFloat](d: BinomialDistribution[T]): T =
  ## Mean: ``n·p``.
  T(d.n) * d.p

func median*[T: SomeFloat](d: BinomialDistribution[T]): T =
  ## Median: ``⌊n·p⌉`` (rounded to nearest integer).
  round(T(d.n) * d.p)

func mode*[T: SomeFloat](d: BinomialDistribution[T]): T =
  ## Mode: ``⌊(n+1)·p⌉`` (rounded to nearest integer).
  round((T(d.n) + T(1.0)) * d.p)

func variance*[T: SomeFloat](d: BinomialDistribution[T]): T =
  ## Variance: ``n·p·(1-p)``.
  T(d.n) * d.p * (T(1.0) - d.p)

func pmf*[T: SomeFloat](d: BinomialDistribution[T], k: int): T =
  ## Probability Mass Function (PMF) for BinomialDistribution.
  if k < 0 or k > d.n:
    return T(0.0)
  if d.p == T(0.0):
    return if k == 0: T(1.0) else: T(0.0)
  if d.p == T(1.0):
    return if k == d.n: T(1.0) else: T(0.0)
  exp(lfac(d.n) - lfac(k) - lfac(d.n - k) +
      T(k) * ln(d.p) + T(d.n - k) * ln(T(1.0) - d.p))

func cdf*[T: SomeFloat](d: BinomialDistribution[T], k: int): T =
  ## Cumulative Distribution Function (CDF) for BinomialDistribution.
  ##
  ## Uses the identity ``P(X ≤ k) = 1 - I_p(k+1, n-k) = I_{1-p}(n-k, k+1)``
  ## for numerical stability in the upper tail.
  if k < 0:
    T(0.0)
  elif k >= d.n:
    T(1.0)
  else:
    regularized_lower_incomplete_beta(float(d.n - k), float(k + 1), T(1.0) - d.p)

func sf*[T: SomeFloat](d: BinomialDistribution[T], k: int): T =
  ## Survival Function (SF): 1 - CDF for BinomialDistribution.
  T(1.0) - d.cdf(k)

proc ppf*[T: SomeFloat](d: BinomialDistribution[T], p: T): int {.raises: [ValueError].} =
  ## Percent Point Function (quantile, inverse CDF) for BinomialDistribution.
  ## Returns `0` for `p <= 0`, `n` for `p >= 1`.
  if p <= T(0.0):
    0
  elif p >= T(1.0):
    d.n
  else:
    discretePpf(proc(k: int): T {.closure, raises: [].} = d.cdf(k), p, start = 0)

{.pop.}
