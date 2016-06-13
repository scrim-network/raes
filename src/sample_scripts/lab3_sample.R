# lab3_sample.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Produces (pseudo-)random numbers from a normal distribution and plots a
# histogram and empirical cumulative density function using these numbers.  

# Clear away any existing variables or figures.  
rm(list = ls())
graphics.off()

# Set some values.  
mu <- 5         # mean of normal distribution
sigma <- 3      # standard deviation of normal distribution
n.obs <- 10^ 4  # number of random values to generate
n.bins <- 25    # number of bins in the histogram

# Set the seed for random sampling.  
set.seed(1)

# Generate the random values.  
data <- rnorm(n = n.obs, mean = mu, sd = sigma)

# Extract some relevant quantities from the random values.  
mean.data <- mean(data)
median.data <- median(data)

# Make a plot.  
dir.create('figures')
pdf('figures/lab3_sample_plot1.pdf')
par(mfrow = c(2, 1))

# Plot the histogram.  
hist(data, breaks = n.bins, freq = FALSE, xaxs = 'i', main = 'Histogram', 
     xlab = 'x', ylab = 'f(x)')

# Show the mean and the median on the histogram.  
abline(v = mean.data, lty = 1, lwd = 2, col = 'red')
abline(v = median.data, lty = 2, lwd = 2, col = 'blue')

# Put a legend on the histogram.  
legend('topright', legend = c('mean', 'median', '0.025 and 0.975'), 
       lty = c(1, 2), lwd = 2, bty = 'n', col = c('red', 'blue'))

# Find the extents of the histogram's axes.  
axis.lims <- par('usr')

# Now, plot the empirical cumulative distribution function.  
plot.ecdf(data, xlim = axis.lims[1: 2], bty = 'n', xaxs = 'i', 
          main = 'Cumulative distribution function', xlab = 'x', ylab = 'F(x)')

# Plot the mean and the median on the ecdf.  
abline(v = mean.data, lty = 1, lwd = 2, col = 'red')
abline(v = median.data, lty = 2, lwd = 2, col = 'blue')
dev.off()