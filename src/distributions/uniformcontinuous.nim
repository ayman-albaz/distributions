{.experimental: "strictFuncs".}
{.push raises: [].}

import distributions/[base, mathutils]

## Uniform continuous distribution on ``[a, b]`` (``a < b``).
## <https://en.wikipedia.org/wiki/Continuous_uniform_distribution>

type
  UniformContinuousDistribution*[T: SomeFloat] = object of DistributionContinuous
    a*: T
    b*: T

func initUniformContinuousDistribution*[T: SomeFloat](
    a, b: T): UniformContinuousDistribution[T] {.raises: [ValueError].} =
  ## Construct a Uniform continuous distribution on `[a, b]`.
  ## Requires `a < b`.
  if a >= b:
    raise newException(ValueError, "a must be < b; got a=" & $a & ", b=" & $b)
  result.a = a
  result.b = b

func mean*[T: SomeFloat](d: UniformContinuousDistribution[T]): T =
  ## Mean: ``(a+b)/2``.
  T(0.5) * (d.a + d.b)

func median*[T: SomeFloat](d: UniformContinuousDistribution[T]): T =
  ## Median: ``(a+b)/2``.
  T(0.5) * (d.a + d.b)

func mode*[T: SomeFloat](d: UniformContinuousDistribution[T]): T =
  ## Mode: ``(a+b)/2``.
  T(0.5) * (d.a + d.b)

func variance*[T: SomeFloat](d: UniformContinuousDistribution[T]): T =
  ## Variance: ``(b-a)² / 12``.
  pow2(d.b - d.a) / T(12.0)

func pdf*[T: SomeFloat](d: UniformContinuousDistribution[T], x: T): T =
  ## Probability Density Function (PDF) for UniformContinuousDistribution.
  if x < d.a or x > d.b:
    T(0.0)
  else:
    T(1.0) / (d.b - d.a)

func cdf*[T: SomeFloat](d: UniformContinuousDistribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for UniformContinuousDistribution.
  if x < d.a:
    T(0.0)
  elif x > d.b:
    T(1.0)
  else:
    (x - d.a) / (d.b - d.a)

func sf*[T: SomeFloat](d: UniformContinuousDistribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for UniformContinuousDistribution.
  T(1.0) - d.cdf(x)

func ppf*[T: SomeFloat](d: UniformContinuousDistribution[T], p: T): T =
  ## Percent Point Function (quantile, inverse CDF) for UniformContinuousDistribution.
  if p <= T(0.0):
    d.a
  elif p >= T(1.0):
    d.b
  else:
    p * (d.b - d.a) + d.a

{.pop.}
