function dependancies=KinematicDependancy(Human_model)
% Structure of equations for kinematics dependancy declared in Human_model
%
%   INPUT
%  - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   OUTPUT
%   - dependancies: structure where are defined all kinematic dependancies
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________






dependancies=[];
if isfield(Human_model,'kinematic_dependancy')
    dependancies=[Human_model.kinematic_dependancy];
    
    if ~isempty(dependancies)
        ind_output=1;
        for k=1:size(Human_model,2)
            if ~isempty(Human_model(k).kinematic_dependancy)
                dependancies(ind_output).solid=k;
                ind_output=ind_output+1;
            end
        end
    end
end


end