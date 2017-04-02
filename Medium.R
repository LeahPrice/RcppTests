###################################################
# Kalman filter

# List of matrices
# F state transition model
# B the control input model (not always relevant, may be all zeros)
# Q process noise covariance (difficult to obtain in practice)
# H observation model
# R observation noise covariance (difficult to obtain in practice)
# z the observations
# u the control inputs (not always relevant, may be all zeros)
# xinit initial guess at state vector (quantities of interest)
# Pinit initial guess at covariance matrix for states

# State is what want to know e.g. position and velocity.
# We have noisy observations of a related quantity, e.g. noisy estimate of location from GPS
# Units and scale of reading might not be the same as the units and scale of the state (so use H)
# We may know about process, e.g. steering wheel movements

# A simple function to perform Kalman filtering
RKalman <- function(F,B,Q,H,R,z,u,xinit,Pinit){
  x <- xinit
  P <- Pinit
  d <- nrow(F)
  N <- nrow(z)
  dimH <- nrow(H)
  Y <- matrix(NA, N, dimH)
  for (i in 1:N) {
    # Predict
    x <- F%*%x + B%*%u[i,]
    P <- F%*%P%*%t(F) + Q
    # Update
    Kal <- P %*% t(H) %*% solve(H %*% P %*% t(H) + R) #Kalman gain
    x <- x + Kal %*% (z[i,]-H %*% x)
    P <- (diag(d) - Kal %*% H) %*% P
    Y[i,] <- t(H %*% x)
  }
  return(Y)
}

# An example, the same as used in the Kalman filtering example in the RcppArmadillo package
# See http://dirk.eddelbuettel.com/papers/RcppArmadillo-intro.pdf
z <- as.matrix(read.table("pos.txt", header=FALSE, col.names=c("x","y")))
dt <- 1
F <- matrix( c( 1, 0, dt, 0, 0, 0,  # x
                0, 1, 0, dt, 0, 0,   # y
                0, 0, 1, 0, dt, 0,   # Vx
                0, 0, 0, 1, 0, dt,   # Vy
                0, 0, 0, 0, 1,  0,   # Ax
                0, 0, 0, 0, 0,  1),  # Ay
             6, 6, byrow=TRUE)
B <- matrix(0, 6, 6) # Not relevant here
N <- nrow(z)
Q <- diag(6)
H <- matrix( c(1, 0, 0, 0, 0, 0,
               0, 1, 0, 0, 0, 0),
             2, 6, byrow=TRUE)
R <- 1000 * diag(2)
u <- matrix(0, N, 6) # Not relevant here
xinit <- matrix(0, 6, 1)
Pinit <- matrix(0, 6, 6)

Y <- RKalman(F,B,Q,H,R,z,u,xinit,Pinit)


# Plot of the original and estimated trajectories
plot(z[,1],z[,2],pch=1,col=1,xlab="x",ylab="y")
points(Y[,1],Y[,2],pch=2,col=2)
legend("topleft",legend=c('Original','Estimated'),col=1:2,pch=1:2)
