type
    Submodule* = object
      name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")


import math
import math_utils
import special_functions/beta
import utils


{.nanChecks: on, infChecks: on.}


type 
    NegativeBinomialDistribution* = object
    #[
        'In probability theory and statistics, the negative binomial distribution 
        is a discrete probability distribution that models the number of successes 
        in a sequence of independent and identically distributed Bernoulli trials 
        before a specified (non-random) number of failures (denoted r) occurs.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Negative_binomial_distribution
    ]#
        r*: Positive
        p*: FractionPositiveFloat


proc initNegativeBinomialDistribution*(r: Positive, p: FractionPositiveFloat): NegativeBinomialDistribution = 
    result.r = r
    result.p = p


proc mean*(negative_binomial_dist: NegativeBinomialDistribution): float =
    return (negative_binomial_dist.r.float * (1 - negative_binomial_dist.p)) / negative_binomial_dist.p


proc mode*(negative_binomial_dist: NegativeBinomialDistribution): float =
    if negative_binomial_dist.r <= 1: return 0.0
    else: return ((negative_binomial_dist.r - 1).float * (1 - negative_binomial_dist.p)) / negative_binomial_dist.p


proc variance*(negative_binomial_dist: NegativeBinomialDistribution): float =
    return (negative_binomial_dist.r.float * (1 - negative_binomial_dist.p)) / pow2(negative_binomial_dist.p)


proc pmf*(negative_binomial_dist: NegativeBinomialDistribution, k: Natural): float =
    #[
        Probability Density Function (PDF) for NegativeBinomialDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    return binom(k + negative_binomial_dist.r - 1, k).float * pow(1.0 - negative_binomial_dist.p, negative_binomial_dist.r.float) * pow(negative_binomial_dist.p, k.float)


proc cdf*(negative_binomial_dist: NegativeBinomialDistribution, k: Natural): float = 
    #[
        Cumulative Density Function (CDF) for NegativeBinomialDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    return 1 - regularized_lower_incomplete_beta((k + 1).float, negative_binomial_dist.r.float, negative_binomial_dist.p)


proc sf*(negative_binomial_dist: NegativeBinomialDistribution, k: Natural): float =
    #[
        Survival function (sf) for NegativeBinomialDistribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 14 decimal place.
    ]#
    return 1 - negative_binomial_dist.cdf(k)


proc ppf*(negative_binomial_dist: NegativeBinomialDistribution, p: FractionPositiveFloat): int = 
    #[
        Point prevalence function (ppf) for BinomialDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    var k = 1
    while true:
        if negative_binomial_dist.cdf(k) >= p:
            return k
        k += 1 
