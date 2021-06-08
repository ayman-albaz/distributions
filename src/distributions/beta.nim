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


proc mean*(beta_dist: BetaDistribution): float =
    return beta_dist.alpha / (beta_dist.alpha + beta_dist.beta)


proc median*(beta_dist: BetaDistribution): float =
    return regularized_lower_incomplete_beta(beta_dist.alpha, beta_dist.beta, 0.5)


proc mode*(beta_dist: BetaDistribution): float =
    if beta_dist.alpha > 1.0 and beta_dist.beta > 1.0: return (beta_dist.alpha - 1) / (beta_dist.alpha + beta_dist.beta - 2)
    elif beta_dist.alpha == 1.0 and beta_dist.beta == 1.0: return 0.5
    elif beta_dist.alpha < 1.0 and beta_dist.beta < 1.0: return 0.5
    elif beta_dist.alpha <= 1.0 and beta_dist.beta > 1.0: return 0.0
    elif beta_dist.alpha > 1.0 and beta_dist.beta <= 1.0: return 1.0


proc variance*(beta_dist: BetaDistribution): float =
    return beta_dist.alpha * beta_dist.beta / (pow2(beta_dist.alpha + beta_dist.beta) * (beta_dist.alpha + beta_dist.beta + 1.0))


proc pdf*(beta_dist: BetaDistribution, b: FractionPositiveFloat): float =
    #[
        Probability Density Function (PDF) for BetaDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    return pow(b, beta_dist.alpha - 1.0) * pow(1 - b, beta_dist.beta - 1) / beta(beta_dist.alpha, beta_dist.beta) 


proc cdf*(beta_dist: BetaDistribution, b: FractionPositiveFloat): float = 
    #[
        Cumulative Density Function (CDF) for BetaDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    return regularized_lower_incomplete_beta(beta_dist.alpha, beta_dist.beta, b)


proc sf*(beta_dist: BetaDistribution, b: FractionPositiveFloat): float =
    #[
        Survival function (sf) for BetaDistribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 14 decimal place.
    ]#
    return 1 - beta_dist.cdf(b)


proc ppf*(beta_dist: BetaDistribution, p: FractionPositiveFloat): float = 
    #[
        Point prevalence function (ppf) for BetaDistribution.
        Accurate for up-to 14 decimal place.
    ]#
    return inverse_regularized_lower_incomplete_beta(beta_dist.alpha, beta_dist.beta, p)