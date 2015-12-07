# lab7_done.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Downloads sea level anomaly data covering the last ~200 yr, plots these
# data with a second-order polynomial, and plots the residuals between the
# data and the polynomial.  Also performs a simple bootstrap analysis with
# the residuals.  

# Copyright 2015 by the Authors

# This file is part of Risk Analysis in the Earth Sciences: A Lab Manual with 
# Exercises in R.

# This e-textbook is free software: you can redistribute it and/or modify it 
# under the terms of the GNU General Public License as published by the Free 
# Software Foundation, either version 3 of the License, or (at your option) 
# any later version.

# This e-textbook is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for 
# more details.

# You should have received a copy of the GNU General Public License along with 
# this e-textbook.  If not, see <http://www.gnu.org/licenses/>.

# Clear away any existing variables or figures.  
rm(list = ls())
graphics.off()

# Function for estimating sea level trends based on vectors of parameters
# and time values.  
poly.sl <- function(params, time) {
  
  # Pick apart the vector params into its individual values.  
  a <- params[1]
  b <- params[2]
  c <- params[3]
  t.0 <- params[4]
  
  # Calculate sea level values.  
  sl <- a* (time- t.0)^ 2+ b* (time- t.0)+ c
  
  # Return the sea level values.  
  return(sl)
  
} # end function poly.sl

# Function for calculating the root mean squared error given a set of
# parameters, a vector of time values, and a vector of sea level values.  
sl.rmse <- function(params, time, sea.levels) { 
  
  # Step 1: Pick apart the vector params into its individual values.  
  a <- params[1]
  b <- params[2]
  c <- params[3]
  t.0 <- params[4]
  
  # Step 2: Calculate the estimated sea level anomalies based on a, b, c, t.0,
  # and time.  
  est.sl <- poly.sl(c(a, b, c, t.0), time)
  
  # Step 3: Calculate the rmse based on the estimated sea level anomalies
  # calculated in Step 2 and the observed values passed into the function
  # in sea.levels.  
  rmse <- sqrt(mean((sea.levels- est.sl)^ 2))
  
  # Step 4: Return the rmse value calculated in Step 3.  
  return(rmse)
  
} # end function sl.rmse

# Set some values.  
n.boot <- 10^3    # number of bootstrap replicates to perform
start.yr <- 1700  # starting year for the time vector
end.yr <- 2100    # ending year for the time vector

# Create a directory called data and download a file into it.  
dir.create('data')
download.file('http://www.psmsl.org/products/reconstructions/gslGRL2008.txt', 
              'data/gslGRL2008.txt', method = 'curl')

# Read in the information from the downloaded file.  
sl.data <- read.table('data/gslGRL2008.txt', skip = 14, header = FALSE)

# Extract two key vectors from sl.data.  
# t, time in years
# obs.sl, global mean sea level in mm
t <- sl.data[, 1]
obs.sl <- sl.data[, 2]

# Optimize the sl.rmse function.  
start <- c(0, 0, -150, 1700)
best.fit <- optim(start, sl.rmse, gr = NULL, time = t, sea.levels = obs.sl)

# Extract the parameters of the best-fit polynomial, and the root mean squared
# error, from best.fit.  
best.a <- best.fit$par[1]
best.b <- best.fit$par[2]
best.c <- best.fit$par[3]
best.t.0 <- best.fit$par[4]
best.rmse <- best.fit$value

# Given the values of a, b, c, and t.0 specified above, estimate the sea level
# anomalies in each year using a second-order polynomial.  
best.sl <- poly.sl(c(best.a, best.b, best.c, best.t.0), t)

# Calculate the residuals between the observed and estimated sea level anomaly 
# values.
resids <- obs.sl- best.sl

# Make some vectors for storing values of a, b, c, and t.0.  
boot.a <- rep(NA, n.boot)
boot.b <- rep(NA, n.boot)
boot.c <- rep(NA, n.boot)
boot.t.0 <- rep(NA, n.boot)

# Make a vector of time values for projections.  
proj.t <- seq(start.yr, end.yr, by = 1)

# Make a matrix for storing the sea level estimates from the bootstrap
# realizations of past sea level.  
proj.sl <- matrix(NA, nrow = length(proj.t), ncol = n.boot)

# plot(t, obs.sl, type = 'l')

# Perform the bootstrap.  
for (i in 1: n.boot) {
  
  # Generate a bootstrap replicate of the residuals.  
  boot.resids <- sample(resids, length(resids), replace = TRUE)
  
  # Add the resampled residuals to the best-fit second-order polynomial.  
  boot.sl <- boot.resids+ best.sl
  # lines(t, boot.sl, col = 'gray')
  
  # Fit a second-order polynomial to the residuals+ trend.  
  boot.start <- c(best.a, best.b, best.c, best.t.0)
  boot.fit <- optim(boot.start, sl.rmse, gr = NULL, time = t, 
                    sea.levels = boot.sl)
  
  # Extract the new parameter values from boot.fit.  
  boot.a[i] <- boot.fit$par[1]
  boot.b[i] <- boot.fit$par[2]
  boot.c[i] <- boot.fit$par[3]
  boot.t.0[i] <- boot.fit$par[4]
  
  # Estimate the trends in past and future sea levels based on boot.a, etc.
  proj.sl[, i] <- poly.sl(c(boot.a[i], boot.b[i], boot.c[i], boot.t.0[i]), 
                          proj.t)
  
} # end for (i in 1: n.boot)

matplot(proj.t, proj.sl, type = 'l', lty = 1, col = 'gray')
lines(t, obs.sl, col = 'black')
lines(proj.t, poly.sl(c(best.a, best.b, best.c, best.t.0), proj.t), col = 'red')

# # Make a plot.  
# par(mfrow = c(2, 1))
# plot(t, obs.sl, type = 'l', xlab = 'Time (yr)', ylab = 'Sea level anomaly (mm)', 
#      lwd = 1, col = 'red')
# lines(t, best.sl, lwd = 1, col = 'blue')
# legend(x = 'topleft', legend = c('Data', '2nd-Order Polynomial'), lwd = 1, 
#        col = c('red', 'blue'), bty = 'n')
# plot(t, resids, type = 'l', xlab = 'Time (yr)', ylab = 'Residuals (mm)', 
#      lwd = 1)