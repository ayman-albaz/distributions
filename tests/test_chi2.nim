import math
import times
import unittest

import distributions/chi2


suite "Chi2Distribution":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "Chi2Distribution(1).pdf(1.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.pdf(1.0).round(15) == 0.24197072451914337.round(15)

    test "Chi2Distribution(1).pdf(2.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.pdf(2.0).round(15) == 0.10377687435514868.round(15)

    test "Chi2Distribution(1).pdf(3.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.pdf(3.0).round(15) == 0.05139344326792309.round(15)

    test "Chi2Distribution(1).cdf(1.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.cdf(1.0).round(15) == 0.6826894921370859.round(15)

    test "Chi2Distribution(1).cdf(2.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.cdf(2.0).round(15) == 0.8427007929497151.round(15)

    test "Chi2Distribution(1).cdf(3.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.cdf(3.0).round(15) == 0.9167354833364496.round(15)

    test "Chi2Distribution(1).sf(1.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.sf(1.0).round(14) == 0.31731050786291115.round(14)

    test "Chi2Distribution(1).sf(2.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.sf(2.0).round(14) == 0.15729920705028105.round(14)

    test "Chi2Distribution(1).sf(3.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.sf(3.0).round(14) == 0.0832645166635504.round(14)
