# Risk Analysis in the Earth Sciences: A Lab Manual with Exercises in R

Edited by Patrick J. Applegate and Klaus Keller

Contributions by Patrick J. Applegate, Ryan L. Sriver, Gregory G. Garner, Alexander Bakker, Richard B. Alley, and Klaus Keller

## Preamble

This Github repository contains the complete source code needed to generate the freely-available e-textbook, *Risk Analysis in the Earth Sciences: A Lab Manual with Exercises in R*, version 1.2 (updated 13 June 2016).  The repository also contains the code examples that accompany the book.  

If you find this material useful, please download a `.pdf` copy of the book from https://leanpub.com/raes.  We use the download counter on Leanpub to track use of the book.  

The exercise scripts are also available from http://scrimhub.org/resources/raes/.  

We’d like to make *Risk Analysis in the Earth Sciences* as useful as possible. If you have a comment about the book or a question about one of the exercises, please post an issue to this Github repository. 

## Introduction

Greenhouse gas emissions have caused considerable changes in climate, including increased surface air temperatures and rising sea levels.  Rising sea levels increase the risks of flooding for people living near the world's coastlines.  Managing such risks requires an understanding of many fields, including Earth science, statistics, and economics.  At the same time, the free, open-source programming environment R is growing in popularity among statisticians and scientists due to its flexibility and graphics capabilities, as well as its large collection of existing software libraries.  

*Risk Analysis in the Earth Sciences: A Lab Manual with Exercises in R* teaches the Earth science and statistical concepts needed for assessing climate-related risks.  These exercises are intended for upper-level undergraduates, beginning graduate students, and professionals in other areas who wish to gain insight into academic climate risk analysis.  

This work was supported by the National Science Foundation through the Network for Sustainable Climate Risk Management (SCRiM) under NSF cooperative agreement GEO-1240507. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation. Other support was provided by the Center for Climate Risk Management and the Rock Ethics Institute.

## Compiling This Book  

The `.pdf` version of the book was created using [R Markdown](http://rmarkdown.rstudio.com), which allows for dynamic document creation through the use of markdown syntax and R code.  We used R version 3.3.0 to compile the book.  

### Requirements  

You'll need the following R packages and Unix utilities to compile the book.  

* R packages
	- `rmarkdown` (0.9.6)
	- `animation` (2.4)
* Unix utilities
	- pandoc (1.13.1)  
	- pdfTeX (1.40.12)  
	- ghostscript (9.14)  

### Compilation Instructions

To compile this textbook through a command line interface, type ```./make.R``` from the root directory of the project folder. The book can also be created from within R or RStudio by sourcing the make.R file.
