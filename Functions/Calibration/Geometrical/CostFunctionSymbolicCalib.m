function [error] = CostFunctionSymbolicCalib(q,k,Pelvis_position,Pelvis_rotation,positions)
% Cost function used for the geometrical calibration step
%   
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - k: vector of homothety coefficient
%   - Pelvis_position: position of the pelvis at the considered instant
%   - Pelvis_rotation: rotation of the pelvis at the considered instant
%   - positions : matrix of experimental marker positions
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

[Rcut,pcut]=fcut(Pelvis_position,Pelvis_rotation,q,k);

e =  sqrt(sum(reshape(-X_markers(Pelvis_position,Pelvis_rotation,q,k,pcut,Rcut) + positions,3,length(positions)/3).^2,1))';

error=e'*e;
end