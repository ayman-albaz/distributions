![Linux Build Status (Github Actions)](https://github.com/ayman-albaz/distributions/actions/workflows/install_and_test.yml/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Distributions
Distributions is a Nim library for distributions and their functions.


## Supported Distributions
| Distribution       | Nim Command                                                               |
|--------------------|---------------------------------------------------------------------------|
| Bernoulli          | `initBernoulliDistribution(p: FractionPositiveFloat)`                     |
| Beta               | `initBetaDistribution(alpha, beta: PositiveFloat)`                        |
| Binomial           | `initBinomialDistribution(n: Positive, p: FractionPositiveFloat)`         |
| Chisquare          | `initChi2Distribution(df: int)`                                           |
| F                  | `initFDistribution(df_1, df_2: Positive)`                                 |
| Gamma              | `initGammaDistribution(k, theta: PositiveFloat)`                          |
| Negative Binomial  | `initNegativeBinomialDistribution(r: Positive, p: FractionPositiveFloat)` |
| Normal             | `initNormalDistribution(mu: float = 0.0, sigma: PositiveFloat = 1.0)`     |
| Poisson            | `initPoissonDistribution(lambda: PositiveFloat)`                          |
| t                  | `initTDistribution(df: Natural)`                                          |
| Uniform Continuous | `initUniformContinuousDistribution(a, b: float)`                          |
| Uniform Discrete   | `initUniformDiscreteDistribution(a, b: int)`                              |
|                    |                                                                           |

## Supported Functions
Please note these functions are available for all distributions, except for the t and gamma distributions which lack the point prevalence (ppf) function. Also note: all these functions return a float.
```Nim
let normal_dist = initNormalDistribution(0.0, 1.0)
discard normal_dist.mean()		# Mean
discard normal_dist.median()		# Median
discard normal_dist.mode()		# Mode
discard normal_dist.pdf()		# Probability density function (use .pmf() for discrete distributions)
discard normal_dist.cdf()		# Cumulative density function
discard normal_dist.sf()		# Survival function (1 - cdf)
discard normal_dist.ppf()		# Point prevalence function
```


## Future Directions:
There are really two directions this library can grow.
1. Write more distributions in Nim.
	- Pros: Library is in Nim.
	- Cons: Longer dev time, calculations are more error prone.
2. Implement all functions using a C-wrapper around the Rmath library.
	- Pros: Reduced dev time, calculations are less error prone.
	- Cons: Library is written in C and hard to read (its filled with macros).

I don't have a preferred direction and I prefer to leave the answer for the Nim scientific community to answer.


## Accuracy
All functions in this library are accurate up-to 14 decimal places (float64).


## Performance
This library was written with accuracy as a top priority as opposed to performance, however almost all implementations here are faster than SciPy's implementations and equal to, slower, or faster than Julia's distributions implementations. 


## TODO
List is organized from most important to least important:
- Add ppf for T-distribution and Gamma-distributions
- Add more functions for each distribution (in this order: random, fit, CF, skewness, etc...)
- Add more univariate distributions on an as-need-bases
- Bonus: Add multivariate distributions on an as-need-bases


Performance, feature, and documentation PR's are always welcome.


## Contact
I can be reached at aymanalbaz98@gmail.com
