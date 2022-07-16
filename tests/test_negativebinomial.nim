import math
import times
import unittest

import distributions


suite "NegativeBinomialDistribution":
  
  const r1 = 14

  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0


  test "NegativeBinomialDistribution(10, 0.25).mean()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25)
    check negative_binomial_dist.mean().round(r1) == 30.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.5).mean()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.50)
    check negative_binomial_dist.mean().round(r1) == 10.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.75).mean()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.75)
    check negative_binomial_dist.mean().round(r1) == 3.3333333333333335.round(r1)

  test "NegativeBinomialDistribution(10, 0.25).mode()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25)
    check negative_binomial_dist.mode().round(r1) == 27.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.5).mode()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.50)
    check negative_binomial_dist.mode().round(r1) == 9.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.75).mode()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.75)
    check negative_binomial_dist.mode().round(r1) == 3.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.25).variance()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25)
    check negative_binomial_dist.variance().round(r1) == 120.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.5).variance()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.50)
    check negative_binomial_dist.variance().round(r1) == 20.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.75).variance()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.75)
    check negative_binomial_dist.variance().round(r1) == 4.444444444444445.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).pmf(5)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.pmf(5).round(r1) == 3.086620381509411e-08.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).pmf(10)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.pmf(10).round(r1) == 7.298892633400564e-06.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).pmf(20)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.pmf(20).round(r1) == 0.002423897023955031.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).cdf(10)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.cdf(10).round(r1) == 1.193066583837777e-05.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).cdf(20)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.cdf(20).round(r1) == 0.006744646865595934.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).cdf(30)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.cdf(30).round(r1) == 0.1409894608968279.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).sf(10)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.sf(10).round(r1) == 0.9999880693341616.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).sf(20)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.sf(20).round(r1) == 0.993255353134404.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).sf(30)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.sf(30).round(r1) == 0.8590105391031722.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).ppf(0.25)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.ppf(0.25) == 34

  test "NegativeBinomialDistribution(40, 0.5).ppf(0.5)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.ppf(0.5) == 39

  test "NegativeBinomialDistribution(40, 0.5).ppf(0.75)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.ppf(0.75) == 46

  test "NegativeBinomialDistribution(40, 0.5).ppf(0.76)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
    check negative_binomial_dist.ppf(0.76) == 46
