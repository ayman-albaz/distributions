import base, mathutils

type 
  UniformDiscreteDistribution* = object of DistributionDiscrete
    a*: int
    b*: int

func initUniformDiscreteDistribution*(a, b: int): UniformDiscreteDistribution = 
  result.a = a
  result.b = b

func mean*(dist: UniformDiscreteDistribution): float =
  result = 0.5 * (dist.a + dist.b).float

func median*(dist: UniformDiscreteDistribution): float =
  result = 0.5 * (dist.a + dist.b).float

func mode*(dist: UniformDiscreteDistribution): float =
  result = 0.5 * (dist.a + dist.b).float

func variance*(dist: UniformDiscreteDistribution): float =
  result = (pow2(dist.b - dist.a + 1) - 1).float / 12.0

func pmf*(dist: UniformDiscreteDistribution, x: int): float =
  ##[
    Probability Mass Function (PMF) for UniformDiscreteDistribution.
    Accurate for up-to 15 decimal place.
  ]##
  if x < dist.a or x > dist.b:
    return 0.0
  return 1 / (dist.b - dist.a + 1)

func cdf*(dist: UniformDiscreteDistribution, x: int): float = 
  ##[
    Cumulative Density Function (CDF) for UniformDiscreteDistribution.
    Accurate for up-to 15 decimal place.
  ]##
  if x < dist.a:
    return 0.0
  elif x > dist.b:
    return 1.0
  return (x - dist.a + 1) / (dist.b - dist.a + 1)

func sf*(dist: UniformDiscreteDistribution, x: int): float =
  ##[
    Survival function (sf) for UniformDiscreteDistribution.
    Equivalent to 1 - cdf.
    Accurate for up-to 15 decimal place.
  ]##
  result = 1 - dist.cdf(x)

func ppf*(dist: UniformDiscreteDistribution, p: float): int =
  ##[
    Point prevalence function (ppf) for UniformDiscreteDistribution.
    Accurate for up-to 15 decimal place.
  ]##
  var k = dist.a
  while true:
    if dist.cdf(k) >= p:
      return k
    k += 1 
