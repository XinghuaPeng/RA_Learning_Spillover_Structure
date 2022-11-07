
## CLEAN ENVIRONMENT
rm(list = ls())
graphics.off()

## INSTALL & LOAD PACKAGES
library(pacman)
pacman::p_load(tidyverse, readr,ggplot2, readxl, dplyr, 
               grid, tidyr, plotrix, matrixStats, tidyselect,boot, compiler,LowRankQP) 

## SET WROK DIRECOTORY
setwd("~/lss/empirical_application_R/") 

#-------------------
## DATA CLEANING
#--------------------

source("code/data_clean.R")

#-------------------
## SCM estimation for CA
#--------------------

## LOAD MODELS
source("functions/fcn_estimation_intercept.R")
source("functions/scm_batch.R")

weights_batch = scm_batch_weights(pretreat)

cp.sum = subset(cp,select=c(ncol(cp),3))

# DD: average of rest of states except CA 
cp.sum$DD = rowMeans(subset(cp,select=(1:ncol(cp))[-c(3,ncol(cp))]))

pretreat = as.matrix(subset(cp,cp$years<1989,select=-c(years,CA)))
weights = scm.estimator(cp$CA[cp$years<1989],pretreat)
pred.periods = as.matrix(subset(cp,select=-c(years,CA)))
pred.periods = cbind(1,pred.periods)
all(colnames(pred.periods)==names(weights))

# SCM estimates of CA
cp.sum$scm_CA = pred.periods%*%weights

# Gap between CA and SCM
cp.sum$gap_CA <- cp.sum$CA - cp.sum$scm_CA


#-------------------
## Inference by Placebo Test 
#--------------------

source("functions/fcn_inference.R")


#-------------------
## Plot
#--------------------

source("code/plot.R")



