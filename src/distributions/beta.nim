{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import special_functions
import distributions/[base, mathutils]

## Beta distribution — continuous distribution on ``[0, 1]`` with
## shape parameters ``alpha > 0`` and ``beta > 0``.
## <https://en.wikipedia.org/wiki/Beta_distribution>

type
  BetaDistribution*[T: SomeFloat] = object of DistributionContinuous
    alpha*: T
    beta*: T

func initBetaDistribution*[T: SomeFloat](
    alpha, beta: T): BetaDistribution[T] {.raises: [ValueError].} =
  ## Construct a Beta distribution with shape parameters `alpha` and `beta`.
  ## Both must be > 0.
  validatePositive("alpha", alpha)
  validatePositive("beta", beta)
  result.alpha = alpha
  result.beta = beta

func mean*[T: SomeFloat](d: BetaDistribution[T]): T =
  ## Mean: ``α / (α + β)``.
  d.alpha / (d.alpha + d.beta)

func median*[T: SomeFloat](d: BetaDistribution[T]): T =
  ## Median via the 0.5-quantile of the regularized lower incomplete beta.
  regularized_lower_incomplete_beta(d.alpha, d.beta, T(0.5))

func mode*[T: SomeFloat](d: BetaDistribution[T]): T {.raises: [ValueError].} =
  ## Mode: ``(α-1) / (α+β-2)`` for ``α > 1 ∧ β > 1``.
  ## Raises ``ValueError`` when ``α < 1 ∧ β < 1`` or ``α = β = 1``;
  ## returns ``0`` for ``α < 1 ∧ β ≥ 1``, ``1`` for ``α ≥ 1 ∧ β < 1``.
  if d.alpha > T(1.0) and d.beta > T(1.0):
    return (d.alpha - T(1.0)) / (d.alpha + d.beta - T(2.0))
  if d.alpha == T(1.0) and d.beta == T(1.0):
    raise newException(ValueError, "mode undefined for Beta(1,1): uniform distribution")
  if d.alpha < T(1.0) and d.beta < T(1.0):
    raise newException(ValueError,
      "mode undefined for Beta(alpha<1, beta<1): divergent at both boundaries")
  if d.alpha < T(1.0) and d.beta == T(1.0):
    return T(0.0)
  if d.alpha == T(1.0) and d.beta > T(1.0):
    return T(0.0)
  if d.alpha > T(1.0) and d.beta == T(1.0):
    return T(1.0)
  if d.alpha == T(1.0) and d.beta < T(1.0):
    return T(1.0)
  if d.alpha < T(1.0) and d.beta > T(1.0):
    return T(0.0)
  if d.alpha > T(1.0) and d.beta < T(1.0):
    return T(1.0)
  raise newException(ValueError, "mode: unreachable")

func variance*[T: SomeFloat](d: BetaDistribution[T]): T =
  ## Variance: ``αβ / ((α+β)² (α+β+1))``.
  d.alpha * d.beta / (pow2(d.alpha + d.beta) * (d.alpha + d.beta + T(1.0)))

func pdf*[T: SomeFloat](d: BetaDistribution[T], x: T): T =
  ## Probability Density Function (PDF) for BetaDistribution.
  if x <= T(0.0) or x >= T(1.0):
    return T(0.0)
  exp((d.alpha - T(1.0)) * ln(x) + (d.beta - T(1.0)) * ln(T(1.0) - x) -
      lgamma(d.alpha) - lgamma(d.beta) + lgamma(d.alpha + d.beta))

func cdf*[T: SomeFloat](d: BetaDistribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for BetaDistribution.
  if x <= T(0.0):
    T(0.0)
  elif x >= T(1.0):
    T(1.0)
  else:
    regularized_lower_incomplete_beta(d.alpha, d.beta, x)

func sf*[T: SomeFloat](d: BetaDistribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for BetaDistribution.
  T(1.0) - d.cdf(x)

func ppf*[T: SomeFloat](d: BetaDistribution[T], p: T): T =
  ## Percent Point Function (quantile, inverse CDF) for BetaDistribution.
  if p <= T(0.0):
    T(0.0)
  elif p >= T(1.0):
    T(1.0)
  else:
    inverse_regularized_lower_incomplete_beta(d.alpha, d.beta, p)

proc sample*[T: SomeFloat](d: BetaDistribution[T], r: var Rand): T {.raises: [CatchableError].} =
  ## Draw a Beta(α, β) variate.
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
