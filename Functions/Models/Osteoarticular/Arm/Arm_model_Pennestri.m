function [Human_model] = Arm_model_Pennestri(Human_model,k,Signe,Mass,varargin)
% Addition of an arm model
%   This arm model contains 3 solids (upper arm, forearm and hand),
%   exhibits 3 dof for the shoulder, 2 dof for the elbow and 2 dof for the
%   wrist
%
%	Based on:
%	-Pennestrì, E., Stefanelli, R., Valentini, P. P., & Vita, L. (2007).
%Virtual musculo-skeletal model for the biomechanical analysis of the upper limb.
% Journal of Biomechanics, 40(6), 1350–1361. https://doi.org/10.1016/j.jbiomech.2006.05.013

%   INPUT
%   - Human_model: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the arm model ('R' for right side or 'L' for left side)
%   - Mass: mass of the solids
%   - AttachmentPoint: name of the attachment point of the model on the
%   already existing model (character string)
%   OUTPUT
%   - Human_model: new osteo-articular model (see the Documentation
%   for the structure) 
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________


%% Ajout d'un bras
[Human_model]= Upperarm(Human_model,k,Signe,Mass,varargin);

%% Ajout d'un avant-bras
[Human_model]=Forearm_Pennestri_model_definition(Human_model,k,Signe,Mass,[Signe 'Humerus_RadiusJointNode']);

%% Ajout d'une main
[Human_model]=Hand(Human_model,k,Signe,Mass,[Signe 'Forearm_WristJointNode']);

end
