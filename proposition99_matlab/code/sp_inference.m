

%% INFERENCE - TREATMENT EFFECTS

% test for treatment effect

C = [1 zeros(1,N-1)]; 

p_value_vec = zeros(1,S);
lb_vec = zeros(1,S);
ub_vec = zeros(1,S);

C_AZ = zeros(1,N); C_AZ(indAZ) = 1 ; lbAZ = zeros(1,S); ubAZ = zeros(1,S);
C_NV = zeros(1,N); C_NV(indNV) = 1 ; lbNV = zeros(1,S); ubNV = zeros(1,S);
C_OR = zeros(1,N); C_OR(indNV) = 1 ; lbOR = zeros(1,S); ubOR = zeros(1,S);

for s = 1 : S

    % CA
    [p_value,lb,ub] = sp_andrews_te(Y_pre,cig(:,T+s),A,1,alpha_sig);
    p_value_vec(s) = p_value;
    lb_vec(s) = lb;
    ub_vec(s) = ub;
    
%     % AZ
%     [~,lb,ub] = sp_andrews_te(Y_pre,cig(:,T+s),A,indAZ,alpha_sig);
%     lbAZ(s) = lb;
%     ubAZ(s) = ub;

    % NV
    [~,lb,ub] = sp_andrews_te(Y_pre,cig(:,T+s),A,indNV,alpha_sig);
    lbNV(s) = lb;
    ubNV(s) = ub;

%     % OR
%     [~,lb,ub] = sp_andrews_te(Y_pre,cig(:,T+s),A,indOR,alpha_sig);
%     lbOR(s) = lb;
%     ubOR(s) = ub;

end


%% INFERENCE - SPILLOVER EFFECTS
% test for whether there is spillover at each post-treatment period

spillover_test = zeros(1,S);

for s = 1 : S

    C = [zeros(N-1,1) eye(N-1)];
    d = zeros(N-1,1);

    spillover_test(s) = sp_andrews(Y_pre,cig(:,T+s),A,C,d,alpha_sig);

end
