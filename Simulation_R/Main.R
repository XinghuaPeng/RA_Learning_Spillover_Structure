
## CLEAR
rm(list = ls())
graphics.off()
set.seed(7)
setwd("~/lss/Simulation_R")

## package loading
library(iterators)
library(parallel)
library(pracma)
library(foreach)
library(doParallel)


time1 <- Sys.time()

S <- 1000
N_vec <- c(10,30,50)
T_vec <- c(15,50,200)
l_N <- length(N_vec)
l_T <- length(T_vec)

result_mat <- matrix(0, 4, 9)
loop <- 0

for (i_N in 1 : l_N)
{
  for (i_T in 1 : l_T)
 {
N <- N_vec[i_N]
T <- T_vec[i_T]
T1 <- T+1

mu_mat_1 = runif(N, min = 0, max = 1) # factor loadings - predetermined for each simulation
mu_mat_2 = runif(N, min = 0, max = 1)
mu_mat_3 = runif(N, min = 0, max = 1)

mu_mat <- rbind (mu_mat_1, mu_mat_2, mu_mat_3)


alpha <- matrix (0, N, 1)
  spillover <- 3
  alpha[1] <- 5
  
  #spillover type: 1 = concentrate sp; 2 = spreadout
  sp_type <- 1
  alpha1 <- alpha[1] # wrong position? alpha1 = 5 here
  
  
  for (i in 2 : ceiling(sp_type * N/3))
  {    
    alpha[i] <- spillover
   }

# vector for saving alpha
alpha1_SC_vec <- matrix(0, S, 1)
#alpha1_lasso_vec <- matrix(0, S, 1)
alpha1_sp_vec <- matrix(0, S, 1)


# Create a cluster and register
parallel::detectCores()
n.cores <- parallel::detectCores() - 5

my.cluster <- parallel::makeCluster(
  n.cores, 
  type = "FORK"
)

#check cluster definition (optional)
print(my.cluster)

#register it to be used by %dopar%
doParallel::registerDoParallel(cl = my.cluster)

# Parfor in MATLAB
result_dopar <- foreach(s = 1:S, .combine = 'rbind') %dopar% {

set.seed(s)

## common factors
delta <- matrix (0, T1, 1)
delta[1] <- rnorm(1)/sqrt(1-.5^2)+1/(1-.5)
lambda1 <- matrix (0, T1, 1)
lambda1[1] <- rnorm(1)/sqrt(1-.5^2)
nu2 <- rnorm(T1,1)
lambda2 <- matrix (0, T1, 1)
lambda2[1] <- 1+ nu2[1]+rnorm(1)
nu3 <- rnorm(T1,1)
lambda3 <- matrix (0, T1, 1)
lambda3[1] <- 0+nu3[1]+rnorm(1)
for (t in 2 : T1)
{
delta[t] <- 1+.5*delta[t-1]+rnorm(1)
lambda1[t] <- .5*lambda1[t-1]+rnorm(1)
lambda2[t] <- 1+nu2[t]+.5*nu2[t-1]
lambda3[t] <- .5*lambda3[t-1]+nu3[t]+.5*nu3[t-1]
}

lambda_mat <- cbind(lambda1, lambda2, lambda3)

epsilon <- rnorm (N,T1) # shocks

# counterfactural value
Y0_mat <- repmat(t(delta), N, 1) + t(lambda_mat%*%mu_mat) + epsilon
                
# observed outcomes
Y_T0 <- Y0_mat[,1:T]
Y_T1 <- Y0_mat[,T1] + alpha
Y <- cbind(Y_T0, Y_T1) # merged outcome
                
## naive synthetic control
# synthetic control weights and intercepts for all units
source("functions/scm_batch.R")
weights_batch = scm_batch_weights(t(Y_T0))

a_hat = weights_batch$A_hat
B_hat = weights_batch$B_hat

### SP with known structure
ind <- matrix(0, N, 1)
ind[1] <- 1 # count first unit
for (i in 2:ceiling(sp_type*N/3))
{
  ind[i] = 1
}

A <- diag(N)
A = A[,ind == 1]

M_hat <- t((diag(N)-B_hat))*(diag(N)-B_hat)
gamma_hat <- solve((t(A)%*%M_hat%*%A))%*% ((t(A)%*%t(diag(N)-B_hat))%*%((diag(N)-B_hat)%*%Y_T1-a_hat))
alpha_sp <- A %*% gamma_hat
alpha1_sp <- alpha_sp[1]
#alpha1_sp_vec[s] <- alpha1_sp

synthetic_control_scm <- a_hat[1] + B_hat[1,] %*% Y # vanilla SCM

teEstimateSCM <- Y[1,] - synthetic_control_scm

alpha1_SC <- teEstimateSCM[T+1]
# alpha1_SC_vec[s] <- alpha1_SC

c(alpha_sp[1], teEstimateSCM[T+1]) # output result for each dopar, combind them using rbind

}

# Close Cluster
parallel::stopCluster(cl = my.cluster)

# Store result from dopar result
alpha1_SC_vec = result_dopar[,1]
alpha1_sp_vec = result_dopar[,2]

loop <- loop + 1
                
result_mat[,loop] <- c(mean(alpha1_SC_vec)-alpha1, var(alpha1_SC_vec), mean(alpha1_sp_vec)-alpha1, var(alpha1_sp_vec))

  }
}

result_mat

# Timer
time2 <- Sys.time()
print(time2 - time1)


# Output Table
write.csv(result_mat, file = "output/result_mat1000.csv")

