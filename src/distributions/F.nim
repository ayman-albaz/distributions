type
  Submodule* = object
    name*: string

proc initSubmodule*(): Submodule =
  ## Initialises a new ``Submodule`` object.
  Submodule(name: "Anonymous")


import math
import special_functions
import utils


{.nanChecks: on, infChecks: on.}


type 
    FDistribution* = object
    #[
        'In probability theory and statistics, the F-distribution, 
        also known as Snedecor's F distribution or the Fisher–Snedecor distribution 
        is a continuous probability distribution that arises frequently 
        as the null distribution of a test statistic, most notably in the analysis 
        of variance (ANOVA) and other F-tests.' ~ Wikipedia
        https://en.wikipedia.org/wiki/F-distribution
    ]#
        df_1*: Positive
        df_2*: Positive


proc initFDistribution*(df_1, df_2: Positive): FDistribution = 
    result.df_1 = df_1
    result.df_2 = df_2


proc pdf*(f_dist: FDistribution, f: PositiveFloat): float =
    #[
        Probability Density Function (PDF) for FDistribution.
        Accurate for up-to 15 decimal place.
    ]#
    let 
        numerator = sqrt(pow(f_dist.df_1.float * f, f_dist.df_1.float) * pow(f_dist.df_2.float, f_dist.df_2.float) / pow(f_dist.df_1.float * f + f_dist.df_2.float, (f_dist.df_1 + f_dist.df_2).float))
        denominator = f * beta(f_dist.df_1 / 2, f_dist.df_2 / 2)
    return numerator / denominator


proc cdf*(f_dist: FDistribution, f: PositiveFloat): float = 
    #[
        Cumulative Density Function (CDF) for FDistribution.
        Accurate for up-to 8 decimal place.
    ]#
    return regularized_incomplete_beta(f_dist.df_1.float / 2.0, f_dist.df_2.float / 2.0, (f_dist.df_1.float * f) / (f_dist.df_1.float * f + f_dist.df_2.float))


proc sf*(f_dist: FDistribution, f: PositiveFloat): float =
    #[
        Survival function (sf) for FDistribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 8 decimal place.
    ]#
    return 1 - f_dist.cdf(f)


proc ppf*(f_dist: FDistribution, p: FractionPositiveFloat): float = 
    #[
        Cumulative Density Function (CDF) for FDistribution.
        Accurate for up-to 8 decimal place.
    ]#
    return (f_dist.df_2 / f_dist.df_1) * (1 / inverse_regularized_upper_incomplete_beta(f_dist.df_2.float / 2, f_dist.df_1.float / 2, p) - 1)
