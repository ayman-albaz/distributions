{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import results
import distributions/[base, errors, mathutils]

## Uniform continuous distribution on ``[a, b]`` (``a < b``).
## <https://en.wikipedia.org/wiki/Continuous_uniform_distribution>

type UniformContinuousDistribution*[T: SomeFloat] = object of DistributionContinuous
  ## Uniform continuous distribution on the interval ``[a, b]``.
  a*: T ## Lower bound (``a < b``).
  b*: T ## Upper bound (``a < b``).

func initUniformContinuousDistribution*[T: SomeFloat](
    a, b: T
): Result[UniformContinuousDistribution[T], DistError] =
  ## Construct a Uniform continuous distribution on `[a, b]`.
  ## Requires `a < b`; rejects NaN.
  ?validateNotNaN(a)
  ?validateNotNaN(b)
  if a >= b:
    return err(DistError.aMustBeLessThanB)
  ok(UniformContinuousDistribution[T](a: a, b: b))

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
  ## Probability Density Function (PDF) for UniformContinuousDistribution:
  ## ``1/(b-a)`` on ``[a, b]``, `0` outside.
  ## `x` is the value at which the density is evaluated.
  ## A `NaN` argument propagates `NaN`.
  if isNaN(x):
    return x
  if x < d.a or x > d.b:
    T(0.0)
  else:
    T(1.0) / (d.b - d.a)

func cdf*[T: SomeFloat](d: UniformContinuousDistribution[T], x: T): T =
  ## Cumulative Distribution Function (CDF) for UniformContinuousDistribution:
  ## closed form ``(x-a)/(b-a)`` on ``[a, b]``, `0` below, `1` above.
  ## `x` is the value at which the CDF is evaluated.
  if x < d.a:
    T(0.0)
  elif x > d.b:
    T(1.0)
  else:
    (x - d.a) / (d.b - d.a)

func sf*[T: SomeFloat](d: UniformContinuousDistribution[T], x: T): T =
  ## Survival Function (SF): 1 - CDF for UniformContinuousDistribution.
  ## `x` is the value at which the SF is evaluated.
  T(1.0) - d.cdf(x)

func ppf*[T: SomeFloat](d: UniformContinuousDistribution[T], q: T): T =
  ## Percent Point Function (quantile, inverse CDF) for
  ## UniformContinuousDistribution: closed form ``a + q·(b-a)``.
  ## `q` is the quantile probability. Returns `a` for `q <= 0`, `b` for
  ## `q >= 1`.
  if q <= T(0.0):
    d.a
  elif q >= T(1.0):
    d.b
  else:
    q * (d.b - d.a) + d.a

proc sample*[T: SomeFloat](d: UniformContinuousDistribution[T], r: var Rand): T =
  ## Draw a UniformContinuous(a, b) variate via the inverse-CDF closed form.
  ## `r` is the RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`.
  ## <https://en.wikipedia.org/wiki/Continuous_uniform_distribution#Random_variate_generation>
  d.a + (d.b - d.a) * T(r.rand(1.0))

{.pop.}
