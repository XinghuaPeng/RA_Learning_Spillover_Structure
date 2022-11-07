#---------------------------------------------
#              Run Code
#---------------------------------------------
# This is R code by Connor Dowd, ported from
# matlab code by Jianfei Cao, which can be found
# at: 
# https://voices.uchicago.edu/jianfeicao/research/
# 

setwd("~/scm/public_code/")
#Indicator for running data cleaning. 
#Will require some external packages.
clean.data = F
#Indicator for running leave-one-out, Normal inference
loo = F
normal = F

#File names.
data_loc = "cigs.xls"
function_loc = "functions.R"

#Clean or load data
if (clean.data) {
  source("clean_data.R")
} else {
  load("cigs.RData")
}



#---------------------------------------------
#              Model Building
#---------------------------------------------
#Build interference matrix
#indicators of all possibly affected states
ind = c(1,0,0,0,1,1,0,0,1,0,0,0,0,0,1,0,0,0,0,
        0,0,0,1,1,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0)
affected.states = states[which(!!ind),]
# Surrounding states and the Northeast.

# All possible states
A = diag(n)
#Interact the two
A = A[,which(!!ind)]

# Pull apart pre-treatment and post-treatment
Y0 = cigs[1:t,]
Y1 = cigs[1:s + t,]


#---------------------------------------------
#              Run Models
#---------------------------------------------

source(function_loc)

all_post_periods = lapply(1:s,
          function(i) sp_andrews_te(Y0,Y1[i,],A,
                  loo,normal))

#Testing treatment effect on CA
tau_t  = sapply(all_post_periods,
               function(x) x$Estimates[1])
pval_t = sapply(all_post_periods,
               function(x) x$pval)
ci_t   = sapply(all_post_periods,
               function(x) x$CI)


#---------------------------------------------
#              NOTES
#---------------------------------------------
# Original Matlab code also performs inference 
# on spillover effects, plots the data, and 
# estimates the actual synthetic control points. 




