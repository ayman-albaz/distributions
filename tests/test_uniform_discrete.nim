import math
import times
import unittest

import distributions/uniform_discrete


suite "UniformDiscreteDistribution":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0


    test "UniformDiscreteDistribution(0, 1).mean()":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.mean().round(15) == 0.5.round(15)

    test "UniformDiscreteDistribution(0, 1).median()":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.median().round(15) == 0.5.round(15)

    test "UniformDiscreteDistribution(0, 1).mode()":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.mode().round(15) == 0.5.round(15)

    test "UniformDiscreteDistribution(0, 1).variance()":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.variance().round(15) == 0.25.round(15)

    test "UniformDiscreteDistribution(0, 1).pmf(0)":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.pmf(0).round(15) == 0.5.round(15)

    test "UniformDiscreteDistribution(0, 1).pmf(1)":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.pmf(1).round(15) == 0.5.round(15)

    test "UniformDiscreteDistribution(0, 1).pmf(2)":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.pmf(2).round(15) == 0.0.round(15)

    test "UniformDiscreteDistribution(0, 1).cdf(0)":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.cdf(0).round(15) == 0.5.round(15)

    test "UniformDiscreteDistribution(0, 1).cdf(1)":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.cdf(1).round(15) == 1.0.round(15)

    test "UniformDiscreteDistribution(0, 1).cdf(2)":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.cdf(2).round(15) == 1.0.round(15)

    test "UniformDiscreteDistribution(0, 1).sf(0)":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.sf(0).round(15) == 0.5.round(15)

    test "UniformDiscreteDistribution(0, 1).sf(1)":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.sf(1).round(15) == 0.0.round(15)

    test "UniformDiscreteDistribution(0, 1).sf(2)":
        let uniform_discrete_dist = initUniformDiscreteDistribution(0, 1)
        check uniform_discrete_dist.sf(2).round(15) == 0.0.round(15)

    test "UniformDiscreteDistribution(-1, 1).ppf(0.25)":
        let uniform_discrete_dist = initUniformDiscreteDistribution(-1, 1)
        check uniform_discrete_dist.ppf(0.25) == -1

    test "UniformDiscreteDistribution(-1, 1).ppf(0.50)":
        let uniform_discrete_dist = initUniformDiscreteDistribution(-1, 1)
        check uniform_discrete_dist.ppf(0.50) == 0

    test "UniformDiscreteDistribution(-1, 1).ppf(0.75)":
        let uniform_discrete_dist = initUniformDiscreteDistribution(-1, 1)
        check uniform_discrete_dist.ppf(0.75) == 1