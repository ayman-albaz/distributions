import math
import times
import unittest

import distributions/binomial


suite "BinomialDistribution":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "BinomialDistribution(40, 0.5).pmf(10)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.pmf(10).round(15) == 0.0007709427591180397.round(15)

    test "BinomialDistribution(40, 0.5).pmf(20)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.pmf(20).round(15) == 0.1253706876195787.round(15)

    test "BinomialDistribution(40, 0.5).pmf(30)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.pmf(30).round(15) == 0.0007709427591180404.round(15)

    test "BinomialDistribution(40, 0.5).cdf(10)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.cdf(10).round(8) == 0.0011107168866146822.round(8)

    test "BinomialDistribution(40, 0.5).cdf(20)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.cdf(20).round(8) == 0.5626853438097896.round(8)

    test "BinomialDistribution(40, 0.5).cdf(30)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.cdf(30).round(8) == 0.9996602258725034.round(8)

    test "BinomialDistribution(40, 0.5).sf(10)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.sf(10).round(8) == 0.9988892831133853.round(8)

    test "BinomialDistribution(40, 0.5).sf(20)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.sf(20).round(8) == 0.4373146561902104.round(8)

    test "BinomialDistribution(40, 0.5).sf(30)":
        let binomial_dist = initBinomialDistribution(40, 0.5)
        check binomial_dist.sf(30).round(8) == 0.00033977412749663927.round(8)

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