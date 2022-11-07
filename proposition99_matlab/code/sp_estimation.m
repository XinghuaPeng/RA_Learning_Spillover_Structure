
Y_pre = Y(:,1:T);
Y_post = Y(:,T+1:end);

% synthetic control weights and intercepts for all units
[a_hat,B_hat] = scm_batch(Y_pre);

M_hat = (eye(N)-B_hat)'*(eye(N)-B_hat); % M=(I-B)'(I-B)
synthetic_control_sp = a_hat(1)+B_hat(1,:)*Y_pre;

% Create Table for saving spillover effect table 
Table_spillover=table;
state_name = state;
state_name(CA_position,:) = [];% 3 in 38states, 5 in 50states
state_name = ['CA'; state_name];

Table_spillover.state = state_name; 

alpha1_hat_vec = zeros(1,S); % treatment effect estimator

% specification for spillovers 
indAZ = find(state_list{:,1} == "AZ");
indNV = find(state_list{:,1} == "NV");
indOR = find(state_list{:,1} == "OR");
alphaAZ = zeros(1,S);
alphaNV = zeros(1,S);
alphaOR = zeros(1,S);

for s = 1 : S
    Y_Ts = Y(:,T+s);
    gamma_hat = (A'*M_hat*A)\(A'*(eye(N)-B_hat)'*((eye(N)-B_hat)*...
        Y_Ts-a_hat));
    alpha_hat = A*gamma_hat;
    alpha1_hat_vec(s) = alpha_hat(1);
    synthetic_control_sp(T+s) = Y(1,T+s)-alpha1_hat_vec(s);

    % spillover effects
    alphaAZ(s) = alpha_hat(indAZ);
    alphaNV(s) = alpha_hat(indNV);
    alphaOR(s) = alpha_hat(indOR);

    %% loop for spillover effect table 
    %asbtrcat('alpha_hat_', num2str(s)) = alpha_hat;
    s_year=s+1988;
    Table_spillover.name =  alpha_hat;
    Table_spillover.Properties.VariableNames{'name'} = strcat('alpha_hat_', num2str(s_year));
 
    filesave = append('output/', 'spillover', '.csv');
    filePath = sprintf(filesave);
    writetable(Table_spillover, filePath); 
    
end

teEstimateSP = CA-synthetic_control_sp;