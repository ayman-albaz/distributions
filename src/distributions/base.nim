{.nanChecks: on, infChecks: on.}
type
  Distribution* = object of RootObj
  DistributionContinuous* = object of Distribution
  DistributionDiscrete* = object of Distribution
