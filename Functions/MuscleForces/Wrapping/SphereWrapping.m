function [L, Q, T, AnimPt_in_Rw, ind] = SphereWrapping(P, S, R,ind)
% Provide the length wrapping around a shere
%   Based on:
%   -B.A. Garner and M.G. Pandy, The obstacle-set method for
%   representing muscle paths in musculoskeletal models,
%   Comput. Methods Biomech. Biomed. Engin. 3 (2000), pp. 1–30.
%
%   INPUT
%   - P1: array 3x1 position of the first point
%   - P2: array 3x1 position of the second point
%   - R: radius of the sphere
%   - ind : side of the wrapping.
%   OUTPUT
%   - L: minimal Length between P and S wrapping around the cylinder.
%   - Q: Position of point Q on the sphere.
%   - T: Position of point T on the sphere.
%   - AnimPt_in_Rw: 20 points on the cylinder for displaying purpose.
%   - ind : side of the wrapping.
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
if size(P,1)<3 || size(S,1)<3
    error('P or S need to 3x1 arrays');
end

L = 0;

%%%_Rotation matrix M
OS_barre = S/norm(S);
OP_barre = P/norm(P);
N_chapeau = cross(OP_barre, OS_barre);
N_chapeau = N_chapeau/norm(N_chapeau);
M = [transpose(OS_barre); transpose(cross(N_chapeau, OS_barre)); transpose(N_chapeau)];

%%%_ P ans S in a plan XY
p = M*P;
s = M*S;

%%%_coordonnates of q and t dans the plan
qx1 = (p(1)*R^2-R*p(2)*sqrt(p(1)^2+p(2)^2-R^2))/(p(1)^2+p(2)^2);
qy1 = (p(2)*R^2+R*p(1)*sqrt(p(1)^2+p(2)^2-R^2))/(p(1)^2+p(2)^2);
qx2 = (p(1)*R^2+R*p(2)*sqrt(p(1)^2+p(2)^2-R^2))/(p(1)^2+p(2)^2);
qy2 = (p(2)*R^2-R*p(1)*sqrt(p(1)^2+p(2)^2-R^2))/(p(1)^2+p(2)^2);
qz = 0;

q1 = [qx1; qy1; qz];q(:,1)=q1;
q2 = [qx2; qy2; qz];q(:,2)=q2;

tx1 = (s(1)*R^2-R*s(2)*sqrt(s(1)^2+s(2)^2-R^2))/(s(1)^2+s(2)^2);
ty1 = (s(2)*R^2+R*s(1)*sqrt(s(1)^2+s(2)^2-R^2))/(s(1)^2+s(2)^2);
tx2 = (s(1)*R^2+R*s(2)*sqrt(s(1)^2+s(2)^2-R^2))/(s(1)^2+s(2)^2);
ty2 = (s(2)*R^2-R*s(1)*sqrt(s(1)^2+s(2)^2-R^2))/(s(1)^2+s(2)^2);
tz = 0;

t1 = [tx1; ty1; tz];t(:,2)=t1;
t2 = [tx2; ty2; tz];t(:,1)=t2;

% figure(1)
% plot3(t1(1),t1(2),t1(3),'o'); hold on
% plot3(t2(1),t2(2),t2(3),'o');
% 
% plot3(q1(1),q1(2),q1(3),'o'); hold on
% plot3(q2(1),q2(2),q2(3),'o');
% 
% plot(R*cosd(0:360),R*sind(0:360),'--'); axis equal
% 
% plot3(p(1),p(2),p(3),'o'); hold on
% plot3(s(1),s(2),s(3),'o');
% 
% Pt1=p;
% Pt2=q1;
% h=plot3([Pt1(1) Pt2(1)],[Pt1(2) Pt2(2)],[Pt1(3) Pt2(3)],'r');
% Pt1=s;
% Pt2=t2;
% h=plot3([Pt1(1) Pt2(1)],[Pt1(2) Pt2(2)],[Pt1(3) Pt2(3)],'r');
% 
% Pt1=p;
% Pt2=q2;
% h=plot3([Pt1(1) Pt2(1)],[Pt1(2) Pt2(2)],[Pt1(3) Pt2(3)],'b');
% Pt1=s;
% Pt2=t1;
% h=plot3([Pt1(1) Pt2(1)],[Pt1(2) Pt2(2)],[Pt1(3) Pt2(3)],'b');

%%%_distance btw q - p and t - s
PQ1 = norm(q1-p);
ST1 = norm(t2-s);

PQ2 = norm(q2-p);
ST2 = norm(t1-s);

Q(:,1) = M'*q1;
T(:,1) = M'*t2;
l_arc1 = R*acos(1-((qx1-tx2)^2+(qy1-ty2)^2)/(2*R^2));

Q(:,2) = M'*q2;
T(:,2) = M'*t1;
l_arc2 = R*acos(1-((qx2-tx1)^2+(qy2-ty1)^2)/(2*R^2));

L = [PQ1+l_arc1+ST1, PQ2+l_arc2+ST2];

% figure(2)
% [x,y,z]=sphere();
% s=surf(R*x,R*y,R*z); hold on; axis equal
% s.EdgeColor = 'none';
% fastscatter3(Q(:,1)); hold on; fastscatter3(Q(:,2))
% fastscatter3(T(:,1)); hold on; fastscatter3(T(:,2))
% fastscatter3(P); fastscatter3(S);
% Pt1=P;
% Pt2=Q(:,1);
% h=plot3([Pt1(1) Pt2(1)],[Pt1(2) Pt2(2)],[Pt1(3) Pt2(3)],'b');
% Pt1=S;
% Pt2=T(:,1);
% h=plot3([Pt1(1) Pt2(1)],[Pt1(2) Pt2(2)],[Pt1(3) Pt2(3)],'b');
% 
% Pt1=P;
% Pt2=Q(:,2);
% h=plot3([Pt1(1) Pt2(1)],[Pt1(2) Pt2(2)],[Pt1(3) Pt2(3)],'r');
% Pt1=S;
% Pt2=T(:,2);
% h=plot3([Pt1(1) Pt2(1)],[Pt1(2) Pt2(2)],[Pt1(3) Pt2(3)],'r');


%Choose the minimal one or the previous one
if nargin>3 && ~isempty(ind)
else
    [~,ind]=min(L);
end
L=L(ind);Q=Q(:,ind);T=T(:,ind);
q=q(:,ind);t=t(:,ind);

if nargout>3
    
    theta1 = 2*atand(q(2)/ (q(1) + sqrt( q(1)^2 + q(2)^2 ) ));
    theta2 = 2*atand(t(2)/ (t(1) + sqrt( t(1)^2 + t(2)^2 ) ));
    n=20;
    theta = linspace(theta1,theta2,n);
    z_T(1:n) = 0;
    
    x = R*cosd(theta);
    y = R*sind(theta);
    z = z_T;
    
    % figure(1)
    % plot(R*cosd(theta1),R*sind(theta1),'bo')
    % plot(R*cosd(theta2),R*sind(theta2),'ro')
    % plot(R*cosd(theta),R*sind(theta),'k-')
    
    AnimPt_in_Rw = ( M'*[x;y;z] )';
    
    % figure(2)
    % plot3(AnimPt_in_Rw(:,1),AnimPt_in_Rw(:,2),AnimPt_in_Rw(:,3),'o')
    
end

end
