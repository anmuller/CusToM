function [c,ceq]=NonLinCon_ClosedLoop(qred,nb_cut,list_function,pcut,Rcut)
% Non-linear equation used in the inverse kinematics step for closed loops
%
%   INPUT
%   - q: vector of joint coordinates at a given instant
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

for c=1:nb_cut
	[Rcut(:,:,c),pcut(:,:,c)]=list_function{c}(qred,pcut,Rcut);
end

[c,ceq]=fCL(qred,pcut,Rcut);
end
