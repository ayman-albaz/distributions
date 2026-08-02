{.experimental: "strictFuncs".}
{.push raises: [].}

import std/math
import std/random
import results
import distributions/errors

## Shared math and sampling primitives for the distribution modules.
##
## Exported primitives and their roles:
## - `pow2` / `pow3` — fast integer-power squares/cubes used throughout
##   the log-space formulas.
## - `lfac` — natural log of the factorial (float64 by design; avoids
##   overflow for large arguments) used by the discrete log-pmf
##   expressions.
## - `discretePpf` — generic discrete quantile (doubling + binary search,
##   `Result`-valued) backing the discrete `ppf`/`median` functions.
## - `standardGamma` — Marsaglia-Tsang (2000) standard Gamma sampler with
##   the k < 1 boost, the shared building block for the continuous
##   `sample` procs (Chi2, F, Gamma, T, Beta, NegativeBinomial).
## - `samplePoisson` / `sampleBinomial` — Poisson / Binomial samplers
##   (Knuth or sum-of-Bernoullis for small parameters, exact
##   truncated-normal rejection otherwise) sharing the internal
##   `rejectionSampleTrunc` core.
##
## All of the above are exported from `distributions/mathutils` for
## direct/advanced use. Only `pow2`/`pow3`/`lfac` are re-exported at the
## top level (`distributions`); the sampling primitives are deliberately
## **not** re-exported (minimal-surface convention — the top-level module
## exposes the distribution API only).

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
    cdfFn: proc(k: int): T {.closure, raises: [].}, p: T, start = 0
): Result[int, DistError] =
  ## Returns the smallest `k >= start` such that `cdfFn(k) >= p`.
  ## `cdfFn` is the monotone nondecreasing CDF to invert; `p` is the
  ## quantile probability; `start` is the lowest `k` to consider (default 0).
  ## Assumes `cdfFn` is monotone nondecreasing with `cdfFn → 1` as `k → ∞`.
  ## Exponential (doubling) search for an upper bound `hi`, then binary
  ## search in `[start, hi]`: O(log span) cdf evaluations. The doubling
  ## continues through any `NaN` cdf values (treated as "not yet `>= p`"),
  ## so a bounded `NaN` band cannot break the `cdfFn(hi) >= p` invariant.
  ## Returns `err(DistError.deNotConverged)` if the doubling search hits the
  ## `int` range without convergence (unreachable for valid monotone cdfs).
  if cdfFn(start) >= p:
    return ok(start)
  var hi = start
  var step = 1
  while not (cdfFn(hi) >= p):
    if hi > high(int) - step:
      if cdfFn(high(int)) >= p:
        hi = high(int)
      else:
        return err(DistError.deNotConverged)
      break
    hi += step
    step =
      if step > high(int) div 2:
        high(int)
      else:
        step * 2
  var lo = start
  while hi - lo > 1:
    let mid = lo + (hi - lo) div 2
    if cdfFn(mid) >= p:
      hi = mid
    else:
      lo = mid
  ok(hi)

proc standardGamma*[T: SomeFloat](r: var Rand, k: T): T =
  ## Sample Gamma(shape=k, scale=1) via Marsaglia-Tsang (2000).
  ## `r` is the RNG source (`std/random`); deterministic sequences via
  ## `initRand(seed)`; `k` is the shape parameter (``k > 0``).
  ## For k < 1, uses the boost: sample Gamma(k+1, 1) and multiply by U^(1/k).
  ## <https://en.wikipedia.org/wiki/Gamma_distribution>
  proc gammaMt(rMt: var Rand, kLocal: T): T =
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

const TruncC = 5.5
const InvSqrt2 = 1.0 / sqrt(2.0)

func logTruncCell(mu, sigma: float64, k: int): float64 =
  ## Natural log of the mass the truncated-normal proposal assigns to
  ## integer `k`: the N(mu, sigma²) cell ``[k-0.5, k+0.5]`` clipped to the
  ## z-band ``[-TruncC, TruncC]``. Returns `-Inf` for cells entirely
  ## outside the band (never produced by the proposal).
  let u1c = max((float64(k) - 0.5 - mu) / sigma, -TruncC)
  let u2c = min((float64(k) + 0.5 - mu) / sigma, TruncC)
  if u2c <= u1c:
    -Inf
  else:
    ln(0.5 * (erf(u2c * InvSqrt2) - erf(u1c * InvSqrt2)))

proc rejectionSampleTrunc(
    r: var Rand,
    mu, sigma: float64,
    kLo, kHi: int,
    logPmf: proc(k: int): float64 {.closure, raises: [].},
): int {.raises: [].} =
  ## Shared exact truncated-normal rejection core for `samplePoisson` and
  ## `sampleBinomial`. Scans the band `[kLo, kHi]` for the envelope
  ## `M = max pmf(k)/g(k)` (skipping cells with `logG == -Inf`), then draws
  ## `z ~ N(0,1)` conditioned on `|z| <= TruncC`, rounds
  ## `k = round(mu + sigma·z)`, rejects draws outside `[kLo, kHi]`, and
  ## accepts with `pmf(k) / (M·g(k))`. Returns `int(round(mu))` as the
  ## `MaxIter` fallback.
  ## The envelope scan is O(sigma) `lfac`/`lgamma` evaluations per draw —
  ## negligible below `mu` ≈ 1e4, material above. The API is stateless, so
  ## `M` cannot be cached across draws; a future stateful sampler could.
  const MaxIter = 1000
  var logM = -Inf
  for k in kLo .. kHi:
    let logG = logTruncCell(mu, sigma, k)
    if logG == -Inf:
      continue
    logM = max(logM, logPmf(k) - logG)
  for iter in 0 ..< MaxIter:
    var z = gauss(r, 0.0, 1.0)
    while abs(z) > TruncC:
      z = gauss(r, 0.0, 1.0)
    let kc = int(round(mu + sigma * z))
    if kc < kLo or kc > kHi:
      continue
    let u = r.rand(1.0)
    if u <= 0.0 or ln(u) < logPmf(kc) - logM - logTruncCell(mu, sigma, kc):
      return kc
  int(round(mu))

proc samplePoisson*[T: SomeFloat](r: var Rand, lambda: T): int =
  ## Sample Poisson(lambda). `r` is the RNG source (`std/random`);
  ## deterministic sequences via `initRand(seed)`; `lambda` is the rate
  ## parameter (``lambda > 0``).
  ## Knuth's multiplicative method for lambda < 30;
  ## exact truncated-normal rejection otherwise: draw z ~ N(0,1) conditioned
  ## on `|z| <= c` (c = 5.5), round `k = lambda + sqrt(lambda)·z`, and accept
  ## with `pmf(k) / (M·g(k))`, where `g(k)` is the mass the proposal assigns
  ## to `k` (the N(lambda, lambda) cell, clipped to the band) and
  ## `M = max pmf/g` over the band. Exact on the truncated support
  ## `[0, lambda + c·sqrt(lambda)]`; the omitted right tail has mass < 1e-8
  ## for all lambda >= 30.
  ## The per-draw envelope scan costs O(sqrt(lambda)) `lfac` evaluations —
  ## negligible below `lambda` ≈ 1e4, material above.
  ## <https://en.wikipedia.org/wiki/Poisson_distribution>
  const KnuthThreshold = 30.0
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
    let sigma = sqrt(mu)
    let kLo = max(0, int(floor(mu - TruncC * sigma)))
    let kHi = int(ceil(mu + TruncC * sigma))
    proc logPmf(k: int): float64 {.closure, raises: [].} =
      float64(k) * ln(mu) - mu - lfac(k)

    rejectionSampleTrunc(r, mu, sigma, kLo, kHi, logPmf)

proc sampleBinomial*[T: SomeFloat](r: var Rand, n: int, p: T): int =
  ## Sample Binomial(n, p). `r` is the RNG source (`std/random`);
  ## deterministic sequences via `initRand(seed)`; `n` is the number of
  ## trials (``n >= 0``); `p` is the success probability per trial
  ## (``p ∈ [0, 1]``).
  ## Sum-of-Bernoullis for n ≤ 25 or n·p·(1-p) ≤ 10;
  ## exact truncated-normal rejection otherwise: draw z ~ N(0,1) conditioned
  ## on `|z| <= c` (c = 5.5), round `k = np + sqrt(np(1-p))·z`, and accept
  ## with `pmf(k) / (M·g(k))`, where `g(k)` is the mass the proposal assigns
  ## to `k` (the N(np, np(1-p)) cell, clipped to the band) and
  ## `M = max pmf/g` over the band. Exact on the truncated support
  ## `[np - c·sqrt(np(1-p)), np + c·sqrt(np(1-p))]`; the omitted tails have
  ## mass < 1e-8.
  ## The per-draw envelope scan costs O(sigma) `lfac` evaluations —
  ## negligible below `n` ≈ 1e4, material above.
  ## <https://en.wikipedia.org/wiki/Binomial_distribution#Generating_random_numbers>
  const SmallN = 25
  const VarThreshold = 10.0
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
    let lfacN = lfac(n)
    let lnP = ln(pF)
    let lnOneMinusP = ln(1.0 - pF)
    let kLo = max(0, int(floor(mu - TruncC * sigma)))
    let kHi = min(n, int(ceil(mu + TruncC * sigma)))
    proc logPmf(k: int): float64 {.closure, raises: [].} =
      lfacN - lfac(k) - lfac(n - k) + float64(k) * lnP + float64(n - k) * lnOneMinusP

    rejectionSampleTrunc(r, mu, sigma, kLo, kHi, logPmf)

{.pop.}
