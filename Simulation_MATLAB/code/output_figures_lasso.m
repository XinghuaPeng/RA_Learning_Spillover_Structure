%% clean the results to a dataset

penalty_level = 1:100;

% lasso description variables 
alpha1_mean = mean(alpha1_mat);
alpha1_var = var(alpha1_mat);
alpha1_bias = mean(alpha1_mat) - alpha1;
nonzero_mean = mean(nonzero_mat);
false_pos_mean = mean(false_pos_mat);
false_neg_mean = mean(false_neg_mat); 

result_mat = [penalty_level; alpha1_mean;alpha1_bias; alpha1_var; ...
    nonzero_mean; false_pos_mean;false_neg_mean]';

dataframe = array2table(result_mat,...
    'VariableNames',{'penalty_level','alpha1','alpha1_bias',...
    'alpha1_var','nonzero','false_pos', 'false_neg'});

%% Lasso 
% figure 1 
figure1 = figure;
axes1 = axes('Parent',figure1,'box','on');
hold(axes1,'on');
scatter(dataframe.penalty_level,dataframe.alpha1,'DisplayName','data1');
ylabel({'\alpha_1'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,'\alpha_1');

filesave = append('output/', 'alpha1_mean', '.pdf');
filePath = sprintf(filesave);
saveas(figure1,filePath);

% figure 2 
figure2 = figure; 
axes1 = axes('Parent',figure2,'box','on');
hold(axes1,'on');
scatter(dataframe.penalty_level,dataframe.nonzero,'DisplayName','nonzero');
ylabel({'non zero units'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,'nonzero');


filesave = append('output/', 'nonzero', '.pdf');
filePath = sprintf(filesave);
saveas(figure2,filePath);


% figure 3 
figure3 = figure; 
axes1 = axes('Parent',figure3,'box','on');
hold(axes1,'on');
scatter(dataframe.penalty_level,dataframe.false_pos,'DisplayName','false positive');
hold(axes1,'on');
scatter(dataframe.penalty_level,dataframe.false_neg,'DisplayName','false negative');
ylabel({'false discovery'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,{'false positive','false negative'});


filesave = append('output/', 'false_dis', '.pdf');
filePath = sprintf(filesave);
saveas(figure3,filePath);


% Figure 4 

figure4 = figure;
axes1 = axes('Parent',figure4,'box','on');
hold(axes1,'on');
scatter(dataframe.penalty_level,dataframe.alpha1_bias,'DisplayName','data1');
ylabel({'\alpha_1 bias'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,'\alpha_1 bias');

filesave = append('output/', 'alpha1_bias', '.pdf');
filePath = sprintf(filesave);
saveas(figure4,filePath);


% Figure 5

figure5 = figure;
axes1 = axes('Parent',figure5,'box','on');
hold(axes1,'on');
scatter(dataframe.penalty_level,dataframe.alpha1_var,'DisplayName','data1');
ylabel({'\alpha_1 variance'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,'\alpha_1 variance');

filesave = append('output/', 'alpha1_var', '.pdf');
filePath = sprintf(filesave);
saveas(figure5,filePath);

