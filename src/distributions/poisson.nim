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
    PoissonDistribution* = object
    #[ 
        'In probability theory and statistics, the Poisson distribution
        named after French mathematician Denis Poisson, is a discrete
        probability distribution that expresses the probability of a given number
        of events occurring in a fixed interval of time or space if these events
        occur with a known constant mean rate and independently
        of the time since the last even' ~ Wikipedia
        https://en.wikipedia.org/wiki/Poisson_distribution
    ]#
        lambda*: PositiveFloat


proc initPoissonDistribution*(lambda: Natural): PoissonDistribution = 
    result.lambda = lambda


proc mean*(poisson_dist: PoissonDistribution): float =
    return poisson_dist.lambda.float


proc median*(poisson_dist: PoissonDistribution): float =
    return poisson_dist.lambda.float


proc mode*(poisson_dist: PoissonDistribution): float =
    return poisson_dist.lambda.float


proc variance*(poisson_dist: PoissonDistribution): float =
    return poisson_dist.lambda.float


proc pmf*(poisson_dist: PoissonDistribution, k: Natural): float =
    #[
        Probability Density Function (PDF) for PoissonDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    # return pow(poisson_dist.lambda.float, k.float) * pow(E, -poisson_dist.lambda.float) / fac(k).float
    return exp(ln(pow(poisson_dist.lambda.float, k.float)) + ln(pow(E, -poisson_dist.lambda.float)) - lfac(k))


proc cdf*(poisson_dist: PoissonDistribution, k: Natural): float = 
    #[
        Cumulative Density Function (CDF) for PoissonDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    return regularized_upper_incomplete_gamma(k.float + 1.0, poisson_dist.lambda.float)
    # var total = 0.0
    # for i in 0..k:
    #     total += poisson_dist.pmf(i)
    # return total


proc sf*(poisson_dist: PoissonDistribution, k: Natural): float =
    #[
        Survival function (sf) for PoissonDistribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 14 decimal place.
    ]#
    return 1 - poisson_dist.cdf(k)


proc ppf*(poisson_dist: PoissonDistribution, p: FractionPositiveFloat): int = 
    #[
        Point prevalence function (ppf) for PoissonDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    var k = 1
    while true:
        if poisson_dist.cdf(k) >= p:
            return k
        k += 1 
