function [Human_model] = Arm_model_Pennestri(Human_model,k,Signe,Mass,varargin)
% cr�ation d'un mod�le de jambe

% R�partition de la masse totale entre les diff�rents segments
Humerus_Mass=Mass.Arm_Mass;
Forearm_Mass=Mass.Forearm_Mass;
Hand_Mass=Mass.Hand_Mass;


%% Ajout d'un bras
[Human_model]= UpperArm_model_definition(Human_model,k,Signe,Humerus_Mass,varargin);

%% Ajout d'un avant-bras
[Human_model]=Forearm_Pennestri_model_definition(Human_model,k,Signe,Forearm_Mass,[Signe 'Humerus_ElbowJointNode']);

%% Ajout d'une main
[Human_model]=Hand_model_definition(Human_model,k,Signe,Hand_Mass,[Signe 'Forearm_WristJointNode']);

end
