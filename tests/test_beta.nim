import math
import times
import unittest

import distributions


suite "BetaDistribution":
  
  const r1 = 14

  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

  test "BetaDistribution(0.5, 0.5).mean()":
    let beta_dist = initBetaDistribution(0.5, 0.5)
    check beta_dist.mean().round(r1) == 0.5.round(r1)

  test "BetaDistribution(1.0, 1.0).mean()":
    let beta_dist = initBetaDistribution(1.0, 1.0)
    check beta_dist.mean().round(r1) == 0.5.round(r1)

  test "BetaDistribution(2.0, 2.0).mean()":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.mean().round(r1) == 0.5.round(r1)

  test "BetaDistribution(0.5, 0.5).median()":
    let beta_dist = initBetaDistribution(0.5, 0.5)
    check beta_dist.median().round(r1) == 0.5.round(r1)

  test "BetaDistribution(1.0, 1.0).median()":
    let beta_dist = initBetaDistribution(1.0, 1.0)
    check beta_dist.median().round(r1) == 0.5.round(r1)

  test "BetaDistribution(2.0, 2.0).median()":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.median().round(r1) == 0.5.round(r1)

  test "BetaDistribution(0.5, 0.5).mode()":
    let beta_dist = initBetaDistribution(0.5, 0.5)
    check beta_dist.mode().round(r1) == 0.5.round(r1)

  test "BetaDistribution(1.0, 1.0).mode()":
    let beta_dist = initBetaDistribution(1.0, 1.0)
    check beta_dist.mode().round(r1) == 0.5.round(r1)

  test "BetaDistribution(2.0, 2.0).mode()":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.mode().round(r1) == 0.5.round(r1)

  test "BetaDistribution(0.5, 0.5).variance()":
    let beta_dist = initBetaDistribution(0.5, 0.5)
    check beta_dist.variance().round(r1) == 0.125.round(r1)

  test "BetaDistribution(1.0, 1.0).variance()":
    let beta_dist = initBetaDistribution(1.0, 1.0)
    check beta_dist.variance().round(r1) == 0.08333333333333333.round(r1)

  test "BetaDistribution(2.0, 2.0).variance()":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.variance().round(r1) == 0.05.round(r1)

  test "BetaDistribution(2.0, 2.0).pdf(0.25)":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.pdf(0.25).round(r1) == 1.125.round(r1)

  test "BetaDistribution(2.0, 2.0).pdf(0.50)":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.pdf(0.50).round(r1) == 1.5.round(r1)

  test "BetaDistribution(2.0, 2.0).pdf(0.75)":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.pdf(0.75).round(r1) == 1.125.round(r1)

  test "BetaDistribution(2.0, 2.0).cdf(0.25)":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.cdf(0.25).round(r1) == 0.15625.round(r1)

  test "BetaDistribution(2.0, 2.0).cdf(0.50)":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.cdf(0.50).round(r1) == 0.5.round(r1)

  test "BetaDistribution(2.0, 2.0).cdf(0.75)":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.cdf(0.75).round(r1) == 0.84375.round(r1)

  test "BetaDistribution(2.0, 2.0).sf(0.25)":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.sf(0.25).round(r1) == 0.84375.round(r1)

  test "BetaDistribution(2.0, 2.0).sf(0.50)":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.sf(0.50).round(r1) == 0.5.round(r1)

  test "BetaDistribution(2.0, 2.0).sf(0.75)":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.sf(0.75).round(r1) == 0.15625.round(r1)

  test "BetaDistribution(1.0, 1.0).ppf(0.25)":
    let beta_dist = initBetaDistribution(1.0, 1.0)
    check beta_dist.ppf(0.25).round(r1) == 0.25.round(r1)

  test "BetaDistribution(1.0, 1.0).ppf(0.75)":
    let beta_dist = initBetaDistribution(1.0, 1.0)
    check beta_dist.ppf(0.75).round(r1) == 0.75.round(r1)

  test "BetaDistribution(2.0, 2.0).ppf(0.25)":
    let beta_dist = initBetaDistribution(2.0, 2.0)
    check beta_dist.ppf(0.25).round(r1) == 0.32635182233306964.round(r1)

  test "BetaDistribution(3.0, 3.0).ppf(0.25)":
    let beta_dist = initBetaDistribution(3.0, 3.0)
    check beta_dist.ppf(0.25).round(r1) == 0.3594361647896471.round(r1)
