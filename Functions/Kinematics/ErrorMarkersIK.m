function [error] = ErrorMarkersIK(q,positions)
% Computation of reconstruction error for the inverse kinematics step
%   Computation of the distance between the position of each experimental 
%   marker and the position of the corresponded model marker
%
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - positions : vector of experimental marker positions
%   OUTPUT
%   - error: distance between the position of each experimental marker and
%   the position of the corresponded model marker 
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

error =  sqrt(sum(reshape(-X_markers(q,pcut,Rcut) + positions,3,length(positions)/3).^2,1));

end