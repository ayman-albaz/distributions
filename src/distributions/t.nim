type
    Submodule* = object
      name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")


import math
import math_utils
import special_functions/beta


{.nanChecks: on, infChecks: on.}


type 
    TDistribution* = object 
    #[
        'In probability and statistics, Student's t-distribution (or simply the t-distribution)
        is any member of a family of continuous probability distributions that arise when
        estimating the mean of a normally-distributed population in situations where
        the sample size is small and the population's standard deviation is unknown.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Student%27s_t-distribution
    ]#
        df*: Natural


proc initTDistribution*(df: Natural): TDistribution = 
    result.df = df


proc mean*(t_dist: TDistribution): float =
    return 0.0


proc median*(t_dist: TDistribution): float =
    return 0.0


proc mode*(t_dist: TDistribution): float =
    return 0.0


proc variance*(t_dist: TDistribution): float =
    if t_dist.df <= 2: return Inf
    else: return t_dist.df / (t_dist.df - 2)


proc pdf*(t_dist: TDistribution, t: float): float =
    #[
        Probability Density Function (PDF) for TDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    return gamma((t_dist.df + 1) / 2) / (sqrt(PI * t_dist.df.float) * gamma(t_dist.df / 2) * pow(1.float + pow2(t) / t_dist.df.float, (((t_dist.df + 1) / 2))))


proc cdf*(t_dist: TDistribution, t: float): float = 
    #[
        Cumulative Density Function (CDF) for TDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    let 
        x: float = (t + sqrt(t * t + t_dist.df.float)) / (2.0 * sqrt(t * t + t_dist.df.float))
        prob: float = regularized_lower_incomplete_beta(t_dist.df.float / 2.0, t_dist.df.float / 2.0, x)
    return prob


proc sf*(t_dist: TDistribution, t: float): float =
    #[
        Survival function (sf) for TDistribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 14 decimal place.
    ]#
    return 1 - t_dist.cdf(t)
