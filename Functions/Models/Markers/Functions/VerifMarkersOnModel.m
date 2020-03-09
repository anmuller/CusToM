function [Markers_set]=VerifMarkersOnModel(Human_model,Markers_set)
% Verification that each marker is correctly defined on the osteo-articular model
%   Each anatomical position used in the set of markers has to be defined
%   on the osteo-articular model. If it is not the case, the corresponded
%   marker will be not considered. 
%   
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the structure)
%   - Markers_set: set of markers (see the Documentation for the structure)
%   OUTPUT
%   - Markers_set: set of markers with additional informations about the position
%   of the anatomatical positions on the osteo-articular model (see the
%   Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
markers_ex=cell(0);
for i=1:numel(Markers_set)
    test=0;
    name=Markers_set(i).anat_position;
    for j=1:numel(Human_model)
        for k=1:size(Human_model(j).anat_position,1)
            if strcmp(name,Human_model(j).anat_position(k,1))
                Markers_set(i).exist=1;
                Markers_set(i).num_solid=j;
                Markers_set(i).num_markers=k;
                test=1;
                break
            end
        end
        if test == 1
            break
        end
    end
    if test == 0
        markers_ex{end+1,1}=Markers_set(i).name; %#ok<AGROW>
        Markers_set(i).exist=0;
    end    
end

end