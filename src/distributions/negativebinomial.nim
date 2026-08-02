{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import special_functions
import results
import distributions/[base, errors, mathutils]

## Negative binomial distribution — number of failures ``k``
## before ``r`` successes with success probability ``p``
## (mean = ``r·(1-p)/p``).
## <https://en.wikipedia.org/wiki/Negative_binomial_distribution>

type NegativeBinomialDistribution*[T: SomeFloat] = object of DistributionDiscrete
  ## Negative binomial distribution: failures ``k`` before ``r`` successes
  ## with success probability ``p``.
  r*: int ## Number of successes before stopping (``r >= 1``).
  p*: T ## Success probability per trial (``p ∈ [0, 1]``).

func initNegativeBinomialDistribution*[T: SomeFloat](
    r: int, p: T
): Result[NegativeBinomialDistribution[T], DistError] =
  ## Construct a Negative Binomial distribution: number of failures `k`
  ## before the `r`-th success, success probability `p`.
  ## `r` must be >= 1; `p` must be in `[0, 1]`.
  ## `p = 0` is degenerate and accepted: `pmf`/`cdf` report the pointwise
  ## limits (`0`), while the moments report the `p → 0⁺` limit (`Inf`).
  ?validatePositive(r)
  ?validateFraction(p)
  ok(NegativeBinomialDistribution[T](r: r, p: p))

func mean*[T: SomeFloat](d: NegativeBinomialDistribution[T]): T =
  ## Mean: ``r·(1-p)/p``. At ``p = 0`` (degenerate) reports the
  ## ``p → 0⁺`` limit (`Inf`), while `pmf`/`cdf` are the pointwise
  ## limits (`0`).
  T(d.r) * (T(1.0) - d.p) / d.p

proc median*[T: SomeFloat](d: NegativeBinomialDistribution[T]): Result[T, DistError] =
  ## Median is the 0.5-quantile via `discretePpf`.
  ## Returns `err(DistError.NotConverged)` if the quantile search fails to
  ## converge (unreachable for valid monotone cdfs).
  d.ppf(T(0.5)).map(
    proc(k: int): T =
      T(k)
  )

func mode*[T: SomeFloat](d: NegativeBinomialDistribution[T]): T =
  ## Mode: ``(r-1)·(1-p)/p`` for ``r > 1``, ``0`` for ``r = 1``.
  ## At ``p = 0`` (degenerate) reports the ``p → 0⁺`` limit (`Inf` for
  ## ``r > 1``), while `pmf`/`cdf` are the pointwise limits (`0`).
  if d.r <= 1:
    T(0.0)
  else:
    T(d.r - 1) * (T(1.0) - d.p) / d.p

func variance*[T: SomeFloat](d: NegativeBinomialDistribution[T]): T =
  ## Variance: ``r·(1-p)/p²``. At ``p = 0`` (degenerate) reports the
  ## ``p → 0⁺`` limit (`Inf`), while `pmf`/`cdf` are the pointwise
  ## limits (`0`).
  T(d.r) * (T(1.0) - d.p) / pow2(d.p)

func pmf*[T: SomeFloat](d: NegativeBinomialDistribution[T], k: int): T =
  ## Probability Mass Function (PMF) for NegativeBinomialDistribution.
  ## `k` is the number of failures before the `r`-th success
  ## (``k >= 0``).
  ##
  ## Counts failures `k` before `r` successes with success probability `p`.
  ## PMF(k) = C(k+r-1, k) · p^r · (1-p)^k.
  if k < 0:
    return T(0.0)
  if d.p == T(0.0):
    return T(0.0)
  if d.p == T(1.0):
    return
      if k == 0:
        T(1.0)
      else:
        T(0.0)
  exp(
    T(lfac(k + d.r - 1)) - T(lfac(k)) - T(lfac(d.r - 1)) + T(d.r) * ln(d.p) +
      T(k) * ln(T(1.0) - d.p)
  )

func cdf*[T: SomeFloat](d: NegativeBinomialDistribution[T], k: int): T =
  ## Cumulative Distribution Function (CDF) for NegativeBinomialDistribution.
  ## `k` is the number of failures before the `r`-th success
  ## (``k >= 0``).
  ## CDF(k) = P(K <= k) = P(Bin(r+k, p) >= r) = I_p(r, k+1).
  if k < 0:
    T(0.0)
  else:
    regularized_lower_incomplete_beta(T(d.r), T(k + 1), d.p)

func sf*[T: SomeFloat](d: NegativeBinomialDistribution[T], k: int): T =
  ## Survival Function (SF): 1 - CDF for NegativeBinomialDistribution.
  ## `k` is the number of failures before the `r`-th success
  ## (``k >= 0``).
  T(1.0) - d.cdf(k)

proc ppf*[T: SomeFloat](
    d: NegativeBinomialDistribution[T], q: T
): Result[int, DistError] =
  ## Percent Point Function (quantile, inverse CDF) for
  ## NegativeBinomialDistribution.
  ## `q` is the quantile probability, distinct from the distribution's
  ## success probability `p`. Returns `ok(0)` for `q <= 0`. Returns `ok(0)`
  ## for a `NaN` argument (the discrete `ppf` returns `int`, so `NaN` has
  ## no representation; the low clamp is the deterministic convention).
  ## Returns `err(DistError.NotConverged)` if the quantile search fails to
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

proc sample*[T: SomeFloat](d: NegativeBinomialDistribution[T], r: var Rand): int =
  ## Draw a NegativeBinomial(r, p) variate via Gamma-Poisson mixture:
  ## Y ~ Gamma(r, (1-p)/p); K | Y ~ Poisson(Y).
  ## `r` is the RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`.
  ## <https://en.wikipedia.org/wiki/Negative_binomial_distribution#Gamma%E2%80%93Poisson_mixture>
  if d.p == T(0.0) or d.p == T(1.0):
    return 0
  let scale = (T(1.0) - d.p) / d.p
  let y = standardGamma(r, T(d.r)) * scale
  samplePoisson(r, y)

{.pop.}
