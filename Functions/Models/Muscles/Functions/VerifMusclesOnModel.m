function [Muscles]=VerifMusclesOnModel(Human_model,Muscles)
% Verification that each muscle is correctly defined on the osteo-articular model
%   Each anatomical position used in the set of muscles has to be defined
%   on the osteo-articular model. If it is not the case, the corresponded
%   muscle will be not considered. 
%   
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the structure)
%   - Muscles: set of muscles (see the Documentation for the structure)
%   OUTPUT
%   - Muscles: set of muscles with additional informations about the position
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
muscles_ex=cell(0);
for i=1:numel(Muscles) % for each muscle
    test=zeros(size(Muscles(i).path,1),1);
    for p=1:size(Muscles(i).path,1) % for each points used by the muscle
        name=Muscles(i).path{p,1};
        for j=1:numel(Human_model)
            for k=1:size(Human_model(j).anat_position,1)
                if strcmp(name,Human_model(j).anat_position(k,1))
                    Muscles(i).num_solid(p,1)=j;
                    Muscles(i).num_markers(p,1)=k;
                    test(p,1)=1;
                end
            end
            if min(test) == 1
                Muscles(i).exist=1;
                break
            end
        end
    end
    if min(test) == 0
        muscles_ex{end+1,1}=Muscles(i).name; %#ok<AGROW>
        Muscles(i).exist=0;
    end 

end
if numel(muscles_ex) ~= 0
    warning('No existent muscles: ')
    disp(muscles_ex)
end

end