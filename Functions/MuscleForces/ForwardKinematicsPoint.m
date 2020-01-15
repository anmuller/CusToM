function [p] = ForwardKinematicsPoint(Human_model,num_solid_repere,num_solid,num_point,q)
% Computation of the position of a point according to a reference solid
%   
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - num_solid_repere: number of the reference solid
%   - num_solid: number of the solid containing the point
%   - num_point: number of the anatomical position of the point on its
%   corresponded solid 
%   - q: vector of joint coordinates
%   OUTPUT
%   - p: position of the point
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
% Initialisation
Human_model(num_solid_repere).p = zeros(3,1);
Human_model(num_solid_repere).R = eye(3);

% Computation of the point coordinates
if num_solid == num_solid_repere
    p = Human_model(num_solid).c+Human_model(num_solid).anat_position{num_point,2};
else
    path_solid = find_solid_path(Human_model,num_solid,num_solid_repere);

    for n=path_solid(2:end)
        m = Human_model(n).mother;
        Human_model(n).p = Human_model(m).R * Human_model(n).b + Human_model(m).p;
        Human_model(n).R = Human_model(m).R * Rodrigues(Human_model(n).a,q(n)) * Rodrigues(Human_model(n).u,Human_model(n).theta);
    end
    l = path_solid(end);
    Human_model(l).c_global = Human_model(l).p + Human_model(l).R * Human_model(l).c;
    p = Human_model(l).c_global + Human_model(l).R * Human_model(num_solid).anat_position{num_point,2};
end

end


