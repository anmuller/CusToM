function [error] = ErrorMarkersCalib(q,k,Pelvis_position,Pelvis_rotation,positions)
% Computation of reconstruction error for the geometrical calibration
%   Computation of the distance between the position of each experimental 
%   marker and the position of the corresponded model marker
%
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - k: vector of homothety coefficient
%   - Pelvis_position: position of the pelvis at the considered instant
%   - Pelvis_rotation: rotation of the pelvis at the considered instant
%   - positions : matrix of experimental marker positions
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

[Rcut,pcut]=fcut(Pelvis_position,Pelvis_rotation,q,k);

error =  sqrt(sum(reshape(-X_markers(Pelvis_position,Pelvis_rotation,q,k,pcut,Rcut) + positions,3,length(positions)/3).^2,1))';

end