function [F,mu] = KKT_projection(F0,Fmax,R,C,pos_active_set,pos_passive_set,epsilon)
% Resolution of the Karush–Kuhn–Tucker conditions
%   
%   INPUT
%   - F0: initial solution of the optimization
%   - Fmax: upper bounds
%   - R: moment arms matrix
%   - C: vetor of joint torques
%   - pos_active_set: number of muscles subject to an active set
%   - pos_passive_set: number of muscles subject to a passive set
%   - epsilon: weighting coefficient for the bi-objective optimization
%   OUTPUT
%   - F: solution of the optimization
%   - mu: active set values
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
n = numel(F0); % nb of muscles
nca = size(pos_active_set,1); % nb of active constraints

%% matrix initialisation
A=zeros(n,n);
B=zeros(n,1);

%% Filling
if nca == 0 % no active constraints
    % F
    A(1:n,1:n) = diag(2*ones(n,1)./(Fmax.^2)) + (2/epsilon)*(transpose(R)*R);
    B(1:n,:)=2*(F0)./(Fmax.^2) + (2/epsilon)*(transpose(R)*(C));
    % results
        x=A\B;
        F=x(1:n,:);
        mu=[];
elseif nca == n % only active constraints
    % we block everything and we stop
    mu=[];
    F=[];
else % active and passive constraints
    % F
    tRR = transpose(R)*R;
    tRC = transpose(R)*(C);
    A(1:(n-nca),1:(n-nca)) = diag(2*ones((n-nca),1)./(Fmax(pos_passive_set,:).^2)) + (2/epsilon)*(tRR(pos_passive_set,pos_passive_set));
    B(1:(n-nca),:) =  2*(F0(pos_passive_set,:))./(Fmax(pos_passive_set,:).^2) ...
        - (2/epsilon)*tRR(pos_passive_set,pos_active_set(:,1))*(Fmax(pos_active_set(:,1)).*pos_active_set(:,2)) ...
        + (2/epsilon)*tRC(pos_passive_set,:);
    % mu
    A(n-nca+1:end,1:(n-nca)) = (2/epsilon)*tRR(pos_active_set(:,1),pos_passive_set);
    A((n-nca+1):end,(n-nca+1):end)=diag(1*pos_active_set(:,2)-1*~pos_active_set(:,2));
    B((n-nca+1):end,:) = (2*(F0(pos_active_set(:,1),:)) ...
        - 2*Fmax(pos_active_set(:,1)).*pos_active_set(:,2))./(Fmax(pos_active_set(:,1)).^2) ...
        - (2/epsilon)*(tRR(pos_active_set(:,1),pos_active_set(:,1))*(Fmax(pos_active_set(:,1)).*pos_active_set(:,2))) ...
        + (2/epsilon)*tRC(pos_active_set(:,1),:);
    % results
        x=A\B;
        F=x(1:(n-nca),:);
        mu=x(n-nca+1:end,:);
end

end