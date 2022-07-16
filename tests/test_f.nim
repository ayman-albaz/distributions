import math
import times
import unittest

import distributions


suite "FDistribution":
  
  const r1 = 14

  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

  test "FDistribution(1, 1).mean()":
    let f_dist = initFDistribution(1, 1)
    check f_dist.mean().round(r1) == Inf.round(r1)

  test "FDistribution(2, 2).mean()":
    let f_dist = initFDistribution(2, 2)
    check f_dist.mean().round(r1) == Inf.round(r1)
  
  test "FDistribution(3, 3).mean()":
    let f_dist = initFDistribution(3, 3)
    check f_dist.mean().round(r1) == 3.0.round(r1)

  test "FDistribution(1, 1).mode()":
    let f_dist = initFDistribution(1, 1)
    check f_dist.mode().round(r1) == Inf.round(r1)

  test "FDistribution(2, 2).mode()":
    let f_dist = initFDistribution(2, 2)
    check f_dist.mode().round(r1) == Inf.round(r1)
  
  test "FDistribution(3, 3).mode()":
    let f_dist = initFDistribution(3, 3)
    check f_dist.mode().round(r1) == 0.2.round(r1)

  test "FDistribution(1, 1).variance()":
    let f_dist = initFDistribution(1, 1)
    check f_dist.variance().round(r1) == Inf.round(r1)

  test "FDistribution(2, 2).variance()":
    let f_dist = initFDistribution(2, 2)
    check f_dist.variance().round(r1) == Inf.round(r1)
  
  test "FDistribution(3, 3).variance()":
    let f_dist = initFDistribution(3, 3)
    check f_dist.variance().round(r1) == Inf.round(r1)

  test "FDistribution(1, 1).pdf(1)":
    let f_dist = initFDistribution(1, 1)
    check f_dist.pdf(1.0).round(r1) == 0.1591549430918953.round(r1)

  test "FDistribution(1, 1).pdf(2)":
    let f_dist = initFDistribution(1, 1)
    check f_dist.pdf(2.0).round(r1) == 0.07502635967975883.round(r1)

  test "FDistribution(1, 1).pdf(3)":
    let f_dist = initFDistribution(1, 1)
    check f_dist.pdf(3.0).round(r1) == 0.04594407461848267.round(r1)

  test "FDistribution(1, 1).cdf(1)":
    let f_dist = initFDistribution(1, 1)
    check f_dist.cdf(1.0).round(r1) == 0.5000000000000001.round(r1)

  test "FDistribution(1, 1).cdf(2)":
    let f_dist = initFDistribution(1, 1)
    check f_dist.cdf(2.0).round(r1) == 0.6081734479693929.round(r1)

  test "FDistribution(1, 1).cdf(3)":
    let f_dist = initFDistribution(1, 1)
    check f_dist.cdf(3.0).round(r1) == 0.6666666666666666.round(r1)

  test "FDistribution(1, 1).sf(1)":
    let f_dist = initFDistribution(1, 1)
    check f_dist.sf(1.0).round(r1) == 0.5000000000000001.round(r1)

  test "FDistribution(1, 1).sf(2)":
    let f_dist = initFDistribution(1, 1)
    check f_dist.sf(2.0).round(r1) == 0.39182655203060734.round(r1)

  test "FDistribution(1, 1).sf(3)":
    let f_dist = initFDistribution(1, 1)
    check f_dist.sf(3.0).round(r1) == 0.33333333333333337.round(r1)

  test "FDistribution(1, 1).ppf(0.25)":
    let f_dist = initFDistribution(1, 1)
    check f_dist.ppf(0.25).round(r1) == 0.17157287525380982.round(r1)

  test "FDistribution(2, 2).ppf(0.25)":
    let f_dist = initFDistribution(2, 2)
    check f_dist.ppf(0.25).round(r1) == 0.3333333333333333.round(r1)

  test "FDistribution(2, 2).ppf(0.50)":
    let f_dist = initFDistribution(2, 2)
    check f_dist.ppf(0.50).round(r1) == 1.0.round(r1)

  test "FDistribution(2, 2).ppf(0.75)":
    let f_dist = initFDistribution(2, 2)
    check f_dist.ppf(0.75).round(r1) == 3.0.round(r1)

  test "FDistribution(3, 4).ppf(0.25)":
    let f_dist = initFDistribution(3, 4)
    check f_dist.ppf(0.25).round(r1) == 0.4183909951315492.round(r1)

  test "FDistribution(3, 4).ppf(0.50)":
    let f_dist = initFDistribution(3, 4)
    check f_dist.ppf(0.50).round(r1) == 0.9405340763677549.round(r1)

  test "FDistribution(3, 4).ppf(0.75)":
    let f_dist = initFDistribution(3, 4)
    check f_dist.ppf(0.75).round(r1) == 2.046667486615369.round(r1)