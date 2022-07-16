
import base, utils

type 
  BernoulliDistribution* = object of DistributionDiscrete 
    ##[ 
      'In probability theory and statistics, the Bernoulli distribution, 
      named after Swiss mathematician Jacob Bernoulli,[1] is the discrete probability 
      distribution of a random variable which takes the value 1 with probability p
      and the value 0 with probability q = 1 − p . Less formally, it can be thought of as a model 
      for the set of possible outcomes of any single experiment that asks a yes–no question. 
      Such questions lead to outcomes that are boolean-valued: a single bit whose value is 
      success/yes/true/one with probability p and failure/no/false/zero with probability q. 
      It can be used to represent a (possibly biased) coin toss where 1 and 0 would represent 
      "heads" and "tails" (or vice versa), respectively, and p would be the probability of 
      the coin landing on heads or tails, respectively. In particular, unfair coins would 
      have p ≠ 1 / 2. ' ~ Wikipedia
      https://en.wikipedia.org/wiki/bernoulli_distribution
    ]##
    p*: FractionPositiveFloat

func initBernoulliDistribution*(p: FractionPositiveFloat): BernoulliDistribution = 
  result.p = p

func mean*(dist: BernoulliDistribution): float =
  result = dist.p

func median*(dist: BernoulliDistribution): float =
  if dist.p < 0.5: result = 0.0
  elif dist.p == 0.5: result = 0.5
  elif dist.p > 0.5: result = 1.0

func mode*(dist: BernoulliDistribution): float =
  if dist.p < 0.5: result = 0.0
  elif dist.p == 0.5: result = 0.5
  elif dist.p > 0.5: result = 1.0

func variance*(dist: BernoulliDistribution): float =
  result = dist.p * (1 - dist.p)

func pmf*(dist: BernoulliDistribution, k: BinaryInteger): float =
  ##[
    Probability Density Function (PDF) for BernoulliDistribution.
    Accurate for up-to 15 decimal place.
  ]##
  if k == 0: result = 1 - dist.p
  elif k == 1: result = dist.p

func cdf*(dist: BernoulliDistribution, k: BinaryInteger): float = 
  ##[
    Cumulative Density Function (CDF) for BernoulliDistribution.
    Accurate for up-to 15 decimal place.
  ]##
  if k == 0: result = 1 - dist.p
  elif k >= 0: result = 1

func sf*(dist: BernoulliDistribution, k: BinaryInteger): float =
  ##[
    Survival function (sf) for BernoulliDistribution.
    Equivalent to 1 - cdf.
    Accurate for up-to 15 decimal place.
  ]##
  result = 1 - dist.cdf(k)

func ppf*(dist: BernoulliDistribution, p: FractionPositiveFloat): int = 
  ##[
    Point prevalence function (ppf) for BernoulliDistribution.
    Accurate for up-to 15 decimal place.
  ]##
  if p <= 1 - dist.p: result = 0
  else: result = 1
