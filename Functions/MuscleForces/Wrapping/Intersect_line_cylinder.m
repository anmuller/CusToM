function [bool]=Intersect_line_cylinder(P1,P2,R)
% Verify if the line intersect the cylinder
%
%   INPUT
%   - P1: array 3x1 position of the first point
%   - P2: array 3x1 position of the second point
%   - R: radius of the cylinder
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
%________________________________________________________


% %circle equation : x^2+y^2=R^2
% % equation of the line : y = a*x+b avec :
% a = (S(2)-P(2))/(S(1)-P(1));
% b = P(2)-a*P(1);
% % injecting in circle equation
% %x^2 + (a*x+b)^2=R^2
% %x^2 + a^2*x^2+ 2*a*b*x + b^2=R^2
% %  (a^2+1)*x^2+ 2*a*b*x + b^2-R^2 =0
% % compute determinant
% DD = (2*a*b)^2-4*(a^2+1)*(b^2-R^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%circle equation : x^2+y^2=R^2
%parametric equation of the line:
%x = x0 +T*a_d
%y = y0 +T*b_d
%x = z0 +T*c_d
%N = S-P =PS
%P + T_Sol*N = [x;y;z]
N = P2-P1;
% injecting in circle equation x,y
%(x0 +T*a_d)^2 + (y0 +T*b_d)^2=R^2
%(a_d^2+b_d^2) * T^2 + 2*(x0*a_d+y0*b_d) * T + (y0^2 + x0^2) - R^2 = 0
AlPha=N(1)^2+N(2)^2;
BeTa=2*(P1(1)*N(1)+P1(2)*N(2));
Gamma=(P1(1)^2+P1(2)^2-R^2);
DD = BeTa^2-4*AlPha*Gamma;
bool = DD>0;