function [Human_model,f,t]=InverseDynamicsSolid(Human_model,external_forces,g,j)
% Computation of the inverse dynamics step on one solid
%   
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the structure)
%   - external_forces: external forces applied on the subject
%   - g: vector of gravity
%   - j: number of the solid to study
%   OUTPUT
%   - Human_model: osteo-articular model with additional joint torques (see the Documentation for the structure)
%   - f: dynamic residuals (forces)
%   - t: dynamic residuals (torques)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if j==0
    f=[0 0 0]';
    t=[0 0 0]';
return;
end

c=Human_model(j).R*Human_model(j).c+Human_model(j).p; % centre de masse
I=Human_model(j).R*Human_model(j).I*Human_model(j).R'; % tenseur d'inertie exprimé au centre de masse
c_hat=wedge(c);
I=I+Human_model(j).m*(c_hat*c_hat'); % tenseur d'inertie exprimé au repère global
P=Human_model(j).m*(Human_model(j).v0+cross(Human_model(j).w,c)); % quantité de mouvement
L=Human_model(j).m*cross(c,Human_model(j).v0)+I*Human_model(j).w; % moment cinétique

%%computation of the external forces -->external forces+gravity+previous body forces
f0=Human_model(j).m*(Human_model(j).dv0+cross(Human_model(j).dw,c))+cross(Human_model(j).w,P)...
    - external_forces(j).fext(:,1) - Human_model(j).m*g;
t0=Human_model(j).m*cross(c,Human_model(j).dv0)+I*Human_model(j).dw+cross(Human_model(j).v0,P)+cross(Human_model(j).w,L)...
    - external_forces(j).fext(:,2) - cross(c,Human_model(j).m*g);

[Human_model,f1,t1]=InverseDynamicsSolid(Human_model,external_forces,g,Human_model(j).child);
f=f0+f1;
t=t0+t1;

if j~=1
    Human_model(j).f=f;
    Human_model(j).t=t;
    Human_model(j).torques=Human_model(j).sv'*f+Human_model(j).sw'*t;
end

[Human_model,f2,t2]=InverseDynamicsSolid(Human_model,external_forces,g,Human_model(j).sister);
f=f+f2;
t=t+t2;

end