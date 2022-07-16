import math
import times
import unittest

import distributions


suite "NormalDistribution":
  
  const r1 = 14

  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

  test "NormalDistribution(0.0, 1.0).mean()":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.mean().round(r1) == 0.0.round(r1)

  test "NormalDistribution(0.0, 1.0).median()":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.median().round(r1) == 0.0.round(r1)

  test "NormalDistribution(0.0, 1.0).mode()":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.mode().round(r1) == 0.0.round(r1)

  test "NormalDistribution(0.0, 1.0).variance()":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.variance().round(r1) == 1.0.round(r1)

  test "NormalDistribution(0.0, 1.0).pdf(-1)":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.pdf(-1).round(r1) == 0.24197072451914337.round(r1)

  test "NormalDistribution(0.0, 1.0).pdf(0)":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.pdf(0).round(r1) == 0.3989422804014327.round(r1)

  test "NormalDistribution(0.0, 1.0).pdf(1)":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.pdf(1).round(r1) == 0.24197072451914337.round(r1)

  test "NormalDistribution(0.0, 1.0).cdf(-1)":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.cdf(-1).round(r1) == 0.15865525393145707.round(r1)

  test "NormalDistribution(0.0, 1.0).cdf(0)":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.cdf(0).round(r1) == 0.5.round(r1)

  test "NormalDistribution(0.0, 1.0).cdf(1)":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.cdf(1).round(r1) == 0.8413447460685429.round(r1)

  test "NormalDistribution(0.0, 1.0).sf(-1)":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.sf(-1).round(r1) == 0.8413447460685429.round(r1)

  test "NormalDistribution(0.0, 1.0).sf(0)":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.sf(0).round(r1) == 0.5.round(r1)

  test "NormalDistribution(0.0, 1.0).sf(1)":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.sf(1).round(r1) == 0.15865525393145707.round(r1)

  test "NormalDistribution(0.0, 1.0).ppf(0.25)":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.ppf(0.25).round(r1) == -0.6744897501960817.round(r1)

  test "NormalDistribution(0.0, 1.0).ppf(0.5)":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.ppf(0.50).round(r1) == 0.0.round(r1)

  test "NormalDistribution(0.0, 1.0).ppf(0.75)":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    check normal_dist.ppf(0.75).round(r1) == 0.6744897501960817.round(r1)

  test "NormalDistribution(0.0, 1.0).rand()":
    let normal_dist = initNormalDistribution(0.0, 1.0)
    var x: seq[float]
    for i in 1..1000: x.add(normal_dist.rand())
    check x.mean().round(1) == normal_dist.mean().round(1)
    check x.variance().round(1) == normal_dist.variance().round(1)
