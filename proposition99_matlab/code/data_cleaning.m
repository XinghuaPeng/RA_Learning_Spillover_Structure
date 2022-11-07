% This is the data cleaning function for Cigarette sales raw data ...
% from The Tax Burden on Tobacco, Orzechowski and Walker(2019). 
% Run this function to get the per-capita cigarette consumption (in packs)
% for all 51 states from 1970 to 2000. 

% raw data input
Raw_Cigs = readtable('data/The_Tax_Burden_on_Tobacco__1970-2019.csv');

% keep vital vars 
Raw_Cigs = [Raw_Cigs(:,"LocationAbbr"), Raw_Cigs(:,"Year"), ...
    Raw_Cigs(:,"Data_Value"), Raw_Cigs(:,"Data_Value_Type")];

Raw_Cigs = Raw_Cigs(contains(Raw_Cigs.Data_Value_Type,'Pack'),:);
Raw_Cigs = removevars(Raw_Cigs,"Data_Value_Type");

% define data type and rename
Raw_Cigs.Properties.VariableNames = ["state", "year", "cigs"];
cigs_all_state = convertvars(Raw_Cigs,{'cigs','year'},'double');
cigs_all_state = sortrows(cigs_all_state,{'state','year'});

% keep data from 1970 to 2000
cigs_all_state = cigs_all_state(~(cigs_all_state.year > 2000),:);

% output data as excel
writetable(cigs_all_state,'data/cigs_consumption.csv');




