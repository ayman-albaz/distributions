import std/unittest
import results

import distributions

suite "API surface (documented fields and ppf quantile argument)":
  test "BernoulliDistribution fields":
    let d = initBernoulliDistribution(0.75).get()
    check d.p == 0.75
    check d.ppf(q = 0.5) == 1

  test "BetaDistribution fields":
    let d = initBetaDistribution(2.0, 5.0).get()
    check d.alpha == 2.0
    check d.beta == 5.0
    check d.ppf(q = 0.5) > 0.0

  test "BinomialDistribution fields":
    let d = initBinomialDistribution(10, 0.5).get()
    check d.n == 10
    check d.p == 0.5
    check d.ppf(q = 0.5).get() == 5

  test "Chi2Distribution fields":
    let d = initChi2Distribution[float64](4).get()
    check d.df == 4
    check d.ppf(q = 0.5) > 0.0

  test "FDistribution fields":
    let d = initFDistribution[float64](3, 5).get()
    check d.df1 == 3
    check d.df2 == 5
    check d.ppf(q = 0.5) > 0.0

  test "GammaDistribution fields":
    let d = initGammaDistribution(2.0, 3.0).get()
    check d.k == 2.0
    check d.theta == 3.0
    check d.ppf(q = 0.5) > 0.0

  test "NegativeBinomialDistribution fields":
    let d = initNegativeBinomialDistribution(5, 0.4).get()
    check d.r == 5
    check d.p == 0.4
    check d.ppf(q = 0.5).get() >= 0

  test "NormalDistribution fields":
    let d = initNormalDistribution(1.0, 2.0).get()
    check d.mu == 1.0
    check d.sigma == 2.0
    check d.ppf(q = 0.5) == 1.0

  test "PoissonDistribution fields":
    let d = initPoissonDistribution(7.0).get()
    check d.lambda == 7.0
    check d.ppf(q = 0.5).get() == 7

  test "TDistribution fields":
    let d = initTDistribution(3.5).get()
    check d.df == 3.5
    check abs(d.ppf(q = 0.5)) < 1e-12

  test "UniformContinuousDistribution fields":
    let d = initUniformContinuousDistribution(-1.0, 3.0).get()
    check d.a == -1.0
    check d.b == 3.0
    check d.ppf(q = 0.5) == 1.0

  test "UniformDiscreteDistribution fields":
    let d = initUniformDiscreteDistribution[float64](2, 5).get()
    check d.a == 2
    check d.b == 5
    check d.ppf(q = 0.5).get() == 3

  test "float32 field types":
    let d = initNormalDistribution(0.0'f32, 1.0'f32).get()
    check d.mu == 0.0'f32
    check d.sigma == 1.0'f32
