{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import special_functions
import results
import distributions/[base, errors, mathutils]

## Binomial distribution — number of successes in ``n`` trials
## with success probability ``p ∈ [0,1]``.
## <https://en.wikipedia.org/wiki/Binomial_distribution>

type BinomialDistribution*[T: SomeFloat] = object of DistributionDiscrete
  ## Binomial distribution with `n` trials and success probability ``p``.
  n*: int ## Number of trials (``n >= 0``).
  p*: T ## Success probability per trial (``p ∈ [0, 1]``).

func initBinomialDistribution*[T: SomeFloat](
    n: int, p: T
): Result[BinomialDistribution[T], DistError] =
  ## Construct a Binomial distribution with `n` trials and success probability `p`.
  ## `n` must be >= 0; `p` must be in `[0, 1]`.
  ?validateNonNegative(n)
  ?validateFraction(p)
  ok(BinomialDistribution[T](n: n, p: p))

func mean*[T: SomeFloat](d: BinomialDistribution[T]): T =
  ## Mean: ``n·p``.
  T(d.n) * d.p

func median*[T: SomeFloat](d: BinomialDistribution[T]): T =
  ## Median: ``⌊n·p⌉`` (rounded to nearest integer).
  round(T(d.n) * d.p)

func mode*[T: SomeFloat](d: BinomialDistribution[T]): T =
  ## Mode: ``⌊(n+1)·p⌉`` (rounded to nearest integer), clamped to `n`.
  min(round((T(d.n) + T(1.0)) * d.p), T(d.n))

func variance*[T: SomeFloat](d: BinomialDistribution[T]): T =
  ## Variance: ``n·p·(1-p)``.
  T(d.n) * d.p * (T(1.0) - d.p)

func pmf*[T: SomeFloat](d: BinomialDistribution[T], k: int): T =
  ## Probability Mass Function (PMF) for BinomialDistribution:
  ## ``C(n, k) p^k (1-p)^(n-k)``, `0` for ``k < 0`` or ``k > n``.
  ## `k` is the number of successes (``0 <= k <= n``).
  if k < 0 or k > d.n:
    return T(0.0)
  if d.p == T(0.0):
    return
      if k == 0:
        T(1.0)
      else:
        T(0.0)
  if d.p == T(1.0):
    return
      if k == d.n:
        T(1.0)
      else:
        T(0.0)
  exp(
    T(lfac(d.n)) - T(lfac(k)) - T(lfac(d.n - k)) + T(k) * ln(d.p) +
      T(d.n - k) * ln(T(1.0) - d.p)
  )

func cdf*[T: SomeFloat](d: BinomialDistribution[T], k: int): T =
  ## Cumulative Distribution Function (CDF) for BinomialDistribution.
  ## `k` is the number of successes (``0 <= k <= n``).
  ##
  ## Uses the identity ``P(X ≤ k) = 1 - I_p(k+1, n-k) = I_{1-p}(n-k, k+1)``
  ## for numerical stability in the upper tail.
  if k < 0:
    T(0.0)
  elif k >= d.n:
    T(1.0)
  else:
    regularized_lower_incomplete_beta(T(d.n - k), T(k + 1), T(1.0) - d.p)

func sf*[T: SomeFloat](d: BinomialDistribution[T], k: int): T =
  ## Survival Function (SF): 1 - CDF for BinomialDistribution.
  ## `k` is the number of successes (``0 <= k <= n``).
  T(1.0) - d.cdf(k)

proc ppf*[T: SomeFloat](d: BinomialDistribution[T], q: T): Result[int, DistError] =
  ## Percent Point Function (quantile, inverse CDF) for BinomialDistribution.
  ## `q` is the quantile probability, distinct from the distribution's
  ## success probability `p`. Returns `ok(0)` for `q <= 0`, `ok(n)` for
  ## `q >= 1`. Returns `ok(0)` for a `NaN` argument (the discrete `ppf`
  ## returns `int`, so `NaN` has no representation; the low clamp is the
  ## deterministic convention).
  ## Returns `err(DistError.NotConverged)` if the quantile search fails to
  ## converge (unreachable for valid monotone cdfs).
  if isNaN(q) or q <= T(0.0):
    ok(0)
  elif q >= T(1.0):
    ok(d.n)
  else:
    discretePpf(
      proc(k: int): T {.closure, raises: [].} =
        d.cdf(k),
      q,
      start = 0,
    )

proc sample*[T: SomeFloat](d: BinomialDistribution[T], r: var Rand): int =
  ## Draw a Binomial(n, p) variate via `mathutils.sampleBinomial`.
  ## `r` is the RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`.
  ## <https://en.wikipedia.org/wiki/Binomial_distribution#Generating_random_numbers>
  sampleBinomial(r, d.n, d.p)

{.pop.}
