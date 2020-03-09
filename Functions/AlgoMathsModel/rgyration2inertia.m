function [I]=rgyration2inertia(r_gyration, Mass, coord_point, length, Signe)
% Computation of inertia matrix from radius of gyration
%
%   INPUT
%   - r_gyration: radius of gyration (%) : [rxx ryy rzz rxy rxz ryz]
%   - Mass: solid mass
%   - coord_point: coordinates of the point where radius of gyration are
%   defined (from center of mass)
%   - length: solid length
%   - Signe: side of the solid ('R' for right side or 'L' for left side)
%   OUTPUT
%   - I: inertia matrix [Ixx Iyy Izz Ixy Ixz Iyz]
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if nargin<5
    Signe='R';
end
if strcmp(Signe,'R') == 1
    Signe_b=1;
else
    Signe_b=-1;
end

r_gyration=r_gyration/100;
I1=length^2*Mass*(r_gyration.^2);
Huygens=Mass*[coord_point(2)^2+coord_point(3)^2 ...
    coord_point(1)^2+coord_point(3)^2 ...
    coord_point(1)^2+coord_point(2)^2 ...
    coord_point(1)*coord_point(2) ...
    Signe_b*coord_point(1)*coord_point(3) ...
    Signe_b*coord_point(2)*coord_point(3)];
I = I1 - Huygens;

end