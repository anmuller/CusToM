function [ExternalForcesComputationResults] = MassLoad(filename, BiomechanicalModel, AnalysisParameters)
% Computation of the external forces
%   From a c3d file, external forces are extracted, filtered and shaped
%   into an adapted structure
%
%   INPUT
%   - filename: name of the c3d file to process (character string)
%   - BiomechanicalModel: musculoskeletal model
%   - AnalysisParameters: parameters of the musculoskeletal analysis,
%   automatically generated by the graphic interface 'Analysis' 
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
% Firstframe = ExperimentalData.FirstFrame;
% Lastframe = ExperimentalData.LastFrame;

nbframe=numel(time);
f_mocap=1/time(2);

% Initialisation
for f=1:nbframe
    for n=1:numel(Human_model)
        external_forces(f).fext(n).fext=zeros(3,2); %#ok<AGROW,*SAGROW>
    end
end

% for solid = 1:size(AnalysisParameters.ExternalForces.Mass,2)
%     idx = find(strcmp({BiomechanicalModel.OsteoArticularModel.name},AnalysisParameters.ExternalForces.Mass{2, solid}));  
%     BiomechanicalModel.OsteoArticularModel(idx).m =  BiomechanicalModel.OsteoArticularModel(idx).m  + AnalysisParameters.ExternalForces.Mass{1, solid};
% end
% 
% save('BiomechanicalModel','BiomechanicalModel');



% Sauvegarde des donn�es (data saving)
if exist([filename '/ExternalForcesComputationResults.mat'],'file')
    load([filename '/ExternalForcesComputationResults.mat']);
end
ExternalForcesComputationResults.ExternalForcesExperiments = external_forces;


end