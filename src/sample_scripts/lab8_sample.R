# lab8_sample.R
# Patrick Applegate, patrick.applegate@psu.edu; Greg Garner, ggg121@psu.edu
# 
# Optimizes the DICE model to produce a plausible climate-economic trajectory
# and performs a Monte Carlo experiment to evaluate the effects of uncertainty
# in the climate sensitivity on the present-day social cost of carbon.  

# Mise en place.  
rm(list = ls())
graphics.off()

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

# Put the time.dependent output from optimized DICE into opt.output.  
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

# Plot the time-dependent output from the optimized DICE object.  
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