function [F,V]=PlotSphere(r)
% Generation of cylinder mesh for animation
%
%   INPUT
%   - r: radius
%   OUTPUT
%   - F: Faces
%   - V: Vertices
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
% Create a sphere
[x,y,z]=sphere;
% Faces and Vertices
[F,V]= surf2patch(x*r,y*r,z*r);

end