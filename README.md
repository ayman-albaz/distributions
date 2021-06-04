# Distributions




## TODO
List is organized from most important to least important:
- Add a more accurate version of `regularized_incomplete_beta`.
	- Current approach gets upto 8 decimal places of precision (compared with SciPy), ideally it should be at least 15.
- Add a non-recursive version of `binomial_coefficient` that is not prone to integer overflow.
- Add more functions for each distribution (e.g. CF, skewness, etc...)
- Add more univariate distributions
- Bonus: Add multivariate distributions