
function [alpha_sp] = sp_post_lasso(Y0, Y1, alpha_lasso)

[N,T] = size(Y0);
% indicators of all uints assumed to be potentially affected by the policy
ind = zeros(N,1);

for i = 1:N

    if alpha_lasso(i) ~= 0 
        ind(i) = 1; 
    end
end

% A: matrix of spillover exposure 
A = eye(N);
A(:,ind == 0) = [];


% synthetic control method with spillover[Cao and Dowd (2022)]
[a_hat,B_hat] = scm_batch(Y0); 
M_hat = (eye(N)-B_hat)'*(eye(N)-B_hat);
gamma_hat = (A'*M_hat*A)\(A'*(eye(N)-B_hat)'*((eye(N)-B_hat)*Y1-a_hat));
alpha_sp = A*gamma_hat;
