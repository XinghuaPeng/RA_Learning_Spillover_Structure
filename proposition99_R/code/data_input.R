# This script cleans the data and generates all variables needed.

# Y: N-by-(T+S) outcome matrix with first row being treated unit
# N: number of units
# T: number of pre-treatment time periods
# S: number of post-treatment time periods
# A: matrix of spillover exposure

## GENERATE Y, N, T, S

# set CA position in the dataset
  if (state_num == 38) {
     CA_position <- 3
  } else {
    CA_position <- 5
  }
  
# input the 50 states spillover table 
  state_list <- read.csv("data/state_list.csv")
  
# input 50 states data
  state_data_50 <- read.csv('data/cigs_consumption.csv')
  
  state_list_data <- merge(state_data_50,state_list)
  
# exclude data which not belongs to 38 states list
  if (state_num == 38) {
  state_list_data <- subset(missing12 != 1)
  } 
  
  data <- table(state_list_data$year, state_list_data$cigs)
  
  data <- array(data)
  
  states <- state_list_data$state

  state <- unique(states)
  
  year <- unique(data[,1])
  
  N <- length(state)
  T <- 1989 - 1970
  S <- length(year) - T
  install.packages('reshape2')
  library(reshape2)
  cig <- reshape(data(,missing12 == 2),T+S,N) #???
  cig <- cig #???
  CA <- cig[CA_position,] # 3 in 38states, 5 in 50states
  cig[CA_position,] = [] # 3 in 38states, 5 in 50states
  cig <- [CA;cig]
  Y <- cig # outcome matrix
  
  # EXCLUDE STATES NAME WHICH NOT BELONGS TO 38 STATES LIST
  
  if (state_num <- 38) {
  state_list <- state_list[subset(state_list.missing12 == 1),]
  }
  
  ## GENERATE A  
  
  unitInd <- state_list$treated # start with treated unit
  for (i in 1 : length(spilloverVarList))
  # add spillover units to the unit list
  {
    unitInd = unitInd|state_list.(string(spilloverVarList(i))) #???
  }
  
  A <- diag(N)
  A <- A [, unitInd] # delete unaffected columns  
  
