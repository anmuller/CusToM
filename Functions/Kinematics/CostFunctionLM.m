function [func,J]=CostFunctionLM(q,positions,gamma,hclosedloophandle,zeta,hbutees,weights, l_inf1,l_sup1,Aeq_ik,J_marqueurs_handle)
% Limit penalisation for LM algorithm
%
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - positions : vector of experimental marker positions
%   - gamma: closed loop penalisation
%   - hclosedloophandle: closed loop function handle
%   - zeta: bound penalisation
%   - hbutees: bound function handle
%   OUTPUT
%   - func: cost function for marker tracking with constraints and bounds
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________


% cut evaluation
[Rcut,pcut]=fcut(q);

newweights= repmat(weights,3,1);

% dx
dX = newweights(:).*(-X_markers(q,pcut,Rcut) + positions);

constraints=cell(length(hclosedloophandle),1);
for k=1:length(hclosedloophandle)
    fonc = hclosedloophandle{k};
    constraints{k}= fonc(q);
end
constraints=[constraints{:}];
func = [ dX ; gamma*constraints(:) ; zeta*hbutees(q)];

if nargout > 1   % Two output arguments
    J = IK_Jacobian(q,pcut,Rcut, l_inf1,l_sup1,Aeq_ik,gamma,zeta, J_marqueurs_handle,newweights(:));   % Jacobian of the function evaluated at q
end

end