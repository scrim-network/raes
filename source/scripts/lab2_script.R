# patrick_lab4_script.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Simulates a Galton board and checks its output for normality.  Also performs
# the same check on two data sets built in to R.  

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

# Set some variables.  
n_balls = 200     # number of balls to drop
n_rows = 10       # number of rows of pins in the board

# Set up a variable to save the results of the 
# calculation performed within the for loop.  
output = rep(NA, n_balls)

# Now, carry out the ball-dropping experiment n_balls times.  
# The size argument in the sample command sets the number of
# rows of pins in the Galton board, and the number of bins
# below the board. 
for (i in 1: n_balls) { 
  output[i] = sum(sample(c(-0.5, 0.5), size = (n_rows- 1), replace = TRUE))
} 

# Make a histogram of the results.  
dir.create('figures')
pdf('figures/lab2_plot1.pdf', height = 5)
par(mfrow = c(1, 2))
bin_edges <- seq(-n_rows/ 2, n_rows/ 2, by = 1)
hist(output, bin_edges, xlab = 'Bin', ylab = 'Frequency')

# Make another plot that checks the results for normality.  Does the line 
# pass through the points?  
qqnorm(output)
qqline(output)
dev.off()
# # OPTIONAL: Refigure the values in output so that the bins
# # are numbered 0, 1... n_rows.  Note that the total number
# # of bins will be n_rows+ 1.  
# output = (output+ n_rows)/ 2
# 
# # Histogram the results.  Specifying bin_edges is OPTIONAL.  
# # The pdf and dev.off commands are OPTIONAL.  
# pdf('patrick_lab4_fig1.pdf')
# bin_edges = seq(0- 0.5, n_rows+ 0.5)
# hist(output, bin_edges, main = 'Galton Board', xlab = 'Bin #', ylab = 'Number of trials')
# dev.off()
# 
# # Part 2: checking built-in data sets for normality
# pdf('patrick_lab4_fig2.pdf')
# par(mfrow = c(1, 2))
# 
# # Check the faithful data set for normality.  
# qqnorm(faithful[, 2], main = 'Old Faithful waiting times (min)')
# qqline(faithful[, 2])
# 
# # Check the iris3 data set for normality.  
# qqnorm(iris3[, 1, 1], main = 'Setosa iris petal lengths (cm)')
# qqline(iris3[, 1, 1])
# dev.off()