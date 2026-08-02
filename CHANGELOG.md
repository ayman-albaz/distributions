# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] — 2026-08-02
### Added
- NaN parameter rejection: every constructor now rejects `NaN` parameters
  (`MustNotBeNaN`); `Inf` remains accepted (`sigma = Inf` is a valid
  limiting parameter).
- New `tests/test_api_surface.nim` pins the documented surface: every field
  of all 12 distributions plus the `ppf(q = ...)` named-argument form.

### Changed
- **Breaking**: `TDistribution.df` changed from `int` to `T` (the float type
  parameter), enabling non-integer (fractional) degrees of freedom for
  Welch's t-test and other applications. `initTDistribution(3.5)` now infers
  `float64`; callers passing an `int` argument must pass `3.0`.
- **Breaking**: all constructors return `Result[Dist[T], DistError]` instead
  of raising `ValueError`; validators return `Result[void, DistError]`.
  Callers use `.get()` or `?` propagation.
- **Breaking**: fallible moments return `Result[T, DistError]` instead of
  raising: Bernoulli `mode`, Beta `mode`, F `mean`/`mode`/`variance`,
  t `mean`/`variance`.
- **Breaking**: `DistError` is now a single string-valued `{.pure.}` enum;
  each variant carries its static message as the enum value, so `$`/`echo`/
  `repr` yield the message directly. `DistErrorKind`, the `DistError`
  object, its dynamic `msg` field, the custom `$` override, and the
  `toDistError` converter are removed. `Result[..., DistError]` signatures
  are unchanged.
- **Breaking**: `DistError` variants are unprefixed (`MustBePositive`,
  `MustBeNonNegative`, `MustBeFraction`, `MustNotBeNaN`, `AMustBeLessThanB`,
  `AMustBeAtMostB`, `MeanUndefined`, `ModeUndefined`, `VarianceUndefined`,
  `NotConverged`). The old `de` prefix is dropped: the `{.pure.}` enum
  provides the namespace itself, so `DistError.MustBePositive` (or the
  unqualified `MustBePositive`) needs no extra disambiguation.
- **Breaking**: validators (`validatePositive`/`validateNonNegative`/
  `validateFraction`) dropped the `name: static string` parameter; errors
  are the per-constraint variants (`MustBePositive`,
  `MustBeNonNegative`, `MustBeFraction`, `MustNotBeNaN`). Inline
  constructor errors use `AMustBeLessThanB`/`AMustBeAtMostB`;
  undefined-moment errors use `MeanUndefined`/`ModeUndefined`/
  `VarianceUndefined`; the discrete-ppf safety net is `NotConverged`.
- **Breaking**: discrete `ppf` (Binomial, NegativeBinomial, Poisson,
  UniformDiscrete) and the NegativeBinomial/Poisson `median` return
  `Result[int, DistError]` / `Result[T, DistError]`; the non-convergence
  safety net no longer raises `ValueError`.
- **Breaking**: the `ppf` quantile argument is renamed `p` → `q` (scipy
  convention) in all 12 distributions, resolving the ambiguity with the `p`
  success-probability field of Bernoulli/Binomial/NegativeBinomial. Only
  affects callers using named arguments (`d.ppf(p = 0.5)` →
  `d.ppf(q = 0.5)`); positional calls are unchanged.
- All 12 `sample` procs and the `mathutils` sampling primitives inherit
  `{.raises: [].}` (dropped the spurious `{.raises: [CatchableError].}`).
- Binomial/NegativeBinomial `cdf` pass `T(...)` arguments (not `float(...)`)
  to the incomplete-beta call, keeping float32 arithmetic in `T`; `lfac`
  calls in discrete `pmf` are narrowed with `T(...)`.
- `samplePoisson`/`sampleBinomial` share the extracted `rejectionSampleTrunc`
  rejection core.
- `discretePpf` rewritten from linear scan to exponential doubling + binary
  search: O(log span) cdf evaluations (Poisson(1e7).ppf(0.5) was previously
  impossible; Poisson(1e6) was seconds).
- Removed dead `standardNormal` MathUtils primitive (unused; `t.nim` inlines
  `gauss`).
- The discrete `ppf` NaN convention is now uniform across all five discrete
  distributions: Binomial, NegativeBinomial, and Poisson `ppf(NaN)` return
  `ok(0)`, and UniformDiscrete `ppf(NaN)` returns `ok(a)` — the low clamp,
  matching Bernoulli (the discrete `ppf` returns `int`, so `NaN` has no
  representation). Previously the four search-based `ppf`s reported
  `err(DistError.NotConverged)`.
- Documentation pass: every distribution type and every public field now
  carries a doc comment (`d.p`, `d.n`, `d.df`, ...); `pmf`/`pdf`/`cdf`/
  `sf`/`ppf` docstrings state their formulas, clamping behavior, and
  parameter definitions (`k`/`x` point parameters, `q` quantile, `r` RNG
  source); `sample` docstrings document the `r: var Rand` RNG parameter;
  `mathutils.nim` gained a module docstring listing its exported
  primitives; NegativeBinomial `p = 0` degenerate moments, the top-level
  re-export surface, and the sampler envelope-scan cost are documented.

### Fixed
- **NegativeBinomial CDF for p ≠ 0.5**: computed the survival function
  (`1 - I_p(k+1, r)` = `I_{1-p}(r, k+1)`) instead of the CDF; now the direct
  form `I_p(r, k+1)`. Cascading fixes to `sf` and `ppf`/`median` for p ≠ 0.5.
- **Beta median for α ≠ β**: returned the CDF at 0.5; now the true 0.5-quantile
  via `inverse_regularized_lower_incomplete_beta`.
- Binomial `mode` clamped to `n` at p = 1 (was returning `n+1`).
- Gamma `pdf(0)` returns `Inf` for k < 1 (pdf diverges; was 0).
- F `pdf(0)` boundary values: `Inf` for df1 = 1, `1.0` for df1 = 2 (was 0).
- Chi2/Gamma `ppf` underflow guards dropped: ppf(p) → 0 as p → 0⁺ (was `Inf`).
- `tests/test_sample.nim`: the F(5,5) variance constant used in the 5σ band
  was wrong (`3.0` instead of `df1+df2−2 = 8`); the band was wrongly tight.
  Test-only fix; no sampler bug implied.

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
- `standardGamma`, `samplePoisson`, `sampleBinomial` shared MathUtils primitives.
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
