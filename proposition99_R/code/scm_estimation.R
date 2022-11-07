
Y_pre = Y[ , 1:T] 
Y_post = Y[ , T+1:end]

# synthetic control weights and intercepts for all units 

source("functions/scm_batch_matlab.R")
scm_batch = scm_batch(Y_pre)

a_hat = scm_batch$a_hat
B_hat = scm_batch$B_hat

synthetic_control_scm = a_hat[1] + B_hat[1,] %*% Y # vanilla SCM 

teEstimateSCM = CA - synthetic_control_scm 
