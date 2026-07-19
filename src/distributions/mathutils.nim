{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random

func pow2*[T: SomeFloat](x: T): T {.inline.} =
  ## Returns `x * x`.
  x * x

func pow3*[T: SomeFloat](x: T): T {.inline.} =
  ## Returns `x * x * x`.
  x * x * x

func lfac*[T: SomeInteger](k: T): float64 {.inline.} =
  ## Natural logarithm of the factorial of `k`.
  ## Uses `lgamma` for O(1) computation, avoiding overflow for large `k`.
  ##
  ## Return type is deliberately ``float64`` (not generic ``SomeFloat``) because
  ## factorial logarithms span orders of magnitude that overflow ``float32``.
  ## Callers needing ``float32`` should narrow with ``float32(...)``.
  lgamma(float64(k) + 1.0)

proc discretePpf*[T: SomeFloat](
    cdfFn: proc(k: int): T {.closure, raises: [].},
    p: T,
    start = 0,
): int {.raises: [ValueError].} =
  ## The smallest `k >= start` such that `cdfFn(k) >= p`.
  ## Assumes `cdfFn → 1` as `k → ∞`. Iterates up to `MAX_ITER`
  ## and raises `ValueError` if convergence fails.
  const MAX_ITER = 10_000_000
  var k = start
  while k < start + MAX_ITER:
    if cdfFn(k) >= p:
      return k
    k += 1
  raise newException(ValueError, "discretePpf did not converge")

proc standardNormal*[T: SomeFloat](r: var Rand): T {.raises: [CatchableError], inline.} =
  ## Standard Normal N(0,1) sample via std/random's Box-Muller (`gauss`).
  ## <https://en.wikipedia.org/wiki/Normal_distribution#Generating_values_from_normal_distribution>
  T(gauss(r, 0.0, 1.0))

proc standardGamma*[T: SomeFloat](r: var Rand, k: T): T {.raises: [CatchableError].} =
  ## Sample Gamma(shape=k, scale=1) via Marsaglia-Tsang (2000).
  ## For k < 1, uses the boost: sample Gamma(k+1, 1) and multiply by U^(1/k).
  ## <https://en.wikipedia.org/wiki/Gamma_distribution#Generating_gamma-distributed_random_variables>
  proc gammaMt(rMt: var Rand, kLocal: T): T {.raises: [CatchableError].} =
    let d = kLocal - T(1.0) / T(3.0)
    let c = T(1.0) / sqrt(T(9.0) * d)
    while true:
      let x = T(gauss(rMt, 0.0, 1.0))
      let v = pow3(T(1.0) + c * x)
      if v <= T(0.0):
        continue
      let u = T(rMt.rand(1.0))
      if u <= T(0.0):
        continue
      if ln(u) < T(0.5) * pow2(x) + d - d * v + d * ln(v):
        return d * v
    # unreachable
  if k >= T(1.0):
    result = gammaMt(r, k)
  else:
    let g = gammaMt(r, k + T(1.0))
    let u = T(r.rand(1.0))
    if u <= T(0.0):
      result = T(0.0)
    else:
      result = g * exp(ln(u) / k)

proc samplePoisson*[T: SomeFloat](r: var Rand, lambda: T): int {.raises: [CatchableError].} =
  ## Sample Poisson(lambda). Knuth's multiplicative method for lambda < 30;
  ## rejection from N(lambda, sqrt(lambda)) with Stirling-corrected
  ## acceptance otherwise.
  ## <https://en.wikipedia.org/wiki/Poisson_distribution#Generating_Poisson-distributed_random_variables>
  const KnuthThreshold = 30.0
  const MaxIter = 1000
  if float64(lambda) < KnuthThreshold:
    let targetL = exp(-float64(lambda))
    var p = 1.0
    var k = 0
    while p > targetL:
      p *= r.rand(1.0)
      k += 1
    return k - 1
  else:
    let mu = float64(lambda)
    let sigmaSq = mu
    let sigma = sqrt(sigmaSq)
    let halfLog2PiSigmaSq = 0.5 * ln(2.0 * PI * sigmaSq)
    for iter in 0 ..< MaxIter:
      let x = gauss(r, 0.0, 1.0)
      let kc = int(round(mu + sigma * x))
      if kc < 0:
        continue
      let logPmf = float64(kc) * ln(mu) - mu - lfac(kc)
      let logNorm = -halfLog2PiSigmaSq - pow2(float64(kc) - mu) / (2.0 * sigmaSq)
      let logRho = logPmf - logNorm
      let u = r.rand(1.0)
      if u <= 0.0 or ln(u) < logRho:
        return kc
    return int(round(mu))

proc sampleBinomial*[T: SomeFloat](r: var Rand, n: int, p: T): int {.raises: [CatchableError].} =
  ## Sample Binomial(n, p). Sum-of-Bernoullis for n ≤ 25 or n·p·(1-p) ≤ 10;
  ## rejection from Normal(np, sqrt(np(1-p))) with Stirling-corrected
  ## acceptance otherwise.
  ## <https://en.wikipedia.org/wiki/Binomial_distribution#Generating_random_numbers>
  const SmallN = 25
  const VarThreshold = 10.0
  const MaxIter = 1000
  if n <= 0:
    return 0
  let pF = float64(p)
  if pF <= 0.0:
    return 0
  if pF >= 1.0:
    return n
  let mu = float64(n) * pF
  let sigmaSq = mu * (1.0 - pF)
  if n <= SmallN or sigmaSq <= VarThreshold:
    var s = 0
    for i in 0 ..< n:
      if r.rand(1.0) < pF:
        s += 1
    return s
  else:
    let sigma = sqrt(sigmaSq)
    let halfLog2PiSigmaSq = 0.5 * ln(2.0 * PI * sigmaSq)
    let lfacN = lfac(n)
    let lnP = ln(pF)
    let lnOneMinusP = ln(1.0 - pF)
    for iter in 0 ..< MaxIter:
      let x = gauss(r, 0.0, 1.0)
      let k = int(round(mu + sigma * x))
      if k < 0 or k > n:
        continue
      let logPmf = lfacN - lfac(k) - lfac(n - k) +
                  float64(k) * lnP + float64(n - k) * lnOneMinusP
      let logNorm = -halfLog2PiSigmaSq - pow2(float64(k) - mu) / (2.0 * sigmaSq)
      let logRho = logPmf - logNorm
      let u = r.rand(1.0)
      if u <= 0.0 or ln(u) < logRho:
        return k
    return int(round(mu))

{.pop.}
