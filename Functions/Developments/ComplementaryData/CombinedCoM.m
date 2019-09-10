function [] = CombinedCoM(AnalysisParameters)

load('BiomechanicalModel.mat'); %#ok<LOAD>
Human_model = BiomechanicalModel.OsteoArticularModel;
for num_f = 1:numel(AnalysisParameters.filename) % for each file
    load([filename '/InverseKinematicsResults.mat']); %#ok<LOAD>
    load([filename '/ExternalForcesComputationResults.mat']); %#ok<LOAD>
    CCoM = zeros(3,size(InverseKinematicsResults.JointOrientations,2));
    for j = 1:size(InverseKinematicsResults.JointOrientations,2)
        for i = 1:numel(Human_model)
            Human_model(i).p = InverseKinematicsResults.JointPositions{i}(:,j);
            Human_model(i).R = InverseKinematicsResults.JointOrientations{i,j};
        end
        CoM = CalcCoM(Human_model);
        % Combining human body and load
        CCoM(:,i) = (sum([Human_model.m])*CoM + ...
            ExternalForcesComputationResults.Boxes(j).m*ExternalForcesComputationResults.Boxes(j).p) / ...
            (sum([Human_model.m]) + ExternalForcesComputationResults.Boxes(j).m);
    end
    InverseKinematicsResults.CCoM = CCoM;
end

end