import math
import mathutils
import special_functions
import base, utils

type 
  PoissonDistribution* = object of DistributionDiscrete
    ##[ 
      'In probability theory and statistics, the Poisson distribution
      named after French mathematician Denis Poisson, is a discrete
      probability distribution that expresses the probability of a given number
      of events occurring in a fixed interval of time or space if these events
      occur with a known constant mean rate and independently
      of the time since the last even' ~ Wikipedia
      https://en.wikipedia.org/wiki/Poisson_distribution
    ]##
    lambda*: PositiveFloat

func initPoissonDistribution*(lambda: PositiveFloat): PoissonDistribution = 
  result.lambda = lambda

func mean*(dist: PoissonDistribution): float =
  result = dist.lambda.float

func median*(dist: PoissonDistribution): float =
  result = dist.lambda.float

func mode*(dist: PoissonDistribution): float =
  result = dist.lambda.float

func variance*(dist: PoissonDistribution): float =
  result = dist.lambda.float

func pmf*(dist: PoissonDistribution, k: Natural): float =
  ##[
    Probability Density Function (PDF) for PoissonDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  # result = pow(dist.lambda.float, k.float) * pow(E, -dist.lambda.float) / fac(k).float
  result = exp(ln(pow(dist.lambda.float, k.float)) + ln(pow(E, -dist.lambda.float)) - lfac(k))

func cdf*(dist: PoissonDistribution, k: Natural): float = 
  ##[
    Cumulative Density Function (CDF) for PoissonDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = regularized_upper_incomplete_gamma(k.float + 1.0, dist.lambda.float)
  # var total = 0.0
  # for i in 0..k:
  #   total += dist.pmf(i)
  # result = total

func sf*(dist: PoissonDistribution, k: Natural): float =
  ##[
    Survival function (sf) for PoissonDistribution.
    Equivalent to 1 - cdf.
    Accurate for up-to 14 decimal place.
  ]##
  result = 1 - dist.cdf(k)

func ppf*(dist: PoissonDistribution, p: FractionPositiveFloat): int = 
  ##[
    Point prevalence function (ppf) for PoissonDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  var k = 1
  while true:
    if dist.cdf(k) >= p:
      return k
    k += 1 
