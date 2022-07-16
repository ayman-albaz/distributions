import math
import times
import unittest

import distributions

suite "BinomialDistribution":
  
  const r1 = 14
  const r2 = 13

  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

  test "BinomialDistribution(10, 0.25).mean()":
    let binomial_dist = initBinomialDistribution(10, 0.25)
    check binomial_dist.mean().round(r1) == 2.5.round(r1)

  test "BinomialDistribution(10, 0.5).mean()":
    let binomial_dist = initBinomialDistribution(10, 0.50)
    check binomial_dist.mean().round(r1) == 5.0.round(r1)

  test "BinomialDistribution(10, 0.75).mean()":
    let binomial_dist = initBinomialDistribution(10, 0.75)
    check binomial_dist.mean().round(r1) == 7.5.round(r1)

  test "BinomialDistribution(10, 0.25).median()":
    let binomial_dist = initBinomialDistribution(10, 0.25)
    check binomial_dist.median().round(r1) == 3.0.round(r1)

  test "BinomialDistribution(10, 0.5).median()":
    let binomial_dist = initBinomialDistribution(10, 0.50)
    check binomial_dist.median().round(r1) == 5.0.round(r1)

  test "BinomialDistribution(10, 0.75).median()":
    let binomial_dist = initBinomialDistribution(10, 0.75)
    check binomial_dist.median().round(r1) == 8.0.round(r1)

  test "BinomialDistribution(10, 0.25).mode()":
    let binomial_dist = initBinomialDistribution(10, 0.25)
    check binomial_dist.mode().round(r1) == 3.0.round(r1)

  test "BinomialDistribution(10, 0.5).mode()":
    let binomial_dist = initBinomialDistribution(10, 0.50)
    check binomial_dist.mode().round(r1) == 6.0.round(r1)

  test "BinomialDistribution(10, 0.75).mode()":
    let binomial_dist = initBinomialDistribution(10, 0.75)
    check binomial_dist.mode().round(r1) == 8.0.round(r1)

  test "BinomialDistribution(10, 0.25).variance()":
    let binomial_dist = initBinomialDistribution(10, 0.25)
    check binomial_dist.variance().round(r1) == 1.875.round(r1)

  test "BinomialDistribution(10, 0.5).variance()":
    let binomial_dist = initBinomialDistribution(10, 0.50)
    check binomial_dist.variance().round(r1) == 2.5.round(r1)

  test "BinomialDistribution(10, 0.75).variance()":
    let binomial_dist = initBinomialDistribution(10, 0.75)
    check binomial_dist.variance().round(r1) == 1.875.round(r1)

  test "BinomialDistribution(40, 0.5).pmf(10)":
    let binomial_dist = initBinomialDistribution(40, 0.5)
    check binomial_dist.pmf(10).round(r1) == 0.0007709427591180397.round(r1)

  test "BinomialDistribution(40, 0.5).pmf(20)":
    let binomial_dist = initBinomialDistribution(40, 0.5)
    check binomial_dist.pmf(20).round(r1) == 0.1253706876195787.round(r1)

  test "BinomialDistribution(40, 0.5).pmf(30)":
    let binomial_dist = initBinomialDistribution(40, 0.5)
    check binomial_dist.pmf(30).round(r1) == 0.0007709427591180404.round(r1)

  test "BinomialDistribution(40, 0.5).cdf(10)":
    let binomial_dist = initBinomialDistribution(40, 0.5)
    check binomial_dist.cdf(10).round(r1) == 0.001110716886614682.round(r1)

  test "BinomialDistribution(40, 0.5).cdf(20)":
    let binomial_dist = initBinomialDistribution(40, 0.5)
    check binomial_dist.cdf(20).round(r2) == 0.5626853438097896.round(r2)

  test "BinomialDistribution(40, 0.5).cdf(30)":
    let binomial_dist = initBinomialDistribution(40, 0.5)
    check binomial_dist.cdf(30).round(r1) == 0.9996602258725034.round(r1)

  test "BinomialDistribution(40, 0.5).sf(10)":
    let binomial_dist = initBinomialDistribution(40, 0.5)
    check binomial_dist.sf(10).round(r2) == 0.9988892831133853.round(r2)

  test "BinomialDistribution(40, 0.5).sf(20)":
    let binomial_dist = initBinomialDistribution(40, 0.5)
    check binomial_dist.sf(20).round(r2) == 0.4373146561902104.round(r2)

  test "BinomialDistribution(40, 0.5).sf(30)":
    let binomial_dist = initBinomialDistribution(40, 0.5)
    check binomial_dist.sf(30).round(r2) == 0.00033977412749663927.round(r2)

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