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
    GammaDistribution* = object
    #[
        'The beta distribution has been applied to model 
        the behavior of random variables limited to intervals 
        of finite length in a wide variety of disciplines.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Beta_distribution

    ]#
        k*: PositiveFloat
        theta*: PositiveFloat


proc initGammaDistribution*(k, theta: PositiveFloat): GammaDistribution = 
    result.k = k
    result.theta = theta


proc mean*(gamma_dist: GammaDistribution): float =
    return gamma_dist.k * gamma_dist.theta


proc mode*(gamma_dist: GammaDistribution): float =
    if gamma_dist.k < 1.0: return 0
    else: return gamma_dist.theta * (gamma_dist.k - 1.0)


proc variance*(gamma_dist: GammaDistribution): float =
    return gamma_dist.k  * pow2(gamma_dist.theta)


proc pdf*(gamma_dist: GammaDistribution, x: PositiveFloat): float =
    #[
        Probability Density Function (PDF) for GammaDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    return pow(x, gamma_dist.k - 1.0) * pow(E, -(x / gamma_dist.theta)) / (gamma(gamma_dist.k) * pow(gamma_dist.theta, gamma_dist.k))


proc cdf*(gamma_dist: GammaDistribution, x: PositiveFloat): float = 
    #[
        Cumulative Density Function (CDF) for GammaDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    return lower_incomplete_gamma(gamma_dist.k, x / gamma_dist.theta) / gamma(gamma_dist.k)


proc sf*(gamma_dist: GammaDistribution, x: PositiveFloat): float =
    #[
        Survival function (sf) for GammaDistribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 14 decimal place.
    ]#
    return 1 - gamma_dist.cdf(x)

