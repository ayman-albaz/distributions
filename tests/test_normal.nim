import math
import times
import unittest

import distributions/normal


suite "NormalDistribution":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "NormalDistribution(0.0, 1.0).pdf(-1)":
        let normal_dist = initNormalDistribution(0.0, 1.0)
        check normal_dist.pdf(-1).round(15) == 0.24197072451914337.round(15)

    test "NormalDistribution(0.0, 1.0).pdf(0)":
        let normal_dist = initNormalDistribution(0.0, 1.0)
        check normal_dist.pdf(0).round(15) == 0.3989422804014327.round(15)

    test "NormalDistribution(0.0, 1.0).pdf(1)":
        let normal_dist = initNormalDistribution(0.0, 1.0)
        check normal_dist.pdf(1).round(15) == 0.24197072451914337.round(15)

    test "NormalDistribution(0.0, 1.0).cdf(-1)":
        let normal_dist = initNormalDistribution(0.0, 1.0)
        check normal_dist.cdf(-1).round(15) == 0.15865525393145707.round(15)

    test "NormalDistribution(0.0, 1.0).cdf(0)":
        let normal_dist = initNormalDistribution(0.0, 1.0)
        check normal_dist.cdf(0).round(15) == 0.5.round(15)

    test "NormalDistribution(0.0, 1.0).cdf(1)":
        let normal_dist = initNormalDistribution(0.0, 1.0)
        check normal_dist.cdf(1).round(15) == 0.8413447460685429.round(15)

    test "NormalDistribution(0.0, 1.0).sf(-1)":
        let normal_dist = initNormalDistribution(0.0, 1.0)
        check normal_dist.sf(-1).round(15) == 0.8413447460685429.round(15)

    test "NormalDistribution(0.0, 1.0).sf(0)":
        let normal_dist = initNormalDistribution(0.0, 1.0)
        check normal_dist.sf(0).round(15) == 0.5.round(15)

    test "NormalDistribution(0.0, 1.0).sf(1)":
        let normal_dist = initNormalDistribution(0.0, 1.0)
        check normal_dist.sf(1).round(15) == 0.15865525393145707.round(15)

    test "NormalDistribution(0.0, 1.0).ppf(0.25)":
        let normal_dist = initNormalDistribution(0.0, 1.0)
        check normal_dist.ppf(0.25).round(15) == -0.6744897501960817.round(15)

    test "NormalDistribution(0.0, 1.0).ppf(0.5)":
        let normal_dist = initNormalDistribution(0.0, 1.0)
        check normal_dist.ppf(0.50).round(15) == 0.0.round(15)

    test "NormalDistribution(0.0, 1.0).ppf(0.75)":
        let normal_dist = initNormalDistribution(0.0, 1.0)
        check normal_dist.ppf(0.75).round(15) == 0.6744897501960817.round(15)
