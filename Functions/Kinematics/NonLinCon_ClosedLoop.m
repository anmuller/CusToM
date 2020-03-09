function [c,ceq]=NonLinCon_ClosedLoop(q,nb_cut,list_function,pcut,Rcut)
% Non-linear equation used in the inverse kinematics step for closed loops
%
%   INPUT
%   - q: vector of joint coordinates at a given instant
%   - nb_cut: number of cuts in the  forward kinematics equations
%   - list_function: list of functions for forward kinematics cuts
%   - pcut: empty cut vector for forward kinematics
%   - Rcut: empty cut matrices for forward kinematics
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

% Filling Rcut and pcut tables with corresponding numerical values
for c=1:nb_cut
	[Rcut(:,:,c),pcut(:,:,c)]=list_function{c}(q,pcut,Rcut);
end

% Constaints computation
[c,ceq]=fCL(q,pcut,Rcut);
end
