import math
import times
import unittest

import distributions/gamma


suite "GammaDistribution":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "GammaDistribution(0.5, 0.5).mean()":
        let gamma_dist = initGammaDistribution(0.5, 0.5)
        check gamma_dist.mean().round(14) == 0.25.round(14)

    test "GammaDistribution(1.0, 1.0).mean()":
        let gamma_dist = initGammaDistribution(1.0, 1.0)
        check gamma_dist.mean().round(14) == 1.0.round(14)

    test "GammaDistribution(2.0, 2.0).mean()":
        let gamma_dist = initGammaDistribution(2.0, 2.0)
        check gamma_dist.mean().round(14) == 4.0.round(14)

    test "GammaDistribution(0.5, 0.5).mode()":
        let gamma_dist = initGammaDistribution(0.5, 0.5)
        check gamma_dist.mode().round(14) == 0.0.round(14)

    test "GammaDistribution(1.0, 1.0).mode()":
        let gamma_dist = initGammaDistribution(1.0, 1.0)
        check gamma_dist.mode().round(14) == 0.0.round(14)

    test "GammaDistribution(2.0, 2.0).mode()":
        let gamma_dist = initGammaDistribution(2.0, 2.0)
        check gamma_dist.mode().round(14) == 2.0.round(14)

    test "GammaDistribution(0.5, 0.5).variance()":
        let gamma_dist = initGammaDistribution(0.5, 0.5)
        check gamma_dist.variance().round(14) == 0.125.round(14)

    test "GammaDistribution(1.0, 1.0).variance()":
        let gamma_dist = initGammaDistribution(1.0, 1.0)
        check gamma_dist.variance().round(14) == 1.0.round(14)

    test "GammaDistribution(2.0, 2.0).variance()":
        let gamma_dist = initGammaDistribution(2.0, 2.0)
        check gamma_dist.variance().round(14) == 8.0.round(14)

    test "GammaDistribution(2.0, 2.0).pdf(0.25)":
        let gamma_dist = initGammaDistribution(2.0, 2.0)
        check gamma_dist.pdf(0.25).round(14) == 0.05515605641153722.round(14)

    test "GammaDistribution(2.0, 2.0).pdf(0.50)":
        let gamma_dist = initGammaDistribution(2.0, 2.0)
        check gamma_dist.pdf(0.50).round(14) == 0.09735009788392561.round(14)

    test "GammaDistribution(2.0, 2.0).pdf(0.75)":
        let gamma_dist = initGammaDistribution(2.0, 2.0)
        check gamma_dist.pdf(0.75).round(14) == 0.1288667397733073.round(14)

    test "GammaDistribution(2.0, 2.0).cdf(0.25)":
        let gamma_dist = initGammaDistribution(2.0, 2.0)
        check gamma_dist.cdf(0.25).round(14) == 0.007190984592330175.round(14)

    test "GammaDistribution(2.0, 2.0).cdf(0.50)":
        let gamma_dist = initGammaDistribution(2.0, 2.0)
        check gamma_dist.cdf(0.50).round(14) == 0.026499021160743912.round(14)

    test "GammaDistribution(2.0, 2.0).cdf(0.75)":
        let gamma_dist = initGammaDistribution(2.0, 2.0)
        check gamma_dist.cdf(0.75).round(14) == 0.054977241662413245.round(14)

    test "GammaDistribution(2.0, 2.0).sf(0.25)":
        let gamma_dist = initGammaDistribution(2.0, 2.0)
        check gamma_dist.sf(0.25).round(14) == 0.9928090154076699.round(14)

    test "GammaDistribution(2.0, 2.0).sf(0.50)":
        let gamma_dist = initGammaDistribution(2.0, 2.0)
        check gamma_dist.sf(0.50).round(14) == 0.9735009788392561.round(14)

    test "GammaDistribution(2.0, 2.0).sf(0.75)":
        let gamma_dist = initGammaDistribution(2.0, 2.0)
        check gamma_dist.sf(0.75).round(14) == 0.9450227583375868.round(14)

    # test "GammaDistribution(2.0, 2.0).ppf(0.25)":
    #     let gamma_dist = initGammaDistribution(2.0, 2.0)
    #     check gamma_dist.ppf(0.25).round(14) == 1.9225575262295542.round(14)

    # test "GammaDistribution(2.0, 2.0).ppf(0.50)":
    #     let gamma_dist = initGammaDistribution(2.0, 2.0)
    #     check gamma_dist.ppf(0.50).round(14) == 3.3566939800333224.round(14)

    # test "GammaDistribution(2.0, 2.0).ppf(0.75)":
    #     let gamma_dist = initGammaDistribution(2.0, 2.0)
    #     check gamma_dist.ppf(0.75).round(14) == 5.38526905777939.round(14)
