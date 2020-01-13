function [Human_model, Muscles, Markers_set]=ForwardKinematicsAnimation_Interf(Human_model,Markers_set,Muscles,q,j,seg_anim,muscles_anim,mod_marker_anim,RPelvis)
% Computation of a forward kinematics step for the interface
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
%   - RPelvis: rotation of the pelvis
%   OUTPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - Muscles: set of muscles (see the Documentation for the structure)
%   - Markers_set: set of markers (see the Documentation for the structure)
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

i=Human_model(j).mother; % number of the mother
if i == 0
    Human_model(j).p = zeros(3,1);
    Human_model(j).R = RPelvis;
    Human_model(j).pos_pts_anim=[]; % new field initialization
else
    if Human_model(j).joint == 1    % pin joint
        Human_model(j).p = Human_model(i).R * Human_model(j).b + Human_model(i).p;
        Human_model(j).R = Human_model(i).R * Rodrigues(Human_model(j).a,q(j)) * Rodrigues(Human_model(j).u,Human_model(j).theta);
    end
    if Human_model(j).joint == 2    % slide joint
        Human_model(j).p = Human_model(i).R * (Human_model(j).b + q(j)*Human_model(j).a) + Human_model(i).p;
        Human_model(j).R = Human_model(i).R * Rodrigues(Human_model(j).u,Human_model(j).theta);
    end
end
Human_model(j).pc = Human_model(j).p + Human_model(j).R*Human_model(j).c;
Human_model(j).Tc_R0_Ri=[Human_model(j).R, Human_model(j).pc ; [0 0 0 1]];

% Computation of each point position
if seg_anim
if Human_model(j).Visual == 1
    Human_model(j).pos_pts_anim = [Human_model(j).pos_pts_anim Human_model(j).p]; % local segment coordinate frame
    Human_model(j).pos_pts_anim = [Human_model(j).pos_pts_anim (Human_model(j).R * Human_model(j).c + Human_model(j).p)]; % center of mass position
    for n = 1:size(Human_model(j).pos_solid_visual,2)
        Human_model(j).pos_pts_anim = [Human_model(j).pos_pts_anim (Human_model(j).R * Human_model(j).pos_solid_visual(:,n) + Human_model(j).p)]; % other points
    end
	% markers (if there is one solid without children with the center of mass at the same location at the origin
    if (Human_model(j).child == 0 && min(Human_model(j).c == [0 0 0]') ~= 0)
        for m=1:numel(Markers_set)
            if Markers_set(m).exist && Markers_set(m).num_solid == j
                Human_model(j).pos_pts_anim = [Human_model(j).pos_pts_anim (Human_model(j).R * (Human_model(j).c + Human_model(j).anat_position{Markers_set(m).num_markers,2}) + Human_model(j).p)];
            end
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
            for num_pts = 1:numel(Muscles(m).num_solid) % each point associated to the muscle m
                if Muscles(m).num_solid(num_pts,1) == j
                        Muscles(m).pos_pts(:,num_pts) = (Human_model(j).R * (Human_model(j).c + Human_model(j).anat_position{Muscles(m).num_markers(num_pts,1),2}) + Human_model(j).p);
                end
            end 
        end
    end
end

[Human_model, Muscles, Markers_set]=ForwardKinematicsAnimation_Interf(Human_model,Markers_set,Muscles,q,Human_model(j).sister,seg_anim,muscles_anim,mod_marker_anim);
[Human_model, Muscles, Markers_set]=ForwardKinematicsAnimation_Interf(Human_model,Markers_set,Muscles,q,Human_model(j).child,seg_anim,muscles_anim,mod_marker_anim);

end
