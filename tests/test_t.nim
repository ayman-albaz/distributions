import math
import times
import unittest

import distributions


suite "TDistribution":
  
  const r1 = 15
  const r2 = 10

  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

  test "TDistribution(3).mean()":
    let t_dist = initTDistribution(3)
    check t_dist.mean().round(r1) == 0.0.round(r1)

  test "TDistribution(3).median()":
    let t_dist = initTDistribution(3)
    check t_dist.median().round(r1) == 0.0.round(r1)

  test "TDistribution(3).mode()":
    let t_dist = initTDistribution(3)
    check t_dist.mode().round(r1) == 0.0.round(r1)

  test "TDistribution(3).variance()":
    let t_dist = initTDistribution(3)
    check t_dist.variance().round(r1) == 3.0.round(r1)

  test "TDistribution(1).pdf(-1)":
    let t_dist = initTDistribution(1)
    check t_dist.pdf(-1).round(r1) == 0.15915494309189537.round(r1)

  test "TDistribution(1).pdf(0)":
    let t_dist = initTDistribution(1)
    check t_dist.pdf(0).round(r1) == 0.31830988618379075.round(r1)

  test "TDistribution(1).pdf(1)":
    let t_dist = initTDistribution(1)
    check t_dist.pdf(1).round(r1) == 0.15915494309189537.round(r1)

  test "TDistribution(1).cdf(-1)":
    let t_dist = initTDistribution(1)
    check t_dist.cdf(-1).round(8) == 0.24999999999999978.round(r1)

  test "TDistribution(1).cdf(0)":
    let t_dist = initTDistribution(1)
    check t_dist.cdf(0).round(r1) == 0.5.round(r1)

  test "TDistribution(1).cdf(1)":
    let t_dist = initTDistribution(1)
    check t_dist.cdf(1).round(r1) == 0.7500000000000002.round(r1)

  test "TDistribution(1).sf(-1)":
    let t_dist = initTDistribution(1)
    check t_dist.sf(-1).round(r1) == 0.7500000000000002.round(r1)

  test "TDistribution(1).sf(0)":
    let t_dist = initTDistribution(1)
    check t_dist.sf(0).round(r1) == 0.5.round(r1)

  test "TDistribution(1).sf(1)":
    let t_dist = initTDistribution(1)
    check t_dist.sf(1).round(r1) == 0.24999999999999978.round(r1)

  test "TDistribution(1).ppf(0.25)":
    let t_dist = initTDistribution(1)
    check t_dist.ppf(0.25).round(r2) == -1.0000000000133888.round(r2)

  test "TDistribution(1).ppf(0.50)":
    let t_dist = initTDistribution(1)
    check t_dist.ppf(0.50).round(r2) == 8.177562772704119e-17.round(r2)

  test "TDistribution(1).ppf(0.75)":
    let t_dist = initTDistribution(1)
    check t_dist.ppf(0.75).round(r2) == 1.0000000000133888.round(r2)

  test "TDistribution(10).ppf(0.25)":
    let t_dist = initTDistribution(10)
    check t_dist.ppf(0.25).round(r2) == -0.6998120613124291.round(r2)

  test "TDistribution(10).ppf(0.50)":
    let t_dist = initTDistribution(10)
    check t_dist.ppf(0.50).round(r2) == 6.80574793290978e-17.round(r2)

  test "TDistribution(10).ppf(0.75)":
    let t_dist = initTDistribution(10)
    check t_dist.ppf(0.75).round(r2) == 0.6998120613124291.round(r2)
