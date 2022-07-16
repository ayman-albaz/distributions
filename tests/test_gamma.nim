import math
import times
import unittest

import distributions


suite "GammaDistribution":
  
  const r1 = 14
  const r2 = 13
  let gd = initGammaDistribution(5.0, 3.0)
  echo gd.ppf(0.255).round(r2)

  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

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
    check gamma_dist.ppf(0.25).round(r2) == 2.9612787631147772.round(r2)

  test "GammaDistribution(2.0, 2.0).ppf(0.50)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.ppf(0.50).round(r2) == 3.678346990016661.round(r2)

  test "GammaDistribution(2.0, 2.0).ppf(0.75)":
    let gamma_dist = initGammaDistribution(2.0, 2.0)
    check gamma_dist.ppf(0.75).round(r2) == 4.692634528889695.round(r2)

  test "GammaDistribution(3.0, 5.0).ppf(0.25)":
    let gamma_dist = initGammaDistribution(3.0, 5.0)
    check gamma_dist.ppf(0.25).round(r2) == 6.727299417860519.round(r2)

  test "GammaDistribution(3.0, 5.0).ppf(0.50)":
    let gamma_dist = initGammaDistribution(3.0, 5.0)
    check gamma_dist.ppf(0.50).round(r2) == 7.674060313723559.round(r2)

  test "GammaDistribution(3.0, 5.0).ppf(0.75)":
    let gamma_dist = initGammaDistribution(3.0, 5.0)
    check gamma_dist.ppf(0.75).round(r2) == 8.920402060292561.round(r2)
