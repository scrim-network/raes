# lab0_sample.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Generates a histogram of random samples from a normal distribution
# with a mean of 1 and a standard deviation of 1.  You'll need to 
# modify this script to come up with a full solution to the 
# exercise.  

# Set some values.  
num <- 10^3   # number of random draws
mu <- 1       # mean of normal distribution to draw from
sigma <- 1    # standard deviation of normal distribution

# Sample randomly from a normal distribution and assign these values to a 
# variable called x.  
x <- rnorm(n = num, mean = mu, sd = sigma)

# Plot the results as a histogram.  Also plot a red line showing the mean
# of the parent distribution on top of the histogram, and save the results
# to a .pdf file.  
pdf("lab0_plot1.pdf", height = 4, width = 4)
hist(x, main = "Patrick Applegate", xlab = "gbbsh", ylab = "xkkktc")
abline(v = mu, lwd = 2, col = "red")
dev.off()

