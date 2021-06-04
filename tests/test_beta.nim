import math
import times
import unittest

import distributions/beta


suite "BetaDistribution":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "BetaDistribution(2.0, 2.0).pdf(0.25)":
        let beta_dist = initBetaDistribution(2.0, 2.0)
        check beta_dist.pdf(0.25).round(15) == 1.125.round(15)

    test "BetaDistribution(2.0, 2.0).pdf(0.50)":
        let beta_dist = initBetaDistribution(2.0, 2.0)
        check beta_dist.pdf(0.50).round(15) == 1.5.round(15)

    test "BetaDistribution(2.0, 2.0).pdf(0.75)":
        let beta_dist = initBetaDistribution(2.0, 2.0)
        check beta_dist.pdf(0.75).round(15) == 1.125.round(15)

    test "BetaDistribution(2.0, 2.0).cdf(0.25)":
        let beta_dist = initBetaDistribution(2.0, 2.0)
        check beta_dist.cdf(0.25).round(8) == 0.15625.round(8)

    test "BetaDistribution(2.0, 2.0).cdf(0.50)":
        let beta_dist = initBetaDistribution(2.0, 2.0)
        check beta_dist.cdf(0.50).round(8) == 0.5.round(8)

    test "BetaDistribution(2.0, 2.0).cdf(0.75)":
        let beta_dist = initBetaDistribution(2.0, 2.0)
        check beta_dist.cdf(0.75).round(8) == 0.84375.round(8)

    test "BetaDistribution(2.0, 2.0).sf(0.25)":
        let beta_dist = initBetaDistribution(2.0, 2.0)
        check beta_dist.sf(0.25).round(8) == 0.84375.round(8)

    test "BetaDistribution(2.0, 2.0).sf(0.50)":
        let beta_dist = initBetaDistribution(2.0, 2.0)
        check beta_dist.sf(0.50).round(8) == 0.5.round(8)

    test "BetaDistribution(2.0, 2.0).sf(0.75)":
        let beta_dist = initBetaDistribution(2.0, 2.0)
        check beta_dist.sf(0.75).round(8) == 0.15625.round(8)

    test "BetaDistribution(1.0, 1.0).ppf(0.25)":
        let beta_dist = initBetaDistribution(1.0, 1.0)
        check beta_dist.ppf(0.25).round(10) == 0.25.round(10)

    test "BetaDistribution(1.0, 1.0).ppf(0.75)":
        let beta_dist = initBetaDistribution(1.0, 1.0)
        check beta_dist.ppf(0.75).round(10) == 0.75.round(10)

    test "BetaDistribution(2.0, 2.0).ppf(0.25)":
        let beta_dist = initBetaDistribution(2.0, 2.0)
        check beta_dist.ppf(0.25).round(10) == 0.32635182233306964.round(10)

    test "BetaDistribution(3.0, 3.0).ppf(0.25)":
        let beta_dist = initBetaDistribution(3.0, 3.0)
        check beta_dist.ppf(0.25).round(10) == 0.3594361647896471.round(10)
