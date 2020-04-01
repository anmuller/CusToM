%Verification of the wrapping for sphere problems
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

P1=0.8*[0.01,1,1]';
P2=0.8*[0.01,-.9,-1]';
R = 0.48;

b = Intersect_line_sphere(P1,P2,R);

figure;
[x,y,z]=sphere();
s=surf(R*x,R*y,R*z); hold on; axis equal
s.EdgeColor = 'none';

h = plot3point(P1);
h = plot3point(P2);

function h = plot3point(Pt)
h =plot3(Pt(1),Pt(2),Pt(3),'r*');
end