import math
import times
import unittest

import distributions


suite "Chi2Distribution":
  
  const r1 = 14
  const r2 = 13

  setup:
    let t0 = getTime()

  teardown:
    echo "\n  RUNTIME: ", getTime() - t0

  test "Chi2Distribution(1).mean()":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.mean().round(r1) == 1.0.round(r1)

  test "Chi2Distribution(2).mean()":
    let chi2_dist = initChi2Distribution(2)
    check chi2_dist.mean().round(r1) == 2.0.round(r1)

  test "Chi2Distribution(3).mean()":
    let chi2_dist = initChi2Distribution(3)
    check chi2_dist.mean().round(r1) == 3.0.round(r1)

  test "Chi2Distribution(1).median()":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.median().round(r1) == 0.47050754458162.round(r1)

  test "Chi2Distribution(2).median()":
    let chi2_dist = initChi2Distribution(2)
    check chi2_dist.median().round(r1) == 1.40466392318244.round(r1)

  test "Chi2Distribution(3).median()":
    let chi2_dist = initChi2Distribution(3)
    check chi2_dist.median().round(r1) == 2.38149672306051.round(r1)

  test "Chi2Distribution(1).mode()":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.mode().round(r1) == 0.0.round(r1)

  test "Chi2Distribution(2).mode()":
    let chi2_dist = initChi2Distribution(2)
    check chi2_dist.mode().round(r1) == 0.0.round(r1)

  test "Chi2Distribution(3).mode()":
    let chi2_dist = initChi2Distribution(3)
    check chi2_dist.mode().round(r1) == 1.0.round(r1)

  test "Chi2Distribution(1).variance()":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.variance().round(r1) == 2.0.round(r1)

  test "Chi2Distribution(2).variance()":
    let chi2_dist = initChi2Distribution(2)
    check chi2_dist.variance().round(r1) == 4.0.round(r1)

  test "Chi2Distribution(3).variance()":
    let chi2_dist = initChi2Distribution(3)
    check chi2_dist.variance().round(r1) == 6.0.round(r1)

  test "Chi2Distribution(1).pdf(1.0)":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.pdf(1.0).round(r1) == 0.24197072451914337.round(r1)

  test "Chi2Distribution(1).pdf(2.0)":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.pdf(2.0).round(r1) == 0.10377687435514868.round(r1)

  test "Chi2Distribution(1).pdf(3.0)":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.pdf(3.0).round(r1) == 0.05139344326792309.round(r1)

  test "Chi2Distribution(1).cdf(1.0)":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.cdf(1.0).round(r1) == 0.6826894921370859.round(r1)

  test "Chi2Distribution(1).cdf(2.0)":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.cdf(2.0).round(r2) == 0.8427007929497151.round(r2)

  test "Chi2Distribution(1).cdf(3.0)":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.cdf(3.0).round(r1) == 0.9167354833364496.round(r1)

  test "Chi2Distribution(1).sf(1.0)":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.sf(1.0).round(r1) == 0.31731050786291115.round(r1)

  test "Chi2Distribution(1).sf(2.0)":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.sf(2.0).round(r2) == 0.15729920705028105.round(r2)

  test "Chi2Distribution(1).sf(3.0)":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.sf(3.0).round(r1) == 0.0832645166635504.round(r1)

  test "Chi2Distribution(1).ppf(0.25)":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.ppf(0.25).round(r1) == 0.10153104426762159.round(r1)

  test "Chi2Distribution(1).ppf(0.50)":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.ppf(0.50).round(r1) == 0.45493642311957283.round(r1)

  test "Chi2Distribution(1).ppf(0.75)":
    let chi2_dist = initChi2Distribution(1)
    check chi2_dist.ppf(0.75).round(r2) == 1.3233036969314669.round(r2)

  test "Chi2Distribution(2).ppf(0.25)":
    let chi2_dist = initChi2Distribution(2)
    check chi2_dist.ppf(0.25).round(r1) == 0.5753641449035619.round(r1)

  test "Chi2Distribution(2).ppf(0.50)":
    let chi2_dist = initChi2Distribution(2)
    check chi2_dist.ppf(0.50).round(r1) == 1.3862943611198906.round(r1)

  test "Chi2Distribution(2).ppf(0.75)":
    let chi2_dist = initChi2Distribution(2)
    check chi2_dist.ppf(0.75).round(r1) == 2.772588722239781.round(r1)

  test "Chi2Distribution(3).ppf(0.25)":
    let chi2_dist = initChi2Distribution(3)
    check chi2_dist.ppf(0.25).round(r1) == 1.2125329030456689.round(r1)

  test "Chi2Distribution(3).ppf(0.50)":
    let chi2_dist = initChi2Distribution(3)
    check chi2_dist.ppf(0.50).round(r1) == 2.3659738843753386.round(r1)

  test "Chi2Distribution(3).ppf(0.75)":
    let chi2_dist = initChi2Distribution(3)
    check chi2_dist.ppf(0.75).round(r1) == 4.108344935632317.round(r1)