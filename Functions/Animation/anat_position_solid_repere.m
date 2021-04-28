function [Human_model] = anat_position_solid_repere(Human_model,i)
% Identification of anatomical positions where other solids are fixed
%  
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - i: current solid
%   OUTPUT
%   - Human_model: osteo-articular model with additional computations (see
%   the Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud, Pauline Morin and
% Georges Dumont
%________________________________________________________

if i == 0 % end of the kinematic chain
    return;
end

j=Human_model(i).mother; % number of the mother solid
if j == 0 % initialization : first time this function is called
    Human_model(i).pos_solid_visual=[]; % init of a new domain    
end
if (j ~= 0) && (Human_model(j).Visual ~= 0) 
    Human_model(j).pos_solid_visual = [Human_model(j).pos_solid_visual Human_model(i).b];
end

[Human_model] = anat_position_solid_repere(Human_model,Human_model(i).child);
[Human_model] = anat_position_solid_repere(Human_model,Human_model(i).sister);

end