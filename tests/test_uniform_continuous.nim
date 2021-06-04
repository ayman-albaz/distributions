import math
import times
import unittest

import distributions/uniform_continuous

suite "UniformContinuousDistribution":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "UniformContinuousDistribution(0.0, 1.0).pdf(0.0)":
        let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
        check uniform_continuous_dist.pdf(0.0).round(15) == 1.0.round(15)

    test "UniformContinuousDistribution(0.0, 1.0).pdf(1.0)":
        let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
        check uniform_continuous_dist.pdf(1.0).round(15) == 1.0.round(15)

    test "UniformContinuousDistribution(0.0, 1.0).pdf(2.0)":
        let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
        check uniform_continuous_dist.pdf(2.0).round(15) == 0.0.round(15)

    test "UniformContinuousDistribution(0.0, 1.0).cdf(0.0)":
        let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
        check uniform_continuous_dist.cdf(0.0).round(15) == 0.0.round(15)

    test "UniformContinuousDistribution(0.0, 1.0).cdf(1.0)":
        let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
        check uniform_continuous_dist.cdf(1.0).round(15) == 1.0.round(15)

    test "UniformContinuousDistribution(0.0, 1.0).cdf(2.0)":
        let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
        check uniform_continuous_dist.cdf(2.0).round(15) == 1.0.round(15)

    test "UniformContinuousDistribution(0.0, 1.0).sf(0.0)":
        let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
        check uniform_continuous_dist.sf(0.0).round(15) == 1.0.round(15)

    test "UniformContinuousDistribution(0.0, 1.0).sf(1.0)":
        let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
        check uniform_continuous_dist.sf(1.0).round(15) == 0.0.round(15)

    test "UniformContinuousDistribution(0.0, 1.0).sf(2.0)":
        let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
        check uniform_continuous_dist.sf(2.0).round(15) == 0.0.round(15)

    test "UniformContinuousDistribution(-1.0, -1.0).ppf(0.0)":
        let uniform_continuous_dist = initUniformContinuousDistribution(-1.0, 1.0)
        check uniform_continuous_dist.ppf(0.25).round(15) == -0.50.round(15)

    test "UniformContinuousDistribution(-1.0, -1.0).ppf(1.0)":
        let uniform_continuous_dist = initUniformContinuousDistribution(-1.0, 1.0)
        check uniform_continuous_dist.ppf(0.50).round(15) == 0.0.round(15)

    test "UniformContinuousDistribution(-1.0, -1.0).ppf(2.0)":
        let uniform_continuous_dist = initUniformContinuousDistribution(-1.0, 1.0)
        check uniform_continuous_dist.ppf(0.75).round(15) == 0.50.round(15)