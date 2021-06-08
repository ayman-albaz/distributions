type
    Submodule* = object
      name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")


import math_utils


{.nanChecks: on, infChecks: on.}


type 
    UniformContinuousDistribution* = object 
        a*: float
        b*: float


proc initUniformContinuousDistribution*(a, b: float): UniformContinuousDistribution = 
    result.a = a
    result.b = b


proc mean*(uniform_continuous_dist: UniformContinuousDistribution): float =
    return 0.5 * (uniform_continuous_dist.a + uniform_continuous_dist.b)


proc median*(uniform_continuous_dist: UniformContinuousDistribution): float =
    return 0.5 * (uniform_continuous_dist.a + uniform_continuous_dist.b)


proc mode*(uniform_continuous_dist: UniformContinuousDistribution): float =
    return 0.5 * (uniform_continuous_dist.a + uniform_continuous_dist.b)


proc variance*(uniform_continuous_dist: UniformContinuousDistribution): float =
    return pow2(uniform_continuous_dist.b - uniform_continuous_dist.a) / 12.0


proc pdf*(uniform_continuous_dist: UniformContinuousDistribution, x: float): float =
    #[
        Probability Density Function (PDF) for UniformContinuousDistribution.
        Accurate for up-to 15 decimal place.
    ]#
    if x < uniform_continuous_dist.a or x > uniform_continuous_dist.b:
        return 0.0
    return 1.0 / (uniform_continuous_dist.b - uniform_continuous_dist.a)


proc cdf*(uniform_continuous_dist: UniformContinuousDistribution, x: float): float = 
    #[
        Cumulative Density Function (CDF) for UniformContinuousDistribution.
        Accurate for up-to 15 decimal place.
    ]#
    if x < uniform_continuous_dist.a:
        return 0.0
    elif x > uniform_continuous_dist.b:
        return 1.0
    return (x - uniform_continuous_dist.a) / (uniform_continuous_dist.b - uniform_continuous_dist.a)


proc sf*(uniform_continuous_dist: UniformContinuousDistribution, x: float): float =
    #[
        Survival function (sf) for UniformContinuousDistribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 15 decimal place.
    ]#
    return 1 - uniform_continuous_dist.cdf(x)


proc ppf*(uniform_continuous_dist: UniformContinuousDistribution, p: float): float =
    #[
        Point prevalence function (ppf) for UniformContinuousDistribution.
        Accurate for up-to 15 decimal place.
    ]#
    return p * (uniform_continuous_dist.b - uniform_continuous_dist.a) +  uniform_continuous_dist.a
