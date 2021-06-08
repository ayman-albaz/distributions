import math
import times
import unittest

import distributions/chi2


suite "Chi2Distribution":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "Chi2Distribution(1).mean()":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.mean().round(14) == 1.0.round(14)

    test "Chi2Distribution(2).mean()":
        let chi2_dist = initChi2Distribution(2)
        check chi2_dist.mean().round(14) == 2.0.round(14)

    test "Chi2Distribution(3).mean()":
        let chi2_dist = initChi2Distribution(3)
        check chi2_dist.mean().round(14) == 3.0.round(14)

    test "Chi2Distribution(1).median()":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.median().round(14) == 0.47050754458162.round(14)

    test "Chi2Distribution(2).median()":
        let chi2_dist = initChi2Distribution(2)
        check chi2_dist.median().round(14) == 1.40466392318244.round(14)

    test "Chi2Distribution(3).median()":
        let chi2_dist = initChi2Distribution(3)
        check chi2_dist.median().round(14) == 2.38149672306051.round(14)

    test "Chi2Distribution(1).mode()":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.mode().round(14) == 0.0.round(14)

    test "Chi2Distribution(2).mode()":
        let chi2_dist = initChi2Distribution(2)
        check chi2_dist.mode().round(14) == 0.0.round(14)

    test "Chi2Distribution(3).mode()":
        let chi2_dist = initChi2Distribution(3)
        check chi2_dist.mode().round(14) == 1.0.round(14)

    test "Chi2Distribution(1).variance()":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.variance().round(14) == 2.0.round(14)

    test "Chi2Distribution(2).variance()":
        let chi2_dist = initChi2Distribution(2)
        check chi2_dist.variance().round(14) == 4.0.round(14)

    test "Chi2Distribution(3).variance()":
        let chi2_dist = initChi2Distribution(3)
        check chi2_dist.variance().round(14) == 6.0.round(14)

    test "Chi2Distribution(1).pdf(1.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.pdf(1.0).round(14) == 0.24197072451914337.round(14)

    test "Chi2Distribution(1).pdf(2.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.pdf(2.0).round(14) == 0.10377687435514868.round(14)

    test "Chi2Distribution(1).pdf(3.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.pdf(3.0).round(14) == 0.05139344326792309.round(14)

    test "Chi2Distribution(1).cdf(1.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.cdf(1.0).round(14) == 0.6826894921370859.round(14)

    test "Chi2Distribution(1).cdf(2.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.cdf(2.0).round(13) == 0.8427007929497151.round(13)

    test "Chi2Distribution(1).cdf(3.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.cdf(3.0).round(14) == 0.9167354833364496.round(14)

    test "Chi2Distribution(1).sf(1.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.sf(1.0).round(14) == 0.31731050786291115.round(14)

    test "Chi2Distribution(1).sf(2.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.sf(2.0).round(13) == 0.15729920705028105.round(13)

    test "Chi2Distribution(1).sf(3.0)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.sf(3.0).round(14) == 0.0832645166635504.round(14)

    test "Chi2Distribution(1).ppf(0.25)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.ppf(0.25).round(14) == 0.10153104426762159.round(14)

    test "Chi2Distribution(1).ppf(0.50)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.ppf(0.50).round(14) == 0.45493642311957283.round(14)

    test "Chi2Distribution(1).ppf(0.75)":
        let chi2_dist = initChi2Distribution(1)
        check chi2_dist.ppf(0.75).round(13) == 1.3233036969314669.round(13)

    test "Chi2Distribution(2).ppf(0.25)":
        let chi2_dist = initChi2Distribution(2)
        check chi2_dist.ppf(0.25).round(14) == 0.5753641449035619.round(14)

    test "Chi2Distribution(2).ppf(0.50)":
        let chi2_dist = initChi2Distribution(2)
        check chi2_dist.ppf(0.50).round(14) == 1.3862943611198906.round(14)

    test "Chi2Distribution(2).ppf(0.75)":
        let chi2_dist = initChi2Distribution(2)
        check chi2_dist.ppf(0.75).round(14) == 2.772588722239781.round(14)

    test "Chi2Distribution(3).ppf(0.25)":
        let chi2_dist = initChi2Distribution(3)
        check chi2_dist.ppf(0.25).round(14) == 1.2125329030456689.round(14)

    test "Chi2Distribution(3).ppf(0.50)":
        let chi2_dist = initChi2Distribution(3)
        check chi2_dist.ppf(0.50).round(14) == 2.3659738843753386.round(14)

    test "Chi2Distribution(3).ppf(0.75)":
        let chi2_dist = initChi2Distribution(3)
        check chi2_dist.ppf(0.75).round(14) == 4.108344935632317.round(14)