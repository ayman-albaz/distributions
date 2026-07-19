{.experimental: "strictFuncs".}
{.push raises: [].}

import distributions/[base, mathutils]

## Uniform discrete distribution on ``{a, …, b}`` (``a ≤ b``).
## <https://en.wikipedia.org/wiki/Discrete_uniform_distribution>

type
  UniformDiscreteDistribution*[T: SomeFloat] = object of DistributionDiscrete
    a*: int
    b*: int

func initUniformDiscreteDistribution*[T: SomeFloat](
    a, b: int): UniformDiscreteDistribution[T] {.raises: [ValueError].} =
  ## Construct a Uniform discrete distribution on `{a, ..., b}`.
  ## Requires `a <= b`.
  if a > b:
    raise newException(ValueError, "a must be <= b; got a=" & $a & ", b=" & $b)
  result.a = a
  result.b = b

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
  ## Probability Mass Function (PMF) for UniformDiscreteDistribution.
  if k < d.a or k > d.b:
    T(0.0)
  else:
    T(1.0) / T(d.b - d.a + 1)

func cdf*[T: SomeFloat](d: UniformDiscreteDistribution[T], k: int): T =
  ## Cumulative Distribution Function (CDF) for UniformDiscreteDistribution.
  if k < d.a:
    T(0.0)
  elif k > d.b:
    T(1.0)
  else:
    T(k - d.a + 1) / T(d.b - d.a + 1)

func sf*[T: SomeFloat](d: UniformDiscreteDistribution[T], k: int): T =
  ## Survival Function (SF): 1 - CDF for UniformDiscreteDistribution.
  T(1.0) - d.cdf(k)

proc ppf*[T: SomeFloat](d: UniformDiscreteDistribution[T], p: T): int {.raises: [ValueError].} =
  ## Percent Point Function (quantile, inverse CDF) for UniformDiscreteDistribution.
  ## Returns `a` for `p <= 0`, `b` for `p >= 1`.
  if p <= T(0.0):
    d.a
  elif p >= T(1.0):
    d.b
  else:
    discretePpf(proc(k: int): T {.closure, raises: [].} = d.cdf(k), p, start = d.a)

{.pop.}
