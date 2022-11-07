clear

tic 
rng(7)
addpath('code');
addpath('functions');
warning('off','all')

S = 1000;
N_vec = [10,30,50];
T_vec = [15,50,200];
l_N = length(N_vec);
l_T = length(T_vec);

result_mat_alpha1 = zeros(14,9);
result_mat_False_Dis = zeros(10,9); % store false discovery
result_mat_penalty = zeros(9,9); 

loop = 0;

for i_N = 1 : l_N
    for i_T = 1 : l_T

N = N_vec(i_N);
T = T_vec(i_T);
T1 = T+1;

mu_mat = rand(3,N); % factor loadings - predetermined for each simulation

alpha = zeros(N,1);
 
 spillover = 3;
 alpha(1) = 5; 
 alpha1 = alpha(1); % alpha1 = 5 here

 %spillover type: 1 = concentrate; 2 = spreadout 
 sp_type = 1;

 for i = 2:ceil(sp_type*N/3)
     alpha(i) = spillover;
 end


% vector for saving alpha
alpha1_scm_vec = zeros(S,1); % SCM
alpha1_sp_vec = zeros(S,1); % Known Structure SP 
alpha1_lasso_vec = zeros(S,1); % Lasso with miniMSE lambda
alpha1_lasso2_vec = zeros(S,1); % Lasso with 2*lambda 
alpha1_pl_vec = zeros(S,1); % Post Lasso 
alpha1_pl2_vec = zeros(S,1); % Post Lasso with 2*lambda
alpha1_fs_vec = zeros(S,1); % forward selection

% vector for lasso penalty
penalty_vec = zeros(S,1);
alpha_lasso_nonzero_vec = zeros(S,1);

penalty2_vec = zeros(S,1);
alpha_lasso2_nonzero_vec = zeros(S,1);

penalty_pl2_vec = zeros(S,1);
alpha_pl2_nonzero_vec = zeros(S,1);


% vector for false discovery
False_Dis_pos_lasso_vec = zeros(S,1);
False_Dis_neg_lasso_vec = zeros(S,1);

False_Dis_pos_lasso2_vec= zeros(S,1);
False_Dis_neg_lasso2_vec= zeros(S,1);

False_Dis_pos_pl_vec = zeros(S,1);
False_Dis_neg_pl_vec = zeros(S,1);

False_Dis_pos_pl2_vec = zeros(S,1);
False_Dis_neg_pl2_vec = zeros(S,1);

False_Dis_pos_fs_vec = zeros(S,1);
False_Dis_neg_fs_vec = zeros(S,1);

parfor (s = 1 : S, 6) % number of the working CPU cores

rng(s)

% common factors 
delta = zeros(T1,1);
delta(1) = randn/sqrt(1-.5^2)+1/(1-.5);
lambda1 = zeros(T1,1);
lambda1(1) = randn/sqrt(1-.5^2);
nu2 = randn(T1,1);
lambda2 = zeros(T1,1);
lambda2(1) = 1+nu2(1)+randn;
nu3 = randn(T1,1);
lambda3 = zeros(T1,1);
lambda3(1) = 0+nu3(1)+randn;
for t = 2 : T1
    delta(t) = 1+.5*delta(t-1)+randn;
    lambda1(t) = .5*lambda1(t-1)+randn;
    lambda2(t) = 1+nu2(t)+.5*nu2(t-1);
    lambda3(t) = .5*lambda3(t-1)+nu3(t)+.5*nu3(t-1);
end
lambda_mat = [lambda1 lambda2 lambda3];

epsilon = randn(N,T1); % shocks

% counterfactural value
Y0_mat = repmat(delta',N,1)+(lambda_mat*mu_mat)'+epsilon; 

% observed outcomes
Y_T0 = Y0_mat(:,1:T);
Y_T1 = Y0_mat(:,T1)+alpha;
Y = [Y_T0 Y_T1]; % merged outcome

%% 1. naive synthetic control
% synthetic control weights and intercepts for all units

[a_hat,B_hat] = scm_batch(Y_T0);

synthetic_control_scm = a_hat(1)+B_hat(1,:)*Y; % vanilla SCM

teEstimateSCM = Y(1,:)-synthetic_control_scm;

alpha1_scm = teEstimateSCM(T+1);
alpha1_scm_vec(s) = alpha1_scm;

%% 2. SP with known structure 

ind = zeros(N,1);
ind(1) = 1; % count first unit

 for i = 2:ceil(sp_type*N/3)
     ind(i) = 1;
 end

A = eye(N);
A(:,ind == 0) = [];
M_hat = (eye(N)-B_hat)'*(eye(N)-B_hat);
gamma_hat = (A'*M_hat*A)\(A'*(eye(N)-B_hat)'*((eye(N)-B_hat)*Y_T1-a_hat));
alpha_sp = A*gamma_hat;

alpha1_sp = alpha_sp(1);
alpha1_sp_vec(s) = alpha1_sp;

%% 3. Lasso

% we choose lambda which minimum MSE, i.e. green point in the figure
[alpha_lasso, penalty] = sp_lasso(Y_T0, Y_T1);


alpha1_lasso = alpha_lasso(1);
alpha1_lasso_vec(s) = alpha1_lasso;

penalty_vec(s) = penalty; 
alpha_lasso_nonzero = sum(alpha_lasso(1:N,:) ~= 0);
alpha_lasso_nonzero_vec(s) = alpha_lasso_nonzero; 

%% 4. Post-Lasso

% We learned spillover structure from the lasso estimator and compute
% the post-lasso estimator

alpha_pl = sp_post_lasso(Y_T0, Y_T1);
alpha1_pl = alpha_pl(1);
alpha1_pl_vec(s) = alpha1_pl;

%% 5. lasso with 2*lambda 

[alpha_lasso2, penalty_2] = sp_lasso_double(Y_T0, Y_T1);
alpha1_lasso2 = alpha_lasso2(1);
alpha1_lasso2_vec(s) = alpha1_lasso2;

penalty2_vec(s) = penalty_2; 

alpha_lasso2_nonzero = sum(alpha_lasso2(1:N,:) ~= 0);

alpha_lasso2_nonzero_vec(s) = alpha_lasso2_nonzero; 


%% 6. post-lasso with 2* lambda 

[alpha_pl2, penalty_pl2] = sp_post_lasso2(Y_T0, Y_T1);
alpha1_pl2 = alpha_pl2(1);
alpha1_pl2_vec(s) = alpha1_pl2;

penalty_pl2_vec(s) = penalty_pl2; 

alpha_pl2_nonzero = sum(alpha_pl2(1:N,:) ~= 0);

alpha_pl2_nonzero_vec(s) = alpha_pl2_nonzero; 




%% Forward Selection
[~,p] = sort(alpha_lasso,'descend','ComparisonMethod','abs');
lasso_rank = 1:length(alpha_lasso);
lasso_rank(p) = lasso_rank;

step_max = min(sum(alpha_lasso ~= 0), N-1);

%step_max

if step_max == 0 % only add treatment unit

  ind = zeros(N,1);
  ind(1) = 1; % count first unit
  A = eye(N);
  A(:,ind == 0) = [];
  M_hat = (eye(N)-B_hat)'*(eye(N)-B_hat);
  gamma_hat = (A'*M_hat*A)\(A'*(eye(N)-B_hat)'*((eye(N)-B_hat)*Y_T1-a_hat));
  alpha_fs = A*gamma_hat;
  

else
    
    alpha_fs_vec = zeros(N+1,step_max);
    
    for i = 1:step_max
    
      stepwise_vec = find(lasso_rank<=i);
    
      ind = zeros(N,1);
      ind(1) = 1; % count first unit
      
    
    
      for j = stepwise_vec
      ind(j) = 1;
      end
    
    
      A = eye(N);
      A(:,ind == 0) = [];
    
      % synthetic control method with spillover[Cao and Dowd (2022)]
    
      M_hat = (eye(N)-B_hat)'*(eye(N)-B_hat);
      gamma_hat = (A'*M_hat*A)\(A'*(eye(N)-B_hat)'*((eye(N)-B_hat)*Y_T1-a_hat));
      alpha_fs = A*gamma_hat;
      
      alpha_fs_vec(1:N,i) = alpha_fs;
      
      % MSE = || (I-B)(Y1 - alpha) - a ||
    
      MSE = ((eye(N)-B_hat)*(Y_T1- alpha_fs)-a_hat)'*((eye(N)-B_hat)*(Y_T1- alpha_fs)-a_hat); 
      alpha_fs_vec(N+1,i) = MSE;
     
    end
    
    % alpha: minimize MSE
    %alpha_fs_minMSE_index = find(alpha_fs_vec(N+1,:) == min(alpha_fs_vec(N+1,:)));
    %alpha_fs_minMSE = alpha_fs_vec(1:N,alpha_fs_minMSE_index);
    
    % alpha: forward selection 
    if step_max > 1
    
         for i = 1:step_max-1
        
              if alpha_fs_vec(N+1,i) < alpha_fs_vec(N+1,i+1)
                  
                  alpha_fs = alpha_fs_vec(1:N,i);
                 
              else 
                  alpha_fs = alpha_fs_vec(1:N,step_max) ; 
              end
        
         end
    
    
    else 
        alpha_fs = alpha_fs_vec(1:N,step_max)
    end

end

alpha1_fs = alpha_fs(1);
alpha1_fs_vec(s) = alpha1_fs;


%% False Discovery Distribution Lasso

% alpha_hat != 0 but beta =0 
False_Dis_pos_lasso = sum(alpha_lasso(ceil(sp_type*N/3)+1:N,:) ~= 0);

% alpha_hat == 0 but beta !=0 
False_Dis_neg_lasso = sum(alpha_lasso(1:ceil(sp_type*N/3),:) == 0);


False_Dis_pos_lasso_vec(s) = False_Dis_pos_lasso;
False_Dis_neg_lasso_vec(s) = False_Dis_neg_lasso;

%% False Discovery Distribution Post-Lasso

% alpha_hat != 0 but beta =0 
False_Dis_pos_pl = sum(alpha_pl(ceil(sp_type*N/3)+1:N,:) ~= 0);

% alpha_hat == 0 but beta !=0 
False_Dis_neg_pl = sum(alpha_pl(1:ceil(sp_type*N/3),:) == 0);


False_Dis_pos_pl_vec(s) = False_Dis_pos_pl;
False_Dis_neg_pl_vec(s) = False_Dis_neg_pl;

%% False Discovery Distribution Lasso with 2*lambda

% alpha_hat != 0 but beta =0 
False_Dis_pos_lasso2 = sum(alpha_lasso2(ceil(sp_type*N/3)+1:N,:) ~= 0);

% alpha_hat == 0 but beta !=0 
False_Dis_neg_lasso2 = sum(alpha_lasso2(1:ceil(sp_type*N/3),:) == 0);


False_Dis_pos_lasso2_vec(s) = False_Dis_pos_lasso2;
False_Dis_neg_lasso2_vec(s) = False_Dis_neg_lasso2;

%% False Discovery Distribution Post-Lasso with 2*lambda & N-1 DFmax

% alpha_hat != 0 but beta =0 
False_Dis_pos_pl2 = sum(alpha_pl2(ceil(sp_type*N/3)+1:N,:) ~= 0);

% alpha_hat == 0 but beta !=0 
False_Dis_neg_pl2 = sum(alpha_pl2(1:ceil(sp_type*N/3),:) == 0);


False_Dis_pos_pl2_vec(s) = False_Dis_pos_pl2;
False_Dis_neg_pl2_vec(s) = False_Dis_neg_pl2;


%% False Discovery Distribution Forward Selection

% alpha_hat != 0 but beta =0 
False_Dis_pos_fs = sum(alpha_fs(ceil(sp_type*N/3)+1:N,:) ~= 0);

% alpha_hat == 0 but beta !=0 
False_Dis_neg_fs = sum(alpha_fs(1:ceil(sp_type*N/3),:) == 0);


False_Dis_pos_fs_vec(s) = False_Dis_pos_fs;
False_Dis_neg_fs_vec(s) = False_Dis_neg_fs;


end

loop = loop+1;

result_mat_alpha1(:,loop) = [mean(alpha1_scm_vec)-alpha1;var(alpha1_scm_vec);...
    mean(alpha1_sp_vec)-alpha1; var(alpha1_sp_vec);...
    mean(alpha1_lasso_vec)-alpha1;var(alpha1_lasso_vec);...
    mean(alpha1_pl_vec)-alpha1; var(alpha1_pl_vec);...
    mean(alpha1_lasso2_vec)-alpha1; var(alpha1_lasso2_vec);...
    mean(alpha1_pl2_vec) - alpha1; var(alpha1_pl2_vec);...
    mean(alpha1_fs_vec)-alpha1; var(alpha1_fs_vec)]

result_mat_False_Dis(:,loop) = [mean(False_Dis_pos_lasso_vec);mean(False_Dis_neg_lasso_vec);...
    mean(False_Dis_pos_pl_vec);mean(False_Dis_neg_pl_vec);...
    mean(False_Dis_pos_lasso2_vec); mean(False_Dis_neg_lasso2_vec);...
    mean(False_Dis_pos_pl2_vec); mean(False_Dis_neg_pl2_vec);...
    mean(False_Dis_pos_fs_vec);mean(False_Dis_neg_fs_vec)]

result_mat_penalty(:,loop) = [mean(penalty_vec); mean(alpha_lasso_nonzero_vec);...
    max(alpha_lasso_nonzero_vec);...
    mean(penalty2_vec); mean(alpha_lasso2_nonzero_vec); max(alpha_lasso2_nonzero_vec);...
    mean(penalty_pl2_vec); mean(alpha_pl2_nonzero_vec); max(alpha_pl2_nonzero_vec)]

    end
end

result_mat_alpha1

result_mat_False_Dis

result_mat_penalty

toc

%% OUTPUT TABLE

csvwrite('output/result_mat.csv',result_mat_alpha1);

csvwrite('output/False_Discovery.csv',result_mat_False_Dis);

csvwrite('output/result_mat_penalty.csv',result_mat_penalty);

