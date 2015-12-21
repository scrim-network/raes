# lab8_done.R
# Patrick Applegate, patrick.applegate@psu.edu; Greg Garner, ggg121@psu.edu
# 
# Optimizes the DICE model to produce a plausible climate-economic trajectory
# and performs a Monte Carlo experiment to evaluate the effects of uncertainty
# in the climate sensitivity on the present-day social cost of carbon.  

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

# Mise en place.  
rm(list = ls())
graphics.off()

# Define a function for matching the lognormal distribution to two (or more)
# tie points.  
lnorm.rmse <- function(dist.params, xs, ps) {
  # dist.params, vector of meanlog and sdlog values; see help(dlnorm)
  # xs, vector of values of the distributed variable to match
  # ps, probabilities of the values in xs
  logmu <- dist.params[1]
  logsigma <- dist.params[2]
  trial.xs <- qlnorm(ps, logmu, logsigma)
  rmse <- sqrt(mean((xs- trial.xs)^ 2))
  return(rmse)
}

# Set some values.  
xs <- c(1, 6)       # climate sensitivities corresponding to the probabilities 
                    # in ps
ps <- c(0.05, (1- 0.1))  
                    # (approximate) probabilities of the climate sensitivity
                    # being less than xs[1] or greater than xs[2], according 
                    # to IPCC AR5 WG1
n.trials <- 300     # number of Monte Carlo trials

# Set sensible names for the time-dependent variables to extract from DICE.  
names <- c('Time (yr)', 
           'Emissions (Gt CO_2/yr)', 
           'Atmospheric [CO_2] (ppm)', 
           'Global mean T anomaly (C)', 
           'Climate damages (10^12 $)', 
           'Social cost of carbon ($/t CO_2)')

# Load the DICE model.  
source('dice.R')

# Create a new DICE object.  
my.dice <- dice.new()

# Solve the DICE object for the optimal control policy.  
# NOTE: THIS STEP MAY TAKE A COUPLE OF MINUTES!  
dice.solve(my.dice)

# Make a place to store time-dependent output from optimized DICE.  
opt.output <- matrix(data = NA, nrow = length(my.dice$year), ncol = 6)
colnames(opt.output) <- names

# Put the time.dependent output from optimized DICE into dice.output.  
opt.output[, 1] <- my.dice$year
opt.output[, 2] <- my.dice$e
opt.output[, 3] <- my.dice$mat
opt.output[, 4] <- my.dice$tatm
opt.output[, 5] <- my.dice$damages
opt.output[, 6] <- my.dice$scc

# Also extract the assumed climate sensitivity and social cost of carbon
# from the DICE object.  
opt.t2xco2 <- my.dice$t2xco2
opt.scc <- opt.output[1, 6]

# Print some key quantities.  
print(sprintf('The assumed climate sensitivity for optimization is %2.2f C/doubling', 
              opt.t2xco2))
print(sprintf('The optimized social cost of carbon in %d is $%4.2f/t CO_2', 
              opt.output[1, 1], opt.scc))

# Identify the parameters of the lognormal distribution that produce the best
# match to the IPCC's statements about climate sensitivity.  
lnorm.optim <- optim(log(c(2.9, 1.5)), lnorm.rmse, gr = NULL, xs = xs, ps = ps, 
                     method = 'L-BFGS-B', lower = c(0, 0), upper = c(Inf, Inf))

# Generate a vector of climate sensitivity values.  
set.seed(1)
tx2co2s <- rlnorm(n.trials, meanlog = lnorm.optim$par[1], 
                  sdlog = lnorm.optim$par[2])

# Make a vector to store the social cost of carbon values.  
sccs <- rep(NA, length.out = n.trials)

# Cycle over the Monte Carlo trials and calculate a new social cost of carbon
# each time.  
for (i in 1: n.trials) {
  
  # Change the climate sensitivity value in the DICE object.  
  dice.modify(my.dice, "t2xco2", tx2co2s[i])
  
  # Run the DICE model with the new parameter value.  
  dice.run(my.dice)
  
  # Store the estimated social cost of carbon value given the new climate
  # sensitivity value.  
  sccs[i] <- my.dice$scc[1]
}

# Output the mean of the social cost of carbon values.  
mean.sccs <- mean(sccs)
print(sprintf('The expected social cost of carbon in %d is $%4.2f/t CO_2', 
              opt.output[1, 1], mean.sccs, n.trials))
print(sprintf('The expected social cost of carbon is %2.1f%% higher', 
              100* (mean.sccs- opt.scc)/ opt.scc))

# Plot the time-dependent output from the optimized DICE object.  
dir.create('figures')
pdf('figures/lab8_plot1.pdf', width = 5, height = 8.5)
par(mfrow = c(5, 1))
plot(opt.output[, 1], opt.output[, 2], type = 'l', bty = 'n', xlab = names[1], 
     ylab = names[2])
plot(opt.output[, 1], opt.output[, 3], type = 'l', bty = 'n', xlab = names[1], 
     ylab = names[3])
plot(opt.output[, 1], opt.output[, 4], type = 'l', bty = 'n', xlab = names[1], 
     ylab = names[4])
plot(opt.output[, 1], opt.output[, 5], type = 'l', bty = 'n', xlab = names[1], 
     ylab = names[5])
plot(opt.output[, 1], opt.output[, 6], type = 'l', bty = 'n', xlab = names[1], 
     ylab = names[6])
dev.off()

# Plot a histogram of the SCC values from the Monte Carlo experiment, the
# mean of those values, and the SCC value from the optimization.  
pdf('figures/lab8_plot2.pdf', width = 5, height = 8.5)
par(mfrow = c(2, 1))
hist(tx2co2s, breaks = 25, xlab = 'Climate sensitivity (C/doubling)', main = '')
abline(v = opt.t2xco2, lwd = 2, col = 'blue')
legend('topright', legend = c('Assumed CS'), lwd = 2, 
       col = c('blue', 'red'), bty = 'n')
hist(sccs, breaks = 25, xlab = names[6], main = '')
abline(v = opt.scc, lwd = 2, col = 'blue')
abline(v = mean.sccs, lwd = 2, col = 'red')
legend('topright', legend = c('Optimized SCC', 'Expected SCC'), lwd = 2, 
       col = c('blue', 'red'), bty = 'n')
dev.off()