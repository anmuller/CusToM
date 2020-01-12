function [Prediction]=verif_Prediction_Humanmodel(Human_model,Prediction)
% Verification that each contact point on Prediction is correctly defined on the osteo-articular model
%   Each anatomical position used for the prediction of external forces has
%   to be defined on the osteo-articular model. If it is not the case, the
%   corresponded point will be not considered. 
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - Prediction: contact points for the ground reaction forces
%   OUTPUT
%   - Prediction: contact points for the ground reaction forces with
%   additional informations about the position of the anatomatical
%   positions on the osteo-articular model  
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

prediction_ex=cell(0);
for i=1:numel(Prediction)
    test=0;
    name=Prediction(i).points_prediction_efforts;
    for j=1:numel(Human_model)
        for k=1:size(Human_model(j).anat_position,1)
            if strcmp(name,Human_model(j).anat_position(k,1))
                Prediction(i).exist=1;
                Prediction(i).num_solid=j;
                Prediction(i).num_markers=k;
                test=1;
                break
            end
        end
        if test == 1
            break
        end
    end
    if test == 0
        prediction_ex{end+1,1}=Prediction(i).points_prediction_efforts; %#ok<AGROW>
        Prediction(i).exist=0;
    end    
end
if numel(prediction_ex) ~= 0
    warning(['No existent prediction points: ']) %#ok<NBRAK>
    disp(prediction_ex)
end

end
