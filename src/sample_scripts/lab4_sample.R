# lab4_sample.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Performs a simple Monte Carlo analysis with the optimal dike height
# equation from van Dantzig (1956).  

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
range <- 0.1      # fractional range of each parameter to test
probs <- c(0.025, 0.5, 0.975)
                  # which quantiles to report

# Set the seed for random sampling.  
set.seed(1)

# Perform the random sampling.  
facs <- c((1- 0.5* range), (1+ 0.5* range))
delta.vals <- runif(n.trials, min = facs[1]* delta, 
               max = facs[2]* delta)

# Calculate the optimal dike heights.  
best.heights <- alpha^-1* log((V* p_0* alpha)/ (delta.vals* k))

# Make a histogram and print the quantiles to the screen.  
hist(best.heights, main = '', xlab = 'Optimal dike heights (m)')
abline(v = alpha^-1* log((V* p_0* alpha)/ (delta* k)), lwd = 2, col = 'red')
print(round(quantile(best.heights, probs = probs), 3))
