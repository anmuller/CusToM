function [Human_model, Muscles, Markers_set]=ForwardKinematicsAnimation(...
    Human_model,Markers_set,Muscles,q,j,...
    muscles_anim,mod_marker_anim,solid_inertia_anim)
% Computation of a forward kinematics step for the animation
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - Markers_set: set of markers (see the Documentation for the structure)
%   - Muscles: set of muscles (see the Documentation for the structure)
%   - q: vector of joint coordinates
%   - j: current solid
%   - muscles_anim: representation of the muscles (0 or 1)
%   - mod_marker_anim: representation of the model markers (0 or 1)
%   - solid_inertia_anim: representation of the stadium solids (0 or 1)
%   OUTPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - Muscles: set of muscles (see the Documentation for the structure)
%   - Markers_set: set of markers (see the Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if j == 0 
    return;
end

i=Human_model(j).mother; % number (ident) of mother
if i == 0
    Human_model(j).p = zeros(3,1);
    Human_model(j).R = eye(3,3);
    Human_model(j).pos_pts_anim=[]; % initialization of a new domain
else
    if Human_model(j).joint == 1    % hinge         
        Human_model(j).p = Human_model(i).R * Human_model(j).b + Human_model(i).p;
        Human_model(j).R = Human_model(i).R * Rodrigues(Human_model(j).a,q(j)) * Rodrigues(Human_model(j).u,Human_model(j).theta);
    end
    if Human_model(j).joint == 2    % slider
        Human_model(j).p = Human_model(i).R * (Human_model(j).b + q(j)*Human_model(j).a) + Human_model(i).p;
        Human_model(j).R = Human_model(i).R * Rodrigues(Human_model(j).u,Human_model(j).theta);
    end
end

% Computation of the location for each point
if Human_model(j).Visual == 1
    Human_model(j).pos_pts_anim = [Human_model(j).pos_pts_anim Human_model(j).p]; % segment local coordinate frame
    Human_model(j).pos_pts_anim = [Human_model(j).pos_pts_anim (Human_model(j).R * Human_model(j).c + Human_model(j).p)]; % position of center of mass
    for n = 1:size(Human_model(j).pos_solid_visual,2)
        Human_model(j).pos_pts_anim = [Human_model(j).pos_pts_anim (Human_model(j).R * Human_model(j).pos_solid_visual(:,n) + Human_model(j).p)]; % other points
    end
    % markers (if there is a solid at chain’s extremity with center of mass
    % at the same location as origin)
    if (Human_model(j).child == 0 && min(Human_model(j).c == [0 0 0]') ~= 0)
        for m=1:numel(Markers_set)
            if Markers_set(m).exist && Markers_set(m).num_solid == j
                Human_model(j).pos_pts_anim = [Human_model(j).pos_pts_anim (Human_model(j).R * (Human_model(j).c + Human_model(j).anat_position{Markers_set(m).num_markers,2}) + Human_model(j).p)];
            end
        end
    end
end
if solid_inertia_anim
    % Computation of cylinders origins
    for n=1:numel(Human_model)
        for b=1:numel(Human_model(n).N_Bone) % for each bone on the solid
            if Human_model(n).N_Bone(b,1) == j % if the considered point belongs to solid j: compute its position
                Human_model(n).pos_cylinder_anim(:,b) = (Human_model(j).R * (Human_model(j).c + Human_model(j).anat_position{Human_model(n).N_Point(b,1),2}) + Human_model(j).p);
            end
        end
    end
end
% mod_marker
if mod_marker_anim
    for m=1:numel(Markers_set)
        if Markers_set(m).exist && Markers_set(m).num_solid == j
            Markers_set(m).pos_anim = (Human_model(j).R * (Human_model(j).c + Human_model(j).anat_position{Markers_set(m).num_markers,2}) + Human_model(j).p);
        end        
    end
end
% position of muscle points
if muscles_anim
    for m=1:numel(Muscles) % for each muscle
        if Muscles(m).exist
            for num_pts = 1:numel(Muscles(m).num_solid) % for each point associated to the muscle m
                if Muscles(m).num_solid(num_pts,1) == j
                        Muscles(m).pos_pts(:,num_pts) = (Human_model(j).R * (Human_model(j).c + Human_model(j).anat_position{Muscles(m).num_markers(num_pts,1),2}) + Human_model(j).p);
                end
            end 
        end
    end
end

[Human_model, Muscles, Markers_set]=ForwardKinematicsAnimation(Human_model,Markers_set,Muscles,q,Human_model(j).sister,muscles_anim,mod_marker_anim,solid_inertia_anim);
[Human_model, Muscles, Markers_set]=ForwardKinematicsAnimation(Human_model,Markers_set,Muscles,q,Human_model(j).child,muscles_anim,mod_marker_anim,solid_inertia_anim);

end
