#install.packages("RcppSMC")
library(RcppSMC)

# Block sampling particle filter for a linear Gaussian model.
# Uses optimal block sampler from Doucet, Briers and Senecal (2006)
sim <- simGaussian(len=250)
res <- blockpfGaussianOpt(sim$data,lag=5,plot=TRUE)


# Particle Filter example based on vehicle tracking application from
# Section 5.1 of Johansen (2009)
res <- pfLineartBS(plot=TRUE)
if (interactive()) ## if not running R CMD check etc
  res <- pfLineartBS(onlinePlot=pfLineartBSOnlinePlot)

# Nonlinear bootstrap particle filter example
sim <- simNonlin(len=50)
res <- pfNonlinBS(sim$data,particles=500,plot=TRUE)
