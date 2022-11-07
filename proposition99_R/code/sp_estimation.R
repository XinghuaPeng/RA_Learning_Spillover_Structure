
Y_pre = Y[,1:T]
Y_post = Y[, T+1:ncol(Y)]

# synthetic control weights and intercepts for all units
source("functions/scm_batch_matlab.R")
scm_batch = scm_batch(Y_pre)
a_hat = scm_batch$a_hat
B_hat = scm_batch$B_hat

M_hat <- t((diag(N)-B_hat))*(diag(N)-B_hat) # M=(I-B)'(I-B)
synthetic_contril_sp = a_hat[1] + B_hat[1,]%*%Y_pre

# Create Table for saving spillover effect table 
Table_spillover = table
state_name = state_name
state_name[CA_position, ] = NULL 
state_name = c('CA', state_name)

Table_spillover$state = state_name

alpha1_hat_vec = zeros(1,S) # treatment effect estimator 

# specification for spillovers 
indAZ = which(state_list == "AZ",arr.ind = TRUE)
indNV = which(state_list == "NV",arr.ind = TRUE)
indOR = which(state_list == "OR",arr.ind = TRUE)
alphaAZ = zeros(1,S)
alphaNV = zeros(1,S)
alphaOR = zeros(1,S)

for (s in 1:S){
  Y_Ts = Y[,T+s]
  gamma_hat <- solve((t(A)%*%M_hat%*%A))%*% ((t(A)%*%t(diag(N)-B_hat))%*%((diag(N)-B_hat)%*%Y_Ts-a_hat))
  alpha_hat = A%*%gamma_hat 
  alpha1_hat_vec[s] = alpha_hat[1]
  synthetic_contril_sp[T+s] = Y[1, T+s] - alpha1_hat_vec[s]
  
  # spillover effects 
  alphaAZ[s] = alpha_hat[indAZ]
  alphaNV[s] = alpha_hat[indNV]
  alphaOR[s] = alpha_hat[indOR]
  
  ## loop for spillover effect table 
  s_year = s + 1988 
  Table_spillover$alpha_hat =  alpha_hat
  Table_spillover <- Table_spillover %>% 
    rename("alpha_hat" = as.character(s_year) )
}

write.csv(Table_spillover, file = "output/spillover.csv")

teEstimateSP = CA-synthetic_control_sp


