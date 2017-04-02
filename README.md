# RcppTests
Doing the essential tests involving Kalman filter implementations

## Easy Test
Open and run Easy.R

## Medium Test
Open and run Medium.R. The data pos.txt is used in Medium.R

## Hard Test
Install package myKalman_1.0.tar.gz.
Example to test the package:

```
# An example, the same as used in the Kalman filtering example in the RcppArmadillo package
# See http://dirk.eddelbuettel.com/papers/RcppArmadillo-intro.pdf
  
  library(myKalman)
  data(pos)
  z <- pos
  dt <- 1
  F <- matrix( c( 1, 0, dt, 0, 0, 0,  # x
                0, 1, 0, dt, 0, 0,   # y
                0, 0, 1, 0, dt, 0,   # Vx
                0, 0, 0, 1, 0, dt,   # Vy
                0, 0, 0, 0, 1,  0,   # Ax
                0, 0, 0, 0, 0,  1),  # Ay
                6, 6, byrow=TRUE)
  B <- matrix(0, 6, 6) # not relevant for this example
  N <- nrow(pos)
  Q <- diag(6)
  H <- matrix( c(1, 0, 0, 0, 0, 0,
               0, 1, 0, 0, 0, 0),
               2, 6, byrow=TRUE)
  R <- 1000 * diag(2)
  u <- matrix(0, N, 6) #not relevant for this example
  xinit <- matrix(0, 6, 1)
  Pinit <- matrix(0, 6, 6)

  results <- Kalman(F,B,Q,H,R,z,u,xinit,Pinit)

  # Plot of the original and estimated trajectories
  plot(z[,1],z[,2],pch=1,col=1,xlab="x",ylab="y")
  points(results$Y[,1],results$Y[,2],pch=2,col=2)
  legend("topleft",legend=c('Original','Estimated'),col=1:2,pch=1:2)
  ```
