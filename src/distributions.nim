{.experimental: "strictFuncs".}
{.push raises: [].}

import distributions/[base, bernoulli, beta, binomial, chi2, f, gamma,
                       mathutils, negativebinomial, normal, poisson, t,
                       uniformcontinuous, uniformdiscrete]

export Distribution, DistributionContinuous, DistributionDiscrete
export BernoulliDistribution, initBernoulliDistribution
export BetaDistribution, initBetaDistribution
export BinomialDistribution, initBinomialDistribution
export Chi2Distribution, initChi2Distribution
export FDistribution, initFDistribution
export GammaDistribution, initGammaDistribution
export NegativeBinomialDistribution, initNegativeBinomialDistribution
export NormalDistribution, initNormalDistribution, sample
export PoissonDistribution, initPoissonDistribution
export TDistribution, initTDistribution
export UniformContinuousDistribution, initUniformContinuousDistribution
export UniformDiscreteDistribution, initUniformDiscreteDistribution
export mean, median, mode, variance
export pdf, pmf, cdf, sf, ppf
export pow2, pow3, lfac

{.pop.}
