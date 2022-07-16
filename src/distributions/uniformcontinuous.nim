import base, mathutils

type 
  UniformContinuousDistribution* = object of DistributionContinuous
    a*: float
    b*: float

func initUniformContinuousDistribution*(a, b: float): UniformContinuousDistribution = 
  result.a = a
  result.b = b

func mean*(dist: UniformContinuousDistribution): float =
  result = 0.5 * (dist.a + dist.b)

func median*(dist: UniformContinuousDistribution): float =
  result = 0.5 * (dist.a + dist.b)

func mode*(dist: UniformContinuousDistribution): float =
  result = 0.5 * (dist.a + dist.b)

func variance*(dist: UniformContinuousDistribution): float =
  result = pow2(dist.b - dist.a) / 12.0

func pdf*(dist: UniformContinuousDistribution, x: float): float =
  ##[
    Probability Density Function (PDF) for UniformContinuousDistribution.
    Accurate for up-to 15 decimal place.
  ]##
  if x < dist.a or x > dist.b:
    return 0.0
  return 1.0 / (dist.b - dist.a)

func cdf*(dist: UniformContinuousDistribution, x: float): float = 
  ##[
    Cumulative Density Function (CDF) for UniformContinuousDistribution.
    Accurate for up-to 15 decimal place.
  ]##
  if x < dist.a:
    return 0.0
  elif x > dist.b:
    return 1.0
  return (x - dist.a) / (dist.b - dist.a)

func sf*(dist: UniformContinuousDistribution, x: float): float =
  ##[
    Survival function (sf) for UniformContinuousDistribution.
    Equivalent to 1 - cdf.
    Accurate for up-to 15 decimal place.
  ]##
  result = 1 - dist.cdf(x)

func ppf*(dist: UniformContinuousDistribution, p: float): float =
  ##[
    Point prevalence function (ppf) for UniformContinuousDistribution.
    Accurate for up-to 15 decimal place.
  ]##
  result = p * (dist.b - dist.a) +  dist.a
