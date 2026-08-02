{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import results
import distributions/[base, errors, mathutils]

## Uniform discrete distribution on ``{a, …, b}`` (``a ≤ b``).
## <https://en.wikipedia.org/wiki/Discrete_uniform_distribution>

type UniformDiscreteDistribution*[T: SomeFloat] = object of DistributionDiscrete
  ## Uniform discrete distribution on the integer range ``{a, …, b}``.
  a*: int ## Lower bound (``a <= b``).
  b*: int ## Upper bound (``a <= b``).

func initUniformDiscreteDistribution*[T: SomeFloat](
    a, b: int
): Result[UniformDiscreteDistribution[T], DistError] =
  ## Construct a Uniform discrete distribution on `{a, ..., b}`.
  ## Requires `a <= b`.
  if a > b:
    return err(DistError.deAMustBeAtMostB)
  ok(UniformDiscreteDistribution[T](a: a, b: b))

func mean*[T: SomeFloat](d: UniformDiscreteDistribution[T]): T =
  ## Mean: ``(a+b)/2``.
  T(0.5) * T(d.a + d.b)

func median*[T: SomeFloat](d: UniformDiscreteDistribution[T]): T =
  ## Median: ``(a+b)/2``.
  T(0.5) * T(d.a + d.b)

func mode*[T: SomeFloat](d: UniformDiscreteDistribution[T]): T =
  ## Mode: ``(a+b)/2`` (any ``k ∈ {a,…,b}`` has equal probability).
  T(0.5) * T(d.a + d.b)

func variance*[T: SomeFloat](d: UniformDiscreteDistribution[T]): T =
  ## Variance: ``((b-a+1)² - 1) / 12``.
  (pow2(T(d.b - d.a + 1)) - T(1.0)) / T(12.0)

func pmf*[T: SomeFloat](d: UniformDiscreteDistribution[T], k: int): T =
  ## Probability Mass Function (PMF) for UniformDiscreteDistribution:
  ## ``1/(b-a+1)`` for ``a <= k <= b``, `0` otherwise.
  ## `k` is an integer in ``{a, ..., b}``.
  if k < d.a or k > d.b:
    T(0.0)
  else:
    T(1.0) / T(d.b - d.a + 1)

func cdf*[T: SomeFloat](d: UniformDiscreteDistribution[T], k: int): T =
  ## Cumulative Distribution Function (CDF) for UniformDiscreteDistribution:
  ## closed form ``(k-a+1)/(b-a+1)`` for ``a <= k <= b``, `0` below, `1`
  ## above.
  ## `k` is an integer in ``{a, ..., b}``.
  if k < d.a:
    T(0.0)
  elif k > d.b:
    T(1.0)
  else:
    T(k - d.a + 1) / T(d.b - d.a + 1)

func sf*[T: SomeFloat](d: UniformDiscreteDistribution[T], k: int): T =
  ## Survival Function (SF): 1 - CDF for UniformDiscreteDistribution.
  ## `k` is an integer in ``{a, ..., b}``.
  T(1.0) - d.cdf(k)

proc ppf*[T: SomeFloat](
    d: UniformDiscreteDistribution[T], q: T
): Result[int, DistError] =
  ## Percent Point Function (quantile, inverse CDF) for
  ## UniformDiscreteDistribution: the smallest ``k >= a`` with
  ## ``cdf(k) >= q``. `q` is the quantile probability. Returns `ok(a)` for
  ## `q <= 0`, `ok(b)` for `q >= 1`. Returns `ok(a)` for a `NaN` argument
  ## (the discrete `ppf` returns `int`, so `NaN` has no representation; the
  ## low clamp is the deterministic convention).
  ## Returns `err(DistError.deNotConverged)` if the quantile search fails to
  ## converge (unreachable for valid monotone cdfs).
  if isNaN(q) or q <= T(0.0):
    ok(d.a)
  elif q >= T(1.0):
    ok(d.b)
  else:
    discretePpf(
      proc(k: int): T {.closure, raises: [].} =
        d.cdf(k),
      q,
      start = d.a,
    )

proc sample*[T: SomeFloat](d: UniformDiscreteDistribution[T], r: var Rand): int =
  ## Draw a UniformDiscrete(a, b) variate via std/random's `rand(range)`.
  ## `r` is the RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`.
  ## <https://en.wikipedia.org/wiki/Discrete_uniform_distribution#Random_variate_generation>
  r.rand(d.a .. d.b)

{.pop.}
