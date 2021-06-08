type
    Submodule* = object
      name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")


import math
import math_utils
import random
import special_functions/erf
import utils


{.nanChecks: on, infChecks: on.}


type 
    NormalDistribution* = object
        #[
            'Normal distributions are important in statistics
            and are often used in the natural and social sciences
            to represent real-valued random variables whose distributions
            are not known. Their importance is partly due to the central limit theorem.
            It states that, under some conditions, the average of many
            samples (observations) of a random variable with finite mu and
            variance is itself a random variable—whose distribution converges
            to a normal distribution as the number of samples increases.
            Therefore, physical quantities that are expected to be the sum of many
            independent processes, such as measurement errors, often have
            distributions that are nearly normal' ~ Wikipedia
            https://en.wikipedia.org/wiki/Normal_distribution
        ]#
        mu*: float
        sigma*: PositiveFloat


proc initNormalDistribution*(mu: float = 0.0, sigma: PositiveFloat = 1.0): NormalDistribution = 
    result.mu = mu
    result.sigma = sigma


proc mean*(normal_dist: NormalDistribution): float =
    return normal_dist.mu


proc median*(normal_dist: NormalDistribution): float =
    return normal_dist.mu


proc mode*(normal_dist: NormalDistribution): float =
    return normal_dist.mu


proc variance*(normal_dist: NormalDistribution): float =
    return pow2(normal_dist.sigma)


proc pdf*(normal_dist: NormalDistribution, z: float): float =
    #[
        Probability Density Function (PDF) for NormalDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    return pow(E, (-0.5 * pow2((z - normal_dist.mu) / normal_dist.sigma))) / (normal_dist.sigma * sqrt(2.0 * PI))


proc cdf*(normal_dist: NormalDistribution, z: float): float = 
    #[
        Cumulative Density Function (CDF) for NormalDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    return 0.5 * (1 + erf((z - normal_dist.mu) / (normal_dist.sigma * sqrt(2.0))))


proc sf*(normal_dist: NormalDistribution, z: float): float =
    #[
        Survival function (sf) for NormalDistribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 14 decimal place.
    ]#
    return 1 - normal_dist.cdf(z)


proc ppf*(normal_dist: NormalDistribution, p: FractionPositiveFloat): float = 
    #[
        Point prevalence function (ppf) for NormalDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    return normal_dist.mu + normal_dist.sigma * sqrt(2.0) * inverse_erf(2.0 * p - 1.0)


var rng: Rand = initRand(1)
proc rand*(normal_dist: NormalDistribution, rng: var Rand = rng): float = 
    return gauss(rng, normal_dist.mu, normal_dist.sigma)
