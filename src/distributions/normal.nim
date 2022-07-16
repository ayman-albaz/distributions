import math
import mathutils
import random
import special_functions
import base, utils

type 
  NormalDistribution* = object of DistributionContinuous
    ##[
      'Normal distributions are important in statistics
      and are often used in the natural and social sciences
      to represent real-valued random variables whose distributions
      are not known. Their importance is partly due to the central limit theorem.
      It states that, under some conditions, the average of many
      samples (observations) of a random variable with finite mu and
      variance is itself a random variable—whose distribution converges
      to a normal distribution as the number of samples increases.
      Therefore, physical quantities that are expected to be the sum of many
      independent funcesses, such as measurement errors, often have
      distributions that are nearly normal' ~ Wikipedia
      https://en.wikipedia.org/wiki/Normal_distribution
    ]##
    mu*: float
    sigma*: PositiveFloat

func initNormalDistribution*(mu: float = 0.0, sigma: PositiveFloat = 1.0): NormalDistribution = 
  result.mu = mu
  result.sigma = sigma

func mean*(dist: NormalDistribution): float =
  result = dist.mu

func median*(dist: NormalDistribution): float =
  result = dist.mu

func mode*(dist: NormalDistribution): float =
  result = dist.mu

func variance*(dist: NormalDistribution): float =
  result = pow2(dist.sigma)

func pdf*(dist: NormalDistribution, z: float): float =
  ##[
    Probability Density Function (PDF) for NormalDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = pow(E, (-0.5 * pow2((z - dist.mu) / dist.sigma))) / (dist.sigma * sqrt(2.0 * PI))

func cdf*(dist: NormalDistribution, z: float): float = 
  ##[
    Cumulative Density Function (CDF) for NormalDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = 0.5 * (1 + erf((z - dist.mu) / (dist.sigma * sqrt(2.0))))

func sf*(dist: NormalDistribution, z: float): float =
  ##[
    Survival function (sf) for NormalDistribution.
    Equivalent to 1 - cdf.
    Accurate for up-to 14 decimal place.
  ]##
  result = 1 - dist.cdf(z)

func ppf*(dist: NormalDistribution, p: FractionPositiveFloat): float = 
  ##[
    Point prevalence function (ppf) for NormalDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = dist.mu + dist.sigma * sqrt(2.0) * inverse_erf(2.0 * p - 1.0)

proc rand*(dist: NormalDistribution): float = 
  ## Make sure to import random and `initRand`
  result = gauss(dist.mu, dist.sigma)
