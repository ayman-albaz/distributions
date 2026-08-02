import std/math
import std/unittest
import results

import distributions

suite "NegativeBinomialDistribution":
  const r1 = 12

  test "NegativeBinomialDistribution(10, 0.25).mean()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25).get()
    check negative_binomial_dist.mean().round(r1) == 30.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.5).mean()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.50).get()
    check negative_binomial_dist.mean().round(r1) == 10.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.75).mean()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.75).get()
    check negative_binomial_dist.mean().round(r1) == 3.3333333333333335.round(r1)

  test "NegativeBinomialDistribution(10, 0.25).mode()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25).get()
    check negative_binomial_dist.mode().round(r1) == 27.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.5).mode()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.50).get()
    check negative_binomial_dist.mode().round(r1) == 9.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.75).mode()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.75).get()
    check negative_binomial_dist.mode().round(r1) == 3.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.25).variance()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25).get()
    check negative_binomial_dist.variance().round(r1) == 120.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.5).variance()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.50).get()
    check negative_binomial_dist.variance().round(r1) == 20.0.round(r1)

  test "NegativeBinomialDistribution(10, 0.75).variance()":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.75).get()
    check negative_binomial_dist.variance().round(r1) == 4.444444444444445.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).pmf(5)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    check negative_binomial_dist.pmf(5).round(r1) == 3.086620381509411e-08.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).pmf(10)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    check negative_binomial_dist.pmf(10).round(r1) == 7.298892633400564e-06.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).pmf(20)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    check negative_binomial_dist.pmf(20).round(r1) == 0.002423897023955.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).cdf(10)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    check negative_binomial_dist.cdf(10).round(r1) == 1.193066583837777e-05.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).cdf(20)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    check negative_binomial_dist.cdf(20).round(r1) == 0.006744646865595934.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).cdf(30)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    check negative_binomial_dist.cdf(30).round(r1) == 0.1409894608968279.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).sf(10)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    check negative_binomial_dist.sf(10).round(r1) == 0.9999880693341616.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).sf(20)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    check negative_binomial_dist.sf(20).round(r1) == 0.993255353134404.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).sf(30)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    check negative_binomial_dist.sf(30).round(r1) == 0.8590105391031722.round(r1)

  test "NegativeBinomialDistribution(40, 0.5).ppf(0.25)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    check negative_binomial_dist.ppf(0.25).get() == 34

  test "NegativeBinomialDistribution(40, 0.5).ppf(0.5)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    # cdf(39) is exactly 0.5 in exact arithmetic (Bin(79, 0.5) symmetry);
    # the direct I_p(r, k+1) form rounds it to 0.49999999999996503, so
    # ppf lands on 40. Both 39 and 40 are valid medians.
    check negative_binomial_dist.ppf(0.5).get() == 40

  test "NegativeBinomialDistribution(40, 0.5).ppf(0.75)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    check negative_binomial_dist.ppf(0.75).get() == 46

  test "NegativeBinomialDistribution(40, 0.5).ppf(0.76)":
    let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5).get()
    check negative_binomial_dist.ppf(0.76).get() == 46

  test "NegativeBinomialDistribution(10, 0.25).cdf(0)":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25).get()
    check negative_binomial_dist.cdf(0).round(r1) == 9.5367431640625e-07.round(r1)

  test "NegativeBinomialDistribution(10, 0.25).cdf(5)":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25).get()
    check negative_binomial_dist.cdf(5).round(r1) == 0.0007949490100145333.round(r1)

  test "NegativeBinomialDistribution(10, 0.25).cdf(10)":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25).get()
    check negative_binomial_dist.cdf(10).round(r1) == 0.013864416943761126.round(r1)

  test "NegativeBinomialDistribution(10, 0.25).cdf(20)":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25).get()
    check negative_binomial_dist.cdf(20).round(r1) == 0.19659336305049044.round(r1)

  test "NegativeBinomialDistribution(10, 0.25).cdf(30)":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25).get()
    check negative_binomial_dist.cdf(30).round(r1) == 0.5604602683274673.round(r1)

  test "NegativeBinomialDistribution(10, 0.25).sf(5)":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25).get()
    check negative_binomial_dist.sf(5).round(r1) == 0.9992050509899855.round(r1)

  test "NegativeBinomialDistribution(10, 0.25).ppf(0.25)":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25).get()
    check negative_binomial_dist.ppf(0.25).get() == 22

  test "NegativeBinomialDistribution(10, 0.25).ppf(0.5)":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25).get()
    check negative_binomial_dist.ppf(0.5).get() == 29

  test "NegativeBinomialDistribution(10, 0.25).ppf(0.75)":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.25).get()
    check negative_binomial_dist.ppf(0.75).get() == 37

  test "NegativeBinomialDistribution(10, 0.75).cdf(5)":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.75).get()
    check negative_binomial_dist.cdf(5).round(r1) == 0.8516319226473572.round(r1)

  test "NegativeBinomialDistribution(10, 0.75).ppf(0.5)":
    let negative_binomial_dist = initNegativeBinomialDistribution(10, 0.75).get()
    check negative_binomial_dist.ppf(0.5).get() == 3
