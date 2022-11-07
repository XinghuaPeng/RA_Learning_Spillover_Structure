

%% CONFIGURATION
ftSize = 20;
lWidth = 3;
lWidthErr = 2;
 

%% OUTPUT TABLE

output_mat = zeros(S,5); % output: [time,estimate,p-value,lb,ub]
output_mat(:,1) = (1:S)';
output_mat(:,2) = alpha1_hat_vec;
output_mat(:,3) = p_value_vec;
output_mat(:,4) = lb_vec;
output_mat(:,5) = ub_vec;

fprintf('\n            ####### OUTPUT TABLE #######\n')
fprintf('Time    TE estimate    p-value            CI\n')
for s = 1 : S
    fprintf('%2d%15.4f%12.4f     [%8.4f,%8.4f]\n',output_mat(s,:))
end



%% PLOT - ACTUAL VS COUNTERFACTUAL OUTCOMES

f1 = figure(1);

p = plot(year,Y(1,:),'-.',year,synthetic_control_scm,'--',...
    year,synthetic_control_sp,...
    [1988,1988],[35,135],'--k');
p(1).LineWidth = lWidth;
p(2).LineWidth = lWidth;
p(3).LineWidth = lWidth;
p(1).Color = [ 0.9290    0.6940    0.1250];
p(2).Color = [ 0.8500    0.3250    0.0980];
p(3).Color = [   0    0.4470    0.7410];
ylim([35,135]);

x1 = 1972;
y1 = 75;
txt1 = 'Passage of Proposition 99 \rightarrow';
text(x1,y1,txt1, 'FontSize', ftSize,'FontName', 'Times New Roman')
set(gca, 'FontName', 'Times New Roman')
xlabel('year','FontSize', ftSize,'FontName', 'Times New Roman');
ylabel('per-capita cigarette sales (in packs)',...
    'FontSize', ftSize,'FontName', 'Times New Roman');

% legend
lgdSCM = append( 'SCM');
lgdSP = append('SP') ; 
lgd = legend('California',lgdSCM,...
    lgdSP,'Location','southwest');
lgd.FontSize = ftSize;

ax = gca;
ax.FontSize = ftSize; 

% filepath
filesave = append('output/', 'CA_vs_synthetic_control', '.pdf') ; 
filePath = sprintf(filesave);
saveas(f1,filePath);
%close(f1)


%% PLOT - RESIDUALS AND TREATMENT EFFECT ESTIMATES

f2 = figure(2);

basevalue = -40;
% change shade area by spillover test

for i=1:12

j = i + 1988;
if spillover_test(i) == 1 
   h = area([j-.5 j+.5], [25 25],basevalue,'LineStyle','none');
   h.FaceColor = [.8 .8 .8];
   hold on 
end

end

xlim([1970,2000]);
hold on 
p = plot(year,Y(1,:)-synthetic_control_scm,'--',year,...
    Y(1,:)-synthetic_control_sp,[1988,1988],[-40,30],'--k',...
    [year(1),year(end)],[0,0],'--k');
p(1).LineWidth = lWidth;
p(2).LineWidth = lWidth;
p(1).Color = '[0.8500 0.3250 0.0980]';
p(2).Color = '[     0    0.4470    0.7410]';

% extend Y axis for CI

if min(Y(1,T+1:end)-synthetic_control_sp(T+1:end)-alpha1_hat_vec+lb_vec) <= -30 
    ylim([-40,25]);
elseif min(Y(1,T+1:end)-synthetic_control_sp(T+1:end)-alpha1_hat_vec+lb_vec) <= -25
    ylim([-30,25]); 
else
    ylim([-25,25]);
end
% hold on
p3 = errorbar(year(T+1:end),Y(1,T+1:end)-synthetic_control_sp(T+1:end),...
    alpha1_hat_vec-lb_vec,ub_vec-alpha1_hat_vec,'LineWidth',lWidthErr);
p3.Color = '[     0    0.4470    0.7410]';
hold off

lgd = legend([p(1) p(2)],{lgdSCM,lgdSP},'Location','Northwest');
lgd.FontSize = ftSize;
x1 = 1972;
y1 = -13;
txt1 = 'Passage of Proposition 99 \rightarrow';
text(x1,y1,txt1, 'FontSize', ftSize,'FontName', 'Times New Roman')
set(gca, 'FontName', 'Times New Roman')
xlabel('year','FontSize', 16,'FontName', 'Times New Roman');
ylabel('per-capita cigarette sales (in packs)',...
    'FontSize', 16,'FontName', 'Times New Roman');

ax = gca;
ax.FontSize = ftSize; 

filesave = append('output/', 'prop99_te', '.pdf');
filePath = sprintf(filesave);
saveas(f2,filePath);
% close(f2)


%% PLOT - SPILLOVER EFFECTS OF NEIGHBORING STATES
f3 = figure(3);

uHatAZ = [Y(indAZ,1:T)-(a_hat(indAZ)+B_hat(indAZ,:)*Y_pre),alphaAZ];
uHatNV = [Y(indNV,1:T)-(a_hat(indNV)+B_hat(indNV,:)*Y_pre),alphaNV];
uHatOR = [Y(indOR,1:T)-(a_hat(indOR)+B_hat(indOR,:)*Y_pre),alphaOR];

% hold on 

p = plot(year,uHatAZ,'--^',...
    year,uHatNV,year,uHatOR,'--s',[1988,1988],[-100,100],'--k',...
    [year(1),year(end)],[0,0],'--k');

hold on
NVerrorBar = errorbar(year(T+1:end),alphaNV,...
    alphaNV-lbNV,ubNV-alphaNV,'LineWidth',lWidthErr);
NVerrorBar.Color = '[     0    0.4470    0.7410]';
hold off
% hold off

p(1).LineWidth = 2;
p(2).LineWidth = 3;
p(3).LineWidth = 2;
p(1).Color = '[0.8500 0.3250 0.0980]';
p(1).MarkerSize = 8;
p(2).Color = '[     0    0.4470    0.7410]';
p(3).Color = '[0.9290, 0.6940, 0.1250]';
p(3).MarkerSize = 10;

lgd = legend('AZ','NV','OR','Location','Northwest');
% lgd.FontSize = ftSize;
x1 = 1972;
y1 = -25;
txt1 = 'Passage of Proposition 99 \rightarrow';
text(x1,y1,txt1, 'FontSize', ftSize,'FontName', 'Times New Roman')

ax = gca;
ax.FontSize = ftSize; 
set(gca, 'FontName', 'Times New Roman')

xlim([1970,2000])
ylim([-40,50])

filesave = append('output/', 'prop99_spillover_effects', '.pdf');
filePath = sprintf(filesave);
saveas(f3,filePath);





