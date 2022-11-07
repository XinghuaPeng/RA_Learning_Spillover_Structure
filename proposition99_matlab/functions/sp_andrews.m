function [test] = sp_andrews(Y0,Y1,A,C,d,alpha_sig)
%SP_ANDREWS The proposed test in Cao and Dowd (2019). 
% sp_andrews(Y0,Y1,A,C,d) returns 1 if the test rejects the null hypothesis
% C*alpha=d, and 0 otherwise. 

[N,T] = size(Y0);

% corrected synthetic control
[a_hat,B_hat] = scm_batch(Y0); 
M_hat = (eye(N)-B_hat)'*(eye(N)-B_hat);
gamma_hat = (A'*M_hat*A)\(A'*(eye(N)-B_hat)'*((eye(N)-B_hat)*Y1-a_hat));
alpha_hat = A*gamma_hat;

P = (C*alpha_hat-d)'*(C*alpha_hat-d); % test statistic
G_hat = A*((A'*M_hat*A)\A')*(eye(N)-B_hat)';

P_t = zeros(T,1);
for t = 1 : T
    a_t = a_hat;
    B_t = B_hat;
    P_t(t) = (Y0(:,t)-(a_t+B_t*Y0(:,t)))'*G_hat'*C'*C*G_hat*(Y0(:,t)-...
        (a_t+B_t*Y0(:,t)));
end

test = P>quantile(P_t,1-alpha_sig);




