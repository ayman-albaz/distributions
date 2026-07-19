![Linux Build Status (Github Actions)](https://github.com/ayman-albaz/distributions/actions/workflows/install_and_test.yml/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Distributions
Distributions is a Nim library for probability distributions and their functions. Generic over `float32` and `float64`.

## Supported Distributions
| Distribution       | Nim Command                                        |
|--------------------|----------------------------------------------------|
| Bernoulli          | `initBernoulliDistribution(p = 0.5)`               |
| Beta               | `initBetaDistribution(alpha = 2.0, beta = 2.0)`    |
| Binomial           | `initBinomialDistribution(n = 10, p = 0.5)`        |
| Chisquare          | `initChi2Distribution[float64](df = 1)`            |
| F                  | `initFDistribution[float64](df1 = 3, df2 = 5)`     |
| Gamma              | `initGammaDistribution(k = 2.0, theta = 1.0)`      |
| Negative Binomial  | `initNegativeBinomialDistribution(r = 10, p = 0.5)`|
| Normal             | `initNormalDistribution(mu = 0.0, sigma = 1.0)`    |
| Poisson            | `initPoissonDistribution(lambda = 10.0)`           |
| t                  | `initTDistribution[float64](df = 3)`               |
| Uniform Continuous | `initUniformContinuousDistribution(a = 0.0, b = 1.0)`|
| Uniform Discrete   | `initUniformDiscreteDistribution[float64](a = 0, b = 1)`|

Type parameter defaults to `float64` and is inferred from float arguments. Distributions with only `int` parameters (Chi2, F, t, UniformDiscrete) require an explicit type, e.g. `initChi2Distribution[float64](1)`. For `float32`, pass `float32` literals: `initNormalDistribution(0.0'f32, 1.0'f32)`.

## Supported Functions
```nim
let d = initNormalDistribution(0.0, 1.0)
discard d.mean()     # Mean
discard d.median()   # Median
discard d.mode()     # Mode
discard d.pdf(x)     # Probability density function
discard d.pmf(k)     # Probability mass function (discrete distributions)
discard d.cdf(x)     # Cumulative distribution function
discard d.sf(x)      # Survival function (1 - cdf)
discard d.ppf(p)     # Percent point function (quantile, inverse CDF)

# Sampling (all distributions)
import std/random
var r = initRand(0xDEADBEEF)
discard initNormalDistribution(0.0, 1.0).sample(r)   # continuous → float64
discard initPoissonDistribution(5.0).sample(r)         # discrete → int
```

## Accuracy
~1e-13 relative where convergent (float64); ~1e-5 (float32).

## Requirements
- Nim >= 2.0.0
- [special_functions](https://github.com/ayman-albaz/special-functions) >= 1.0.0

## Install
```
nimble install distributions
```

## TODO
- Add more distributions on an as-needed basis.
- Add fit, CF, skewness functions.

Performance, feature, and documentation PR's are always welcome.

## Contact
I can be reached at aymanalbaz98@gmail.com
