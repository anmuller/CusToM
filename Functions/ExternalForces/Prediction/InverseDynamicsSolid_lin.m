function [Human_model,b1,b2]=InverseDynamicsSolid_lin(Human_model,g,j,b1,b2)
% Computation of the inverse dynamics step on one solid linearly written according to the external forces
%   
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the structure)
%   - g: vector of gravity
%   - j: number of the solid to study
%   - b1/b2: current coefficient of the linear equation (updated at each call)
%   OUTPUT
%   - Human_model: osteo-articular model with additional joint torques (see the Documentation for the structure)
%   - f: dynamic residuals (forces)
%   - t: dynamic residuals (torques)
%   - b1/b2: current coefficient of the linear equation (updated at each call)
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
    return;
end

c=Human_model(j).R*Human_model(j).c+Human_model(j).p; % centre de masse
I=Human_model(j).R*Human_model(j).I*Human_model(j).R'; % tenseur d'inertie exprimé au centre de masse
c_hat=wedge(c);
I=I+Human_model(j).m*(c_hat*c_hat'); % tenseur d'inertie exprimé au repère global
P=Human_model(j).m*(Human_model(j).v0+cross(Human_model(j).w,c)); % quantité de mouvement
L=Human_model(j).m*cross(c,Human_model(j).v0)+I*Human_model(j).w; % moment cinétique

%%computation of the external forces -->external forces+gravity+previous body forces
b1=b1 + Human_model(j).m*(Human_model(j).dv0+cross(Human_model(j).dw,c))+cross(Human_model(j).w,P)...
     - Human_model(j).m*g;
b2=b2 + Human_model(j).m*cross(c,Human_model(j).dv0)+I*Human_model(j).dw+cross(Human_model(j).v0,P)+cross(Human_model(j).w,L)...
     - cross(c,Human_model(j).m*g);

[Human_model,b1,b2]=InverseDynamicsSolid_lin(Human_model,g,Human_model(j).child,b1,b2);
[Human_model,b1,b2]=InverseDynamicsSolid_lin(Human_model,g,Human_model(j).sister,b1,b2);

end