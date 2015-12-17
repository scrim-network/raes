# convert_all.R
# Randy Miller
# rsm5139@psu.edu
#
# Last updated on: 17 December 2015
#
# This script takes all of the textbook files written in R Markdown and
# converts them to PDF and HTML files. 

# License: GNU General Public License version 3

# Usage
# The purpose of this script is to allow users without a local copy of 
# RStudio to convert all of the R Mardown files. Therefore, it is designed 
# to be executed in a Linux environment.
# From the command line, type the following and press 'Enter':

# ./convert_all.R

render("summary.Rmd", "all")