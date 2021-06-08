type
    Submodule* = object
      name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")

import math_utils


{.nanChecks: on, infChecks: on.}


type 
    UniformDiscreteDistribution* = object 
        a*: int
        b*: int


proc initUniformDiscreteDistribution*(a, b: int): UniformDiscreteDistribution = 
    result.a = a
    result.b = b


proc mean*(uniform_discrete_dist: UniformDiscreteDistribution): float =
    return 0.5 * (uniform_discrete_dist.a + uniform_discrete_dist.b).float


proc median*(uniform_discrete_dist: UniformDiscreteDistribution): float =
    return 0.5 * (uniform_discrete_dist.a + uniform_discrete_dist.b).float


proc mode*(uniform_discrete_dist: UniformDiscreteDistribution): float =
    return 0.5 * (uniform_discrete_dist.a + uniform_discrete_dist.b).float


proc variance*(uniform_discrete_dist: UniformDiscreteDistribution): float =
    return (pow2(uniform_discrete_dist.b - uniform_discrete_dist.a + 1) - 1).float / 12.0


proc pmf*(uniform_discrete_dist: UniformDiscreteDistribution, x: int): float =
    #[
        Probability Mass Function (PMF) for UniformDiscreteDistribution.
        Accurate for up-to 15 decimal place.
    ]#
    if x < uniform_discrete_dist.a or x > uniform_discrete_dist.b:
        return 0.0
    return 1 / (uniform_discrete_dist.b - uniform_discrete_dist.a + 1)


proc cdf*(uniform_discrete_dist: UniformDiscreteDistribution, x: int): float = 
    #[
        Cumulative Density Function (CDF) for UniformDiscreteDistribution.
        Accurate for up-to 15 decimal place.
    ]#
    if x < uniform_discrete_dist.a:
        return 0.0
    elif x > uniform_discrete_dist.b:
        return 1.0
    return (x - uniform_discrete_dist.a + 1) / (uniform_discrete_dist.b - uniform_discrete_dist.a + 1)


proc sf*(uniform_discrete_dist: UniformDiscreteDistribution, x: int): float =
    #[
        Survival function (sf) for UniformDiscreteDistribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 15 decimal place.
    ]#
    return 1 - uniform_discrete_dist.cdf(x)


proc ppf*(uniform_discrete_dist: UniformDiscreteDistribution, p: float): int =
    #[
        Point prevalence function (ppf) for UniformDiscreteDistribution.
        Accurate for up-to 15 decimal place.
    ]#
    var k = uniform_discrete_dist.a
    while true:
        if uniform_discrete_dist.cdf(k) >= p:
            return k
        k += 1 

