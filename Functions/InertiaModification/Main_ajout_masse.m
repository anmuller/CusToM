% Main script of the Toolbox
%   This script is automatically computed by the graphic interface
%   'Analysis'.
%   From the files 'ModelParameters' and 'AnalysisParameters'
%   (automatically loaded by the script), all steps of the musculoskeletal
%   analysis are computed.
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
 
clear all
close all
clc

% GenerateParameters ;
% Analysis ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                              Model generation (only one per subject)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization of pseudo-random seed for optimization
rng('default');

%Chemin pour le tableau contenant les données objet extérieur
table_path = "C:\Users\sterc\Documents\Thèse Aurélien\Ajout masse exterieure\Visuels\Added_Masses.xlsx";

load('ModelParameters.mat');
load('AnalysisParameters.mat');

if ~exist(fullfile(pwd,'BiomechanicalModel.mat'),'file')
%     CalibrateModelGeneration(ModelParameters,AnalysisParameters);
    CalibrateModelGenerationNum(ModelParameters,AnalysisParameters);
end


%Chemin pour le modèle
model_path = "C:\Users\sterc\Documents\Thèse Aurélien\Ajout masse exterieure\Visuels\BiomechanicalModel.mat";

% Génération des perturbations des modèles
[List_BiomechanicalModels] = AddExternalMasses(table_path, model_path) ;
%On sauvegarde le modèle parent
saved_BiomechanicalModel = List_BiomechanicalModels(end).BiomechanicalModel;
save('saved_BiomechanicalModel')

CreateVisuals(table_path,List_BiomechanicalModels) %Create a visual figure for each segment

%% Choix du modèle

i_new_model = 4;

warning(['i_new_model = ', num2str(i_new_model)])
BiomechanicalModel = List_BiomechanicalModels(i_new_model).BiomechanicalModel;
save('BiomechanicalModel')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                    	Inverse kinematics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if AnalysisParameters.IK.Active 
    InverseKinematics(AnalysisParameters);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                               	External forces computation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if AnalysisParameters.ID.Active
    ExternalForcesComputation(AnalysisParameters, ModelParameters);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 	   Inverse dynamics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if AnalysisParameters.ID.Active
    InverseDynamics(AnalysisParameters);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                            	  Muscle forces computation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if AnalysisParameters.Muscles.Active
%     MuscleForcesComputation(AnalysisParameters);
    MuscleForcesComputationNum(AnalysisParameters);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                  	 Animation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
copyfile(nom_fichier,[nom_fichier,'_model_',num2str(i_new_model)]);
% GenerateAnimate;

% if exist(fullfile(pwd,'AnimateParameters.mat'),'file')
%     load('AnimateParameters.mat');
%     PlotAnimation(ModelParameters, AnimateParameters);
% end

