# Sample R script for Exercise #0
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Generates a histogram of random samples from a normal distribution
# with a mean of 1 and a standard deviation of 1.  You'll need to 
# modify this script to come up with a full solution to the 
# exercise.  

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
pdf('lab0_fig1.pdf', height = 4, width = 4)
hist(x, main = 'Patrick Applegate', xlab = 'gbbsh', ylab = 'xkkktc')
abline(v = mu, lwd = 2, col = 'red')
dev.off()

