type
    Submodule* = object
      name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")


import utils


{.nanChecks: on, infChecks: on.}


type 
    BernoulliDistribution* = object
    #[ 
        'In probability theory and statistics, the Bernoulli distribution, 
        named after Swiss mathematician Jacob Bernoulli,[1] is the discrete probability 
        distribution of a random variable which takes the value 1 with probability p
        and the value 0 with probability q = 1 − p . Less formally, it can be thought of as a model 
        for the set of possible outcomes of any single experiment that asks a yes–no question. 
        Such questions lead to outcomes that are boolean-valued: a single bit whose value is 
        success/yes/true/one with probability p and failure/no/false/zero with probability q. 
        It can be used to represent a (possibly biased) coin toss where 1 and 0 would represent 
        "heads" and "tails" (or vice versa), respectively, and p would be the probability of 
        the coin landing on heads or tails, respectively. In particular, unfair coins would 
        have p ≠ 1 / 2. ' ~ Wikipedia
        https://en.wikipedia.org/wiki/bernoulli_distribution
    ]#
        p*: FractionPositiveFloat


proc initBernoulliDistribution*(p: FractionPositiveFloat): BernoulliDistribution = 
    result.p = p


proc mean*(bernoulli_dist: BernoulliDistribution): float =
    return bernoulli_dist.p


proc median*(bernoulli_dist: BernoulliDistribution): float =
    if bernoulli_dist.p < 0.5: return 0.0
    elif bernoulli_dist.p == 0.5: return 0.5
    elif bernoulli_dist.p > 0.5: return 1.0


proc mode*(bernoulli_dist: BernoulliDistribution): float =
    if bernoulli_dist.p < 0.5: return 0.0
    elif bernoulli_dist.p == 0.5: return 0.5
    elif bernoulli_dist.p > 0.5: return 1.0


proc variance*(bernoulli_dist: BernoulliDistribution): float =
    return bernoulli_dist.p * (1 - bernoulli_dist.p)


proc pmf*(bernoulli_dist: BernoulliDistribution, k: BinaryInteger): float =
    #[
        Probability Density Function (PDF) for BernoulliDistribution.
        Accurate for up-to 15 decimal place.
    ]#
    if k == 0:
        return 1 - bernoulli_dist.p
    elif k == 1:
        return bernoulli_dist.p


proc cdf*(bernoulli_dist: BernoulliDistribution, k: BinaryInteger): float = 
    #[
        Cumulative Density Function (CDF) for BernoulliDistribution.
        Accurate for up-to 15 decimal place.
    ]#
    if k == 0:
        return 1 - bernoulli_dist.p
    elif k >= 0:
        return 1

proc sf*(bernoulli_dist: BernoulliDistribution, k: BinaryInteger): float =
    #[
        Survival function (sf) for BernoulliDistribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 15 decimal place.
    ]#
    return 1 - bernoulli_dist.cdf(k)


proc ppf*(bernoulli_dist: BernoulliDistribution, p: FractionPositiveFloat): int = 
    #[
        Point prevalence function (ppf) for BernoulliDistribution.
        Accurate for up-to 15 decimal place.
    ]#
    if p <= 1 - bernoulli_dist.p:
        return 0
    else:
        return 1