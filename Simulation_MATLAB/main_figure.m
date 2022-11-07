clear

tic 
rng(7)
addpath('code');
addpath('functions');
warning('off','all')

S = 1000;
% one setting N = 10, T = 50 
N_vec = [10]; 
T_vec = [50];
l_N = length(N_vec);
l_T = length(T_vec);

%%%% lasso 
penalty_mat = zeros(S,100);
alpha1_mat = zeros(S,100);
nonzero_mat = zeros(S,100);
false_pos_mat = zeros(S,100);
false_neg_mat = zeros(S,100);
%%%%

%%%% post-lasso
penalty_postlasso_mat = zeros(S,100);
alpha1_postlasso_mat= zeros(S,100);
nonzero_postlasso_mat = zeros(S,100);
false_neg_postlasso_mat = zeros(S,100);
false_pos_postlasso_mat = zeros(S,100);
%%%%%

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

%% Lasso penalty 

% we choose lambda which minimum MSE, i.e. green point in the figure
[alpha_lasso, penalty] = sp_lasso(Y_T0, Y_T1);

%% Lasso Lambda multiply
for i = 1:100
    penalty_temp = i * penalty;
    penalty_mat(s,i) = penalty_temp; % lambda 
    % corrected synthetic control
    [a_hat,B_hat] = scm_batch(Y_T0); 

    X_hat = (eye(N)-B_hat);

    Y_hat = (eye(N)-B_hat)*Y_T1-a_hat;
    % assign penalty level
    alpha_hat = lasso(X_hat,Y_hat,'Lambda',penalty_temp,...
    'Intercept',false,'Standardize', false);    

    alpha1_mat(s,i) = alpha_hat(1); % alpha_1 

    nonzero_mat(s,i) = sum(alpha_hat(1:N,:) ~= 0); % non-zero units 

    false_pos_mat(s,i) = sum(alpha_hat(ceil(sp_type*N/3)+1:N,:) ~= 0);

    false_neg_mat(s,i) = sum(alpha_hat(1:ceil(sp_type*N/3),:) == 0);


end


%% Post-Lasso penalty 
[a_hat,B_hat] = scm_batch(Y_T0); 
X_hat = (eye(N)-B_hat);
Y_hat = (eye(N)-B_hat)*Y_T1-a_hat;

% penalty level by CV
[ALPHA,FitInfo] = lasso(X_hat,Y_hat,'Intercept',false,'CV',10,'DFmax',N-1, ...
    'Standardize', false);

penalty_postlasso = FitInfo.LambdaMinMSE;

for i = 1:100
    penalty_temp = i * penalty_postlasso;
    penalty_postlasso_mat(s,i) = penalty_temp; % lambda 
alpha_postlasso = lasso(X_hat,Y_hat,'Lambda',penalty_temp,...
    'Intercept',false,'Standardize', false);

% indicators of all uints assumed to be potentially affected by the policy
ind = zeros(N,1);
ind(1) = 1; % treated unit as 1 
    for j = 2:N
    
        if alpha_postlasso(j) ~= 0 
            ind(j) = 1; 
        end
    end

% A: matrix of spillover exposure 
A = eye(N);
A(:,ind == 0) = [];

% synthetic control method with spillover[Cao and Dowd (2022)]
[a_hat,B_hat] = scm_batch(Y_T0); 
M_hat = (eye(N)-B_hat)'*(eye(N)-B_hat);
gamma_hat = (A'*M_hat*A)\(A'*(eye(N)-B_hat)'*((eye(N)-B_hat)*Y_T1-a_hat));
alpha_sp = A*gamma_hat;

    alpha1_postlasso_mat(s,i) = alpha_sp(1); % alpha_1 

    nonzero_postlasso_mat(s,i) = sum(alpha_sp(1:N,:) ~= 0); % non-zero units 

    false_pos_postlasso_mat(s,i) = sum(alpha_sp(ceil(sp_type*N/3)+1:N,:) ~= 0);

    false_neg_postlasso_mat(s,i) = sum(alpha_sp(1:ceil(sp_type*N/3),:) == 0);


end

end

    end
end

toc

%% output figures 

output_figures_lasso

output_figures_postlasso

output_figures_comparison

