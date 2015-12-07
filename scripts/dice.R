#================================================================================
#
# dice.r   03 August 2015
#
# R VERSION OF DICE
# Economic - Climate Projections
# Based on GAMS version of DICE2013R
# (DICE2013Rv2_102213_vanilla_v24b.gms)
# 
#   William D. Nordhaus, Yale University
#   The Climate Casino (2013), Yale University Press
#   http://www.econ.yale.edu/~nordhaus/homepage/index.html
#
#     for previous versions, see also
#       DICE 2007:
#       William D. Nordhaus
#       A Question of Balance (2008), Yale University Press
#       DICE1999:
#       William D. Norhaus and Joseph Boyer
#       Warming the World (2000), The MIT Press
#       DICE 1994:
#       William D. Nordhaus,
#       Managing the Global Commons (1994), The MIT Press
#           
#          
#   Translated to R by Gregory Garner
#   V 1.0  2015 Penn State University
# 
# Copyright (C) 2015 Gregory Garner, Klaus Keller, 
# Patrick Reed, Martha Butler, and others
# 
# R-DICE is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
# 
# R-DICE is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
# License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with the R-DICE code.  If not, see <http://www.gnu.org/licenses/>.
#
#================================================================================

 
# Load compiler and enable JIT if possible.
# This will speed things up as the code contains
# many loops.  Note: Using this may cause spurious
# warnings about global variables to pop up. The code
# runs fine despite the warnings, but it may
# give new users a bit of anxiety.

#.load.compiler <- require(compiler)
#if(.load.compiler) {enableJIT(3)}


##------------ dice.new ------------------------------------------------------
#
# Creates a new dice object with parameters set to default and decision
# variables set to the optimal values.
#
#-----------------------------------------------------------------------------
dice.new <- function() {
  
  e <- new.env()
  
  # Time Series
  e$nPeriods = 60
  e$tstep = 5.0
  e$startYear = 2010
  
  # Preferences
  e$elasmu = 1.45
  e$prstp = 0.015
  
  # Population and Technology
  e$gama = 0.3
  e$pop0 = 6838.0
  e$popadj = 0.134
  e$popasym = 10500.0
  e$dk = 0.1
  e$q0 = 63.69
  e$k0 = 135.0
  e$a0 = 3.80
  e$ga0 = 0.079
  e$dela = 0.006
  e$optlrsav = (e$dk+0.004)/(e$dk+0.004*e$elasmu+e$prstp)*e$gama
  
  # Emissions paramemters
  e$gsigma1 = -0.01
  e$dsig = -0.001
  e$eland0 = 3.3
  e$deland = 0.2
  e$e0 = 33.61
  e$miu0 = 0.039
  
  # Carbon Cycle
  e$mat0 = 830.4
  e$mu0 = 1527.0
  e$ml0 = 10010.0
  e$mateq = 588.0
  e$mueq = 1350.0
  e$mleq = 10000.0
  
  e$b12 = 0.088
  e$b23 = 0.00250
  e$b11 = 1 - e$b12
  e$b21 = e$b12 * e$mateq/e$mueq
  e$b22 = 1 - e$b21 - e$b23
  e$b32 = e$b23 * e$mueq/e$mleq
  e$b33 = 1 - e$b32
  
  # Climate Model Parameters
  e$t2xco2 = 2.9
  e$fex0 = 0.25
  e$fex1 = 0.70
  e$tocean0 = 0.0068
  e$tatm0 = 0.80
  e$c10 = 0.098
  e$c1beta = 0.01243
  e$c1 = 0.098
  e$c3 = 0.088
  e$c4 = 0.025
  e$fco22x = 3.8
  e$lam = e$fco22x / e$t2xco2
  
  # Climate Damage Parameters
  e$a10 = 0.0
  e$a20 = 0.00267
  e$a1 = 0.0
  e$a2 = 0.00267
  e$a3 = 2.00
  
  # Abatement Cost
  e$expcost2 = 2.8
  e$pback = 344.0
  e$gback = 0.025
  e$limmiu = 1.2
  e$tnopol = 45
  e$cprice0 = 1.0
  e$gcprice = 0.02
  
  # Participation Parameters
  e$periodfullpart = 21
  e$partfract2010 = 1.0
  e$partfractfull = 1.0
  
  # Availability of fossil fuel
  e$fosslim = 6000.0
  
  # Scaling and inessential parameters
  e$scale1 = 0.016408662
  e$scale2 = -3855.106895
  
  # Initialize with the optimal policy and savings
  e$miu <- c(e$miu0,0.1952999,0.2184580,0.2432032,0.2694976,0.2973148,0.3266363,0.3574481,0.3897383,
    0.4234960,0.4587089,0.4953631,0.5334413,0.5729220,0.6137789,0.6559797,0.6994856,
    0.7442508,0.7902230,0.8373550,0.8855712,0.9347613,0.9847725,1.0000000,1.0000000,
    1.0000000,1.0000000,1.0000000,1.0000000,1.2000000,1.2000000,1.2000000,1.2000000,
    1.2000000,1.2000000,1.2000000,1.2000000,1.2000000,1.2000000,1.2000000,1.2000000,
    1.2000000,1.2000000,1.2000000,1.2000000,1.2000000,1.2000000,1.2000000,1.2000000,
    1.2000000,1.2000000,1.2000000,1.2000000,1.1832865,1.0574198,0.9100568,0.7410948,
    0.5486346,0.3275590,0.0000000)
  e$s <- c(0.2590697,0.2562058,0.2538011,0.2516983,0.2498877,
    0.2483500,0.2470624,0.2460016,0.2451452,0.2444727,0.2439655,0.2436065,0.2433806,
    0.2432733,0.2432710,0.2433596,0.2435232,0.2437419,0.2439876,0.2442377,0.2444318,
    0.2444695,0.2441774,0.2442851,0.2446433,0.2450967,0.2457499,0.2467787,0.2484908,
    0.2464324,0.2466940,0.2469128,0.2471021,0.2472696,0.2474195,0.2475544,0.2476759,
    0.2477850,0.2478818,0.2479662,0.2480366,0.2480895,0.2481179,0.2481084,0.2480367,
    0.2478586,0.2474949,0.2468042,0.2455336,0.2432287,rep(e$optlrsav, 10))
  
  # Control policy upper limit
  e$miu.up <- c(rep(1, 29), rep(1.2, e$nPeriods-29))
  
  # Stability limits on variables
  e$k_lo <- 1.0
  e$mat_lo <- 10.0
  e$mu_lo <- 100.0
  e$ml_lo <- 1000.0
  e$c_lo <- 2.0
  e$tocean_up <- 20.0
  e$tocean_lo <- -1.0
  e$tatm_lo <- 0.0
  e$tatm_up <- 40.0
  e$cpc_lo <- 0.01
  e$y_lo <- 0.0
  e$ygross_lo <- 0.0
  e$i_lo <- 0.0
  e$cca_up <- e$fosslim
  
  # Initialize exogenous variables
  e$year <- array(NA, dim=e$nPeriods)
  e$l <- array(NA, dim=e$nPeriods)
  e$al <- array(NA, dim=e$nPeriods)
  e$sigma <- array(NA, dim=e$nPeriods)
  e$rr  <- array(NA, dim=e$nPeriods)
  e$ga <- array(NA, dim=e$nPeriods)
  e$forcoth <- array(NA, dim=e$nPeriods)
  e$gl <- array(NA, dim=e$nPeriods)
  e$gcost <- array(NA, dim=e$nPeriods)
  e$gsig <- array(NA, dim=e$nPeriods)
  e$etree <- array(NA, dim=e$nPeriods)	
  e$cost1 <- array(NA, dim=e$nPeriods)	
  e$partfract <- array(NA, dim=e$nPeriods)
  e$pbacktime <- array(NA, dim=e$nPeriods)
  e$scc <- array(NA, dim=e$nPeriods)
  e$cpricebase <- array(NA, dim=e$nPeriods)
  e$photel <- array(NA, dim=e$nPeriods)
  
  # Initialize endogenous variables
  e$forc <- array(NA, dim=e$nPeriods)
  e$tatm <- array(NA, dim=e$nPeriods)
  e$tocean <- array(NA, dim=e$nPeriods)
  e$mat <- array(NA, dim=e$nPeriods)
  e$mu <- array(NA, dim=e$nPeriods)
  e$ml <- array(NA, dim=e$nPeriods)
  e$e <- array(NA, dim=e$nPeriods)
  e$eind <- array(NA, dim=e$nPeriods)
  e$c <- array(NA, dim=e$nPeriods)
  e$k <- array(NA, dim=e$nPeriods)
  e$cpc <- array(NA, dim=e$nPeriods)
  e$i <- array(NA, dim=e$nPeriods)
  e$ri <- array(NA, dim=e$nPeriods)
  e$y <- array(NA, dim=e$nPeriods)
  e$ygross <- array(NA, dim=e$nPeriods)
  e$ynet <- array(NA, dim=e$nPeriods)
  e$damages <- array(NA, dim=e$nPeriods)
  e$damfrac <- array(NA, dim=e$nPeriods)
  e$abatecost <- array(NA, dim=e$nPeriods)
  e$mcabate <- array(NA, dim=e$nPeriods)
  e$cca <- array(NA, dim=e$nPeriods)
  e$periodu <- array(NA, dim=e$nPeriods)
  e$cprice <- array(NA, dim=e$nPeriods)
  e$cemutotper <- array(NA, dim=e$nPeriods)
  e$e_perturb <- array(NA, dim=e$nPeriods)
  e$c_perturb <- array(NA, dim=e$nPeriods)
  
  # Social Welfare Value (Objective)
  e$utility <- NA
  
  # Do the initial run to calculate and assign the exog/endog variables
  dice.run(e)
  
  return(e)
}


##------------ dice.modify ----------------------------------------------------
#
# Function that modifies a parameter in a dice object. Subsequent dependent
# parameters are also updated.
#
# Note: There is a chain in which updating one model parameter updates other
# dependent model parameters.  Below are the chains:
#
#   dk, elasmu, prstp, gama > optlrsav > s
#   b12, b23, mateq, mueq, mleq > b11, b21, b22, b32, b33
#   fco22x, t2xco2 > lam
#   optlrsav > s
#   miu0 > miu
#
# Changing a variable on the left of any of those chains will subsequently
# update the values of everything to the right. The process does NOT go
# in reverse, so for example, updating 'lam' will NOT change 'fco22x' and
# 't2xco2'. 
#
#-----------------------------------------------------------------------------

dice.modify <- function(dice, this.var, this.val) {
  
  # Parameters that have dependent parameters
  recalc.optlrsav <- c("dk", "elasmu", "prstp", "gama")
  recalc.b <- c("b12", "b23", "mateq", "mueq", "mleq")
  recalc.lam <- c("fco22x", "t2xco2")
  recalc.s <- c("optlrsav")
  recalc.miu <- c("miu0")
  
  # Check the function arguments
  .dice.check.obj(dice, deparse(substitute(dice)))
  .dice.check.varexist(dice, this.var, deparse(substitute(dice)))
  .dice.check.vartype(dice, this.var, this.val)
  .dice.check.vardim(dice, this.var, this.val)
  
  # All is well, pass the new value to the parameter
  assign(this.var, this.val, envir=dice)
  
  # Test to see if dependent parameters need to be updated
  if(this.var %in% recalc.optlrsav) {
    assign("optlrsav", (dice$dk+0.004)/(dice$dk+0.004*dice$elasmu+dice$prstp)*dice$gama, envir=dice)
    temp <- get("s", envir=dice)
    temp[(dice$nPeriods-9):dice$nPeriods] <- rep(dice$optlrsav, 10)
    assign("s", temp, envir=dice)
  }
  if(this.var %in% recalc.b) {
    assign("b11", (1-dice$b12), envir=dice)
    assign("b21", (dice$b12 * dice$mateq/dice$mueq), envir=dice)
    assign("b22", (1 - dice$b21 - dice$b23), envir=dice)
    assign("b32", (dice$b23 * dice$mueq/dice$mleq), envir=dice)
    assign("b33", (1-dice$b32), envir=dice)
  }
  if(this.var %in% recalc.lam) {
    assign("lam", (dice$fco22x / dice$t2xco2), envir=dice)
  }
  if(this.var %in% recalc.s) {
    temp <- get("s", envir=dice)
    temp[(dice$nPeriods-9):dice$nPeriods] <- rep(dice$optlrsav, 10)
    assign("s", temp, envir=dice)
  }
  if(this.var %in% recalc.miu) {
    temp <- get("miu", envir=dice)
    temp[1] <- dice$miu0
    assign("miu", temp, envir=dice)
  }
}

##------------ dice.run ----------------------------------------------------
#
# Runs the model using the parameters in the provided dice object.  This
# function contains the steps necessary to calculate the social cost
# of carbon.
#
#---------------------------------------------------------------------------

dice.run <- function(dice) {
  
  # Check the function arguments
  .dice.check.obj(dice, deparse(substitute(dice)))
  
  # Run the model
  .dice.calc.model(dice)
  
  # Loop over the time steps
  nPeriods <- dice$nPeriods
  for(t in 2:nPeriods){
    
    # Create/Reset the temp DICE object
    temp.dice <- .copy.env(dice)
    
    # Increment consumption
    temp.dice$c[t-1] <- dice$c[t-1] + 1
    
    # Post-process the run
    .dice.postprocess(temp.dice)
    
    # Store the change in utility
    dutil.c <- temp.dice$utility - dice$utility
    
    # Reset the consumption
    temp.dice$c[t-1] <- dice$c[t-1]     
    
    # Increment the emissions at this time step
    temp.dice$e[t-1] <- dice$e[t-1] + 1
    
    # Run the model on the temporary dice object
    for(tsub in t:nPeriods) {
      .dice.calc.endog.t(temp.dice, tsub)
    }
    
    # Do the post processing of this run
    .dice.postprocess(temp.dice)
    
    # Store the utility from this run
    dutil.e <- temp.dice$utility - dice$utility
    
    # Calculate the SCC from these differences in utility
    dice$scc[t-1] <- -1000.0 * (dutil.e / dutil.c)
    
  }
  
}


##------------ dice.solve ----------------------------------------------------
#
# Uses the built-in optimization algorithm to solve a dice object for
# the maximum utility.
#
#-----------------------------------------------------------------------------

dice.solve <- function(dice, max.iteration=100){
  
  # Check the function arguments
  .dice.check.obj(dice, deparse(substitute(dice)))
  
  # Use the current control policy and savings rate
  # as the initial guess
  init.par <- c(dice$miu[-1], dice$s[-c((dice$nPeriods-9):dice$nPeriods)])
  
  # Function that takes in the decision variables
  # and returns the utility
  my.fun <- function(dvars, dice) {
    temp <- get("miu", envir=dice)
    temp[2:dice$nPeriods] <- dvars[1:(dice$nPeriods-1)]
    assign("miu", temp, envir=dice)
    temp <- get("s", envir=dice)
    temp[1:(dice$nPeriods-10)] <- dvars[dice$nPeriods:length(dvars)]
    assign("s", temp, envir=dice)
    .dice.calc.model(dice)
    -1 * dice$utility
  }
  
  # Run the optimization
  my.optim <- optim(init.par, my.fun, dice=dice, method="L-BFGS-B", 
                    lower=rep(0, length(init.par)), 
                    upper=c(dice$miu.up[-1], rep(1,dice$nPeriods-10)), 
                    control=list(trace=0, maxit=max.iteration))
  
  # Re-assign the optimal solution to the dice object
  temp <- get("miu", envir=dice)
  temp[2:dice$nPeriods] <- my.optim$par[1:(dice$nPeriods-1)]
  assign("miu", temp, envir=dice)
  temp <- get("s", envir=dice)
  temp[1:(dice$nPeriods-10)] <- my.optim$par[dice$nPeriods:length(my.optim$par)]
  assign("s", temp, envir=dice)
  dice.run(dice)
}


##------------ dice.plot ----------------------------------------------------
#
# Simple plotting routine for time-series variables in a dice object.
#
#-----------------------------------------------------------------------------
dice.plot <- function(dice, variable, ...) {
  
  # Check the arguements
  .dice.check.obj(dice, deparse(substitute(dice)))
  .dice.check.varexist(dice, variable, deparse(substitute(dice)))
  
  # We're ok to start plotting
  par(mar=c(5,4.2,1,1)+0.1)
  temp <- get(variable, envir=dice)
  this.ylab <- switch(variable,
          tatm = "Atmospheric Temperature Change [deg C since 1900]",
          tocean = "Oceanic Temperature Change [deg C since 1900]",
          e = "Total Emissions [GtCO2 per year]",
          abatecost = "Abatement Cost [Trillions 2005 USD]",
          damages = "Damages [Trillions 2005 USD]",
          mat = "Atmospheric CO2 [GtC]",
          miu = "Control Policy [Fraction of GWP]",
          s = "Savings Rate [Fraction of Net Production]",
          forc = "Radiative Forcing [Wm-2]", 
          scc = "Social Cost of Carbon [USD per ton CO2]", 
          variable)
  plot(dice$year, temp, xlab="Year", ylab=this.ylab, ...)
}


##------------ dice.help ----------------------------------------------------
#
# Provide a brief text description of a parameter or
# variable in a DICE object.
#
#-----------------------------------------------------------------------------
dice.help <- function(variable="all") {
  
  # Determine the variable and assign the
  # appropriate help text
  this.help <- switch(variable,
    all = "    elasmu = Elasticity of marginal utility of consumption
    prstp = Initial rate of social time preference (per year)
    gama = Capital elasticity in production function
    pop0 = Initial world population [Millions]
    popadj = Growth rate to calibrate to 2050 population projection
    popasym = Asymptotic world population [Millions]
    dk = Depreciation rate on capital (per year)
    q0 = Initial world gross output [Trillions 2005 US $]
    k0 = Initial capital value [Trillions 2005 US $]
    a0 = Initial level of total factor productivity (TFP)
    ga0 = Initial growth rate for TFP (per 5 years)
    dela = Decline rate of TFP (per 5 years)
    optlrsav = Optimal long-run savings rate used for transversality
    gsigma1 = Initial growth of sigma (per year)
    dsig = Decline rate of decarbonization (per period)
    eland0 = Carbon emissions from land 2010 [GtCO2 per year]
    deland = Decline rate of land emissions (per period)
    e0 = Industrial emissions 2010 [GtCO2 per year]
    miu0 = Initial emissions control rate for base case 2010
    mat0 = Initial concentration in atmosphere 2010 [GtC]
    mu0 = Initial concentration in upper strata [GtC]
    ml0 = Initial concentration in lower strata [GtC]
    mateq = Equilibrium concentration in atmosphere [GtC]
    mueq = Equilibrium concentration in upper strata [GtC]
    mleq = Equilibrium concentration in lower strata [GtC]
    b12 = Carbon control parameter - atmosphere -> upper strata
    b23 = Carbon control parameter - upper strata -> lower strata
    b11 = Carbon control parameter - atmosphere -> atmosphere
    b21 = Carbon control parameter - upper strata -> atmosphere
    b22 = Carbon control parameter - upper strata -> upper strata
    b32 = Carbon control parameter - lower strata -> upper strata
    b33 = Carbon control parameter - lower strata -> lower strata
    t2xco2 = Equilibrium temperature impact [dC per doubling CO2]
    fex0 = 2010 forcings of non-CO2 greenhouse gases (GHG) [Wm-2]
    fex1 = 2100 forcings of non-CO2 GHG [Wm-2]
    tocean0 = Initial lower stratum temperature change [dC from 1900]
    tatm0 = Initial atmospheric temperature change [dC from 1900]
    c10 = Initial climate equation coefficient for upper level
    c1beta = Regression slope coefficient (SoA~Equil TSC)
    c1 = Climate equation coefficient for upper level
    c3 = Transfer coefficient upper to lower stratum
    c4 = Transfer coefficient for lower level
    fco22x = Forcings of equilibrium CO2 doubling [Wm-2]
    lam = Climate model parameter
    a10 = Initial damage intercept
    a20 = Initial damage quadratic term
    a1 = Damage intercept
    a2 = Damage quadratic term
    a3 = Damage exponent
    expcost2 = Exponent of control cost function
    pback = Cost of backstop [2005$ per tCO2 2010]
    gback = Initial cost decline backstop [cost per period]
    limmiu = Upper limit on control rate after 2150
    tnopol = Period before which no emissions controls base
    cprice0 = Initial base carbon price [2005$ per tCO2]
    gcprice = Growth rate of base carbon price (per year)
    periodfullpart = Period at which have full participation
    partfract2010 = Fraction of emissions under control in 2010
    partfractfull = Fraction of emissions under control at full time
    fosslim = Maximum cummulative extraction fossil fuels [GtC]
    miu = Emission control rate as fraction of GHG emissions (decision variable)
    s = Gross savings rate as fraction of gross world production (decision variable)
    tatm = Atmospheric Temperature Change [deg C since 1900]
    tocean = Oceanic Temperature Change [deg C since 1900]
    e = Total Emissions [GtCO2 per year]
    abatecost = Abatement Cost [Trillions 2005 USD]
    damages = Damages [Trillions 2005 USD]
    mat = Atmospheric CO2 [GtC]
    miu = Control Policy [Fraction of GWP]
    s = Savings Rate [Fraction of Net Production]
    forc = Radiative Forcing [Wm-2]
    scc = Social Cost of Carbon [USD per tonne CO2]",
    elasmu = "Elasticity of marginal utility of consumption",
    prstp = "Initial rate of social time preference (per year)",
    gama = "Capital elasticity in production function",
    pop0 = "Initial world population [Millions]",
    popadj = "Growth rate to calibrate to 2050 population projection",
    popasym = "Asymptotic world population [Millions]",
    dk = "Depreciation rate on capital (per year)",
    q0 = "Initial world gross output [Trillions 2005 US $]",
    k0 = "Initial capital value [Trillions 2005 US $]",
    a0 = "Initial level of total factor productivity (TFP)",
    ga0 = "Initial growth rate for TFP (per 5 years)",
    dela = "Decline rate of TFP (per 5 years)",
    optlrsav = "Optimal long-run savings rate used for transversality",
    gsigma1 = "Initial growth of sigma (per year)",
    dsig = "Decline rate of decarbonization (per period)",
    eland0 = "Carbon emissions from land 2010 [GtCO2 per year]",
    deland = "Decline rate of land emissions (per period)",
    e0 = "Industrial emissions 2010 [GtCO2 per year]",
    miu0 = "Initial emissions control rate for base case 2010",
    mat0 = "Initial concentration in atmosphere 2010 [GtC]",
    mu0 = "Initial concentration in upper strata [GtC]",
    ml0 = "Initial concentration in lower strata [GtC]",
    mateq = "Equilibrium concentration in atmosphere [GtC]",
    mueq = "Equilibrium concentration in upper strata [GtC]",
    mleq = "Equilibrium concentration in lower strata [GtC]",
    b12 = "Carbon control parameter - atmosphere -> upper strata",
    b23 = "Carbon control parameter - upper strata -> lower strata",
    b11 = "Carbon control parameter - atmosphere -> atmosphere",
    b21 = "Carbon control parameter - upper strata -> atmosphere",
    b22 = "Carbon control parameter - upper strata -> upper strata",
    b32 = "Carbon control parameter - lower strata -> upper strata",
    b33 = "Carbon control parameter - lower strata -> lower strata",
    t2xco2 = "Equilibrium temperature impact [dC per doubling CO2]",
    fex0 = "2010 forcings of non-CO2 greenhouse gases (GHG) [Wm-2]",
    fex1 = "2100 forcings of non-CO2 GHG [Wm-2]",
    tocean0 = "Initial lower stratum temperature change [dC from 1900]",
    tatm0 = "Initial atmospheric temperature change [dC from 1900]",
    c10 = "Initial climate equation coefficient for upper level",
    c1beta = "Regression slope coefficient (SoA~Equil TSC)",
    c1 = "Climate equation coefficient for upper level",
    c3 = "Transfer coefficient upper to lower stratum",
    c4 = "Transfer coefficient for lower level",
    fco22x = "Forcings of equilibrium CO2 doubling [Wm-2]",
    lam = "Climate model parameter",
    a10 = "Initial damage intercept",
    a20 = "Initial damage quadratic term",
    a1 = "Damage intercept",
    a2 = "Damage quadratic term",
    a3 = "Damage exponent",
    expcost2 = "Exponent of control cost function",
    pback = "Cost of backstop [2005$ per tCO2 2010]",
    gback = "Initial cost decline backstop [cost per period]",
    limmiu = "Upper limit on control rate after 2150",
    tnopol = "Period before which no emissions controls base",
    cprice0 = "Initial base carbon price [2005$ per tCO2]",
    gcprice = "Growth rate of base carbon price (per year)",
    periodfullpart = "Period at which have full participation",
    partfract2010 = "Fraction of emissions under control in 2010",
    partfractfull = "Fraction of emissions under control at full time",
    fosslim = "Maximum cummulative extraction fossil fuels [GtC]",
    miu = "Emission control rate as fraction of GHG emissions (decision variable)",
    s = "Gross savings rate as fraction of gross world production (decision variable)",
    tatm = "Atmospheric Temperature Change [deg C since 1900]",
    tocean = "Oceanic Temperature Change [deg C since 1900]",
    e = "Total Emissions [GtCO2 per year]",
    abatecost = "Abatement Cost [Trillions 2005 USD]",
    damages = "Damages [Trillions 2005 USD]",
    mat = "Atmospheric CO2 [GtC]",
    miu = "Control Policy [Fraction of GWP]",
    s = "Savings Rate [Fraction of Net Production]",
    forc = "Radiative Forcing [Wm-2]", 
    scc = "Social Cost of Carbon [USD per tonne CO2]",
    "NOT A DICE PARAMETER OR VARIABLE"
  )
  
  # Display the help message
  if(variable == "all") { cat(this.help)}
  else {
    cat(variable, "=", this.help)
  }
}


##------------ Model calculation functions -----------------------------------
#
# Functions that do the model calculations
#
#-----------------------------------------------------------------------------

.pow <- function(x,y) {
  x^y
}

.copy.env <- function(env) {
  as.environment(as.list(env, all.names=T))
}


##------------ .dice.calc.exog -------------------------------------------------
#
# Function that calculates the exogenous variables
#
#------------------------------------------------------------------------------
.dice.calc.exog <- function(dice) {
  
  # Make sure this is a DICE object
  .dice.check.obj(dice, deparse(substitute(dice)))
  
  # Initial time step
  dice$l[1] <- dice$pop0
  dice$ga[1] <- dice$ga0
  dice$al[1] <- dice$a0
  dice$gsig[1] <- dice$gsigma1
  dice$sig0 <- dice$e0 / (dice$q0 * (1 - dice$miu0))
  dice$sigma[1] <- dice$sig0
  dice$pbacktime[1] <- dice$pback
  dice$cost1[1] <- dice$pbacktime[1]*dice$sigma[1]/dice$expcost2/1000
  dice$etree[1] <- dice$eland0
  dice$rr[1] <- 1
  dice$forcoth[1] <- dice$fex0
  dice$partfract[1] <- dice$partfract2010
  dice$cpricebase[1] <- dice$cprice0
  dice$year[1] <- dice$startYear
  
  # Time series
  nPeriods <- dice$nPeriods
  for(t in 2:nPeriods) {
    dice$l[t] <- dice$l[t-1]*(.pow(dice$popasym/dice$l[t-1], dice$popadj))
    dice$ga[t] <- dice$ga0*exp(-1*dice$dela*dice$tstep*(t-1))
    dice$al[t] <- dice$al[t-1]/(1-dice$ga[t-1])
    dice$gsig[t] <- dice$gsig[t-1]*(.pow(1+dice$dsig, dice$tstep))
    dice$sigma[t] <- dice$sigma[t-1]*exp(dice$gsig[t-1]*dice$tstep)
    dice$pbacktime[t] <- dice$pback*.pow(1-dice$gback, t-1)
    dice$cost1[t] <- dice$pbacktime[t]*dice$sigma[t]/dice$expcost2/1000
    dice$etree[t] <- dice$eland0*.pow(1-dice$deland, t-1)
    dice$rr[t] <- 1/.pow(1+dice$prstp, dice$tstep*(t-1))
    dice$year[t] <- dice$year[t-1] + dice$tstep
    
    if (t < 20) {
      dice$forcoth[t] <- dice$fex0+(1.0/18.0)*(dice$fex1-dice$fex0)*(t-1)
    } else {
      dice$forcoth[t] <- dice$fex0+(dice$fex1-dice$fex0)
    }
    
    if (t >= dice$periodfullpart) {
      dice$partfract[t] <- dice$partfractfull
    } else {
      dice$partfract[t] <- dice$partfract2010+(dice$partfractfull-dice$partfract2010)*((t-1)/dice$periodfullpart)
    }
    
    dice$cpricebase[t] <- dice$cprice0*.pow(1+dice$gcprice, dice$tstep*(t-1))
    
  }
  
  # Transient TSC Correction ("Speed of Adjustment Parameter")
  dice$c1 <- dice$c10+dice$c1beta*(dice$t2xco2-2.9)
  
}


##------------ .dice.calc.endog.t ------------------------------------------------
#
# Function that calculates a timestep of the endogenous variables
#
#------------------------------------------------------------------------------
.dice.calc.endog.t <- function(dice, t) {
  
  # Does the DICE object exist?
  .dice.check.obj(dice, deparse(substitute(dice)))
  
  # Initial time step?
  if (t == 1) {
    
    # Climate and carbon variables --------
    dice$mat[1] <- dice$mat0
    if(dice$mat[1] < dice$mat_lo) {
      dice$mat[1] <- dice$mat_lo
    }
    
    dice$mu[1] <- dice$mu0
    if(dice$mu[1] < dice$mu_lo) {
      dice$mu[1] <- dice$mu_lo
    }
    
    dice$ml[1] <- dice$ml0
    if(dice$ml[1] < dice$ml_lo) {
      dice$ml[1] <- dice$ml_lo
    }
    
    dice$tatm[1] <- dice$tatm0
    if(dice$tatm[1] < dice$tatm_lo) {
      dice$tatm[1] <- dice$tatm_lo
    }
    if(dice$tatm[1] > dice$tatm_up) {
      dice$tatm[1] <- dice$tatm_up
    }
    
    dice$tocean[1] <- dice$tocean0
    if(dice$tocean[1] > dice$tocean_up) {
      dice$tocean[1] <- dice$tocean_up
    }
    if(dice$tocean[1] < dice$tocean_lo) {
      dice$tocean[1] <- dice$tocean_lo
    }
    
    dice$forc[1] <- dice$fco22x*(log(dice$mat[1]/588.000)/log(2.0))+dice$forcoth[1]
    
    # Economic variables -----------
    dice$mcabate[1] <- dice$pbacktime[1]*.pow(dice$miu[1],(dice$expcost2-1))
    
    dice$damfrac[1] <- dice$a1*dice$tatm[1]+dice$a2*.pow(dice$tatm[1],dice$a3)
    
    dice$k[1] <- dice$k0
    if(dice$k[1] < dice$k_lo) {
      dice$k[1] <- dice$k_lo
      dice$k_lo_step <- 0
    }
    
    dice$cprice[1] <- dice$pbacktime[1]*.pow((dice$miu[1]/dice$partfract[1]),(dice$expcost2-1))
    
    dice$ygross[1] <- dice$al[1]*.pow((dice$l[1]/1000.0),(1.0-dice$gama))*.pow(dice$k[1],dice$gama)
    
    if(dice$ygross[1] < dice$ygross_lo) {
      dice$ygross[1] <- dice$ygross_lo
      dice$ygross_lo_step <- 0
    }
    
    dice$ynet[1] <- dice$ygross[1]*(1.0-dice$damfrac[1])
    
    dice$abatecost[1] <- dice$ygross[1]*dice$cost1[1]*.pow(dice$miu[1],dice$expcost2)*.pow(dice$partfract[1],(1-dice$expcost2))
    
    dice$damages[1] <- dice$ygross[1]*dice$damfrac[1]
    
    dice$eind[1] <- dice$sigma[1]*dice$ygross[1]*(1.0-dice$miu[1])
    
    dice$e[1] <- dice$eind[1]+dice$etree[1]
    
    dice$cca[1] <- 90.0
    if(dice$cca[1] > dice$cca_up) {
      dice$cca[1] <- dice$cca_up
    }
    
    dice$y[1] <- dice$ynet[1]-dice$abatecost[1]
    if(dice$y[1] < dice$y_lo) {
      dice$y[1] <- dice$y_lo
    }
    
    dice$i[1] <- dice$s[1]*dice$y[1]
    if(dice$i[1] < dice$i_lo) {
      dice$i[1] <- dice$i_lo
    }
    
    dice$c[1] <- dice$y[1]-dice$i[1]
    if(dice$c[1] < dice$c_lo) {
      dice$c[1] <- dice$c_lo
    }
    
    dice$cpc[1] <- 1000.0*dice$c[1]/dice$l[1]
    if(dice$cpc[1] < dice$cpc_lo) {
      dice$cpc[1] <- dice$cpc_lo
    }
    
  } else {
    
    # Climate and carbon variables
    dice$mat[t] <- (dice$e[t-1]*(5.0/3.666))+dice$b11*dice$mat[t-1]+dice$b21*dice$mu[t-1]
    if(dice$mat[t] < dice$mat_lo) {
      dice$mat[t] <- dice$mat_lo
    }
    
    dice$mu[t] <- dice$b12*dice$mat[t-1]+dice$b22*dice$mu[t-1]+dice$b32*dice$ml[t-1]
    if(dice$mu[t] < dice$mu_lo) {
      dice$mu[t] <- dice$mu_lo
    }
    
    dice$ml[t] <- dice$b33*dice$ml[t-1]+dice$b23*dice$mu[t-1]
    if(dice$ml[t] < dice$ml_lo) {
      dice$ml[t] <- dice$ml_lo
    }
    
    dice$forc[t] <- dice$fco22x*(log(dice$mat[t]/588.000)/log(2.0))+dice$forcoth[t]
    
    dice$tatm[t] <- dice$tatm[t-1]+dice$c1*((dice$forc[t]-((dice$fco22x/dice$t2xco2)*dice$tatm[t-1]))-(dice$c3*(dice$tatm[t-1]-dice$tocean[t-1])))
    if(dice$tatm[t] < dice$tatm_lo) {
      dice$tatm[t] <- dice$tatm_lo
    }
    if(dice$tatm[t] > dice$tatm_up) {
      dice$tatm[t] <- dice$tatm_up
    }
    
    dice$tocean[t] <- dice$tocean[t-1]+dice$c4*(dice$tatm[t-1]-dice$tocean[t-1])
    if(dice$tocean[t] > dice$tocean_up) {
      dice$tocean[t] <- dice$tocean_up
    }
    if(dice$tocean[t] < dice$tocean_lo) {
      dice$tocean[t] <- dice$tocean_lo
    }
    
    # Economic variables
    dice$mcabate[t] <- dice$pbacktime[t]*.pow(dice$miu[t],(dice$expcost2-1))
    
    dice$damfrac[t] <- dice$a1*dice$tatm[t]+dice$a2*.pow(dice$tatm[t],dice$a3)
    
    dice$k[t] <- .pow((1-dice$dk),dice$tstep)*dice$k[t-1]+dice$tstep*dice$i[t-1]
    if(dice$k[t] < dice$k_lo) {
      dice$k[t] <- dice$k_lo
    }
    
    dice$cprice[t] <- dice$pbacktime[t]*.pow((dice$miu[t]/dice$partfract[t]),(dice$expcost2-1))
    
    dice$ygross[t] <- dice$al[t]*.pow((dice$l[t]/1000.0),(1.0-dice$gama))*.pow(dice$k[t],dice$gama)
    if(dice$ygross[t] < dice$ygross_lo) {
      dice$ygross[t] <- dice$ygross_lo
    }
    
    dice$ynet[t] <- dice$ygross[t]*(1.0-dice$damfrac[t])
    
    dice$abatecost[t] <- dice$ygross[t]*dice$cost1[t]*.pow(dice$miu[t],dice$expcost2)*.pow(dice$partfract[t],(1-dice$expcost2))
    
    dice$damages[t] <- dice$ygross[t]*dice$damfrac[t]
    
    dice$eind[t] <- dice$sigma[t]*dice$ygross[t]*(1.0-dice$miu[t])
    
    dice$e[t] <- dice$eind[t]+dice$etree[t]
    
    dice$cca[t] <- dice$cca[t-1]+dice$eind[t-1]*5.0/3.666
    if(dice$cca[t] > dice$cca_up) {
      dice$cca[t] <- dice$cca_up
    }
    
    dice$y[t] <- dice$ynet[t]-dice$abatecost[t]
    if(dice$y[t] < dice$y_lo) {
      dice$y[t] <- dice$y_lo
    }
    
    dice$i[t] <- dice$s[t]*dice$y[t]
    if(dice$i[t] < dice$i_lo) {
      dice$i[t] <- dice$i_lo
    }
    
    dice$c[t] <- dice$y[t]-dice$i[t]
    if(dice$c[t] < dice$c_lo) {
      dice$c[t] <- dice$c_lo
    }
    
    dice$cpc[t] <- 1000.0*dice$c[t]/dice$l[t]
    if(dice$cpc[t] < dice$cpc_lo) {
      dice$cpc[t] <- dice$cpc_lo
    }
    
    dice$ri[t-1] <- (1.0+dice$prstp)*.pow((dice$cpc[t]/dice$cpc[t-1]),(dice$elasmu/dice$tstep))-1.0
  }
}


##------------ .dice.calc.endog ----------------------------------------------
#
# Calculates the entire time series of endogenous variables
#
#------------------------------------------------------------------------------
.dice.calc.endog <- function(dice){
  
  # Does the DICE object exist?
  .dice.check.obj(dice, deparse(substitute(dice)))
  
  # Calculate the endogenous variables
  nPeriods <- dice$nPeriods
  for(t in 1:nPeriods) {
    .dice.calc.endog.t(dice, t)
  }
}


##------------ .dice.postprocess ----------------------------------------------
#
# Function that post-processes the model
#
#------------------------------------------------------------------------------
.dice.postprocess <- function(dice){
  
  # Does the DICE object exist?
  .dice.check.obj(dice, deparse(substitute(dice)))
  
  # Calculate the utility
  dice$periodu <- (.pow((dice$c*1000.0/dice$l),(1.0-dice$elasmu))-1.0)/(1.0-dice$elasmu)-1.0
  dice$cemutotper <- dice$periodu*dice$l*dice$rr
  dice$utility <- (sum(dice$cemutotper)*dice$tstep*dice$scale1) + dice$scale2
}


##------------ .dice.calc.model --------------------------------------------
#
# Calculates a single full iteration of the model
#
#---------------------------------------------------------------------------
.dice.calc.model <- function(dice) {
  
  # Check the function arguments
  .dice.check.obj(dice, deparse(substitute(dice)))
  
  # Process the model
  .dice.calc.exog(dice)
  .dice.calc.endog(dice)
  .dice.postprocess(dice)
  
}


##------------ Error checking functions --------------------------------------
#
# Series of functions that checks for some common errors.
#
#-----------------------------------------------------------------------------

.dice.check.obj <- function(dice, dice.name) {
  if(! is.environment(dice)) { stop("\"", dice.name, "\" is not a valid dice object", call.=F)}
}

.dice.check.varexist <- function(dice, this.var, dice.name) {
  if(! this.var %in% ls(dice)) { stop("Cannot find \"", this.var, "\" in \"", dice.name, "\"", call.=F)}
}

.dice.check.vartype <- function(dice, this.var, this.val) {
  if(! is.numeric(this.val)) { stop("\"", this.var, "\" expects numeric values", call.=F)}
}

.dice.check.vardim <- function(dice, this.var, this.val) {
  var.length <- switch(this.var, 
                       miu = ,
                       miu.up = ,
                       s = dice$nPeriods,
                       1)
  if (length(this.val) != var.length) { stop("\"", this.var, "\" should be of length ", var.length, call.=F)}
}