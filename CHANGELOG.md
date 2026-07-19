# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] — breaking rewrite
### Added
- Generic over `SomeFloat` (`float32` / `float64`) on every type and function.
- `median` added for F-distribution and Gamma-distribution (via ppf).
- `sample(d, r: var Rand)` on NormalDistribution (replaces `rand`).
- `pow2`, `pow3`, `lfac` math utilities.
- `discretePpf` generic helper for discrete quantiles.
- float32 test suite.
- Edge-case test suite.
- Round-trip cdf/ppf property tests.
- CI matrix expanded to `ubuntu/macos/windows × Nim 2.0.0/2.2.0`.

### Changed
- Removed range types `PositiveFloat`, `FractionPositiveFloat`, `FractionFloat`, `BinaryInteger`; validation via constructors.
- `NegativeBinomialDistribution` now inherits `DistributionDiscrete` (was Continuous).
- Discrete `ppf` returns `int` with `start = 0` (fixes off-by-one).
- Discrete `pmf` rewritten in log-space (no overflow for large arguments).
- Beta `mode` raises `ValueError` for divergent/uniform cases.
- Bernoulli `mode` raises `ValueError` for `p == 0.5`.
- Bernoulli `median` returns `0.5` for `p == 0.5` (scipy convention).
- Chi2 `median` now uses `ppf(0.5)` instead of Wilson–Hilferty approximation.
- F `mean`/`variance`/`mode` raise `ValueError` when undefined.
- Normal `sample(d, r: var Rand)` replaces `rand`; explicit RNG argument, no global-state sampling.
- Poisson `median` is now `ppf(0.5)`.
- `t.nim` cdf/pdf/sf/ppf parameter renamed `t` → `x`.
- Library depends on `special_functions >= 1.0.0` and `nim >= 2.0.0`.
- Every module uses `{.experimental: "strictFuncs".}` + `{.push raises: [].}`.
- Explicit-symbol `export` from the top-level module.

### Fixed
- Gamma `ppf` multiplied by `theta` instead of adding (was a bug).
- NegativeBinomial `pdf` → `pmf` docstring fix.
- F `ppf` docstring fix.
- `test_binomal.nim` → `test_binomial.nim` (typo).

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
