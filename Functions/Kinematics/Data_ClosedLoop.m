function [solid_path1,solid_path2,num_solid,num_markers]=Data_ClosedLoop(Human_model)
% Return data fixed by the model about closing loop

%   INPUT
%  - Human_model: osteo-articular model (see the Documentation for the
%   structure)

%   OUTPUT
%   - solid_path1 : vector of one of the two paths to close the loop
%   - solid_path2 : vector of the other of the two paths to close the loop
%   - num_solid : vector of the number of solid where the anatomical point must join the
%   origin of another joint to close the loo
%   - num_markers : vector of the position in the list "anat_position" that
%   corresponds to the point to close the loop


solid_path1={};
solid_path2={};
num_solid=[];
num_markers=[];
for j=1:numel(Human_model)
    if size(Human_model(j).ClosedLoop) ~= [0 0] %#ok<BDSCA>
        % we find the solid and the position where there was a cut
        name=Human_model(j).ClosedLoop;
        test=0;
        for pp=1:numel(Human_model)
            for kk=1:size(Human_model(pp).anat_position,1)
                if strcmp(name,Human_model(pp).anat_position(kk,1))
                    num_solid=[num_solid pp];
                    num_markers=[num_markers kk];
                    test=1;
                    break
                end
            end
            if test == 1
                break
            end
        end
        [path1,path2]=find_solid_path(Human_model,j,num_solid(end));
        solid_path1=[solid_path1 path1];
        solid_path2=[solid_path2 path2];
    end
end

end
