function [bool] = Intersect_line_sphere(P1, P2, R)
% Verify if the line intersect the sphere
%
%   INPUT
%   - P1: array 3x1 position of the first point
%   - P2: array 3x1 position of the second point
%   - R: radius of the sphere
%   OUTPUT
%   - bool: logical 1 or 0
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________%% 1- Compute locations of obstacle via points
bool=0;

% [X1,Y1,Z1] = R*sphere(20);
% surf(X1+O(1),Y1+O(2),Z1+O(3))
% shading flat
% hold on

% P Bounding-fixed via points Start of path
P = P1;
% S Bounding-fixed via points END of path
S = P2;
O = [0;0;0];

OS = (S-O)/norm(S-O) ;
OP = (P-O)/norm(P-O) ;

% unit vector normal to the plane (Z-axis)
N = cross(OP,OS)/norm(cross(OP,OS));
NN = cross(N,OS);

% scatter3(P(1),P(2),P(3),'r*')
% hold on
% axis equal
% grid off
% scatter3(S(1),S(2),S(3),'r*')
% scatter3(O(1),O(2),O(3),'b*')

% quiver3(O(1),O(2),O(3),OS(1),OS(2),OS(3))
% quiver3(O(1),O(2),O(3),OP(1),OP(2),OP(3))
% quiver3(O(1),O(2),O(3),N(1),N(2),N(3))
% quiver3(O(1),O(2),O(3),NN(1),NN(2),NN(3))

%Rotation Matrix R_sphere_R_0
% P_R_0 = M_R_0_R_sphere * P_R_sphere
x1 = OS;
y1 = NN;
z1 = N; % Normal to the plan

M_rot = [ x1, y1, z1];

%Express P and S in the plane reference frame;
p = M_rot'*P;
s = M_rot'*S;
%% 2-on vérifie s'il y'a intersection de la droite dans avec le cercle dans le plan XY

%circle equation : x^2+y^2=R^2
%line equation : y = a*x+b avec :
a = (s(2)-p(2))/(s(1)-p(1)); %(1)
b = p(2)-a*p(1); %(2)
% (2) into (1)
%x^2 + (a*x+b)^2=R^2
%x^2 + a^2*x^2+ 2*a*b*x + b^2=R^2
%  (a^2+1)*x^2+ 2*a*b*x + b^2-R^2 =0
% Determinant
DD = (2*a*b)^2-4*(a^2+1)*(b^2-R^2);
% if DD>0 => there is intersection.

bool1 = sign(p(1))~= sign(s(1));
bool = (DD>0 && bool1);


end