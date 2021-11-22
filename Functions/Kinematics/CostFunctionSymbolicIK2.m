function [error] = CostFunctionSymbolicIK2(q,positions,weights)
% Cost function used for the inverse kinematics step using an optimization method
%   
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - positions : vector of experimental marker positions
%   OUTPUT
%   - error: cost function value
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
[Rcut,pcut]=fcut(q);

% Vectorial norm of marker distance 
newweights= repmat(weights,1,3)';
a = sum(newweights(:).*(-X_markers(q,pcut,Rcut) + positions).^2);
error = sum(a(~isnan(a)));

end