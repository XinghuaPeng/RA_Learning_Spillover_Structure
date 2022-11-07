
Y_pre = Y(:,1:T);
Y_post = Y(:,T+1:end);

% synthetic control weights and intercepts for all units
[a_hat,B_hat] = scm_batch(Y_pre);

synthetic_control_scm = a_hat(1)+B_hat(1,:)*Y; % vanilla SCM
teEstimateSCM = CA-synthetic_control_scm;
