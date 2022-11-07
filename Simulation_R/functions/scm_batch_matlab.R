scm_batch = function(Y) {
  # SCM_BATCH Synthetic control weights for each row.
  # [a_hat,B_hat] = scm(Y), for pre-treatment outcome matrix Y calculates all 
  # synthetic control weights, using each row as the treated and the others 
  # as the controls, separately. For the i-th unit, the i-th entry of a_hat 
  # is the synthetic control intercept and the i-th row of B_hat is the 
  # synthetic control weights. 
  T = ncol(Y)
  N = nrow(Y)
  a_hat = zeros(N,1)
  B_hat = zeros(N)
  
  for (i in 1:N) 
    {
    Y_treated = t(Y[i,])
    temp = Y
    temp = temp[-i,]
    Y_untreated = t(temp)
    
    Y_demeaned = Y_treated - mean(Y_treated) 
    X_demeaned = Y_untreated - repmat(colMeans(Y_untreated),T,1) 
    
    b_initial = ones(N-1,1)/(N-1)
    Q = function(b) sum((t(Y_demeaned)-X_demeaned%*%b)^2)


    #constraints
    A_eq = ones(1,N-1)
    B_eq = 1
    LB = zeros(N-1,1)
    
    #options = optimoptions('fmincon','Display','none')
    opt = fmincon(b_initial,Q,Aeq = A_eq,beq = B_eq,lb = LB)
    b_hat = opt$par
    
    a_hat[i] = mean(Y_treated) - colMeans(Y_untreated) %*% b_hat
    b_hat = append(b_hat, 0, i-1)
    B_hat[i,] = t(b_hat)
  }

return(list(a_hat=a_hat,B_hat=B_hat))
}

