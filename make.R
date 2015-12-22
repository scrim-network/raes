#!/usr/local/bin/Rscript
# make.R
# Randy Miller
# rsm5139@psu.edu
#
# Last updated on: 22 December 2015
#
# This script takes all of the textbook files written in R Markdown and
# converts them to PDF and HTML files. 

# License: GNU General Public License version 3

# Usage
# The purpose of this script is to allow users without a local copy of 
# RStudio to convert all of the R Mardown files. Therefore, it is designed 
# to be executed in a Linux environment, or in the R gui.

# Required packages: rmarkdown, animation
# Other required software: pandoc, latex

# From the command line, type the following and press 'Enter':

# ./make.R

# R Markdown library
library("rmarkdown")

# Create directory for the resulting PDF documents
dir.create("pdf")

# Copy cover photo to pdf folder
file.copy("source/figures/cover_with_alexander.pdf", "pdf")

# Render the markdown files and place the resulting PDFs in the pdf directory
render("source/cover.Rmd", "pdf_document", output_dir = "pdf", output_file = "01_cover.pdf")
render("source/summary.Rmd", "pdf_document", output_dir = "pdf", output_file = "02_summary.pdf")
render("source/chap_list.Rmd", "pdf_document", output_dir = "pdf", output_file = "03_chap_list.pdf")
render("source/contrib_bios.Rmd", "pdf_document", output_dir = "pdf", output_file = "04_contrib_bios.pdf")
render("source/acknowledgements.Rmd", "pdf_document", output_dir = "pdf", output_file = "05_acknowledgements.pdf")
render("source/intro.Rmd", "pdf_document", output_dir = "pdf", output_file = "06_into.pdf")
render("source/lab0_doc.Rmd", "pdf_document", output_dir = "pdf", output_file = "07_lab0_doc.pdf")
render("source/lab1_doc.Rmd", "pdf_document", output_dir = "pdf", output_file = "08_lab1_doc.pdf")
render("source/lab2_doc.Rmd", "pdf_document", output_dir = "pdf", output_file = "09_lab2_doc.pdf")
render("source/lab3_doc.Rmd", "pdf_document", output_dir = "pdf", output_file = "10_lab3_doc.pdf")
render("source/lab4_doc.Rmd", "pdf_document", output_dir = "pdf", output_file = "11_lab4_doc.pdf")
render("source/lab5_doc.Rmd", "pdf_document", output_dir = "pdf", output_file = "12_lab5_doc.pdf")
render("source/lab6_doc.Rmd", "pdf_document", output_dir = "pdf", output_file = "13_lab6_doc.pdf")
render("source/lab7_doc.Rmd", "pdf_document", output_dir = "pdf", output_file = "14_lab7_doc.pdf")
render("source/lab8_doc.Rmd", "pdf_document", output_dir = "pdf", output_file = "15_lab8_doc.pdf")
render("source/license.Rmd", "pdf_document", output_dir = "pdf", output_file = "16_license.pdf")

# Create directory for the resulting HTML documents
dir.create("html")

# Copy cover photo to html folder
file.copy("source/figures/cover_with_alexander.png", "html")

# Render the markdown files and place the resulting HTML documents in the html directory
render("source/cover.Rmd", "html_document", output_dir = "html", output_file = "01_cover.html")
render("source/summary.Rmd", "html_document", output_dir = "html", output_file = "02_summary.html")
render("source/contrib_bios.Rmd", "html_document", output_dir = "html", output_file = "03_contrib_bios.html")
render("source/acknowledgements.Rmd", "html_document", output_dir = "html", output_file = "04_acknowledgements.html")
render("source/intro.Rmd", "html_document", output_dir = "html", output_file = "05_into.html")
render("source/lab0_doc.Rmd", "html_document", output_dir = "html", output_file = "06_lab0_doc.html")
render("source/lab1_doc_v2.Rmd", "html_document", output_dir = "html", output_file = "07_lab1_doc.html")
render("source/lab2_doc.Rmd", "html_document", output_dir = "html", output_file = "08_lab2_doc.html")
render("source/lab3_doc.Rmd", "html_document", output_dir = "html", output_file = "09_lab3_doc.html")
render("source/lab4_doc.Rmd", "html_document", output_dir = "html", output_file = "10_lab4_doc.html")
render("source/lab5_doc.Rmd", "html_document", output_dir = "html", output_file = "11_lab5_doc.html")
render("source/lab6_doc.Rmd", "html_document", output_dir = "html", output_file = "12_lab6_doc.html")
render("source/lab7_doc.Rmd", "html_document", output_dir = "html", output_file = "13_lab7_doc.html")
render("source/lab8_doc.Rmd", "html_document", output_dir = "html", output_file = "14_lab8_doc.html")
render("source/license.Rmd", "html_document", output_dir = "html", output_file = "15_license.html")

# Create the scripts directory for the supplemental scripts
dir.create("scripts")

# Copy the supplemental scripts to the scripts directory
file.copy("source/scripts/dice.R", "scripts")
file.copy("source/scripts/lab0_sample.R", "scripts")
file.copy("source/scripts/lab1_sample.R", "scripts")
file.copy("source/scripts/lab3_sample.R", "scripts")
file.copy("source/scripts/lab4_sample.R", "scripts")
file.copy("source/scripts/lab5_sample.R", "scripts")
file.copy("source/scripts/lab8_sample.R", "scripts")

# Render the README file
render("source/README.Rmd", "pdf_document", output_dir = ".")