scm_batch = function(Y) {
 
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
    opt = fmincon(b_initial,Q,A=NULL,b=NULL,Aeq = A_eq,beq = B_eq,lb = LB,ub = NULL)
    b_hat = opt$par
    a_hat[i] = mean(Y_treated) - colMeans(Y_untreated) %*% b_hat
    b_hat = append(b_hat, 0, i-1) # 
    B_hat[i,] = t(b_hat)
  }

return(list(a_hat=a_hat,B_hat=B_hat))
}

