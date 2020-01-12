function R = Rodrigues(a,q)
% Computation of the Rodrigues equation
%
%   INPUT
%   - a: axis of rotation
%   - q: rotation angle
%   OUTPUT
%   - R: rotation matrix
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if isequal(size(a),[0 0]) || isequal(size(q),[0 0])
    R=eye(3);
else
	ap=[0 -a(3) a(2);...
         a(3) 0 -a(1);...
        -a(2) a(1) 0];
	R=[1 0 0;0 1 0;0 0 1]+ap*sin(q)+ap*ap*(1-cos(q));
end

end