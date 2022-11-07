

C_NV = zeros(1,N); 
C_NV(34) = 1 ; % NV




%     
% %% ESTIMATION AND INFERENCE 
% 
% C = [zeros(1,N)]; % all zero matrix
% n = 34; % row of NV 
% C(n) = 1 ; % C matrix for P test to alpha_34 (NV)
% 
% % define pre and post dataset
% Y_pre = Y(:,1:T);
% Y_post = Y(:,T+1:end);
% 
% % get synthetic control weights and intercepts for all units
% [a_hat,B_hat] = scm_batch(Y_pre);
% 
% M_hat = (eye(N)-B_hat)'*(eye(N)-B_hat); % M=(I-B)'(I-B)
% 
% % Create Table and Vector for saveing NV spillover effect table 
% alpha_NV_hat_vec = zeros(1,S);
% year = zeros(1,S);
% 
% p_value_vec = zeros(1,S);
% lb_vec_NV = zeros(1,S);
% ub_vec_NV = zeros(1,S);
% 
% for s = 1 : S
%     
%     % ESTIMATION 
%     Y_Ts = Y(:,T+s);
%     gamma_hat = (A'*M_hat*A)\(A'*(eye(N)-B_hat)'*((eye(N)-B_hat)*...
%     Y_Ts-a_hat));
%     alpha_hat = A*gamma_hat;
%     
%     % store alpha_NV for each year 
%     alpha_NV_hat_vec(s) = alpha_hat(n);
%     
%     % store year column
%     s_year=s+1988;
%     year(s) = s_year;
% 
%     % INFERENCE
%     [p_value,lb,ub] = sp_andrews_te(Y_pre,cig(:,T+s),A,C,alpha_sig,n);
%     % store P-value  and CI
%     p_value_vec(s) = p_value;
%     lb_vec_NV(s) = lb;
%     ub_vec_NV(s) = ub;
% 
% end
% 
% %% OUTPUT TABLE
% 
%     Table_spillover_NV=table;
% 
%     Table_spillover_NV.year = transpose(year);
%     Table_spillover_NV.alpha_NV_hat = transpose(alpha_NV_hat_vec);
%     Table_spillover_NV.lower_bound = transpose(lb_vec_NV);
%     Table_spillover_NV.upper_bound = transpose(ub_vec_NV);
%     
%  
%     filesave = append('output/', 'spillover_NV', '.csv');
%     filePath = sprintf(filesave);
%     writetable(Table_spillover_NV, filePath); 
% 
