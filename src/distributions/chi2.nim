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
    Chi2Distribution* = object 
        df*: int


proc initChi2Distribution*(df: int): Chi2Distribution = 
    if df <= 0:
        raise newException(ValueError, "df must be > 0.")
    result.df = df


proc pdf*(chi2_dist: Chi2Distribution, chi2: PositiveFloat): float =
    #[
        Probability Density Function (PDF) for Chi2Distribution.
        Accurate for up-to 15 decimal place.
    ]#
    return pow(chi2, (chi2_dist.df.float / 2.float - 1)) * pow(E, -chi2 / 2.0) / (pow(2.0, chi2_dist.df.float / 2.0) * gamma(chi2_dist.df.float / 2.0))


proc cdf*(chi2_dist: Chi2Distribution, chi2: PositiveFloat): float = 
    #[
        Cumulative Density Function (CDF) for Chi2Distribution.
        Accurate for up-to 15 decimal place.
    ]#
    return lower_incomplete_gamma(chi2 / 2.0, chi2_dist.df.float / 2.0)


proc sf*(chi2_dist: Chi2Distribution, chi2: PositiveFloat): float =
    #[
        Survival function (sf) for Chi2Distribution.
        Equivalent to 1 - cdf.
        Accurate for up-to 15 decimal place.
    ]#
    return 1 - chi2_dist.cdf(chi2)


