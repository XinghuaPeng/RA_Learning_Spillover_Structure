

clear
addpath('code');
addpath('functions');
if ~exist("output",'dir')
    mkdir("output")
end


%% CONFIGURATION
alpha_sig = .05; % significance level
data_cleaning % data cleaning


%% SCM WITH 38 STATES

% data input
state_num = 38;
spilloverVarList = {};
data_input

% estimation
scm_estimation


%% ACCOUNTING FOR SPILLOVERS WITH 50 STATES

% data input 
state_num = 50;
spilloverVarList = {'missing12','neighbor'};
data_input

% treatment effects estimation 
sp_estimation

% treatment effects inference
sp_inference

% % spillover effects
% spillover_effects



%% OUTPUT
output_results










