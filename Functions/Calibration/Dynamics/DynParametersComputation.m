function [Masse,Zc,Ix,Iy,Iz] = DynParametersComputation(D,r0,t0,r1,t1,h)
% Computation of the inertial parameters of a stadium solid from its geometrical parameters
%
%   INPUT
%   - D: density of the stadium solid
%   - r0/t0/r1/t1/h: geometrical parameters of the stadium solid
%   OUTPUT
%   - Masse: mass of the solid
%   - Zc: position of the center of mass along the principal axis
%   - Ix: moment of inertia on x-axis
%   - Iy: moment of inertia on y-axis
%   - Iz: moment of inertia on z-axis
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if r0 ~= 0
    a = (r1-r0)/r0;
    if t0 ~= 0
        b=(t1-t0)/t0;
        % Mass
        Masse = D*h*r0*(4*t0*F1(a,b) + pi*r0*F1(a,a));
        % Center of mass position (Position du centre de masse)
        Zc=D*h^2*(4*r0*t0*F2(a,b)+pi*r0^2*F2(a,a))/Masse;
        % Inertia
        intz2Adz=4*r0*t0*F3(a,b) + pi*r0^2*F3(a, a) ;
        intJxdz=4*r0*t0^3*F4(a,b)/3 + pi*r0^4*F4(a, a)/4;
        intJydz=4*r0*t0^3*F4(a,b)/3 + pi*r0^2*t0^2*F5(a,b) + 8*r0^3*t0*F4(b,a)/3 + pi*r0^4*F4(a,a)/4;
        Iz=D*h*(4*r0*t0^3*F4(a,b)/3 + pi*r0^2*t0^2*F5(a,b) + 4*r0^3*t0*F4(b,a) + pi*r0^4*F4(a,a)/2); 
    else
        Masse = D*h*r0*(pi*r0*F1(a,a));
        Zc=D*h^2*(pi*r0^2*F2(a,a))/Masse;
        intz2Adz= pi*r0^2*F3(a,a) ;
        intJxdz=pi*r0^4*F4(a,a)/4;
        intJydz= pi*r0^4*F4(a,a)/4;
        Iz=D*h*(pi*r0^4*F4(a,a)/2); 
    end
    % Inertia
    Ix0=D*h*intJxdz+D*h^3*intz2Adz;
    Ix=Ix0-Masse*Zc^2;
    Iy0=D*h*intJydz+D*h^3*intz2Adz;
    Iy=Iy0-Masse*Zc^2;
else
    Masse = 0;
    Zc = 3*h/4;
    Ix = 0;
    Iy = 0;
    Iz = 0;
end

end

function val=F1(a,b)
val=1 + (a+b)/2 + (a*b)/3;
end

function val=F2(a,b)
val=1/2 + (a+b)/3 + (a*b)/4;
end

function val=F3(a,b)
val=1/3 + (a+b)/4 + (a*b)/5;
end

function val=F4(a,b)
val = 1 + (a + 3*b)/2 + (3*a*b + 3*b^2)/3 + (3*a*b^2+ b^3)/4 + (a*b^3)/5;
end

function val=F5(a,b)
val= 1+ (2*a+ 2*b)/2 + (a^2 + 4*a*b + b^2)/3 + 2*a*b*(a + b)/4 + (a^2*b^2)/5; 
end
