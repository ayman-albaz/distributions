type
    Submodule* = object
      name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")


import math
import math_utils
import special_functions/gamma
import utils


{.nanChecks: on, infChecks: on.}


type 
    Chi2Distribution* = object 
    #[
    'The chi-square distribution is used in the common chi-square tests 
    for goodness of fit of an observed distribution to a theoretical one, 
    the independence of two criteria of classification of qualitative data, 
    and in confidence interval estimation for a population standard deviation 
    of a normal distribution from a sample standard deviation. Many other statistical 
    tests also use this distribution, such as Friedman's analysis of variance by ranks.' ~ Wikipedia
    https://en.wikipedia.org/wiki/Chi-square_distribution
    ]#
        df*: int


proc initChi2Distribution*(df: int): Chi2Distribution = 
    if df <= 0:
        raise newException(ValueError, "df must be > 0.")
    result.df = df


proc mean*(chi2_dist: Chi2Distribution): float =
    return chi2_dist.df.float


proc median*(chi2_dist: Chi2Distribution): float =
    return chi2_dist.df.float * pow3(1 - 2 / (9 * chi2_dist.df))


proc mode*(chi2_dist: Chi2Distribution): float =
    return max(chi2_dist.df - 2, 0).float


proc variance*(chi2_dist: Chi2Distribution): float =
    return 2 * chi2_dist.df.float


proc pdf*(chi2_dist: Chi2Distribution, chi2: PositiveFloat): float =
    #[
        Probability Density Function (PDF) for Chi2Distribution.
        Accurate for up-to 14 decimal place.
    ]#
    return pow(chi2, (chi2_dist.df.float / 2.float - 1)) * pow(E, -chi2 / 2.0) / (pow(2.0, chi2_dist.df.float / 2.0) * gamma(chi2_dist.df.float / 2.0))


proc cdf*(chi2_dist: Chi2Distribution, chi2: PositiveFloat): float = 
    #[
        Cumulative Density Function (CDF) for Chi2Distribution.
        Accurate for up-to 14 decimal place.
    ]#
    return regularized_lower_incomplete_gamma(chi2_dist.df.float / 2.0, chi2 / 2.0)


proc sf*(chi2_dist: Chi2Distribution, chi2: PositiveFloat): float =
    #[
        Survival function (sf) for Chi2Distribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 14 decimal place.
    ]#
    return 1 - chi2_dist.cdf(chi2)



proc ppf*(chi2_dist: Chi2Distribution, p: FractionPositiveFloat): float =
    #[
        Point prevalence function (ppf) for Chi2Distribution.
        Accurate for up-to 14 decimal place.
    ]#
    return inverse_regularized_lower_incomplete_gamma(chi2_dist.df / 2, p) * 2
