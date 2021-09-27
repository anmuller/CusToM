function [c,ceq] = ClosedLoopCalib(Pelvis_position,Pelvis_rotation,q,k,pcut,Rcut,nb_ClosedLoop) %#ok<*INUSL>
% Non-linear equation used in the geometrical calibration step for closed loops
%
%   INPUT
%   - Pelvis_position: position of the pelvis at the considered instant
%   - Pelvis_rotation: rotation of the pelvis at the considered instant
%   - q: vector of joint coordinates at a given instant
%   - k: vector of homothety coefficient
%   - pcut: position of geometrical cuts
%   - Rcut: rotation of geometrical cuts
%   - nb_ClosedLoop: number of closed loop in the model
%   OUTPUT
%   - c: non-linar inequality
%   - ceq: non-linear equality
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

[c,ceq] = fCL(Pelvis_position,Pelvis_rotation,q,k,pcut,Rcut);

end