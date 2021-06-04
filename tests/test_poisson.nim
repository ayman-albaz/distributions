import math
import times
import unittest

import distributions/poisson


suite "PoissonDistribution":

    #[
        Benchmarked against Julia's distributions.jl.
    ]#
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "PoissonDistribution(40).pmf(30)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.pmf(30).round(12) == 0.018465470960734028.round(12)

    test "PoissonDistribution(40).pmf(40)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.pmf(40).round(12) == 0.0629470394235922.round(12)

    test "PoissonDistribution(40).pmf(50)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.pmf(50).round(12) == 0.017707017552636196.round(12)

    test "PoissonDistribution(40).cdf(30)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.cdf(30).round(12) == 0.06169415311246949.round(12)

    test "PoissonDistribution(40).cdf(40)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.cdf(40).round(12) == 0.5419181783625371.round(12)

    test "PoissonDistribution(40).cdf(50)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.cdf(50).round(12) == 0.9473719508932414.round(12)

    test "PoissonDistribution(40).sf(30)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.sf(30).round(8) == 0.9383058468875305.round(8)

    test "PoissonDistribution(40).sf(40)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.sf(40).round(8) == 0.4580818216374629.round(8)

    test "PoissonDistribution(40).sf(50)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.sf(50).round(8) == 0.052628049106758557.round(8)

    test "PoissonDistribution(40).ppf(0.25)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.ppf(0.25) == 36

    test "PoissonDistribution(40).ppf(0.5)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.ppf(0.5) == 40

    test "PoissonDistribution(40).ppf(0.75)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.ppf(0.75) == 44

    test "PoissonDistribution(40).ppf(0.76)":
        let poisson_dist = initPoissonDistribution(40)
        check poisson_dist.ppf(0.76) == 44