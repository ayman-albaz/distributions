import std/math
import std/unittest

import distributions

suite "GammaDistribution":
  const r1 = 14
  const r2 = 13

  test "GammaDistribution(0.5, 0.5).mean()":
    let gamma_dist = initGammaDistribution(0.5, 0.5)
    check gamma_dist.mean().round(r1) == 0.25.round(r1)

  test "GammaDistribution(1.0, 1.0).mean()":
    let gamma_dist = initGammaDistribution(1.0, 1.0)
    check gamma_dist.mean().round(r1) == 1.0.round(r1)

  test "GammaDistribution(2.0, 2.0).mean()":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.mean().round(r1) == 4.0.round(r1)

  test "GammaDistribution(0.5, 0.5).mode()":
    let gamma_dist = initGammaDistribution(0.5, 0.5)
    check gamma_dist.mode().round(r1) == 0.0.round(r1)

  test "GammaDistribution(1.0, 1.0).mode()":
    let gamma_dist = initGammaDistribution(1.0, 1.0)
    check gamma_dist.mode().round(r1) == 0.0.round(r1)

  test "GammaDistribution(2.0, 2.0).mode()":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.mode().round(r1) == 2.0.round(r1)

  test "GammaDistribution(0.5, 0.5).variance()":
    let gamma_dist = initGammaDistribution(0.5, 0.5)
    check gamma_dist.variance().round(r1) == 0.125.round(r1)

  test "GammaDistribution(1.0, 1.0).variance()":
    let gamma_dist = initGammaDistribution(1.0, 1.0)
    check gamma_dist.variance().round(r1) == 1.0.round(r1)

  test "GammaDistribution(2.0, 2.0).variance()":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.variance().round(r1) == 8.0.round(r1)

  test "GammaDistribution(2.0, 2.0).pdf(0.25)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.pdf(0.25).round(r1) == 0.05515605641153722.round(r1)

  test "GammaDistribution(2.0, 2.0).pdf(0.50)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.pdf(0.50).round(r1) == 0.09735009788392561.round(r1)

  test "GammaDistribution(2.0, 2.0).pdf(0.75)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.pdf(0.75).round(r1) == 0.1288667397733073.round(r1)

  test "GammaDistribution(2.0, 2.0).cdf(0.25)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.cdf(0.25).round(r1) == 0.007190984592330175.round(r1)

  test "GammaDistribution(2.0, 2.0).cdf(0.50)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.cdf(0.50).round(r1) == 0.026499021160743912.round(r1)

  test "GammaDistribution(2.0, 2.0).cdf(0.75)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.cdf(0.75).round(r1) == 0.054977241662413245.round(r1)

  test "GammaDistribution(2.0, 2.0).sf(0.25)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.sf(0.25).round(r1) == 0.9928090154076699.round(r1)

  test "GammaDistribution(2.0, 2.0).sf(0.50)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.sf(0.50).round(r1) == 0.9735009788392561.round(r1)

  test "GammaDistribution(2.0, 2.0).sf(0.75)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.sf(0.75).round(r1) == 0.9450227583375868.round(r1)

  test "GammaDistribution(2.0, 2.0).ppf(0.25)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.ppf(0.25).round(r2) == 1.9225575262295542.round(r2)

  test "GammaDistribution(2.0, 2.0).ppf(0.50)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.ppf(0.50).round(r2) == 3.3566939800333215.round(r2)

  test "GammaDistribution(2.0, 2.0).ppf(0.75)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.ppf(0.75).round(r2) == 5.385269057779392.round(r2)

  test "GammaDistribution(3.0, 5.0).ppf(0.25)":
    let gamma_dist = initGammaDistribution(3.0, 5.0)
    check gamma_dist.ppf(0.25).round(r2) == 8.636497089302598.round(r2)

  test "GammaDistribution(3.0, 5.0).ppf(0.50)":
    let gamma_dist = initGammaDistribution(3.0, 5.0)
    check gamma_dist.ppf(0.50).round(r2) == 13.3703015686178.round(r2)

  test "GammaDistribution(3.0, 5.0).ppf(0.75)":
    let gamma_dist = initGammaDistribution(3.0, 5.0)
    check gamma_dist.ppf(0.75).round(r2) == 19.602010301462794.round(r2)
