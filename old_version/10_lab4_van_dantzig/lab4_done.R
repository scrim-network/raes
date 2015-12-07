# lab4_sample.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Performs a simple Monte Carlo analysis with the optimal dike height
# equation from van Dantzig (1956).  

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

# Clear any existing variables and plots.  
rm(list = ls())
graphics.off()

# Constants from van Dantzig (1956)
p_0 = 0.0038      # unitless; probability of flooding in 1 yr if the dikes
                  # aren't built
alpha = 2.6       # unitless; constant associated with flooding probabilities
V = 10^ 10        # guilders; value of goods threatened by flooding
delta = 0.04      # unitless; discount rate
I_0 = 0           # guilders; initial cost of building dikes
k = 42* 10^ 6     # guilders/m; cost of raising the dikes by 1 m

# Set some other values.  
n.trials <- 10^5  # number of Monte Carlo trials to do
range <- 0.3      # fractional range of each parameter to test
probs <- c(0.025, 0.5, 0.975)
                  # which quantiles to report

# Set the seed for random sampling.  
set.seed(1)

# Perform the random sampling.  
facs <- c((1- 0.5* range), (1+ 0.5* range))
V.vals <- runif(n.trials, min = facs[1]* V, 
                max = facs[2]* V)
delta.vals <- runif(n.trials, min = facs[1]* delta, 
               max = facs[2]* delta)
k.vals <- runif(n.trials, min = facs[1]* k, 
                max = facs[2]* k)

# Calculate the optimal dike heights.  
best.heights <- alpha^-1* log((V.vals* p_0* alpha)/ (delta.vals* k.vals))

# Make a histogram and print the quantiles to the screen.  
hist(best.heights, main = '', xlab = 'Optimal dike heights (m)')
abline(v = alpha^-1* log((V* p_0* alpha)/ (delta* k)), lwd = 2, col = 'red')
print(round(quantile(best.heights, probs = probs), 3))

# par(mfcol = c(1, 3))
# plot(V.vals, best.heights, type = 'p')
# plot(delta.vals, best.heights, type = 'p')
# plot(k.vals, best.heights, type = 'p')
