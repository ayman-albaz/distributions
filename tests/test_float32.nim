import std/math
import std/unittest
import std/random

import distributions

func approxEq(a, b: float, tol = 1e-9): bool =
  abs(a - b) < tol

func approxEq32(a, b: float32, tol: float32 = 1e-4'f32): bool =
  abs(a - b) < tol

suite "float32 paths":
  test "NormalDistribution float32":
    let d32 = initNormalDistribution(0.0'f32, 1.0'f32)
    let d64 = initNormalDistribution(0.0, 1.0)
    check approxEq32(d32.mean(), 0.0'f32)
    check approxEq32(d32.median(), 0.0'f32)
    check approxEq32(d32.mode(), 0.0'f32)
    check approxEq32(d32.variance(), 1.0'f32)
    check approxEq32(d32.pdf(0.0'f32), float32(d64.pdf(0.0)), 1e-4'f32)
    check approxEq32(d32.cdf(0.0'f32), float32(d64.cdf(0.0)), 1e-4'f32)
    check approxEq32(d32.ppf(0.5'f32), float32(d64.ppf(0.5)), 1e-4'f32)

  test "BernoulliDistribution float32":
    let d32 = initBernoulliDistribution(0.25'f32)
    let d64 = initBernoulliDistribution(0.25)
    check approxEq32(d32.mean(), float32(d64.mean()), 1e-4'f32)
    check approxEq32(d32.variance(), float32(d64.variance()), 1e-4'f32)
    check approxEq32(d32.pmf(0), float32(d64.pmf(0)), 1e-4'f32)
    check approxEq32(d32.cdf(0), float32(d64.cdf(0)), 1e-4'f32)
    check d32.ppf(0.5'f32) == 0

  test "BetaDistribution float32":
    let d32 = initBetaDistribution(2.0'f32, 2.0'f32)
    let d64 = initBetaDistribution(2.0, 2.0)
    check approxEq32(d32.mean(), float32(d64.mean()), 1e-4'f32)
    check approxEq32(d32.variance(), float32(d64.variance()), 1e-4'f32)
    check approxEq32(d32.pdf(0.5'f32), float32(d64.pdf(0.5)), 1e-4'f32)
    check approxEq32(d32.cdf(0.5'f32), float32(d64.cdf(0.5)), 1e-4'f32)
    check approxEq32(d32.ppf(0.5'f32), float32(d64.ppf(0.5)), 1e-4'f32)

  test "BinomialDistribution float32":
    let d32 = initBinomialDistribution(10, 0.5'f32)
    let d64 = initBinomialDistribution(10, 0.5)
    check approxEq32(d32.mean(), float32(d64.mean()), 1e-4'f32)
    check approxEq32(d32.variance(), float32(d64.variance()), 1e-4'f32)
    check approxEq32(d32.pmf(5), float32(d64.pmf(5)), 1e-4'f32)
    check approxEq32(d32.cdf(5), float32(d64.cdf(5)), 1e-4'f32)
    check d32.ppf(0.5'f32) == d64.ppf(0.5)

  test "Chi2Distribution float32":
    let d32 = initChi2Distribution[float32](4)
    let d64 = initChi2Distribution[float64](4)
    check approxEq32(d32.mean(), float32(d64.mean()), 1e-4'f32)
    check approxEq32(d32.median(), float32(d64.median()), 1e-4'f32)
    check approxEq32(d32.variance(), float32(d64.variance()), 1e-4'f32)
    check approxEq32(d32.pdf(4.0'f32), float32(d64.pdf(4.0)), 1e-4'f32)
    check approxEq32(d32.cdf(4.0'f32), float32(d64.cdf(4.0)), 1e-4'f32)
    check approxEq32(d32.ppf(0.5'f32), float32(d64.ppf(0.5)), 1e-4'f32)

  test "FDistribution float32":
    let d32 = initFDistribution[float32](5, 10)
    let d64 = initFDistribution[float64](5, 10)
    check approxEq32(d32.mean(), float32(d64.mean()), 1e-4'f32)
    check approxEq32(d32.median(), float32(d64.median()), 1e-4'f32)
    check approxEq32(d32.pdf(1.0'f32), float32(d64.pdf(1.0)), 1e-4'f32)
    check approxEq32(d32.cdf(1.0'f32), float32(d64.cdf(1.0)), 1e-4'f32)
    check approxEq32(d32.ppf(0.5'f32), float32(d64.ppf(0.5)), 1e-4'f32)

  test "GammaDistribution float32":
    let d32 = initGammaDistribution(2.0'f32, 2.0'f32)
    let d64 = initGammaDistribution(2.0, 2.0)
    check approxEq32(d32.mean(), float32(d64.mean()), 1e-4'f32)
    check approxEq32(d32.variance(), float32(d64.variance()), 1e-4'f32)
    check approxEq32(d32.pdf(4.0'f32), float32(d64.pdf(4.0)), 1e-4'f32)
    check approxEq32(d32.cdf(4.0'f32), float32(d64.cdf(4.0)), 1e-4'f32)
    check approxEq32(d32.ppf(0.5'f32), float32(d64.ppf(0.5)), 1e-4'f32)

  test "NegativeBinomialDistribution float32":
    let d32 = initNegativeBinomialDistribution(10, 0.25'f32)
    let d64 = initNegativeBinomialDistribution(10, 0.25)
    check approxEq32(d32.mean(), float32(d64.mean()), 1e-4'f32)
    check approxEq32(d32.variance(), float32(d64.variance()), 1e-4'f32)
    check approxEq32(d32.pmf(5), float32(d64.pmf(5)), 1e-4'f32)
    check approxEq32(d32.cdf(20), float32(d64.cdf(20)), 1e-4'f32)
    check d32.ppf(0.25'f32) == d64.ppf(0.25)

  test "PoissonDistribution float32":
    let d32 = initPoissonDistribution(10.0'f32)
    let d64 = initPoissonDistribution(10.0)
    check approxEq32(d32.mean(), float32(d64.mean()), 1e-4'f32)
    check approxEq32(d32.variance(), float32(d64.variance()), 1e-4'f32)
    check approxEq32(d32.pmf(10), float32(d64.pmf(10)), 1e-4'f32)
    check approxEq32(d32.cdf(10), float32(d64.cdf(10)), 1e-4'f32)
    check d32.ppf(0.5'f32) == d64.ppf(0.5)

  test "TDistribution float32":
    let d32 = initTDistribution[float32](30)
    let d64 = initTDistribution[float64](30)
    check approxEq32(d32.mean(), 0.0'f32)
    check approxEq32(d32.median(), 0.0'f32)
    check approxEq32(d32.mode(), 0.0'f32)
    check approxEq32(d32.variance(), float32(d64.variance()), 1e-4'f32)
    check approxEq32(d32.pdf(0.0'f32), float32(d64.pdf(0.0)), 1e-4'f32)
    check approxEq32(d32.cdf(0.0'f32), float32(d64.cdf(0.0)), 1e-4'f32)
    check approxEq32(d32.ppf(0.5'f32), float32(d64.ppf(0.5)), 1e-4'f32)

  test "UniformContinuousDistribution float32":
    let d32 = initUniformContinuousDistribution(0.0'f32, 1.0'f32)
    let d64 = initUniformContinuousDistribution(0.0, 1.0)
    check approxEq32(d32.mean(), float32(d64.mean()), 1e-4'f32)
    check approxEq32(d32.variance(), float32(d64.variance()), 1e-4'f32)
    check approxEq32(d32.pdf(0.5'f32), float32(d64.pdf(0.5)), 1e-4'f32)
    check approxEq32(d32.cdf(0.5'f32), float32(d64.cdf(0.5)), 1e-4'f32)
    check approxEq32(d32.ppf(0.5'f32), float32(d64.ppf(0.5)), 1e-4'f32)

  test "UniformDiscreteDistribution float32":
    let d32 = initUniformDiscreteDistribution[float32](0, 5)
    let d64 = initUniformDiscreteDistribution[float64](0, 5)
    check approxEq32(d32.mean(), float32(d64.mean()), 1e-4'f32)
    check approxEq32(d32.variance(), float32(d64.variance()), 1e-4'f32)
    check approxEq32(d32.pmf(2), float32(d64.pmf(2)), 1e-4'f32)
    check approxEq32(d32.cdf(2), float32(d64.cdf(2)), 1e-4'f32)
    check d32.ppf(0.5'f32) == d64.ppf(0.5)

  test "NormalDistribution float32 sample":
    var r = initRand(0xDEADBEEF)
    let d32 = initNormalDistribution(0.0'f32, 1.0'f32)
    var total = 0'f32
    const n = 10_000
    for i in 0 ..< n:
      total += d32.sample(r)
    check abs(total / float32(n) - 0.0'f32) < 0.05'f32

  test "float32 sample":
    let rngSeed = 0xDEADBEEF

    block:
      var r = initRand(rngSeed)
      let d = initNormalDistribution(0.0'f32, 1.0'f32)
      const n = 1000
      var total = 0'f32
      for i in 0 ..< n:
        total += d.sample(r)
      check abs(total / float32(n) - 0.0'f32) < 0.1'f32

    block:
      var r = initRand(rngSeed)
      let d = initUniformContinuousDistribution(0.0'f32, 1.0'f32)
      const n = 1000
      var total = 0'f32
      for i in 0 ..< n:
        total += d.sample(r)
      check abs(total / float32(n) - d.mean()) < 0.1'f32

    block:
      var r = initRand(rngSeed)
      let d = initGammaDistribution(2.0'f32, 2.0'f32)
      const n = 1000
      var total = 0'f32
      for i in 0 ..< n:
        total += d.sample(r)
      check abs(total / float32(n) - d.mean()) < 1.0'f32

    block:
      var r = initRand(rngSeed)
      let d = initBetaDistribution(2.0'f32, 5.0'f32)
      const n = 1000
      var total = 0'f32
      for i in 0 ..< n:
        total += d.sample(r)
      check abs(total / float32(n) - d.mean()) < 0.1'f32

    block:
      var r = initRand(rngSeed)
      let d = initBinomialDistribution(10, 0.5'f32)
      const n = 1000
      var total = 0'f32
      for i in 0 ..< n:
        total += float32(d.sample(r))
      check abs(total / float32(n) - d.mean()) < 1.0'f32
