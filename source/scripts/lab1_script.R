# lab1_script.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Downloads data on atmospheric carbon dioxide concentration, global mean 
# temperature, and global mean sea level as a function of time and makes
# plots of these quantities.  

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

# Uncomment the following lines to create a directory called data and download 
# some files into it.  
dir.create('data')
download.file('ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_mm_mlo.txt', 
              'data/co2_mm_mlo.txt', method = 'curl')
download.file('ftp://ftp.ncdc.noaa.gov/pub/data/paleo/icecore/antarctica/law/law2006.txt', 
              'data/law2006.txt', method = 'curl')
download.file('http://data.giss.nasa.gov/gistemp/tabledata_v3/GLB.Ts+dSST.txt', 
              'data/GLB.Ts+dSST.txt', method = 'curl')
download.file('http://www.psmsl.org/products/reconstructions/gslGPChange2014.txt', 
              'data/gslGPChange2014.txt', method = 'curl')

# Read in the information from the downloaded files.  
loa.co2.data <- read.table('data/co2_mm_mlo.txt', skip = 57, header = FALSE)
law.co2.data <- read.table('data/law2006.txt', skip = 183, nrows = 2004, 
                           header = FALSE)
sl.data <- read.table('data/gslGPChange2014.txt', skip = 22, header = FALSE)

# Reading in the GISS temperature data is somewhat harder.  
begin.rows <- c(9, 31, 53, 75, 97, 119, 141)
num.rows <- c(19, 20, 20, 20, 20, 20, 14)
temp.data <- matrix(NA, nrow = sum(num.rows), ncol = 20)
temp.data[1: num.rows[1], ] <- as.matrix(read.table('data/GLB.Ts+dSST.txt', 
                  skip = begin.rows[1], nrows = num.rows[1], header = FALSE))
for (i in 2: length(begin.rows)) {
  temp.data[(sum(num.rows[1: i- 1])+ 1): sum(num.rows[1: i]), ] <- 
    as.matrix(read.table('data/GLB.Ts+dSST.txt', skip = begin.rows[i], 
                         nrows = num.rows[i], header = FALSE))
}

# Make a plot of the results.  
dir.create('figures', showWarnings = FALSE)
pdf('figures/lab1_plot1.pdf', width = 4.5, height = 6)
par(mfrow = c(3, 1))
plot(law.co2.data[, 1], law.co2.data[, 6], type = 'l', xlim = c(1900, 2020), 
     ylim = c(290, 400), bty = 'n', xlab = 'Time (yr)', 
     ylab = 'Atmospheric carbon dioxide (ppm)')
lines(loa.co2.data[, 3], loa.co2.data[, 5], type = 'l', col = 'blue')
legend(x = 'topleft', legend = c('Law Dome ice core record', 
      'Mauna Loa measurements'), col = c('black', 'blue'), lwd = c(1, 1), 
      bty = 'n')
plot(temp.data[, 1], temp.data[, 14]/ 100, type = 'l', xlim = c(1900, 2020), 
     ylim = c(-0.6, 0.7), bty = 'n', xlab = 'Time (yr)', 
     ylab = 'Global mean temperature anomaly (K)')
plot(sl.data[, 1], sl.data[, 4], type = 'l', xlim = c(1900, 2020), 
     ylim = c(-50, 225), bty ='n', xlab = 'Time (yr)', 
     ylab = 'Sea level anomaly (mm)')
dev.off()