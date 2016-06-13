#!/usr/local/bin/Rscript
# make.R
# Randy Miller
# rsm5139@psu.edu
#
# Last updated on: 13 June 2016
#
# This script takes all of the textbook files written in R Markdown and
# converts them to PDF files.

# License: GNU General Public License version 3

# Usage
# The purpose of this script is to allow users without a local copy of
# RStudio to convert all of the R Mardown files. Therefore, it is designed
# to be executed in a Linux environment, or in the R gui.

# Required packages: rmarkdown, animation
# Other required software: pandoc, latex
# Optional: poppler for the pdfunite command to merge the files

# From the command line, type the following and press 'Enter':

# ./make.R

# R Markdown library
library("rmarkdown")

# Create directory for the resulting PDF documents
dir.create("pdf")

# Copy cover photo and title page to pdf folder
file.copy("src/cover_with_alexander.pdf", "pdf")
file.copy("src/title_page.pdf", "pdf")

# Render the combined book
render("src/main.Rmd", "pdf_document", output_dir = "pdf", output_file = "main.pdf")

# Create the scripts directory for the supplemental scripts
dir.create("scripts")

# Render files for the scripts directory
render("src/sample_scripts/LICENSE_GPLv3.Rmd", "pdf_document", output_dir = "scripts", output_file = "LICENSE_GPLv3.pdf")
render("src/sample_scripts/README.Rmd", "pdf_document", output_dir = "scripts", output_file = "README.pdf")

# Copy the supplemental scripts and PDFs to the scripts directory
file.copy("src/sample_scripts/dice.R", "scripts")
file.copy("src/sample_scripts/lab0_sample.R", "scripts")
file.copy("src/sample_scripts/lab1_sample.R", "scripts")
file.copy("src/sample_scripts/lab3_sample.R", "scripts")
file.copy("src/sample_scripts/lab4_sample.R", "scripts")
file.copy("src/sample_scripts/lab5_sample.R", "scripts")
file.copy("src/sample_scripts/lab8_sample.R", "scripts")
file.copy("src/sample_scripts/LICENSE_GPLv3.pdf", "scripts")
file.copy("src/sample_scripts/README.pdf", "scripts")

system("pdfunite pdf/cover_with_alexander.pdf pdf/title_page.pdf pdf/main.pdf raes_v1p2.pdf")