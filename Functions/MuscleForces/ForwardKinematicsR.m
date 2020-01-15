function [Human_model]=ForwardKinematicsR(Human_model,j,q)
% Computation of a forward kinematics step to obtained all matrix rotation
%   
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - j: current solid
%   - q: vector of joint coordinates
%   OUTPUT
%   - Human_model: osteo-articular model with additional computations
%   (see the Documentation for the structure) 
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

if Human_model(j).mother ~= 0
    i=Human_model(j).mother; % number of mother
    if Human_model(j).joint == 1    % pin joint
        Human_model(j).R = Human_model(i).R * Rodrigues(Human_model(j).a,q(j)) * Rodrigues(Human_model(j).u,Human_model(j).theta);
    end
    if Human_model(j).joint == 2    % sliding joint
        Human_model(j).R = Human_model(i).R * Rodrigues(Human_model(j).u,Human_model(j).theta);
    end
end

Human_model=ForwardKinematicsR(Human_model,Human_model(j).sister,q);
Human_model=ForwardKinematicsR(Human_model,Human_model(j).child,q);

end