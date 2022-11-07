## CLEAN ENVIRONMENT
rm(list = ls())
graphics.off()

## INSTALL & LOAD PACKAGES
library(pacman)
pacman::p_load(tidyverse, readr,ggplot2, readxl, dplyr, 
               grid, tidyr, plotrix, matrixStats, 
               tidyselect,boot, compiler,LowRankQP) 

## SET WROK DIRECOTORY
setwd("~/lss/proposition99_R/") 

#------------------------------------------------------------------------------
## CONFIGURATION
alpha_sig = 0.05 # significant level
source("code/data_cleaning.R") 

#------------------------------------------------------------------------------

## SCM WITH 38 STATES

# data input 
state_num = 38 
spilloverVarlist = c()
source("code/data_input.R") 

# estimation 

source("code/scm_estimation.R")

#------------------------------------------------------------------------------
## ACCOUNTING FOR SPILLOVERS WITH 50 STATES

# data input 
state_num = 50
spilloverVarList = c('missing12','neighbor')
source("code/data_input.R") 

# treatment effects estimation 
source("code/sp_estimation.R") 

# treatment effects inference
source("code/sp_inference.R") 

#------------------------------------------------------------------------------
## OUTPUT
source("code/output_results.R") 

