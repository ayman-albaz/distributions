import math
import mathutils
import special_functions
import base, utils

type 
  FDistribution* = object of DistributionContinuous
    ##[
      'In probability theory and statistics, the F-distribution, 
      also known as Snedecor's F distribution or the Fisher–Snedecor distribution 
      is a continuous probability distribution that arises frequently 
      as the null distribution of a test statistic, most notably in the analysis 
      of variance (ANOVA) and other F-tests.' ~ Wikipedia
      https://en.wikipedia.org/wiki/F-distribution
    ]##
    df1*: Positive
    df2*: Positive

func initFDistribution*(df1, df2: Positive): FDistribution = 
  result = FDistribution(df1: df1, df2: df2)

func mean*(dist: FDistribution): float =
  if dist.df2 <= 2: result = Inf
  else: result = dist.df2 / (dist.df2 - 2)

func mode*(dist: FDistribution): float =
  if dist.df1 <= 2: result = Inf
  else: result = ((dist.df1 - 2) / dist.df1) * (dist.df2 / (dist.df2 + 2))

func variance*(dist: FDistribution): float =
  if dist.df2 <= 4: result = Inf
  else: result = 2 * pow2(dist.df2) * (dist.df1 + dist.df2 - 2) / (dist.df1 * pow2(dist.df2 - 2) * (dist.df2 - 4))

func pdf*(dist: FDistribution, f: PositiveFloat): float =
  ##[
    Probability Density Function (PDF) for FDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  let numerator = sqrt(pow(dist.df1.float * f, dist.df1.float) * pow(dist.df2.float, dist.df2.float) / pow(dist.df1.float * f + dist.df2.float, (dist.df1 + dist.df2).float))
  let denominator = f * beta(dist.df1 / 2, dist.df2 / 2)
  result = numerator / denominator

func cdf*(dist: FDistribution, f: PositiveFloat): float = 
  ##[
    Cumulative Density Function (CDF) for FDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = regularized_lower_incomplete_beta(dist.df1.float / 2.0, dist.df2.float / 2.0, (dist.df1.float * f) / (dist.df1.float * f + dist.df2.float))

func sf*(dist: FDistribution, f: PositiveFloat): float =
  ##[
    Survival function (sf) for FDistribution.
    Equivalent to 1 - cdf.
    Accurate for up-to 14 decimal place.
  ]##
  result = 1 - dist.cdf(f)

func ppf*(dist: FDistribution, p: FractionPositiveFloat): float = 
  ##[
    Cumulative Density Function (CDF) for FDistribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = (dist.df2 / dist.df1) * (1 / inverse_regularized_upper_incomplete_beta(dist.df2.float / 2, dist.df1.float / 2, p) - 1)
