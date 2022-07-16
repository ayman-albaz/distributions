import math
import times
import unittest

import distributions


suite "PoissonDistribution":

  #[
    Benchmarked against Julia's distributions.jl.
  ]#
  
  const r1 = 14

  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

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
    check poisson_dist.pmf(30).round(r1) == 0.018465470960734028.round(r1)

  test "PoissonDistribution(40).pmf(40)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.pmf(40).round(r1) == 0.0629470394235922.round(r1)

  test "PoissonDistribution(40).pmf(50)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.pmf(50).round(r1) == 0.017707017552636196.round(r1)

  test "PoissonDistribution(40).cdf(30)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.cdf(30).round(r1) == 0.06169415311246949.round(r1)

  test "PoissonDistribution(40).cdf(40)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.cdf(40).round(r1) == 0.5419181783625371.round(r1)

  test "PoissonDistribution(40).cdf(50)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.cdf(50).round(r1) == 0.9473719508932414.round(r1)

  test "PoissonDistribution(40).sf(30)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.sf(30).round(r1) == 0.9383058468875305.round(r1)

  test "PoissonDistribution(40).sf(40)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.sf(40).round(r1) == 0.4580818216374629.round(r1)

  test "PoissonDistribution(40).sf(50)":
    let poisson_dist = initPoissonDistribution(40.0)
    check poisson_dist.sf(50).round(r1) == 0.052628049106758557.round(r1)

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
