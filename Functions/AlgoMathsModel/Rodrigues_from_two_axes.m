function [R]=Rodrigues_from_two_axes(a1,a2)
% Computation of the Rodrigues equation
%
%   INPUT 2 axes
%	- a1 (3*1 array)
%   - a2 (3*1 array)
%   OUTPUT
%   - R: rotation matrix between a1 and a2
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

u_r=cross(a1,a2)' / norm(cross(a1,a2));
y=norm(cross(a1,a2)); %sin theta
x=dot(a1,a2); %cos theta
theta_r=atan2(y,x);

R = Rodrigues(u_r,theta_r);

end
