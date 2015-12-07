# lab5_sample.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Downloads sea level anomaly data covering the last ~200 yr, plots these
# data with a second-order polynomial, and plots the residuals between the
# data and the polynomial.  

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

# Set some parameter values.  
a <- 0
b <- 0
c <- -100
t.0 <- 1800

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

# Given the values of a, b, c, and t.0 specified above, estimate the sea level
# anomalies in each year using a second-order polynomial.  
est.sl <- a* (t- t.0)^ 2+ b* (t- t.0)+ c

# Calculate the residuals between the observed and estimated sea level anomaly 
# values.
resids <- obs.sl- est.sl

# Find the root mean squared error between the observed and estimated sea level
# anomaly values.  
rmse <- sqrt(mean((obs.sl- est.sl)^ 2))
print(rmse)

# Make a plot.  
par(mfrow = c(2, 1))
plot(t, obs.sl, type = 'l', xlab = 'Time (yr)', ylab = 'Sea level anomaly (mm)', 
     lwd = 1, col = 'red')
lines(t, est.sl, lwd = 1, col = 'blue')
legend(x = 'topleft', legend = c('Data', '2nd-Order Polynomial'), lwd = 1, 
       col = c('red', 'blue'), bty = 'n')
plot(t, resids, type = 'l', xlab = 'Time (yr)', ylab = 'Residuals (mm)', 
     lwd = 1)