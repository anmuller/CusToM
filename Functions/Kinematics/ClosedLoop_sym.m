function [ceq] = ClosedLoop_sym(q,nb_ClosedLoop) %#ok<*INUSL>
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

c=[];
ceq=sym('ceq',[nb_ClosedLoop*7,1]); % number of equations = number of closed loop * 9 (9 terms in the rotation matrix)

for i=1:nb_ClosedLoop
    eval(['[ci,ceqi] = fCL' num2str(i) '(q);'])  
    ceq(1+7*(i-1):7*i,1) = ceqi;     
end

ceq = double(ceq);
end