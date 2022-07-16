import math
import mathutils
import special_functions
import base, utils

type 
  Chi2Distribution* = object of DistributionContinuous
    ##[
    'The chi-square distribution is used in the common chi-square tests 
    for goodness of fit of an observed distribution to a theoretical one, 
    the independence of two criteria of classification of qualitative data, 
    and in confidence interval estimation for a population standard deviation 
    of a normal distribution from a sample standard deviation. Many other statistical 
    tests also use this distribution, such as Friedman's analysis of variance by ranks.' ~ Wikipedia
    https://en.wikipedia.org/wiki/Chi-square_distribution
    ]##
    df*: int

func initChi2Distribution*(df: int): Chi2Distribution = 
  if df <= 0:
    raise newException(ValueError, "df must be > 0.")
  result.df = df

func mean*(dist: Chi2Distribution): float =
  result = dist.df.float

func median*(dist: Chi2Distribution): float =
  result = dist.df.float * pow3(1 - 2 / (9 * dist.df))

func mode*(dist: Chi2Distribution): float =
  result = max(dist.df - 2, 0).float

func variance*(dist: Chi2Distribution): float =
  result = 2 * dist.df.float

func pdf*(dist: Chi2Distribution, chi2: PositiveFloat): float =
  ##[
    Probability Density Function (PDF) for Chi2Distribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = pow(chi2, (dist.df.float / 2.float - 1)) * pow(E, -chi2 / 2.0) / (pow(2.0, dist.df.float / 2.0) * gamma(dist.df.float / 2.0))

func cdf*(dist: Chi2Distribution, chi2: PositiveFloat): float = 
  ##[
    Cumulative Density Function (CDF) for Chi2Distribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = regularized_lower_incomplete_gamma(dist.df.float / 2.0, chi2 / 2.0)

func sf*(dist: Chi2Distribution, chi2: PositiveFloat): float =
  ##[
    Survival function (sf) for Chi2Distribution.
    Equivalent to 1 - cdf.
    Accurate for up-to 14 decimal place.
  ]##
  result = 1 - dist.cdf(chi2)

func ppf*(dist: Chi2Distribution, p: FractionPositiveFloat): float =
  ##[
    Point prevalence function (ppf) for Chi2Distribution.
    Accurate for up-to 14 decimal place.
  ]##
  result = inverse_regularized_lower_incomplete_gamma(dist.df / 2, p) * 2
