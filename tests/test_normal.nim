import std/math
import std/unittest
import std/random

import distributions

suite "NormalDistribution":
  const r1 = 14

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

  test "NormalDistribution(0.0, 1.0).sample() using seeded RNG":
    var r = initRand(0xDEADBEEF)
    let d = initNormalDistribution(0.0, 1.0)
    var total = 0.0
    const n = 100_000
    for i in 0 ..< n:
      total += d.sample(r)
    check abs(total / float(n) - 0.0) < 0.02
