import std/math
import std/unittest
import results

import distributions

suite "UniformDiscreteDistribution":
  const r1 = 12

  test "UniformDiscreteDistribution(0, 5).mean()":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.mean().round(r1) == 2.5.round(r1)

  test "UniformDiscreteDistribution(0, 5).median()":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.median().round(r1) == 2.5.round(r1)

  test "UniformDiscreteDistribution(0, 5).mode()":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.mode().round(r1) == 2.5.round(r1)

  test "UniformDiscreteDistribution(0, 5).variance()":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.variance().round(r1) == 2.9166666666666665.round(r1)

  test "UniformDiscreteDistribution(0, 5).pmf(0)":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.pmf(0).round(r1) == 0.16666666666666666.round(r1)

  test "UniformDiscreteDistribution(0, 5).pmf(2)":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.pmf(2).round(r1) == 0.16666666666666666.round(r1)

  test "UniformDiscreteDistribution(0, 5).pmf(5)":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.pmf(5).round(r1) == 0.16666666666666666.round(r1)

  test "UniformDiscreteDistribution(0, 5).pmf(1) interior":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.pmf(1).round(r1) == (1.0 / 6.0).round(r1)

  test "UniformDiscreteDistribution(0, 5).cdf(0)":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.cdf(0).round(r1) == 0.16666666666666666.round(r1)

  test "UniformDiscreteDistribution(0, 5).cdf(1)":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.cdf(1).round(r1) == 0.3333333333333333.round(r1)

  test "UniformDiscreteDistribution(0, 5).cdf(5)":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.cdf(5).round(r1) == 1.0.round(r1)

  test "UniformDiscreteDistribution(0, 5).sf(0)":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.sf(0).round(r1) == 0.8333333333333334.round(r1)

  test "UniformDiscreteDistribution(0, 5).sf(1)":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.sf(1).round(r1) == 0.6666666666666667.round(r1)

  test "UniformDiscreteDistribution(0, 5).sf(5)":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.sf(5).round(r1) == 0.0.round(r1)

  test "UniformDiscreteDistribution(0, 5).ppf(0.0)":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.ppf(0.0).get() == 0

  test "UniformDiscreteDistribution(0, 5).ppf(0.3)":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.ppf(0.3).get() == 1

  test "UniformDiscreteDistribution(0, 5).ppf(1.0)":
    let uniform_discrete_dist = initUniformDiscreteDistribution[float64](0, 5).get()
    check uniform_discrete_dist.ppf(1.0).get() == 5
