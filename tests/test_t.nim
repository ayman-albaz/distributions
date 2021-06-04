import math
import times
import unittest

import distributions/t


suite "TDistribution":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "TDistribution(1).pdf(-1)":
        let t_dist = initTDistribution(1)
        check t_dist.pdf(-1).round(15) == 0.15915494309189537.round(15)

    test "TDistribution(1).pdf(0)":
        let t_dist = initTDistribution(1)
        check t_dist.pdf(0).round(15) == 0.31830988618379075.round(15)

    test "TDistribution(1).pdf(1)":
        let t_dist = initTDistribution(1)
        check t_dist.pdf(1).round(15) == 0.15915494309189537.round(15)

    test "TDistribution(1).cdf(-1)":
        let t_dist = initTDistribution(1)
        check t_dist.cdf(-1).round(8) == 0.24999999999999978.round(15)

    test "TDistribution(1).cdf(0)":
        let t_dist = initTDistribution(1)
        check t_dist.cdf(0).round(8) == 0.5.round(15)

    test "TDistribution(1).cdf(1)":
        let t_dist = initTDistribution(1)
        check t_dist.cdf(1).round(8) == 0.7500000000000002.round(15)

    test "TDistribution(1).sf(-1)":
        let t_dist = initTDistribution(1)
        check t_dist.sf(-1).round(8) == 0.7500000000000002.round(15)

    test "TDistribution(1).sf(0)":
        let t_dist = initTDistribution(1)
        check t_dist.sf(0).round(8) == 0.5.round(15)

    test "TDistribution(1).sf(1)":
        let t_dist = initTDistribution(1)
        check t_dist.sf(1).round(8) == 0.24999999999999978.round(15)
