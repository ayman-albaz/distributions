import std/math
import std/unittest
import std/random

import distributions

const SEED = 0xDEADBEEF

template checkMean(emp, trueMean, trueVar, n: float64) =
  let se = sqrt(trueVar / n)
  check abs(emp - trueMean) < 5.0 * se

suite "sampling tests":
  test "Normal (0, 1) sample":
    var r = initRand(SEED)
    let d = initNormalDistribution(0.0, 1.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 0.0, 1.0, float64(n))

  test "Normal (5, 2) sample":
    var r = initRand(SEED)
    let d = initNormalDistribution(5.0, 2.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 5.0, 4.0, float64(n))

  test "UniformContinuous (0, 1) sample":
    var r = initRand(SEED)
    let d = initUniformContinuousDistribution(0.0, 1.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 0.5, 1.0/12.0, float64(n))

  test "UniformContinuous (-3, 7) sample":
    var r = initRand(SEED)
    let d = initUniformContinuousDistribution(-3.0, 7.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 2.0, 100.0/12.0, float64(n))

  test "UniformDiscrete (1, 6) sample":
    var r = initRand(SEED)
    let d = initUniformDiscreteDistribution[float64](1, 6)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    checkMean(total / float64(n), 3.5, 35.0/12.0, float64(n))

  test "UniformDiscrete (10, 100) sample":
    var r = initRand(SEED)
    let d = initUniformDiscreteDistribution[float64](10, 100)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    let tv = (91.0*91.0 - 1.0)/12.0
    checkMean(total / float64(n), 55.0, tv, float64(n))

  test "Bernoulli p=0.3 sample":
    var r = initRand(SEED)
    let d = initBernoulliDistribution(0.3)
    const n = 10_000
    var count = 0
    for i in 0 ..< n:
      count += d.sample(r)
    check abs(float64(count) / float64(n) - 0.3) < 5.0 * sqrt(0.3 * 0.7 / float64(n))

  test "Bernoulli p=0.7 sample":
    var r = initRand(SEED)
    let d = initBernoulliDistribution(0.7)
    const n = 10_000
    var count = 0
    for i in 0 ..< n:
      count += d.sample(r)
    check abs(float64(count) / float64(n) - 0.7) < 5.0 * sqrt(0.7 * 0.3 / float64(n))

  test "Binomial (10, 0.3) sample":
    var r = initRand(SEED)
    let d = initBinomialDistribution(10, 0.3)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    checkMean(total / float64(n), 3.0, 2.1, float64(n))

  test "Binomial (100, 0.5) sample":
    var r = initRand(SEED)
    let d = initBinomialDistribution(100, 0.5)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    checkMean(total / float64(n), 50.0, 25.0, float64(n))

  test "Binomial (5, 0.9) sample":
    var r = initRand(SEED)
    let d = initBinomialDistribution(5, 0.9)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    checkMean(total / float64(n), 4.5, 0.45, float64(n))

  test "NegativeBinomial (3, 0.5) sample":
    var r = initRand(SEED)
    let d = initNegativeBinomialDistribution(3, 0.5)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    checkMean(total / float64(n), 3.0, 6.0, float64(n))

  test "NegativeBinomial (10, 0.25) sample":
    var r = initRand(SEED)
    let d = initNegativeBinomialDistribution(10, 0.25)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    checkMean(total / float64(n), 30.0, 120.0, float64(n))

  test "NegativeBinomial (5, 0.9) sample":
    var r = initRand(SEED)
    let d = initNegativeBinomialDistribution(5, 0.9)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    let tv = 5.0 * 0.1 / (0.9 * 0.9)
    checkMean(total / float64(n), 5.0 * 0.1 / 0.9, tv, float64(n))

  test "Poisson lambda=1 sample":
    var r = initRand(SEED)
    let d = initPoissonDistribution(1.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    checkMean(total / float64(n), 1.0, 1.0, float64(n))

  test "Poisson lambda=5 sample":
    var r = initRand(SEED)
    let d = initPoissonDistribution(5.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    checkMean(total / float64(n), 5.0, 5.0, float64(n))

  test "Poisson lambda=30 sample":
    var r = initRand(SEED)
    let d = initPoissonDistribution(30.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    checkMean(total / float64(n), 30.0, 30.0, float64(n))

  test "Poisson lambda=50 sample":
    var r = initRand(SEED)
    let d = initPoissonDistribution(50.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    checkMean(total / float64(n), 50.0, 50.0, float64(n))

  test "Poisson lambda=100 sample":
    var r = initRand(SEED)
    let d = initPoissonDistribution(100.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += float64(d.sample(r))
    checkMean(total / float64(n), 100.0, 100.0, float64(n))

  test "Beta (2, 5) sample":
    var r = initRand(SEED)
    let d = initBetaDistribution(2.0, 5.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    let m = 2.0 / 7.0
    let v = (2.0 * 5.0) / (49.0 * 8.0)
    checkMean(total / float64(n), m, v, float64(n))

  test "Beta (0.5, 0.5) sample":
    var r = initRand(SEED)
    let d = initBetaDistribution(0.5, 0.5)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 0.5, 0.125, float64(n))

  test "Beta (5, 1) sample":
    var r = initRand(SEED)
    let d = initBetaDistribution(5.0, 1.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    let m = 5.0 / 6.0
    let v = (5.0 * 1.0) / (36.0 * 7.0)
    checkMean(total / float64(n), m, v, float64(n))

  test "Gamma (0.5, 1) sample":
    var r = initRand(SEED)
    let d = initGammaDistribution(0.5, 1.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 0.5, 0.5, float64(n))

  test "Gamma (1, 2) sample":
    var r = initRand(SEED)
    let d = initGammaDistribution(1.0, 2.0)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 2.0, 4.0, float64(n))

  test "Gamma (3, 0.5) sample":
    var r = initRand(SEED)
    let d = initGammaDistribution(3.0, 0.5)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 1.5, 0.75, float64(n))

  test "Chi2 df=3 sample":
    var r = initRand(SEED)
    let d = initChi2Distribution[float64](3)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 3.0, 6.0, float64(n))

  test "Chi2 df=10 sample":
    var r = initRand(SEED)
    let d = initChi2Distribution[float64](10)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 10.0, 20.0, float64(n))

  test "Chi2 df=30 sample":
    var r = initRand(SEED)
    let d = initChi2Distribution[float64](30)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 30.0, 60.0, float64(n))

  test "F (5, 5) sample":
    var r = initRand(SEED)
    let d = initFDistribution[float64](5, 5)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 5.0/3.0, (2.0*25.0*3.0)/(5.0*9.0*1.0), float64(n))

  test "F (3, 10) sample":
    var r = initRand(SEED)
    let d = initFDistribution[float64](3, 10)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 10.0/8.0, (2.0*100.0*11.0)/(3.0*64.0*6.0), float64(n))

  test "t df=3 sample":
    var r = initRand(SEED)
    let d = initTDistribution[float64](3)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 0.0, 3.0, float64(n))

  test "t df=10 sample":
    var r = initRand(SEED)
    let d = initTDistribution[float64](10)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 0.0, 10.0/8.0, float64(n))

  test "t df=30 sample":
    var r = initRand(SEED)
    let d = initTDistribution[float64](30)
    const n = 10_000
    var total = 0.0
    for i in 0 ..< n:
      total += d.sample(r)
    checkMean(total / float64(n), 0.0, 30.0/28.0, float64(n))
