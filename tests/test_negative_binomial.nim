import math
import times
import unittest

import distributions/negative_binomial


suite "NegativeBinomialDistribution":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "NegativeBinomialDistribution(40, 0.5).pmf(5)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.pmf(5).round(15) == 3.086620381509411e-08.round(15)

    test "NegativeBinomialDistribution(40, 0.5).pmf(10)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.pmf(10).round(15) == 7.298892633400564e-06.round(15)

    test "NegativeBinomialDistribution(40, 0.5).pmf(20)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.pmf(20).round(15) == 0.002423897023955031.round(15)

    test "NegativeBinomialDistribution(40, 0.5).cdf(10)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.cdf(10).round(8) == 1.193066583837777e-05.round(8)

    test "NegativeBinomialDistribution(40, 0.5).cdf(20)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.cdf(20).round(8) == 0.006744646865595934.round(8)

    test "NegativeBinomialDistribution(40, 0.5).cdf(30)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.cdf(30).round(8) == 0.1409894608968279.round(8)

    test "NegativeBinomialDistribution(40, 0.5).sf(10)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.sf(10).round(8) == 0.9999880693341616.round(8)

    test "NegativeBinomialDistribution(40, 0.5).sf(20)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.sf(20).round(8) == 0.993255353134404.round(8)

    test "NegativeBinomialDistribution(40, 0.5).sf(30)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.sf(30).round(8) == 0.8590105391031722.round(8)

    test "NegativeBinomialDistribution(40, 0.5).ppf(0.25)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.ppf(0.25) == 34

    test "NegativeBinomialDistribution(40, 0.5).ppf(0.5)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.ppf(0.5) == 39

    test "NegativeBinomialDistribution(40, 0.5).ppf(0.75)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.ppf(0.75) == 46

    test "NegativeBinomialDistribution(40, 0.5).ppf(0.76)":
        let negative_binomial_dist = initNegativeBinomialDistribution(40, 0.5)
        check negative_binomial_dist.ppf(0.76) == 46