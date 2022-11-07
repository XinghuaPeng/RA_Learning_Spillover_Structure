
% post-lasso description variables 
alpha1_pl_mean = mean(alpha1_postlasso_mat);
alpha1_pl_var = var(alpha1_postlasso_mat);
alpha1_pl_bias = mean(alpha1_postlasso_mat) - alpha1; 
nonzero_pl_mean = mean(nonzero_postlasso_mat);
false_pos_pl_mean = mean(false_pos_postlasso_mat);
false_neg_pl_mean = mean(false_neg_postlasso_mat);

result_pl_mat = [penalty_level; alpha1_pl_mean;alpha1_pl_bias; alpha1_pl_var; ...
    nonzero_pl_mean; false_pos_pl_mean;false_neg_pl_mean]';

dataframe_pl = array2table(result_pl_mat,...
    'VariableNames',{'penalty_level','alpha1_pl','alpha1_bias_pl',...
    'alpha1_var_pl','nonzero_pl','false_pos_pl', 'false_neg_pl'});

%% post-Lasso 
% figure 1 
figure6 = figure;
axes1 = axes('Parent',figure6,'box','on');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe_pl.alpha1_pl,'DisplayName','data1');
ylabel({'\alpha_1'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,'\alpha_1 post-lasso');

filesave = append('output/', 'alpha1_mean','_postlasso','.pdf');
filePath = sprintf(filesave);
saveas(figure6,filePath);

% figure 2 
figure7 = figure; 
axes1 = axes('Parent',figure7,'box','on');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe_pl.nonzero_pl,'DisplayName','nonzero');
ylabel({'non zero units'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,'nonzero  post-lasso');


filesave = append('output/', 'nonzero', '_postlasso','.pdf');
filePath = sprintf(filesave);
saveas(figure7,filePath);


% figure 3 
figure8 = figure; 
axes1 = axes('Parent',figure8,'box','on');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe_pl.false_pos_pl,'DisplayName','false positive');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe_pl.false_neg_pl,'DisplayName','false negative');
ylabel({'false discovery'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,{'false positive post-lasso','false negative post-lasso'});


filesave = append('output/', 'false_dis', '_postlasso','.pdf');
filePath = sprintf(filesave);
saveas(figure8,filePath);


% Figure 4 

figure9 = figure;
axes1 = axes('Parent',figure9,'box','on');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe_pl.alpha1_bias_pl,'DisplayName','data1');
ylabel({'\alpha_1 bias'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,'\alpha_1 bias post-lasso');

filesave = append('output/', 'alpha1_bias','_postlasso', '.pdf');
filePath = sprintf(filesave);
saveas(figure9,filePath);


% Figure 5

figure10 = figure;
axes1 = axes('Parent',figure10,'box','on');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe_pl.alpha1_var_pl,'DisplayName','data1');
ylabel({'\alpha_1 variance'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,'\alpha_1 variance post-lasso');

filesave = append('output/', 'alpha1_var','_postlasso', '.pdf');
filePath = sprintf(filesave);
saveas(figure10,filePath);

