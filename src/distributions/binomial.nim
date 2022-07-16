import math
import special_functions
import base, utils

type 
  BinomialDistribution* = object of DistributionDiscrete
    ##[ 
      'The binomial distribution is frequently used to model
      the number of successes in a sample of size n drawn with replacement
      from a population of size N. If the sampling is carried out without replacement,
      the draws are not independent and so the resulting distribution
      is a hypergeometric distribution, not a binomial one.
      However, for N much larger than n, the binomial distribution
      remains a good approximation, and is widely used.' ~ Wikipedia
      https://en.wikipedia.org/wiki/Binomial_distribution
    ]##
    n*: Positive
    p*: FractionPositiveFloat

func initBinomialDistribution*(n: Positive, p: FractionPositiveFloat): BinomialDistribution = 
  result = BinomialDistribution(n: n, p: p)

func mean*(dist: BinomialDistribution): float =
  result = dist.n.float * dist.p

func median*(dist: BinomialDistribution): float =
  result = round(dist.n.float * dist.p).float

func mode*(dist: BinomialDistribution): float =
  result = round((dist.n.float + 1.0) * dist.p).float

func variance*(dist: BinomialDistribution): float =
  result = dist.n.float * dist.p * (1.0 - dist.p)

func pmf*(dist: BinomialDistribution, k: Natural): float =
  ##[
    Probability Density Function (PDF) for BinomialDistribution.
    Accurate for up-to 15 decimal place.
  ]##
  result = binom(dist.n, k).float * pow(dist.p, k.float) * pow(1.0 - dist.p, (dist.n - k).float)

func cdf*(dist: BinomialDistribution, k: Natural): float = 
  ##[
    Cumulative Density Function (CDF) for BinomialDistribution.
    Accurate for up-to 8 decimal place.
  ]##
  result = regularized_lower_incomplete_beta((dist.n - k).float, (1 + k).float, 1.0 - dist.p)

func sf*(dist: BinomialDistribution, k: Natural): float =
  ##[
    Survival function (sf) for BinomialDistribution.
    Equivalent to 1 - cdf.
    Accurate for up-to 8 decimal place.
  ]##
  result = 1 - dist.cdf(k)

func ppf*(dist: BinomialDistribution, p: FractionPositiveFloat): int = 
  ##[
    Point prevalence function (ppf) for BinomialDistribution.
    Accurate for up-to 10 decimal place.
  ]##
  var k = 1
  while true:
    if dist.cdf(k) >= p:
      return k
    k += 1 