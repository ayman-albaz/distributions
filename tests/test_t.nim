import std/math
import std/unittest

import distributions

suite "TDistribution":
  const r1 = 12
  const r2 = 10

  test "TDistribution(3).mean()":
    let t_dist = initTDistribution[float64](3)
    check t_dist.mean().round(r1) == 0.0.round(r1)

  test "TDistribution(3).median()":
    let t_dist = initTDistribution[float64](3)
    check t_dist.median().round(r1) == 0.0.round(r1)

  test "TDistribution(3).mode()":
    let t_dist = initTDistribution[float64](3)
    check t_dist.mode().round(r1) == 0.0.round(r1)

  test "TDistribution(3).variance()":
    let t_dist = initTDistribution[float64](3)
    check t_dist.variance().round(r1) == 3.0.round(r1)

  test "TDistribution(1).variance raises":
    expect ValueError:
      discard initTDistribution[float64](1).variance()

  test "TDistribution(2).variance raises":
    expect ValueError:
      discard initTDistribution[float64](2).variance()

  test "TDistribution(1).pdf(-1)":
    let t_dist = initTDistribution[float64](1)
    check t_dist.pdf(-1).round(r1) == 0.15915494309189537.round(r1)

  test "TDistribution(1).pdf(0)":
    let t_dist = initTDistribution[float64](1)
    check t_dist.pdf(0).round(r1) == 0.31830988618379075.round(r1)

  test "TDistribution(1).pdf(1)":
    let t_dist = initTDistribution[float64](1)
    check t_dist.pdf(1).round(r1) == 0.15915494309189537.round(r1)

  test "TDistribution(1).cdf(-1)":
    let t_dist = initTDistribution[float64](1)
    check t_dist.cdf(-1).round(r2) == 0.25.round(r2)

  test "TDistribution(1).cdf(0)":
    let t_dist = initTDistribution[float64](1)
    check t_dist.cdf(0).round(r1) == 0.5.round(r1)

  test "TDistribution(1).cdf(1)":
    let t_dist = initTDistribution[float64](1)
    check t_dist.cdf(1).round(r1) == 0.75.round(r1)

  test "TDistribution(1).sf(-1)":
    let t_dist = initTDistribution[float64](1)
    check t_dist.sf(-1).round(r1) == 0.75.round(r1)

  test "TDistribution(1).sf(0)":
    let t_dist = initTDistribution[float64](1)
    check t_dist.sf(0).round(r1) == 0.5.round(r1)

  test "TDistribution(1).sf(1)":
    let t_dist = initTDistribution[float64](1)
    check t_dist.sf(1).round(r1) == 0.25.round(r1)

  test "TDistribution(1).ppf(0.25)":
    let t_dist = initTDistribution[float64](1)
    check t_dist.ppf(0.25).round(r2) == -1.0.round(r2)

  test "TDistribution(1).ppf(0.50)":
    let t_dist = initTDistribution[float64](1)
    check abs(t_dist.ppf(0.50)) < 1e-12

  test "TDistribution(1).ppf(0.75)":
    let t_dist = initTDistribution[float64](1)
    check t_dist.ppf(0.75).round(r2) == 1.0.round(r2)

  test "TDistribution(10).ppf(0.25)":
    let t_dist = initTDistribution[float64](10)
    check t_dist.ppf(0.25).round(r2) == -0.6998120613124291.round(r2)

  test "TDistribution(10).ppf(0.50)":
    let t_dist = initTDistribution[float64](10)
    check abs(t_dist.ppf(0.50)) < 1e-12

  test "TDistribution(10).ppf(0.75)":
    let t_dist = initTDistribution[float64](10)
    check t_dist.ppf(0.75).round(r2) == 0.6998120613124291.round(r2)
