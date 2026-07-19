# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-07-19
### Added
- Generic over `SomeFloat` (`float32` / `float64`) on every type and function.
- `median` added for F-distribution and Gamma-distribution (via ppf).
- `sample(d, r: var Rand)` for all 12 distributions:
  - Bernoulli: direct threshold (`U < p`)
  - Beta: Gamma ratio for α,β ≥ 1; Jöhnk (1959) otherwise with MaxIter fallback
  - Binomial: sum-of-Bernoullis for small n; rejection-from-Normal otherwise
  - Chi2: Gamma(df/2, 2)
  - F: (χ²₁/df₁) / (χ²₂/df₂)
  - Gamma: Marsaglia-Tsang (2000) with k < 1 boost
  - NegativeBinomial: Gamma-Poisson mixture
  - Normal: Box-Muller via `gauss` (existing, API changed)
  - Poisson: Knuth multiplicative for λ < 30; rejection-from-Normal otherwise
  - t: Z / √(V/df)
  - UniformContinuous: inverse-CDF closed form
  - UniformDiscrete: `std/random` `rand(range)`
- `standardNormal`, `standardGamma`, `samplePoisson`, `sampleBinomial` shared MathUtils primitives.
- `pow2`, `pow3`, `lfac` math utilities.
- `discretePpf` generic helper for discrete quantiles.
- `test_float32.nim`, `test_edgecases.nim`, `test_prop.nim`, `test_mathutils.nim`, `test_sample.nim` test suites.
- `test_sample.nim` — 33 sampling tests with 5σ CLT mean checks.
- CI matrix expanded to `ubuntu/macos/windows × Nim 2.0.0/2.2.0`.

### Changed
- **Breaking**: removed range types `PositiveFloat`, `FractionPositiveFloat`, `FractionFloat`, `BinaryInteger`; validation via constructors.
- **Breaking**: `NegativeBinomialDistribution` now inherits `DistributionDiscrete` (was Continuous).
- **Breaking**: discrete `ppf` returns `int` with `start = 0` (fixes off-by-one, changes return type).
- **Breaking**: Normal `sample(d, r: var Rand)` replaces `rand`; explicit RNG argument, no global-state sampling.
- **Breaking**: every module uses `{.experimental: "strictFuncs".}` + `{.push raises: [].}`.
- **Breaking**: explicit-symbol `export` from the top-level module.
- Discrete `pmf` rewritten in log-space (no overflow for large arguments).
- Beta `mode` raises `ValueError` for divergent/uniform cases.
- Bernoulli `mode` raises `ValueError` for `p == 0.5`.
- Bernoulli `median` returns `0.5` for `p == 0.5` (scipy convention).
- Chi2 `median` now uses `ppf(0.5)` instead of Wilson–Hilferty approximation.
- F `mean`/`variance`/`mode` raise `ValueError` when undefined.
- Poisson `median` is now `ppf(0.5)`.
- `t.nim` cdf/pdf/sf/ppf parameter renamed `t` → `x`.
- Library depends on `special_functions >= 1.0.0` and `nim >= 2.0.0`.

### Fixed
- Gamma `ppf` multiplied by `theta` instead of adding (was a bug).
- NegativeBinomial `pdf` → `pmf` docstring fix.
- F `ppf` docstring fix.
- `test_binomal.nim` → `test_binomial.nim` (typo).
- NegativeBinomial PMF parameterization swapped (`p^r` vs. `(1-p)^r`); corrected with regression test.
- Chi2 `pdf(0, df=2)` now returns 0.5 (was 0).
- Gamma `pdf(0, k=1)` now returns 1/θ (was 0).
- Bernoulli dead `import std/math` removed.
- Validator `float(n)` casts eliminated (now accept `SomeNumber`).

## [0.2.0] - 2022-07-16
### Added
- Added t distribution ppf
- Added gamma distribution ppf
- Added base type for distribution objects
### Changed
- Reformated API to follow proper nim syntax
- Made testing more standardized

## [0.1.1] - 2021-06-15
### Changed
- Poisson lambda type now positive float instead of real number.

## [0.1.0] - 2021-06-08
### Added
- Created distributions library
