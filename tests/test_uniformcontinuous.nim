import std/math
import std/unittest
import results

import distributions

suite "UniformContinuousDistribution":
  const r1 = 12

  test "UniformContinuousDistribution(0.0, 1.0).mean()":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.mean().round(r1) == 0.5.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).median()":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.median().round(r1) == 0.5.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).mode()":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.mode().round(r1) == 0.5.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).variance()":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.variance().round(r1) == 0.08333333333333333.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).pdf(0.25)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.pdf(0.25).round(r1) == 1.0.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).pdf(0.5)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.pdf(0.5).round(r1) == 1.0.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).pdf(0.75)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.pdf(0.75).round(r1) == 1.0.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).cdf(0.25)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.cdf(0.25).round(r1) == 0.25.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).cdf(0.50)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.cdf(0.50).round(r1) == 0.50.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).cdf(0.75)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.cdf(0.75).round(r1) == 0.75.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).sf(0.25)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.sf(0.25).round(r1) == 0.75.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).sf(0.50)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.sf(0.50).round(r1) == 0.50.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).sf(0.75)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.sf(0.75).round(r1) == 0.25.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).ppf(0.25)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.ppf(0.25).round(r1) == 0.25.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).ppf(0.50)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.ppf(0.50).round(r1) == 0.50.round(r1)

  test "UniformContinuousDistribution(0.0, 1.0).ppf(0.75)":
    let uniform_continuous_dist = initUniformContinuousDistribution(0.0, 1.0).get()
    check uniform_continuous_dist.ppf(0.75).round(r1) == 0.75.round(r1)
