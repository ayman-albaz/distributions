import std/math
import std/unittest

import distributions

func approx(a, b, tol: float): bool =
  abs(a - b) < tol

suite "cdf-ppf round-trip properties":
  test "Normal cdf↔ppf round-trip":
    let d = initNormalDistribution(0.0, 1.0)
    for i in 0 .. 40:
      let x = -10.0 + float(i) * 0.5
      let p = d.cdf(x)
      let x2 = d.ppf(p)
      check (p <= 0.001 or p >= 0.999) or approx(x2, x, 5e-3)

  test "Student's t cdf↔ppf round-trip":
    for df in [1, 2, 5, 30]:
      let d = initTDistribution[float64](df)
      for i in 0 .. 120:
        let x = -30.0 + float(i) * 0.5
        let p = d.cdf(x)
        let x2 = d.ppf(p)
        check (p <= 0.001 or p >= 0.999) or approx(x2, x, 5e-3)

  test "Chi2 cdf↔ppf round-trip":
    for df in [1, 2, 5]:
      let d = initChi2Distribution[float64](df)
      for i in 0 .. 40:
        let x = 0.1 + float(i) * 0.5
        let p = d.cdf(x)
        let x2 = d.ppf(p)
        check approx(x2, x, 1e-7)

  test "F cdf↔ppf round-trip":
    for df1 in [3, 5, 10]:
      for df2 in [5, 10, 15]:
        let d = initFDistribution[float64](df1, df2)
        for i in 0 .. 40:
          let x = 0.05 + float(i) * 0.5
          let p = d.cdf(x)
          let x2 = d.ppf(p)
          check approx(x2, x, 1e-6)

  test "Gamma cdf↔ppf round-trip":
    for ks in [1.0, 2.0, 5.0]:
      let d = initGammaDistribution(ks, 1.0)
      for i in 0 .. 30:
        let x = 0.1 + float(i) * 0.5
        let p = d.cdf(x)
        let x2 = d.ppf(p)
        check p >= 0.999 or approx(x2, x, 1e-7)

  test "Beta cdf↔ppf round-trip":
    for alpha in [0.5, 2.0, 5.0]:
      for beta in [0.5, 2.0, 5.0]:
        let d = initBetaDistribution(alpha, beta)
        for i in 0 .. 19:
          let x = 0.05 + float(i) * 0.05
          let p = d.cdf(x)
          let x2 = d.ppf(p)
          if alpha < 1.0 and beta < 1.0:
            check approx(x2, x, 1e-2)
          else:
            check approx(x2, x, 1e-7)

  test "UniformContinuous cdf↔ppf round-trip":
    let d = initUniformContinuousDistribution(0.0, 1.0)
    for i in 1 .. 9:
      let x = float(i) * 0.1
      let p = d.cdf(x)
      let x2 = d.ppf(p)
      check approx(x2, x, 1e-9)

  test "ppf↔cdf round-trip (p-grid)":
    let d = initNormalDistribution(0.0, 1.0)
    for i in 1 .. 100:
      let p = float(i) / 101.0
      let x = d.ppf(p)
      let p2 = d.cdf(x)
      check approx(p2, p, 1e-7)

  test "discrete cdf↔ppf round-trip":
    let bc = initBinomialDistribution(10, 0.3)
    for k in 0 .. 10:
      let p = bc.cdf(k)
      let k2 = bc.ppf(p)
      check k2 == k

    let nb = initNegativeBinomialDistribution(5, 0.4)
    for k in 0 .. 20:
      let p = nb.cdf(k)
      if p < 1.0:
        let k2 = nb.ppf(p)
        check k2 == k

    let po = initPoissonDistribution(5.0)
    for k in 0 .. 15:
      let p = po.cdf(k)
      if p < 1.0:
        let k2 = po.ppf(p)
        check k2 == k

    let ud = initUniformDiscreteDistribution[float64](1, 5)
    for k in 1 .. 5:
      let p = ud.cdf(k)
      let k2 = ud.ppf(p)
      check k2 == k
