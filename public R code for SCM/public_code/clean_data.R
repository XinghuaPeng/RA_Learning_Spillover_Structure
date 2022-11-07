#---------------------------------------------
#     Cleaning Data for Cigarrette Example
#---------------------------------------------
# This is R code by Connor Dowd, ported from
# matlab code by Jianfei Cao, which can be found
# at: 
# https://voices.uchicago.edu/jianfeicao/research/
#
#

library(readxl)
library(dplyr)
library(tidyr)


#---------------------------------------------
#           Data input
#---------------------------------------------
#Data is from Abadie, Diamond, and Hainmueller (2010).
data = read_xls(data_loc)
data = as_tibble(data)
#Drop extraneous variables
data = data %>% select(state,year,cigs)
#Grab states, years
states = data %>% select(state) %>% unique()
years = data %>% select(year) %>% arrange() %>% unique()
n = nrow(states)
t = 1989-1970
s = nrow(years)-t

#Rearrange for SCM code
data = data %>% spread(state,cigs)

#Shift to matrix
cigs = as.matrix(data[,2:(n+1)])
rownames(cigs) = as.character(data$year)

#Moving treated unit to first column
treat.unit = "CA"
ind = which(colnames(cigs)==treat.unit)
cigs = cbind(cigs[,ind],cigs[,-ind])
colnames(cigs)[1] = treat.unit

save.image("cigs.RData")


