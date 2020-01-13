function [ExternalForcesComputationResults] = ExternalForces_Zero(filename, BiomechanicalModel)
% Computation of ExternalForcesComputationResults structure when there is no external forces
%
%   INPUT
%   - filename: name of the file to process (character string)
%   - BiomechanicalModel: musculoskeletal model
%   OUTPUT
%   - ExternalForcesComputationResults: results of the external forces
%   computation (see the Documentation for the structure)  
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

Human_model = BiomechanicalModel.OsteoArticularModel;
load([filename '/ExperimentalData.mat']); %#ok<LOAD>
time = ExperimentalData.Time;
nbframe=numel(time);

% Initialisation
for f=1:nbframe
    for n=1:numel(Human_model)
        external_forces(f).fext(n).fext=zeros(3,2); %#ok<AGROW,*SAGROW>
    end
end

if exist([filename '/ExternalForcesComputationResults.mat'],'file')
    load([filename '/ExternalForcesComputationResults.mat']);
end
ExternalForcesComputationResults.NoExternalForce = external_forces;

end