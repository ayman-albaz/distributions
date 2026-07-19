import std/math
import std/unittest
import std/random

import distributions

suite "Edge cases":
  test "Bernoulli p=0":
    let d = initBernoulliDistribution(0.0)
    check d.pmf(0) == 1.0
    check d.pmf(1) == 0.0
    check d.ppf(0.5) == 0

  test "Bernoulli p=1":
    let d = initBernoulliDistribution(1.0)
    check d.pmf(0) == 0.0
    check d.pmf(1) == 1.0
    check d.ppf(0.5) == 1

  test "Bernoulli p<0 raises":
    expect ValueError:
      discard initBernoulliDistribution(-0.1)

  test "Bernoulli p>1 raises":
    expect ValueError:
      discard initBernoulliDistribution(1.1)

  test "Bernoulli median p=0.5":
    let d = initBernoulliDistribution(0.5)
    check d.median() == 0.5

  test "Bernoulli mode p=0.5 raises":
    expect ValueError:
      discard initBernoulliDistribution(0.5).mode()

  test "Beta alpha=1 beta=1 mode raises":
    expect ValueError:
      discard initBetaDistribution(1.0, 1.0).mode()

  test "Beta alpha<1 beta<1 mode raises":
    expect ValueError:
      discard initBetaDistribution(0.5, 0.5).mode()

  test "Beta alpha<1 beta<1 pdf(0.5) finite":
    let d = initBetaDistribution(0.5, 0.5)
    check d.pdf(0.5) > 0.0
    check d.pdf(0.5) < Inf

  test "Binomial n=0 pmf(0)=1":
    let d = initBinomialDistribution(0, 0.5)
    check d.pmf(0) == 1.0
    check d.ppf(0.0) == 0

  test "Chi2 df=1 pdf(0.0)=Inf":
    let d = initChi2Distribution[float64](1)
    check d.pdf(0.0) == Inf

  test "Poisson small lambda pmf(0) ~1":
    let d = initPoissonDistribution(1e-9)
    check abs(d.pmf(0) - 1.0) < 1e-6

  test "Poisson lambda=0 raises":
    expect ValueError:
      discard initPoissonDistribution(0.0)

  test "Poisson median is ppf(0.5)":
    let d = initPoissonDistribution(1.0)
    check d.median() == float(d.ppf(0.5))

  test "Uniform a=b raises":
    expect ValueError:
      discard initUniformContinuousDistribution(1.0, 1.0)

  test "Normal sigma=0 raises":
    expect ValueError:
      discard initNormalDistribution(0.0, 0.0)

  test "Normal sigma<0 raises":
    expect ValueError:
      discard initNormalDistribution(0.0, -1.0)

  test "F df2<=2 mean raises":
    expect ValueError:
      discard initFDistribution[float64](1, 2).mean()
    expect ValueError:
      discard initFDistribution[float64](1, 1).mean()

  test "F df2<=4 variance raises":
    expect ValueError:
      discard initFDistribution[float64](5, 4).variance()
    expect ValueError:
      discard initFDistribution[float64](5, 3).variance()

  test "F df1<=2 mode raises":
    expect ValueError:
      discard initFDistribution[float64](2, 5).mode()
    expect ValueError:
      discard initFDistribution[float64](1, 5).mode()

  test "t df=1 ppf extremes":
    let d = initTDistribution[float64](1)
    check d.ppf(0.0) == -Inf
    check d.ppf(1.0) == Inf

  test "t df<=2 variance raises":
    expect ValueError:
      discard initTDistribution[float64](2).variance()
    expect ValueError:
      discard initTDistribution[float64](1).variance()

  test "t df<=1 mean raises":
    expect ValueError:
      discard initTDistribution[float64](1).mean()

  test "NegativeBinomial compile check":
    let d = initNegativeBinomialDistribution(5, 0.5)
    check d.cdf(10) > 0.0

  test "Chi2 df=0 raises":
    expect ValueError:
      discard initChi2Distribution[float](0)

  test "Chi2 df=2 pdf(0.0)=0.5":
    let d = initChi2Distribution[float64](2)
    check d.pdf(0.0) == 0.5

  test "Chi2 df=3 pdf(0.0)=0":
    let d = initChi2Distribution[float64](3)
    check d.pdf(0.0) == 0.0

  test "Gamma k=1 theta=2 pdf(0.0)=0.5":
    let d = initGammaDistribution(1.0, 2.0)
    check d.pdf(0.0) == 0.5

  test "Gamma k=2 theta=2 pdf(0.0)=0":
    let d = initGammaDistribution(2.0, 2.0)
    check d.pdf(0.0) == 0.0

  test "Binomial p=0 pmf(0)=1, pmf(1)=0":
    let d = initBinomialDistribution(10, 0.0)
    check d.pmf(0) == 1.0
    check d.pmf(5) == 0.0

  test "Binomial p=1 pmf(n)=1, pmf(n-1)=0":
    let d = initBinomialDistribution(10, 1.0)
    check d.pmf(10) == 1.0
    check d.pmf(9) == 0.0

  test "NegativeBinomial p=0 pmf(k)=0":
    let d = initNegativeBinomialDistribution(5, 0.0)
    check d.pmf(0) == 0.0
    check d.pmf(10) == 0.0

  test "NegativeBinomial p=0.25 pmf(5) regression (parameterization)":
    ## scipy.stats.nbinom.pmf: pmf(5, n=10, p=0.25) ~ 4.52e-4
    ## (NB: count failures before r=10 successes, p=0.25 probability of success)
    let d = initNegativeBinomialDistribution(10, 0.25)
    check abs(d.pmf(5) - 0.000453) < 2e-6

  test "Binomial n=0 sample always 0":
    var r = initRand(0xDEADBEEF)
    let d = initBinomialDistribution(0, 0.5)
    for i in 0 ..< 5:
      check d.sample(r) == 0

  test "Binomial p=0 sample always 0":
    var r = initRand(0xDEADBEEF)
    let d = initBinomialDistribution(10, 0.0)
    for i in 0 ..< 10:
      check d.sample(r) == 0

  test "Binomial p=1 sample always n":
    var r = initRand(0xDEADBEEF)
    let d = initBinomialDistribution(10, 1.0)
    for i in 0 ..< 10:
      check d.sample(r) == 10

  test "NegativeBinomial p=0 sample always 0":
    var r = initRand(0xDEADBEEF)
    let d = initNegativeBinomialDistribution(5, 0.0)
    for i in 0 ..< 5:
      check d.sample(r) == 0

  test "NegativeBinomial p=1 sample always 0":
    var r = initRand(0xDEADBEEF)
    let d = initNegativeBinomialDistribution(5, 1.0)
    for i in 0 ..< 5:
      check d.sample(r) == 0

  test "Gamma k=1 theta=2 sample returns non-negative":
    var r = initRand(0xDEADBEEF)
    let d = initGammaDistribution(1.0, 2.0)
    for i in 0 ..< 100:
      let x = d.sample(r)
      check x >= 0.0
