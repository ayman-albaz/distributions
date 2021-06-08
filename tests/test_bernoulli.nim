import math
import times
import unittest

import distributions/bernoulli


suite "BernoulliDistribution":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "BernoulliDistribution(0.75).mean()":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.mean().round(15) == 0.75.round(15)

    test "BernoulliDistribution(0.75).median()":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.median().round(15) == 1.0.round(15)

    test "BernoulliDistribution(0.75).model()":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.mode().round(15) == 1.0.round(15)

    test "BernoulliDistribution(0.75).variance()":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.variance().round(15) == 0.1875.round(15)

    test "BernoulliDistribution(0.75).pmf(0)":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.pmf(0).round(15) == 0.25.round(15)

    test "BernoulliDistribution(0.75).pmf(1)":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.pmf(1).round(15) == 0.75.round(15)

    test "BernoulliDistribution(0.75).cdf(0)":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.cdf(0).round(15) == 0.25.round(15)

    test "BernoulliDistribution(0.75).cdf(1)":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.cdf(1).round(15) == 1.0.round(15)

    test "BernoulliDistribution(0.75).sf(0)":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.sf(0).round(15) == 0.75.round(15)

    test "BernoulliDistribution(0.75).sf(1)":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.sf(1).round(15) == 0.0.round(15)

    test "BernoulliDistribution(0.75).ppf(0.0)":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.ppf(0.0) == 0

    test "BernoulliDistribution(0.75).ppf(0.5)":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.ppf(0.5) == 1

    test "BernoulliDistribution(0.75).ppf(1.0)":
        let bernoulli_dist = initBernoulliDistribution(0.75)
        check bernoulli_dist.ppf(1) == 1
