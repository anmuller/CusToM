function [BiomechanicalModelscaled]=MuscleCalibrationAnthropo(ModelParameters,AnalysisParameters,BiomechanicalModel)

%% Model of reference
RefBiomechanicalModel = GenerateGenericModel(ModelParameters);

if isfield(BiomechanicalModel,'Generalized_Coordinates')
    q=BiomechanicalModel.Generalized_Coordinates.q_complete;
    Nb_q= size(q,1);
else
    Nb_q = numel(Human_model)-6;
end

Nb_m=length(RefBiomechanicalModel.Muscles);


%% Scaling l0 and ls
% tendon slack lengths
% optimal musce lengths

% Measuring Musculotendon lengths of the model in reference position with
% all DoF at zero.
% for the reference model and the scaled model.

L_MT_ref = MuscleLengthComputationNum(RefBiomechanicalModel,zeros(Nb_q,1));
L_MT_scaled = MuscleLengthComputationNum(BiomechanicalModel,zeros(Nb_q,1));

BiomechanicalModelscaled = BiomechanicalModel;

% Homothetic factors for anthropometric scaling of muscle paramaters
% optimal muscle fiber lengths l0
% tendon slack length ls

k_m = L_MT_scaled ./ L_MT_ref;

BiomechanicalModelscaled.AnthropometricMuscleScaling=k_m;

for ii=1:Nb_m
    
BiomechanicalModelscaled.Muscles(ii).l0 = ...
    k_m(ii)*BiomechanicalModel.Muscles(ii).l0;

BiomechanicalModelscaled.Muscles(ii).ls = ...
    k_m(ii)*BiomechanicalModel.Muscles(ii).ls;

end

%% Scaling F0
% maximal isometric forces

% functions in the AnalysisParameters struct.
F0_scaled = Maximal_Isometric_Force_Scaling_Steele(BiomechanicalModel.Muscles,ModelParameters);

for ii=1:Nb_m
    BiomechanicalModelscaled.Muscles(ii).f0 = ...
    F0_scaled(ii);
end
end