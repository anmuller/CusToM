function [c,ceq] = ClosedLoop(q) %#ok<*INUSL>
% Non-linear equation used in the inverse kinematics step for closed loops
%
%   INPUT
%   - q: vector of joint coordinates at a given instant
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

[c,ceq] = fCL(q);

end

% function [c,ceq] = ClosedLoop(q,nb_ClosedLoop) %#ok<*INUSL>
% % Non-linear equation used in the inverse kinematics step for closed loops
% %
% %   INPUT
% %   - q: vector of joint coordinates at a given instant
% %   - nb_ClosedLoop: number of closed loop in the model
% %   OUTPUT
% %   - c: non-linar inequality
% %   - ceq: non-linear equality
% %________________________________________________________
% %
% % Licence
% % Toolbox distributed under GPL 3.0 Licence
% %________________________________________________________
% %
% % Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% % Georges Dumont
% %________________________________________________________
% c=[];
% 
% nb_eq=0; % initialization of the number of equations
% if nb_ClosedLoop == 0   % if there is no closed loop --> no non-linear constraint
%     ceq=[];
% else    
%     ceq=zeros(nb_ClosedLoop*9,1); % number of equations = number of closed loop * 9 (9 terms in the rotation matrix)
%     for i=1:nb_ClosedLoop
%     
%     eval(['[R,p] = fCL' num2str(i) '(q);'])  
%     
%     for z=1:3
%     nb_eq=nb_eq+1; % number of equations incrementation
%     ceq(nb_eq,1)=p(z); 
%     end
%     
%     for z=1:3
%     nb_eq=nb_eq+1; % number of equations incrementation
%     ceq(nb_eq,1)=R(z,z)-1; 
%     end
%     
%     nb_eq=nb_eq+1; % number of equations incrementation
%     ceq(nb_eq,1)=R(1,2); 
%     nb_eq=nb_eq+1; % number of equations incrementation
%     ceq(nb_eq,1)=R(1,3); 
%     nb_eq=nb_eq+1; % number of equations incrementation
%     ceq(nb_eq,1)=R(2,3);   
%     end   
% end
% 
% end