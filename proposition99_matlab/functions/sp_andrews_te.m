function [p_value,lb,ub] = sp_andrews_te(Y0,Y1,A,ind,alpha_sig)
%SP_ANDREWS_TE The proposed test for treatment effects in Cao and Dowd 
%(2019). 
% [p_value,lb,ub] = sp_andrews_te(Y0,Y1,A,C,alpha_sig) returns p-value, lower
% bound and upper bound of the confidence interval, for the null hypothesis
% alpha_1=0.

[N,T] = size(Y0);
C = zeros(1,N); 
C(ind) = 1;


%% ESTIMATION

[a_hat,B_hat] = scm_batch(Y0); 
M_hat = (eye(N)-B_hat)'*(eye(N)-B_hat);
gamma_hat = (A'*M_hat*A)\(A'*(eye(N)-B_hat)'*((eye(N)-B_hat)*Y1-a_hat));
alpha_hat = A*gamma_hat;


%% P-VALUE

P = (C*alpha_hat)'*(C*alpha_hat); % test statistic
G_hat = A*((A'*M_hat*A)\A')*(eye(N)-B_hat)';

P_t = zeros(T,1);
for t = 1 : T
    a_t = a_hat;
    B_t = B_hat;
    P_t(t) = (Y0(:,t)-(a_t+B_t*Y0(:,t)))'*G_hat'*(C'*C)*G_hat*(Y0(:,t)-...
        (a_t+B_t*Y0(:,t)));
end

p_value = mean(P<=P_t);


%% CONFIDENCE INTERVAL
% construct confidence interval by inverting test

u_hat_vec = zeros(1,T);
for t = 1 : T
    u_hat_vec(t) = C*G_hat*(Y0(:,t)-(a_t+B_t*Y0(:,t)));
end

lb = alpha_hat(ind)+quantile(u_hat_vec,alpha_sig/2);
ub = alpha_hat(ind)+quantile(u_hat_vec,1-alpha_sig/2);






