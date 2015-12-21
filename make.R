#!/usr/local/bin/Rscript
# make.R
# Randy Miller
# rsm5139@psu.edu
#
# Last updated on: 21 December 2015
#
# This script takes all of the textbook files written in R Markdown and
# converts them to PDF and HTML files. 

# License: GNU General Public License version 3

# Usage
# The purpose of this script is to allow users without a local copy of 
# RStudio to convert all of the R Mardown files. Therefore, it is designed 
# to be executed in a Linux environment, or in the R gui.

# Required packages: rmarkdown
# Other required software: pandoc, latex

# From the command line, type the following and press 'Enter':

# ./make.R

# R Markdown library
library("rmarkdown")

dir.create("pdf")

# copy cover photo to pdf folder
file.copy("source/figures/cover_with_alexander.pdf", "pdf")

render("source/cover.Rmd", "pdf_document", output_dir = "pdf")
render("source/summary.Rmd", "pdf_document", output_dir = "pdf")
render("source/chap_list.Rmd", "pdf_document", output_dir = "pdf")
render("source/contrib_bios.Rmd", "pdf_document", output_dir = "pdf")
render("source/acknowledgements.Rmd", "pdf_document", output_dir = "pdf")
render("source/intro.Rmd", "pdf_document", output_dir = "pdf")
render("source/lab0_doc.Rmd", "pdf_document", output_dir = "pdf")
render("source/lab1_doc.Rmd", "pdf_document", output_dir = "pdf")
render("source/lab2_doc.Rmd", "pdf_document", output_dir = "pdf")
render("source/lab3_doc.Rmd", "pdf_document", output_dir = "pdf")
render("source/lab4_doc.Rmd", "pdf_document", output_dir = "pdf")
render("source/lab5_doc.Rmd", "pdf_document", output_dir = "pdf")
render("source/lab6_doc.Rmd", "pdf_document", output_dir = "pdf")
render("source/lab7_doc.Rmd", "pdf_document", output_dir = "pdf")
render("source/lab8_doc.Rmd", "pdf_document", output_dir = "pdf")
render("source/license.Rmd", "pdf_document", output_dir = "pdf")