%% Lasso 
% figure 1 
figure11 = figure;
axes1 = axes('Parent',figure11,'box','on');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe_pl.alpha1_pl,'DisplayName','data1');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe.alpha1,'DisplayName','false negative');
ylabel({'\alpha_1'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,{'\alpha_1 post-lasso', '\alpha_1 lasso'});

filesave = append('output/', 'alpha1_mean','_cp','.pdf');
filePath = sprintf(filesave);
saveas(figure11,filePath);

% figure 2 
figure12 = figure; 
axes1 = axes('Parent',figure12,'box','on');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe_pl.nonzero_pl,'DisplayName','nonzero');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe.nonzero,'DisplayName','nonzero');
ylabel({'non zero units'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,{'nonzero  post-lasso','nonzero lasso'});


filesave = append('output/', 'nonzero', '_cp','.pdf');
filePath = sprintf(filesave);
saveas(figure12,filePath);


% figure 3 
figure13 = figure; 
axes1 = axes('Parent',figure13,'box','on');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe_pl.false_pos_pl,'DisplayName','false positive');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe_pl.false_neg_pl,'DisplayName','false negative');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe.false_pos,'DisplayName','false positive');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe.false_neg,'DisplayName','false negative');
ylabel({'false discovery'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,{'false positive post-lasso','false negative post-lasso','false positive lasso',...
    'false negative lasso'});


filesave = append('output/', 'false_dis', '_cp','.pdf');
filePath = sprintf(filesave);
saveas(figure13,filePath);


% Figure 4 

figure14 = figure;
axes1 = axes('Parent',figure14,'box','on');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe_pl.alpha1_bias_pl,'DisplayName','data1');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe.alpha1_bias,'DisplayName','data1');

ylabel({'\alpha_1 bias'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,{'\alpha_1 bias post-lasso', '\alpha_1 bias lasso'});

filesave = append('output/', 'alpha1_bias','_cp', '.pdf');
filePath = sprintf(filesave);
saveas(figure14,filePath);


% Figure 5

figure15 = figure;
axes1 = axes('Parent',figure15,'box','on');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe_pl.alpha1_var_pl,'DisplayName','data1');
hold(axes1,'on');
scatter(dataframe_pl.penalty_level,dataframe.alpha1_var,'DisplayName','data1');

ylabel({'\alpha_1 variance'});
xlabel({'penalty level'});
hold(axes1,'off');
legend(axes1,{'\alpha_1 variance post-lasso', '\alpha_1 variance lasso'});

filesave = append('output/', 'alpha1_var','_cp', '.pdf');
filePath = sprintf(filesave);
saveas(figure15,filePath);


