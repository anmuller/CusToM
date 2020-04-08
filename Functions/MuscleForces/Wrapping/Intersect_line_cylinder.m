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
bool=0;

% %circle equation : x^2+y^2=R^2
% % equation of the line : y = a*x+b avec :
% a = (P2(2)-P1(2))/(P2(1)-P1(1));
% b = P1(2)-a*P1(1);
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
if DD>0
    
    %solve the polynom
    p = [AlPha BeTa Gamma];
    t_int = roots(p);
    
    % get the points intersecting the circle
    pt_int(:,1)= P1(1:3) +N(1:3).*t_int(1);
    pt_int(:,2)= P1(1:3) +N(1:3).*t_int(2);
    
    % Find the closest to P1
    val(1)=norm(P1-pt_int(:,1));
    val(2)=norm(P1-pt_int(:,2));
    [~,ind]=min(val);
    P1c = pt_int(:,ind);
    
    % Find the closest to P2
    val(1)=norm(P2-pt_int(:,1));
    val(2)=norm(P2-pt_int(:,2));
    [~,ind]=min(val);
    P2c = pt_int(:,ind);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % define more conditions on intersecting
    % the line has to cross the circle between the two points
%     cdt1=(-0.5*h<P2c(3) && P2c(3)<0.5*h);
%     cdt2=(-0.5*h<P1c(3) && P1c(3)<0.5*h);
%     cdt3 = ~isequal( sign(P1(3)), sign(P2(3)) );
    
    
    bool1= ( (P1(1)<P2c(1) && P2c(1)<P2(1))...
            || (P1(1)>P2c(1) && P2c(1)>P2(1)) ) ...
            ||...
        ( (P1(1)<P1c(1) && P1c(1)<P2(1)) ||...
        (P1(1)>P1c(1) && P1c(1)>P2(1)) ) || P1(1)==P2c(1);
    
    bool2= ( (P1(2)<P2c(2) && P2c(2)<P2(2)) ||...
        (P1(2)>P2c(2) && P2c(2)>P2(2)) )...
        ||...
        ( (P1(2)<P1c(2) && P1c(2)<P2(2)) ||...
        (P1(2)>P1c(2) && P1c(2)>P2(2)) ) || P1(2)==P2c(2);;
    
    bool3= ((P1(3)<P2c(3) && P2c(3)<P2(3)) ||...
        (P1(3)>P2c(3) && P2c(3)>P2(3)) )...
        ||...
        ((P1(3)<P1c(3) && P1c(3)<P2(3)) ||...
        (P1(3)>P1c(3) && P1c(3)>P2(3)) )|| P1(3)==P2c(3);;
    
    
    if (bool1 && bool2 && bool3)
        
        bool=1;
    end

end

end