
%% CONFIGURATION (temp, will be defined in main.m in next version)


clear
addpath('code');
addpath('functions');
if ~exist("output",'dir')
    mkdir("output")
end

treatment_true = 5; 
spillover_true = 3;

% one of the settings
N = 10;
T = 15; 
T1 = T+1;
spillover_str = {'concentrated spillover'};


%% Data Generation Process
rng(100) % For reproducibility

% stationary I(0)
%DGP_I_0
data_generation

%% Add Treatment and spillover effect to data 

%if strcmpi(spillover_str,'concentrated spillover') == 1

%    concentrated_spillover % 1/3 units have spillover
%    disp("concentrated spillover")

%elseif strcmpi(spillover_str,'spreadout spillover') == 1

%    spreadout_spillover % 2/3 units have spillover 
%    disp("spreadout spillover")

%else
%    Y(1,T+1) = Y(1,T+1) + treatment_true; % only first unit be treated
%    disp("no spillover")
%end


%% Estimate SCM Weights 

scm_estimation

%% Known Structure 

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



%% Estimate treatment and spillover effect

%sp_estimation % sp_lasso function

% corrected synthetic control
[a_hat,B_hat] = scm_batch(Y_T0); 

X_hat = (eye(N)-B_hat);

Y_hat = (eye(N)-B_hat)*Y_T1-a_hat;

% penalty level by CV 

[ALPHA,FitInfo] = lasso(X_hat,Y_hat,'Intercept',false,'CV',10);
% .'DFmax',N-1
%[ALPHA,FitInfo] = lasso(X_hat,Y_hat,'CV',10);

lassoPlot(ALPHA,FitInfo,'PlotType','CV');
legend('show') % Show legend


idxLambdaMSE = FitInfo.IndexMinMSE;

alpha_lasso = ALPHA(:,idxLambdaMSE);
% Display lambda
FitInfo.LambdaMinMSE


%% Post_Lasso

% indicators of all uints assumed to be potentially affected by the policy
ind = zeros(N,1);
ind(1) = 1; 
for i = 2:N

    if alpha_lasso(i) ~= 0 
        ind(i) = 1; 
    end
end

% A: matrix of spillover exposure 
A = eye(N);
A(:,ind == 0) = [];

% synthetic control method with spillover[Cao and Dowd (2022)]

M_hat = (eye(N)-B_hat)'*(eye(N)-B_hat);
gamma_hat = (A'*M_hat*A)\(A'*(eye(N)-B_hat)'*((eye(N)-B_hat)*Y_T1-a_hat));
alpha_sp = A*gamma_hat;

%% forward selection

[~,p] = sort(alpha_lasso,'descend','ComparisonMethod','abs');
lasso_rank = 1:length(alpha_lasso);
lasso_rank(p) = lasso_rank;

step_max = min(sum(alpha_lasso ~= 0), N-1);

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

alpha_fs_minMSE_index = find(alpha_fs_vec(N+1,:) == min(alpha_fs_vec(N+1,:)));

alpha_fs_minMSE = alpha_fs_vec(1:N,alpha_fs_minMSE_index);

% alpha: forward selection 

 for i = 1:step_max-1

  if alpha_fs_vec(N+1,i) < alpha_fs_vec(N+1,i+1)
      
      alpha_fs = alpha_fs_vec(1:N,i);
     
  else 
      alpha_fs = alpha_fs_vec(1:N,step_max) ; 
  end

 end


%% Coverage rate 

% coverage rate = Pr(confidence interval cover true value)


%% False Discovery Distribution 

% false discovery = the numbe r of {β_hat ≈ 0 but β = 0}

% number of {ceil(N/3)=0}-ceil(N/3) 
% + number of {ceil(N/3)!=0} 

False_Dis_neg= sum(alpha_lasso(1:ceil(N/3),:) == 0);
%+ sum(alpha_hat(ceil(N/3)+1:N,:) ~= 0);

