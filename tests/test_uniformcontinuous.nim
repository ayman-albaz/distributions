import math
import times
import unittest

import distributions

suite "UniformContinuousDistribution":
  
  const r1 = 15

  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

  test "UniformContinuousDistribution(0.0, 1.0).mean()":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
    check uniform_continuous_dist.mean().round(r1) == 0.5.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).median()":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
    check uniform_continuous_dist.median().round(r1) == 0.5.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).mode()":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
    check uniform_continuous_dist.mode().round(r1) == 0.5.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).variance()":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
    check uniform_continuous_dist.variance().round(r1) == 0.08333333333333333.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).pdf(1.0)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
    check uniform_continuous_dist.pdf(1.0).round(r1) == 1.0.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).pdf(2.0)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
    check uniform_continuous_dist.pdf(2.0).round(r1) == 0.0.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).cdf(0.0)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
    check uniform_continuous_dist.cdf(0.0).round(r1) == 0.0.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).cdf(1.0)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
    check uniform_continuous_dist.cdf(1.0).round(r1) == 1.0.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).cdf(2.0)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
    check uniform_continuous_dist.cdf(2.0).round(r1) == 1.0.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).sf(0.0)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
    check uniform_continuous_dist.sf(0.0).round(r1) == 1.0.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).sf(1.0)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
    check uniform_continuous_dist.sf(1.0).round(r1) == 0.0.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).sf(2.0)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0)
    check uniform_continuous_dist.sf(2.0).round(r1) == 0.0.round(r1)

  test "UniformContinuousDistribution(-1.0, -1.0).ppf(0.0)":
    let uniform_continuous_dist = initUniformContinuousDistribution(-1.0, 1.0)
    check uniform_continuous_dist.ppf(0.25).round(r1) == -0.50.round(r1)

  test "UniformContinuousDistribution(-1.0, -1.0).ppf(1.0)":
    let uniform_continuous_dist = initUniformContinuousDistribution(-1.0, 1.0)
    check uniform_continuous_dist.ppf(0.50).round(r1) == 0.0.round(r1)

  test "UniformContinuousDistribution(-1.0, -1.0).ppf(2.0)":
    let uniform_continuous_dist = initUniformContinuousDistribution(-1.0, 1.0)
    check uniform_continuous_dist.ppf(0.75).round(r1) == 0.50.round(r1)