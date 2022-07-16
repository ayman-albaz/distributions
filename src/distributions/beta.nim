import math
import mathutils
import special_functions
import base, utils

type 
  BetaDistribution* = object of DistributionContinuous
    ##[
      'The beta distribution has been applied to model 
      the behavior of random variables limited to intervals 
      of finite length in a wide variety of disciplines.' ~ Wikipedia
      https://en.wikipedia.org/wiki/Beta_distribution
    ]##
    alpha*: PositiveFloat
    beta*: PositiveFloat

func initBetaDistribution*(alpha, beta: PositiveFloat): BetaDistribution = 
  result.alpha = alpha
  result.beta = beta

func mean*(dist: BetaDistribution): float =
  result = dist.alpha / (dist.alpha + dist.beta)

func median*(dist: BetaDistribution): float =
  result = regularized_lower_incomplete_beta(dist.alpha, dist.beta, 0.5)

func mode*(dist: BetaDistribution): float =
  if dist.alpha > 1.0 and dist.beta > 1.0: result = (dist.alpha - 1) / (dist.alpha + dist.beta - 2)
  elif dist.alpha == 1.0 and dist.beta == 1.0: result = 0.5
  elif dist.alpha < 1.0 and dist.beta < 1.0: result = 0.5
  elif dist.alpha <= 1.0 and dist.beta > 1.0: result = 0.0
  elif dist.alpha > 1.0 and dist.beta <= 1.0: result = 1.0

func variance*(dist: BetaDistribution): float =
  result = dist.alpha * dist.beta / (pow2(dist.alpha + dist.beta) * (dist.alpha + dist.beta + 1.0))

func pdf*(dist: BetaDistribution, b: FractionPositiveFloat): float =
  ##[
    Probability Density function (PDF) for BetaDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = pow(b, dist.alpha - 1.0) * pow(1 - b, dist.beta - 1) / beta(dist.alpha, dist.beta) 

func cdf*(dist: BetaDistribution, b: FractionPositiveFloat): float = 
  ##[
    Cumulative Density function (CDF) for BetaDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = regularized_lower_incomplete_beta(dist.alpha, dist.beta, b)

func sf*(dist: BetaDistribution, b: FractionPositiveFloat): float =
  ##[
    Survival function (sf) for BetaDistribution.
    Equivalent to 1 - cdf.
    Accurate for up-to 14 decimal place.
  ]##
  result = 1 - dist.cdf(b)

func ppf*(dist: BetaDistribution, p: FractionPositiveFloat): float = 
  ##[
    Point prevalence function (ppf) for BetaDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = inverse_regularized_lower_incomplete_beta(dist.alpha, dist.beta, p)
