function [Human_model]=ForwardKinematicsAnimation8XSens(Human_model,q,j)
% Computation of a forward kinematics step for the animation8 (adapted for
% XSens data)
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - q: vector of joint coordinates
%   - j: current solid
%   OUTPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if j == 0 
    return;
end

i=Human_model(j).mother; % index of the mother solid (numéro de la mère)
if i == 0
    Human_model(j).pos_pts_anim=[]; % new domain initialisation (on initialise un nouveau domaine)
else
    if Human_model(j).joint == 1    % hinge (liaison pivot)        
        Human_model(j).p = Human_model(i).R * Human_model(j).b + Human_model(i).p;
        Human_model(j).R = Human_model(i).R * Rodrigues(Human_model(j).a,q(j)) * Rodrigues(Human_model(j).u,Human_model(j).theta);
    end
    if Human_model(j).joint == 2    % prismatic joint (liaison glissière)
        Human_model(j).p = Human_model(i).R * (Human_model(j).b + q(j)*Human_model(j).a) + Human_model(i).p;
        Human_model(j).R = Human_model(i).R * Rodrigues(Human_model(j).u,Human_model(j).theta);
    end
end
Human_model(j).pc = Human_model(j).p + Human_model(j).R*Human_model(j).c;
Human_model(j).Tc_R0_Ri=[Human_model(j).R, Human_model(j).pc ; [0 0 0 1]];

% Each point position computation (Calcul de la position de chaque points)
if Human_model(j).Visual == 1
    for m = 1:size(Human_model(j).anat_position,1)
        Human_model(j).pos_pts_anim = [Human_model(j).pos_pts_anim ... 
            (Human_model(j).R * (Human_model(j).c + Human_model(j).anat_position{m,2}) + Human_model(j).p)];
    end
end

[Human_model]=ForwardKinematicsAnimation8XSens(Human_model,q,Human_model(j).sister);
[Human_model]=ForwardKinematicsAnimation8XSens(Human_model,q,Human_model(j).child);

end
