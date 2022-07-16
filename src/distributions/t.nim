import math
import special_functions
import base, mathutils, utils, normal

type 
  TDistribution* = object of DistributionContinuous 
    ##[
      'In probability and statistics, Student's t-distribution (or simply the t-distribution)
      is any member of a family of continuous probability distributions that arise when
      estimating the mean of a normally-distributed population in situations where
      the sample size is small and the population's standard deviation is unknown.' ~ Wikipedia
      https://en.wikipedia.org/wiki/Student%27s_t-distribution
    ]##
    df*: Positive

func initTDistribution*(df: Positive): TDistribution = 
  result = TDistribution(df: df)

func mean*(dist: TDistribution): float =
  result = 0.0

func median*(dist: TDistribution): float =
  result = 0.0

func mode*(dist: TDistribution): float =
  result = 0.0

func variance*(dist: TDistribution): float =
  if dist.df <= 2: result = Inf
  else: result = dist.df / (dist.df - 2)

func pdf*(dist: TDistribution, t: float): float =
  ##[
    Probability Density Function (PDF) for TDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = gamma((dist.df + 1) / 2) / (sqrt(PI * dist.df.float) * gamma(dist.df / 2) * pow(1.float + pow2(t) / dist.df.float, (((dist.df + 1) / 2))))

func cdf*(dist: TDistribution, t: float): float = 
  ##[
    Cumulative Density Function (CDF) for TDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  let x: float = (t + sqrt(t * t + dist.df.float)) / (2.0 * sqrt(t * t + dist.df.float))
  let prob: float = regularized_lower_incomplete_beta(dist.df.float / 2.0, dist.df.float / 2.0, x)
  result = prob

func sf*(dist: TDistribution, t: float): float =
  ##[
    Survival function (sf) for TDistribution.
    Equivalent to 1 - cdf.
    Accurate for up-to 14 decimal place.
  ]##
  result = 1 - dist.cdf(t)


func ppf*(dist: TDistribution, p: FractionPositiveFloat): float =
  ##[
    Point prevalence function (ppf) for TDistribution.
    Accurate for up-to 10 decimal place.
  ]##

  # Hill, G. W. (1970).
  # Algorithm 396: Student's t-quantiles.
  # Communications of the ACM, 13(10), 619-620.
  # Impl based off: https://github.com/ankane/dist.h/blob/master/include/dist.h

  # distribution is symmetric
  let sign = if p < 0.5: -1.0 else: 1.0
  var pmut: float = p
  pmut = if p < 0.5: 1 - pmut else: pmut

  # two-tail to one-tail
  pmut = 2.0 * (1.0 - pmut)

  if dist.df == 2:
    return sign * sqrt(2.0 / (pmut * (2.0 - pmut)) - 2.0)

  let halfPi = PI / 2.0

  if dist.df == 1:
    pmut = pmut * halfPi
    return sign * cos(pmut) / sin(pmut)

  var a = 1.0 / (dist.df.float - 0.5)
  var b = 48.0 / (a * a)
  var c = ((20700.0 * a / b - 98.0) * a - 16.0) * a + 96.36
  var d = ((94.5 / (b + c) - 3.0) / b + 1.0) * sqrt(a * half_pi) * dist.df.float
  var x = d * pmut
  var y = pow(x, 2.0 / dist.df.float)

  if y > 0.05 + a:
    # asymptotic inverse expansion about normal
    x = initNormalDistribution(0.0, 1.0).ppf(pmut * 0.5)
    y = x * x
    if (dist.df < 5):
      c += 0.3 * (dist.df.float - 4.5) * (x + 0.6)
    c = (((0.05 * d * x - 5.0) * x - 7.0) * x - 2.0) * x + b + c
    y = (((((0.4 * y + 6.3) * y + 36.0) * y + 94.5) / c - y - 3.0) / b + 1.0) * x
    y = a * y * y
    y = if y > 0.002: exp(y) - 1.0 else: 0.5 * y * y + y
  else:
      y = ((1.0 / (((dist.df.float + 6.0) / (dist.df.float * y) - 0.089 * d - 0.822) * (dist.df.float + 2.0) * 3.0) + 0.5 / (dist.df.float + 4.0)) * y - 1.0) * (dist.df.float + 1.0) / (dist.df.float + 2.0) + 1.0 / y
  return sign * sqrt(dist.df.float * y)
