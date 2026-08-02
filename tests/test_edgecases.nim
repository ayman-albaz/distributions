import std/math
import std/unittest
import std/random
import results

import distributions
import distributions/base

suite "Edge cases":
  test "Bernoulli p=0":
    let d = initBernoulliDistribution(0.0).get()
    check d.pmf(0) == 1.0
    check d.pmf(1) == 0.0
    check d.ppf(0.5) == 0

  test "Bernoulli p=1":
    let d = initBernoulliDistribution(1.0).get()
    check d.pmf(0) == 0.0
    check d.pmf(1) == 1.0
    check d.ppf(0.5) == 1

  test "Bernoulli p<0 returns error":
    check initBernoulliDistribution(-0.1).isErr()

  test "Bernoulli p>1 returns error":
    check initBernoulliDistribution(1.1).isErr()

  test "Bernoulli median p=0.5":
    let d = initBernoulliDistribution(0.5).get()
    check d.median() == 0.5

  test "Bernoulli mode p=0.5 returns error":
    check initBernoulliDistribution(0.5).get().mode().isErr()

  test "Beta alpha=1 beta=1 mode returns error":
    check initBetaDistribution(1.0, 1.0).get().mode().isErr()

  test "Beta alpha<1 beta<1 mode returns error":
    check initBetaDistribution(0.5, 0.5).get().mode().isErr()

  test "Beta alpha<1 beta<1 pdf(0.5) finite":
    let d = initBetaDistribution(0.5, 0.5).get()
    check d.pdf(0.5) > 0.0
    check d.pdf(0.5) < Inf

  test "Beta pdf boundary ladder":
    check initBetaDistribution(0.5, 1.0).get().pdf(0.0) == Inf
    check initBetaDistribution(1.0, 2.0).get().pdf(0.0) == 2.0
    check initBetaDistribution(2.0, 1.0).get().pdf(0.0) == 0.0
    check initBetaDistribution(1.0, 1.0).get().pdf(0.0) == 1.0
    check initBetaDistribution(1.0, 0.5).get().pdf(1.0) == Inf
    check initBetaDistribution(2.0, 1.0).get().pdf(1.0) == 2.0
    check initBetaDistribution(1.0, 2.0).get().pdf(1.0) == 0.0

  test "Binomial n=0 pmf(0)=1":
    let d = initBinomialDistribution(0, 0.5).get()
    check d.pmf(0) == 1.0
    check d.ppf(0.0).get() == 0

  test "Chi2 df=1 pdf(0.0)=Inf":
    let d = initChi2Distribution[float64](1).get()
    check d.pdf(0.0) == Inf

  test "Poisson small lambda pmf(0) ~1":
    let d = initPoissonDistribution(1e-9).get()
    check abs(d.pmf(0) - 1.0) < 1e-6

  test "Poisson lambda=0 returns error":
    check initPoissonDistribution(0.0).isErr()

  test "Poisson median is ppf(0.5)":
    let d = initPoissonDistribution(1.0).get()
    check d.median().get() == float(d.ppf(0.5).get())

  test "Uniform a=b returns error":
    check initUniformContinuousDistribution(1.0, 1.0).isErr()

  test "Normal sigma=0 returns error":
    check initNormalDistribution(0.0, 0.0).isErr()

  test "Normal sigma<0 returns error":
    check initNormalDistribution(0.0, -1.0).isErr()

  test "F df2<=2 mean returns error":
    check initFDistribution[float64](1, 2).get().mean().isErr()
    check initFDistribution[float64](1, 1).get().mean().isErr()

  test "F df2<=4 variance returns error":
    check initFDistribution[float64](5, 4).get().variance().isErr()
    check initFDistribution[float64](5, 3).get().variance().isErr()

  test "F df1<=2 mode returns error":
    check initFDistribution[float64](2, 5).get().mode().isErr()
    check initFDistribution[float64](1, 5).get().mode().isErr()

  test "t df=1 ppf extremes":
    let d = initTDistribution(1.0).get()
    check d.ppf(0.0) == -Inf
    check d.ppf(1.0) == Inf

  test "t df<=2 variance returns error":
    check initTDistribution(2.0).get().variance().isErr()
    check initTDistribution(1.0).get().variance().isErr()

  test "t df<=1 mean returns error":
    check initTDistribution(1.0).get().mean().isErr()

  test "t df<1 ppf via bisection":
    for df in [0.4, 0.5, 0.75]:
      let d = initTDistribution(df).get()
      check abs(d.ppf(0.5)) < 1e-9
      check abs(d.ppf(0.25) + d.ppf(0.75)) < 1e-9
      check abs(d.cdf(d.ppf(0.25)) - 0.25) < 1e-9
      check abs(d.cdf(d.ppf(0.5)) - 0.5) < 1e-9
      check abs(d.cdf(d.ppf(0.75)) - 0.75) < 1e-9

  test "NegativeBinomial cdf smoke test":
    let d = initNegativeBinomialDistribution(5, 0.5).get()
    check d.cdf(10) > 0.0

  test "Chi2 df=0 returns error":
    check initChi2Distribution[float](0).isErr()

  test "Chi2 df=2 pdf(0.0)=0.5":
    let d = initChi2Distribution[float64](2).get()
    check d.pdf(0.0) == 0.5

  test "Chi2 df=3 pdf(0.0)=0":
    let d = initChi2Distribution[float64](3).get()
    check d.pdf(0.0) == 0.0

  test "Gamma k=1 theta=2 pdf(0.0)=0.5":
    let d = initGammaDistribution(1.0, 2.0).get()
    check d.pdf(0.0) == 0.5

  test "Gamma k=2 theta=2 pdf(0.0)=0":
    let d = initGammaDistribution(2.0, 2.0).get()
    check d.pdf(0.0) == 0.0

  test "Binomial p=0 pmf(0)=1, pmf(1)=0":
    let d = initBinomialDistribution(10, 0.0).get()
    check d.pmf(0) == 1.0
    check d.pmf(5) == 0.0

  test "Binomial p=1 pmf(n)=1, pmf(n-1)=0":
    let d = initBinomialDistribution(10, 1.0).get()
    check d.pmf(10) == 1.0
    check d.pmf(9) == 0.0

  test "NegativeBinomial p=0 pmf(k)=0":
    let d = initNegativeBinomialDistribution(5, 0.0).get()
    check d.pmf(0) == 0.0
    check d.pmf(10) == 0.0

  test "NegativeBinomial p=1 pmf(0)=1, pmf(1)=0":
    let d = initNegativeBinomialDistribution(5, 1.0).get()
    check d.pmf(0) == 1.0
    check d.pmf(1) == 0.0
    check d.cdf(0) == 1.0
    check d.sf(0) == 0.0

  test "NegativeBinomial p=0.25 pmf(5) regression (parameterization)":
    let d = initNegativeBinomialDistribution(10, 0.25).get()
    check abs(d.pmf(5) - 0.000453) < 2e-6

  test "Binomial n=0 sample always 0":
    var r = initRand(0xDEADBEEF)
    let d = initBinomialDistribution(0, 0.5).get()
    for i in 0 ..< 5:
      check d.sample(r) == 0

  test "Binomial p=0 sample always 0":
    var r = initRand(0xDEADBEEF)
    let d = initBinomialDistribution(10, 0.0).get()
    for i in 0 ..< 10:
      check d.sample(r) == 0

  test "Binomial p=1 sample always n":
    var r = initRand(0xDEADBEEF)
    let d = initBinomialDistribution(10, 1.0).get()
    for i in 0 ..< 10:
      check d.sample(r) == 10

  test "NegativeBinomial p=0 sample always 0":
    var r = initRand(0xDEADBEEF)
    let d = initNegativeBinomialDistribution(5, 0.0).get()
    for i in 0 ..< 5:
      check d.sample(r) == 0

  test "NegativeBinomial p=1 sample always 0":
    var r = initRand(0xDEADBEEF)
    let d = initNegativeBinomialDistribution(5, 1.0).get()
    for i in 0 ..< 5:
      check d.sample(r) == 0

  test "Gamma k=1 theta=2 sample returns non-negative":
    var r = initRand(0xDEADBEEF)
    let d = initGammaDistribution(1.0, 2.0).get()
    for i in 0 ..< 100:
      let x = d.sample(r)
      check x >= 0.0

  test "NaN parameters rejected (Normal)":
    check initNormalDistribution(0.0, NaN).isErr()
    check initNormalDistribution(NaN, 1.0).isErr()

  test "validateNotNaN rejects NaN, accepts Inf":
    let e = validateNotNaN(NaN).error
    check e == DistError.MustNotBeNaN
    check $e == "parameter must not be NaN"
    check validateNotNaN(Inf).isOk()
    check validateNotNaN(-Inf).isOk()
    check validateNotNaN(1).isOk()

  test "NaN parameters rejected (Beta)":
    check initBetaDistribution(NaN, 1.0).isErr()
    check initBetaDistribution(1.0, NaN).isErr()

  test "NaN parameters rejected (Binomial)":
    check initBinomialDistribution(10, NaN).isErr()

  test "NaN parameters rejected (UniformContinuous)":
    check initUniformContinuousDistribution(0.0, NaN).isErr()
    check initUniformContinuousDistribution(NaN, 1.0).isErr()

  test "UniformContinuous pdf/cdf propagate NaN":
    let d = initUniformContinuousDistribution(0.0, 1.0).get()
    check d.pdf(NaN).isNaN()
    check d.cdf(NaN).isNaN()

  test "Bernoulli ppf(NaN) returns 0":
    let d = initBernoulliDistribution(0.3).get()
    check d.ppf(NaN) == 0

  test "Binomial ppf(NaN) returns ok(0)":
    let d = initBinomialDistribution(10, 0.3).get()
    check d.ppf(NaN).get() == 0

  test "NegativeBinomial ppf(NaN) returns ok(0)":
    let d = initNegativeBinomialDistribution(5, 0.3).get()
    check d.ppf(NaN).get() == 0

  test "Poisson ppf(NaN) returns ok(0)":
    let d = initPoissonDistribution(5.0).get()
    check d.ppf(NaN).get() == 0

  test "UniformDiscrete ppf(NaN) returns ok(a)":
    let d = initUniformDiscreteDistribution[float64](3, 7).get()
    check d.ppf(NaN).get() == 3

  test "Gamma k<1 pdf(0.0)=Inf":
    let d = initGammaDistribution(0.5, 2.0).get()
    check d.pdf(0.0) == Inf

  test "F df1=1 pdf(0.0)=Inf":
    let d = initFDistribution[float64](1, 5).get()
    check d.pdf(0.0) == Inf

  test "F df1=2 pdf(0.0)=1.0":
    let d = initFDistribution[float64](2, 5).get()
    check d.pdf(0.0) == 1.0

  test "DistError string-enum variant and message (validator)":
    let e = initPoissonDistribution(-1.0).error
    check e == DistError.MustBePositive
    check $e == "parameter must be positive"

  test "DistError string-enum variant and message (moment)":
    let e = initFDistribution[float64](1, 2).get().mean().error
    check e == DistError.MeanUndefined
    check $e == "mean undefined for these parameters"

  test "DistError string-enum variant and message (bounds)":
    let e = initUniformContinuousDistribution(1.0, 1.0).error
    check e == DistError.AMustBeLessThanB
    check $e == "a must be < b"
