type
  Submodule* = object
    name*: string

proc initSubmodule*(): Submodule =
  ## Initialises a new ``Submodule`` object.
  Submodule(name: "Anonymous")


import math
import math_utils
import special_functions
import utils


{.nanChecks: on, infChecks: on.}


type 
    BinomialDistribution* = object
    #[ 
        'The binomial distribution is frequently used to model
        the number of successes in a sample of size n drawn with replacement
        from a population of size N. If the sampling is carried out without replacement,
        the draws are not independent and so the resulting distribution
        is a hypergeometric distribution, not a binomial one.
        However, for N much larger than n, the binomial distribution
        remains a good approximation, and is widely used.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Binomial_distribution
    ]#
        n*: Positive
        p*: FractionPositiveFloat


proc initBinomialDistribution*(n: Positive, p: FractionPositiveFloat): BinomialDistribution = 
    result.n = n
    result.p = p


proc pmf*(binomial_dist: BinomialDistribution, k: Natural): float =
    #[
        Probability Density Function (PDF) for BinomialDistribution.
        Accurate for up-to 15 decimal place.
    ]#
    return binomial_coefficient(binomial_dist.n, k).float * pow(binomial_dist.p, k.float) * pow(1.0 - binomial_dist.p, (binomial_dist.n - k).float)


proc cdf*(binomial_dist: BinomialDistribution, k: Natural): float = 
    #[
        Cumulative Density Function (CDF) for BinomialDistribution.
        Accurate for up-to 8 decimal place.
    ]#
    return regularized_incomplete_beta((binomial_dist.n - k).float, (1 + k).float, 1.0 - binomial_dist.p)


proc sf*(binomial_dist: BinomialDistribution, k: Natural): float =
    #[
        Survival function (sf) for BinomialDistribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 8 decimal place.
    ]#
    return 1 - binomial_dist.cdf(k)


proc ppf*(binomial_dist: BinomialDistribution, p: FractionPositiveFloat): int = 
    #[
        Point prevalence function (ppf) for BinomialDistribution.
        Accurate for up-to 10 decimal place.
    ]#
    var k = 1
    while true:
        if binomial_dist.cdf(k) >= p:
            return k
        k += 1 