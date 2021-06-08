import math
import times
import unittest

import distributions/binomial


suite "BinomialDistribution":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "BinomialDistribution(10, 0.25).mean()":
        let binomial_dist = initBinomialDistribution(10, 0.25)
        check binomial_dist.mean().round(14) == 2.5.round(14)

    test "BinomialDistribution(10, 0.5).mean()":
        let binomial_dist = initBinomialDistribution(10, 0.50)
        check binomial_dist.mean().round(14) == 5.0.round(14)

    test "BinomialDistribution(10, 0.75).mean()":
        let binomial_dist = initBinomialDistribution(10, 0.75)
        check binomial_dist.mean().round(14) == 7.5.round(14)

    test "BinomialDistribution(10, 0.25).median()":
        let binomial_dist = initBinomialDistribution(10, 0.25)
        check binomial_dist.median().round(14) == 3.0.round(14)

    test "BinomialDistribution(10, 0.5).median()":
        let binomial_dist = initBinomialDistribution(10, 0.50)
        check binomial_dist.median().round(14) == 5.0.round(14)

    test "BinomialDistribution(10, 0.75).median()":
        let binomial_dist = initBinomialDistribution(10, 0.75)
        check binomial_dist.median().round(14) == 8.0.round(14)

    test "BinomialDistribution(10, 0.25).mode()":
        let binomial_dist = initBinomialDistribution(10, 0.25)
        check binomial_dist.mode().round(14) == 3.0.round(14)

    test "BinomialDistribution(10, 0.5).mode()":
        let binomial_dist = initBinomialDistribution(10, 0.50)
        check binomial_dist.mode().round(14) == 6.0.round(14)

    test "BinomialDistribution(10, 0.75).mode()":
        let binomial_dist = initBinomialDistribution(10, 0.75)
        check binomial_dist.mode().round(14) == 8.0.round(14)

    test "BinomialDistribution(10, 0.25).variance()":
        let binomial_dist = initBinomialDistribution(10, 0.25)
        check binomial_dist.variance().round(14) == 1.875.round(14)

    test "BinomialDistribution(10, 0.5).variance()":
        let binomial_dist = initBinomialDistribution(10, 0.50)
        check binomial_dist.variance().round(14) == 2.5.round(14)

    test "BinomialDistribution(10, 0.75).variance()":
        let binomial_dist = initBinomialDistribution(10, 0.75)
        check binomial_dist.variance().round(14) == 1.875.round(14)

    test "BinomialDistribution(40, 0.5).pmf(10)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.pmf(10).round(14) == 0.0007709427591180397.round(14)

    test "BinomialDistribution(40, 0.5).pmf(20)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.pmf(20).round(14) == 0.1253706876195787.round(14)

    test "BinomialDistribution(40, 0.5).pmf(30)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.pmf(30).round(14) == 0.0007709427591180404.round(14)

    test "BinomialDistribution(40, 0.5).cdf(10)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.cdf(10).round(14) == 0.001110716886614682.round(14)

    test "BinomialDistribution(40, 0.5).cdf(20)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.cdf(20).round(13) == 0.5626853438097896.round(13)

    test "BinomialDistribution(40, 0.5).cdf(30)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.cdf(30).round(14) == 0.9996602258725034.round(14)

    test "BinomialDistribution(40, 0.5).sf(10)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.sf(10).round(13) == 0.9988892831133853.round(13)

    test "BinomialDistribution(40, 0.5).sf(20)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.sf(20).round(13) == 0.4373146561902104.round(13)

    test "BinomialDistribution(40, 0.5).sf(30)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.sf(30).round(13) == 0.00033977412749663927.round(13)

    test "BinomialDistribution(40, 0.5).ppf(0.25)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.ppf(0.25) == 18

    test "BinomialDistribution(40, 0.5).ppf(0.5)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.ppf(0.5) == 20

    test "BinomialDistribution(40, 0.5).ppf(0.75)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.ppf(0.75) == 22

    test "BinomialDistribution(40, 0.5).ppf(0.76)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.ppf(0.76) == 22