import math
import mathutils
import special_functions
import base, utils

type 
  NegativeBinomialDistribution* = object of DistributionContinuous
    ##[
      'In probability theory and statistics, the negative binomial distribution 
      is a discrete probability distribution that models the number of successes 
      in a sequence of independent and identically distributed Bernoulli trials 
      before a specified (non-random) number of failures (denoted r) occurs.' ~ Wikipedia
      https://en.wikipedia.org/wiki/Negative_binomial_distribution
    ]##
    r*: Positive
    p*: FractionPositiveFloat

func initNegativeBinomialDistribution*(r: Positive, p: FractionPositiveFloat): NegativeBinomialDistribution =
  result = NegativeBinomialDistribution(r: r, p: p)

func mean*(dist: NegativeBinomialDistribution): float =
  result = (dist.r.float * (1 - dist.p)) / dist.p

func mode*(dist: NegativeBinomialDistribution): float =
  if dist.r <= 1: result = 0.0
  else: result = ((dist.r - 1).float * (1 - dist.p)) / dist.p

func variance*(dist: NegativeBinomialDistribution): float =
  result = (dist.r.float * (1 - dist.p)) / pow2(dist.p)

func pmf*(dist: NegativeBinomialDistribution, k: Natural): float =
  ##[
    Probability Density Function (PDF) for NegativeBinomialDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = binom(k + dist.r - 1, k).float * pow(1.0 - dist.p, dist.r.float) * pow(dist.p, k.float)

func cdf*(dist: NegativeBinomialDistribution, k: Natural): float = 
  ##[
    Cumulative Density Function (CDF) for NegativeBinomialDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = 1 - regularized_lower_incomplete_beta((k + 1).float, dist.r.float, dist.p)

func sf*(dist: NegativeBinomialDistribution, k: Natural): float =
  ##[
    Survival function (sf) for NegativeBinomialDistribution.
    Equivalent to 1 - cdf.
    Accurate for up-to 14 decimal place.
  ]##
  result = 1 - dist.cdf(k)

func ppf*(dist: NegativeBinomialDistribution, p: FractionPositiveFloat): int = 
  ##[
    Point prevalence function (ppf) for BinomialDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  var k = 1
  while true:
    if dist.cdf(k) >= p:
      return k
    k += 1 
