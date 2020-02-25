function [Human_model] = ForwardPositions(Human_model,j)
% Computation of spacial position and rotation for each solid starting from
% j
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - j: current solid
%   OUTPUT
%   - Human_model: osteo-articular model with additional computations (see
%   the Documentation for the structure)
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

if j==0
    return;
end

%% Position vector and Rotation Matrix computation
if j~=1
    i=Human_model(j).mother;
    
    % Pin joint
    if Human_model(j).joint == 1    
        Human_model(j).p=Human_model(i).R*Human_model(j).b+Human_model(i).p;
        Human_model(j).R=Human_model(i).R*Rodrigues(Human_model(j).a,Human_model(j).q)*Rodrigues(Human_model(j).u,Human_model(j).theta);
    end
    
    % Slide joint
    if Human_model(j).joint == 2    
        Human_model(j).p=Human_model(i).R*Human_model(j).b+Human_model(i).R*Human_model(j).a*Human_model(j).q+Human_model(i).p;
        Human_model(j).R=Human_model(i).R*Rodrigues(Human_model(j).u,Human_model(j).theta);
    end    
end

Human_model=ForwardPositions(Human_model,Human_model(j).sister);
Human_model=ForwardPositions(Human_model,Human_model(j).child);

end

