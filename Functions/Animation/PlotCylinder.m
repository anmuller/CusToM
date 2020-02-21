function [F,V]=PlotCylinder(r,h)
% Generation of cylinder mesh for animation
%
%   INPUT
%   - r: radius
%   - h: height
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
% Create constant vectors
t = linspace(0,2*pi,100); z = [flip(linspace(0,-h/2,10)) linspace(0,h/2,10)];
% generate cylinder
xc = repmat(r*cos(t),20,1); yc = repmat(r*sin(t),20,1);
zc = repmat(z',1,100);
% close the cylinder
X = [xc*0; flipud(xc); (xc(1,:))*0]; Y = [yc*0; flipud(yc); (yc(1,:))*0];
Z = [zc; flipud(zc); zc(1,:)];
% Faces and Vertices
[F,V]= surf2patch(X,Y,Z);
end