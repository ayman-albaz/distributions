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
    BetaDistribution* = object
    #[
        'The beta distribution has been applied to model 
        the behavior of random variables limited to intervals 
        of finite length in a wide variety of disciplines.' ~ Wikipedia
        https://en.wikipedia.org/wiki/Beta_distribution

    ]#
        alpha*: PositiveFloat
        beta*: PositiveFloat


proc initBetaDistribution*(alpha, beta: PositiveFloat): BetaDistribution = 
    result.alpha = alpha
    result.beta = beta


proc pdf*(beta_dist: BetaDistribution, b: FractionPositiveFloat): float =
    #[
        Probability Density Function (PDF) for BetaDistribution.
        Accurate for up-to 15 decimal place.
    ]#
    return pow(b, beta_dist.alpha - 1.0) * pow(1 - b, beta_dist.beta - 1) / beta(beta_dist.alpha, beta_dist.beta) 


proc cdf*(beta_dist: BetaDistribution, b: FractionPositiveFloat): float = 
    #[
        Cumulative Density Function (CDF) for BetaDistribution.
        Accurate for up-to 8 decimal place.
    ]#
    return regularized_incomplete_beta(beta_dist.alpha, beta_dist.beta, b)


proc sf*(beta_dist: BetaDistribution, b: FractionPositiveFloat): float =
    #[
        Survival function (sf) for BetaDistribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 8 decimal place.
    ]#
    return 1 - beta_dist.cdf(b)


proc ppf*(beta_dist: BetaDistribution, p: FractionPositiveFloat): float = 
    #[
        Point prevalence function (ppf) for BetaDistribution.
        Accurate for up-to 10 decimal place.
    ]#
    return inverse_regularized_lower_incomplete_beta(beta_dist.alpha, beta_dist.beta, p)