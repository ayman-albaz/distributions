import std/math
import std/unittest

import distributions

suite "PoissonDistribution":
  const r1 = 14

  test "PoissonDistribution(10).mean()":
    let poisson_dist = initPoissonDistribution(10.0)
    check poisson_dist.mean().round(r1) == 10.0.round(r1)

  test "PoissonDistribution(10).median()":
    let poisson_dist = initPoissonDistribution(10.0)
    check poisson_dist.median().round(r1) == 10.0.round(r1)

  test "PoissonDistribution(10).mode()":
    let poisson_dist = initPoissonDistribution(10.0)
    check poisson_dist.mode().round(r1) == 10.0.round(r1)

  test "PoissonDistribution(10).variance()":
    let poisson_dist = initPoissonDistribution(10.0)
    check poisson_dist.variance().round(r1) == 10.0.round(r1)

  test "PoissonDistribution(40).pmf(30)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.pmf(30).round(r1) == 0.01846547096073.round(r1)

  test "PoissonDistribution(40).pmf(40)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.pmf(40).round(r1) == 0.06294703942359.round(r1)

  test "PoissonDistribution(40).pmf(50)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.pmf(50).round(r1) == 0.01770701755264.round(r1)

  test "PoissonDistribution(40).cdf(30)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.cdf(30).round(r1) == 0.06169415311247.round(r1)

  test "PoissonDistribution(40).cdf(40)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.cdf(40).round(r1) == 0.54191817836255.round(r1)

  test "PoissonDistribution(40).cdf(50)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.cdf(50).round(r1) == 0.94737195089324.round(r1)

  test "PoissonDistribution(40).sf(30)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.sf(30).round(r1) == 0.93830584688753.round(r1)

  test "PoissonDistribution(40).sf(40)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.sf(40).round(r1) == 0.45808182163745.round(r1)

  test "PoissonDistribution(40).sf(50)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.sf(50).round(r1) == 0.05262804910676.round(r1)

  test "PoissonDistribution(40).ppf(0.25)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.ppf(0.25) == 36

  test "PoissonDistribution(40).ppf(0.5)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.ppf(0.5) == 40

  test "PoissonDistribution(40).ppf(0.75)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.ppf(0.75) == 44

  test "PoissonDistribution(40).ppf(0.76)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.ppf(0.76) == 44
