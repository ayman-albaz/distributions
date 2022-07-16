import math
import mathutils
import special_functions
import base, utils

type 
  GammaDistribution* = object of DistributionContinuous
    ##[
      https://en.wikipedia.org/wiki/distribution
    ]##
    k*: PositiveFloat
    theta*: PositiveFloat

func initGammaDistribution*(k, theta: PositiveFloat): GammaDistribution = 
  result.k = k
  result.theta = theta

func mean*(dist: GammaDistribution): float =
  result = dist.k * dist.theta

func mode*(dist: GammaDistribution): float =
  if dist.k < 1.0: result = 0
  else: result = dist.theta * (dist.k - 1.0)

func variance*(dist: GammaDistribution): float =
  result = dist.k  * pow2(dist.theta)

func pdf*(dist: GammaDistribution, x: PositiveFloat): float =
  ##[
    Probability Density Function (PDF) for GammaDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = pow(x, dist.k - 1.0) * pow(E, -(x / dist.theta)) / (gamma(dist.k) * pow(dist.theta, dist.k))

func cdf*(dist: GammaDistribution, x: PositiveFloat): float = 
  ##[
    Cumulative Density Function (CDF) for GammaDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = lower_incomplete_gamma(dist.k, x / dist.theta) / gamma(dist.k)

func sf*(dist: GammaDistribution, x: PositiveFloat): float =
  ##[
    Survival function (sf) for GammaDistribution.
    Equivalent to 1 - cdf.
    Accurate for up-to 14 decimal place.
  ]##
  result = 1 - dist.cdf(x)


func ppf*(dist: GammaDistribution, p: FractionPositiveFloat): float =
  ##[
    Point prevalence function (ppf) for GammaDistribution.
    Accurate for up-to 13 decimal place.
  ]##
  result = inverse_regularized_lower_incomplete_gamma(dist.k, p) + dist.theta
