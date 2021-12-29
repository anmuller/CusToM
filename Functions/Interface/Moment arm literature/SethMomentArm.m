function [MomentsArm,RegressionStructure]=SethMomentArm(mus_name,axis,joints_names,q)
% Computing of moment arm as a function of q
%
% All data comes from
% Seth, A., Dong, M., Matias, R., & Delp, S. (2019).
% Muscle contributions to upper-extremity movement and
% work from a musculoskeletal model of the human shoulder.
% Frontiers in Neurorobotics, 13(November), 1–9.
% https://doi.org/10.3389/fnbot.2019.00090
%
%   INPUT
%   - mus_name : name of the muscle concerned
%   - axis : vector of the moment arm axe
%   - joints_names : vector of names of the joints concerned in the moment
%   arm
%   - q : vector of coordinates at the current instant
%
%   OUTPUT
%   - MusculotendonLength : value of moment arm
%   - RegressionStructure : structure containing moment arm
%   equations and coefficients
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________


mus_name = mus_name{:};
mus_name = mus_name(2:end);
MomentsArm = [];
RegressionStructure = [];
load('SethMomentArmData.mat');


if ~isempty(intersect(mus_name,{'Coracobrachialis','DeltoideusScapula_M','DeltoideusScapula_P','Infraspinatus_I','Infraspinatus_S',...
        'LatissimusDorsi_I', 'LatissimusDorsi_S','LevatorScapulae','PectoralisMajorThorax_I','PectoralisMajorThorax_M'...
        'PectoralisMinor','Rhomboideus_I','Rhomboideus_S','SerratusAnterior_I','SerratusAnterior_M','SerratusAnterior_S',...
        'Subscapularis_I','Subscapularis_M','Subscapularis_S','Supraspinatus_A','Supraspinatus_P','TeresMajor',...
        'TeresMinor','TrapeziusClavicle_S','TrapeziusScapula_I','TrapeziusScapula_M','TrapeziusScapula_S'}))
    
    
    %% GH muscles
    
    if strcmp(mus_name,'Coracobrachialis')
        
        [MomentsArm,RegressionStructure] = CreateSethRegression3angles(Coracobrachialis,axis,joints_names,q);
        
        
    elseif strcmp(mus_name,'DeltoideusScapula_M')
        
        [MomentsArm,RegressionStructure] = CreateSethRegression3angles(DeltoideusScapula_M,axis,joints_names,q);
        
    elseif strcmp(mus_name,'DeltoideusScapula_P')
        
        
        [MomentsArm,RegressionStructure] = CreateSethRegression3angles(DeltoideusScapula_P,axis,joints_names,q);
        
        
    elseif strcmp(mus_name,'Infraspinatus_I')
        
        [MomentsArm,RegressionStructure]  = CreateSethRegression3angles(Infraspinatus_I,axis,joints_names,q);
        
        
    elseif strcmp(mus_name,'Infraspinatus_S')
        
        [MomentsArm,RegressionStructure]  = CreateSethRegression3angles(Infraspinatus_S,axis,joints_names,q);
        
    elseif strcmp(mus_name,'Subscapularis_I')
        
        [MomentsArm,RegressionStructure]  = CreateSethRegression3angles(Subscapularis_I,axis,joints_names,q);
        
        
    elseif strcmp(mus_name,'Subscapularis_M')
        
        
        [MomentsArm,RegressionStructure]  = CreateSethRegression3angles(Subscapularis_M,axis,joints_names,q);
        
    elseif strcmp(mus_name,'Subscapularis_S')
        
        
        [MomentsArm,RegressionStructure]  = CreateSethRegression3angles(Subscapularis_S,axis,joints_names,q);
        
        
    elseif strcmp(mus_name,'Supraspinatus_A')
        
        [MomentsArm,RegressionStructure] = CreateSethRegression3angles(Supraspinatus_A,axis,joints_names,q);
        
        
    elseif strcmp(mus_name,'Supraspinatus_P')
        
        [MomentsArm,RegressionStructure] = CreateSethRegression3angles(Supraspinatus_P,axis,joints_names,q);
        
        
    elseif strcmp(mus_name,'TeresMajor')
        
        [MomentsArm,RegressionStructure]   = CreateSethRegression3angles(TeresMajor,axis,joints_names,q);
        
        
    elseif strcmp(mus_name,'TeresMinor')
        
        [MomentsArm,RegressionStructure]  = CreateSethRegression3angles(TeresMinor,axis,joints_names,q);
        
        
        %% Scapula  muscles
        
    elseif strcmp(mus_name,'LevatorScapulae')
        
        [MomentsArm,RegressionStructure] = CreateSethRegression4angles(LevatorScapulae,axis,joints_names,q);
        
    elseif strcmp(mus_name,'Rhomboideus_I')
        
        [MomentsArm,RegressionStructure] = CreateSethRegression4angles(Rhomboideus_I,axis,joints_names,q);
        
        
    elseif strcmp(mus_name,'Rhomboideus_S')
        
        [MomentsArm,RegressionStructure] = CreateSethRegression4angles(Rhomboideus_S,axis,joints_names,q);
        
        
    elseif strcmp(mus_name,'SerratusAnterior_I')
        
        
        [MomentsArm,RegressionStructure] = CreateSethRegression4angles(SerratusAnterior_I,axis,joints_names,q);
        
    elseif strcmp(mus_name,'SerratusAnterior_M')
        
        
        [MomentsArm,RegressionStructure] = CreateSethRegression4angles(SerratusAnterior_M,axis,joints_names,q);
        
        
    elseif strcmp(mus_name,'SerratusAnterior_S')
        [MomentsArm,RegressionStructure] = CreateSethRegression4angles(SerratusAnterior_S,axis,joints_names,q);
        
        
    elseif strcmp(mus_name,'TrapeziusScapula_I')
        [MomentsArm,RegressionStructure] = CreateSethRegression4angles(TrapeziusScapula_I,axis,joints_names,q);
        
    elseif strcmp(mus_name,'TrapeziusScapula_M')
        [MomentsArm,RegressionStructure] = CreateSethRegression4angles(TrapeziusScapula_M,axis,joints_names,q);
        
        
        
    elseif strcmp(mus_name,'TrapeziusScapula_S')
        
        [MomentsArm,RegressionStructure] = CreateSethRegression4angles(TrapeziusScapula_S,axis,joints_names,q);
        
        
        %% Scapula and GH  muscles
        
        
        
        
    elseif strcmp(mus_name,'LatissimusDorsi_I')
         [MomentsArm,RegressionStructure] = CreateSethRegression7angles(LatissimusDorsi_I,axis,joints_names,q);
        
    elseif strcmp(mus_name,'LatissimusDorsi_S')        
        
        
        [MomentsArm,RegressionStructure] = CreateSethRegression7angles(LatissimusDorsi_S,axis,joints_names,q);

        
        
    elseif strcmp(mus_name,'PectoralisMajorThorax_I')
                        [MomentsArm,RegressionStructure] = CreateSethRegression7angles(PectoralisMajorThorax_I,axis,joints_names,q);

    elseif strcmp(mus_name,'PectoralisMajorThorax_M')
        
                [MomentsArm,RegressionStructure] = CreateSethRegression7angles(PectoralisMajorThorax_M,axis,joints_names,q);

    elseif strcmp(mus_name,'PectoralisMinor')
        
                [MomentsArm,RegressionStructure] = CreateSethRegression4angles(PectoralisMinor,axis,joints_names,q);

        
        %% Clavicle muscle
        
        
    elseif strcmp(mus_name,'TrapeziusClavicle_S')
        [MomentsArm,RegressionStructure] = CreateSethRegression2angles(TrapeziusClavicle_S,axis,joints_names,q);
    end
    
    
    
end