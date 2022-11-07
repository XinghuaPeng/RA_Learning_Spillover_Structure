function [alpha_hat, penalty] = sp_lasso(Y0, Y1)


[N,T] = size(Y0);
a_hat = zeros(N,1);
B_hat = zeros(N);

% corrected synthetic control
[a_hat,B_hat] = scm_batch(Y0); 

X_hat = (eye(N)-B_hat);

Y_hat = (eye(N)-B_hat)*Y1-a_hat;


% penalty level by CV 

[ALPHA,FitInfo] = lasso(X_hat,Y_hat, ...
    'Intercept',false, ...
    'Standardize', false,...
    'CV',10);

  %      'DFmax',N-1, ...


% choose lambda by minimum MSE

alpha_hat = ALPHA(:,FitInfo.IndexMinMSE);
%alpha_hat = ALPHA(:,FitInfo.Index1SE);


penalty = FitInfo.LambdaMinMSE; 
%penalty = FitInfo.Lambda1SE; 


end
