sp_andrews = function(Y0, Y1, A, C, d, alpha_sig) {
  #SP_ANDREWS The proposed test in Cao and Dowd (2019). 
  # sp_andrews(Y0,Y1,A,C,d) returns 1 if the test rejects the null hypothesis
  # C*alpha=d, and 0 otherwise. 
  
  T = ncol(Y0)
  N = nrow(Y0)
  
  # corrected synthetic control
  scm_batch = scm_batch(Y0)
  a_hat = scm_batch$a_hat
  B_hat = scm_batch$B_hat
  M_hat <- t((diag(N)-B_hat))*(diag(N)-B_hat)
  gamma_hat <- solve((t(A)%*%M_hat%*%A))%*% ((t(A)%*%t(diag(N)-B_hat))%*%((diag(N)-B_hat)%*%Y1-a_hat))
  alpha_hat <- A %*% gamma_hat
  
  P <- t(C%*%alpha_hat - d)%*%(C%*%alpha_hat-d) # test statistic
  G_hat = A%*%(solve((t(A)%*%M_hat%*%A))%*%t(A))%*%t(diag(N)-B_hat)
  
  P_t = zeros(T,1)
  for (t in 1:T)  
  {
    a_t = a_hat 
    B_t = B_hat 
    P_t[t] = t(Y0[,t] - (a_t + B_t %*% Y0[,t])) %*% t(G_hat) %*% t(C) %*% C %*% G_hat %*% (Y0[,t]-(a_t +B_t %*%Y0[,t])) 
  }
  
  test = as.numeric( P > quantile(P_t, probs = 1-alpha_sig) ) 
  return(test)
}
  