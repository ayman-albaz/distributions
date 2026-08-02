{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import special_functions
import results
import distributions/[base, errors, mathutils]

## Beta distribution — continuous distribution on ``[0, 1]`` with
## shape parameters ``alpha > 0`` and ``beta > 0``.
## <https://en.wikipedia.org/wiki/Beta_distribution>

type BetaDistribution*[T: SomeFloat] = object of DistributionContinuous
  ## Beta distribution with shape parameters ``alpha`` and ``beta``.
  alpha*: T ## Shape parameter ``alpha > 0``.
  beta*: T ## Shape parameter ``beta > 0``.

func initBetaDistribution*[T: SomeFloat](
    alpha, beta: T
): Result[BetaDistribution[T], DistError] =
  ## Construct a Beta distribution with shape parameters `alpha` and `beta`.
  ## Both must be > 0.
  ?validatePositive(alpha)
  ?validatePositive(beta)
  ok(BetaDistribution[T](alpha: alpha, beta: beta))

func mean*[T: SomeFloat](d: BetaDistribution[T]): T =
  ## Mean: ``α / (α + β)``.
  d.alpha / (d.alpha + d.beta)

func median*[T: SomeFloat](d: BetaDistribution[T]): T =
  ## Median is the 0.5-quantile: ``m`` satisfies ``I_m(α, β) = 0.5``.
  inverse_regularized_lower_incomplete_beta(d.alpha, d.beta, T(0.5))

func mode*[T: SomeFloat](d: BetaDistribution[T]): Result[T, DistError] =
  ## Mode: ``(α-1) / (α+β-2)`` for ``α > 1 ∧ β > 1``.
  ## Returns error when ``α < 1 ∧ β < 1`` or ``α = β = 1``;
  ## returns ``0`` for ``α < 1 ∧ β ≥ 1``, ``1`` for ``α ≥ 1 ∧ β < 1``.
  if d.alpha > T(1.0) and d.beta > T(1.0):
    return ok((d.alpha - T(1.0)) / (d.alpha + d.beta - T(2.0)))
  if d.alpha == T(1.0) and d.beta == T(1.0):
    return err(DistError.modeUndefined)
  if d.alpha < T(1.0) and d.beta < T(1.0):
    return err(DistError.modeUndefined)
  if d.alpha < T(1.0) and d.beta == T(1.0):
    return ok(T(0.0))
  if d.alpha == T(1.0) and d.beta > T(1.0):
    return ok(T(0.0))
  if d.alpha > T(1.0) and d.beta == T(1.0):
    return ok(T(1.0))
  if d.alpha == T(1.0) and d.beta < T(1.0):
    return ok(T(1.0))
  if d.alpha < T(1.0) and d.beta > T(1.0):
    return ok(T(0.0))
  if d.alpha > T(1.0) and d.beta < T(1.0):
    return ok(T(1.0))
  err(DistError.modeUndefined)

func variance*[T: SomeFloat](d: BetaDistribution[T]): T =
  ## Variance: ``αβ / ((α+β)² (α+β+1))``.
  d.alpha * d.beta / (pow2(d.alpha + d.beta) * (d.alpha + d.beta + T(1.0)))

func pdf*[T: SomeFloat](d: BetaDistribution[T], x: T): T =
  ## Probability Density Function (PDF) for BetaDistribution:
  ## ``x^(α-1) (1-x)^(β-1) / B(α, β)``.
  ## `x` is the value at which the density is evaluated.
  ## At the boundaries: `Inf` where the density diverges
  ## (``α < 1`` at ``x = 0``, ``β < 1`` at ``x = 1``);
  ## `1/B(1, β) = β` at ``x = 0`` for ``α = 1``; `1/B(α, 1) = α` at
  ## ``x = 1`` for ``β = 1``; `0` elsewhere on the boundary.
  ## A `NaN` argument propagates `NaN`.
  if x <= T(0.0) or x >= T(1.0):
    if x == T(0.0) and d.alpha < T(1.0):
      return Inf
    if x == T(0.0) and d.alpha == T(1.0):
      return d.beta
    if x == T(1.0) and d.beta < T(1.0):
      return Inf
    if x == T(1.0) and d.beta == T(1.0):
      return d.alpha
    return T(0.0)
  exp(
    (d.alpha - T(1.0)) * ln(x) + (d.beta - T(1.0)) * ln(T(1.0) - x) - lgamma(d.alpha) -
      lgamma(d.beta) + lgamma(d.alpha + d.beta)
  )

func cdf*[T: SomeFloat](d: BetaDistribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for BetaDistribution:
  ## ``I_x(α, β)`` (regularized incomplete beta).
  ## `x` is the value at which the CDF is evaluated.
  if x <= T(0.0):
    T(0.0)
  elif x >= T(1.0):
    T(1.0)
  else:
    regularized_lower_incomplete_beta(d.alpha, d.beta, x)

func sf*[T: SomeFloat](d: BetaDistribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for BetaDistribution.
  ## `x` is the value at which the SF is evaluated.
  T(1.0) - d.cdf(x)

func ppf*[T: SomeFloat](d: BetaDistribution[T], q: T): T =
  ## Percent Point Function (quantile, inverse CDF) for BetaDistribution.
  ## `q` is the quantile probability. Returns `0` for `q <= 0`, `1` for
  ## `q >= 1`.
  if q <= T(0.0):
    T(0.0)
  elif q >= T(1.0):
    T(1.0)
  else:
    inverse_regularized_lower_incomplete_beta(d.alpha, d.beta, q)

proc sample*[T: SomeFloat](d: BetaDistribution[T], r: var Rand): T =
  ## Draw a Beta(α, β) variate.
  ## `r` is the RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`.
  ## α ≥ 1 ∧ β ≥ 1: Gamma ratio g1/(g1+g2), g_i ~ Gamma(α_i, 1).
  ## Otherwise: Jöhnk (1959), x = u^(1/α)/(u^(1/α)+v^(1/β)), accept if
  ## u^(1/α)+v^(1/β) ≤ 1. MaxIter cap with fallback to closed-form ppf.
  ## <https://en.wikipedia.org/wiki/Beta_distribution#Generating_beta-distributed_random_variates>
  const MaxIter = 10_000
  if d.alpha >= T(1.0) and d.beta >= T(1.0):
    let g1 = standardGamma(r, d.alpha)
    let g2 = standardGamma(r, d.beta)
    if g1 + g2 == T(0.0):
      return T(0.0)
    return g1 / (g1 + g2)
  else:
    for iter in 0 ..< MaxIter:
      let u = T(r.rand(1.0))
      let v = T(r.rand(1.0))
      if u <= T(0.0) or v <= T(0.0):
        continue
      let x = exp(ln(u) / d.alpha)
      let y = exp(ln(v) / d.beta)
      let s = x + y
      if s > T(1.0) or s == T(0.0):
        continue
      return x / s
    d.ppf(T(r.rand(1.0)))

{.pop.}
