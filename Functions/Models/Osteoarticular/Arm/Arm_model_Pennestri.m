function [Human_model] = Arm_model_Pennestri(Human_model,k,Signe,Mass,varargin)
% cr�ation d'un mod�le de jambe
% R�partition de la masse totale entre les diff�rents segments
Forearm_Mass=Mass.Forearm_Mass;


%% Ajout d'un bras
[Human_model]= Upperarm(Human_model,k,Signe,Mass,varargin);

%% Ajout d'un avant-bras
[Human_model]=Forearm_Pennestri_model_definition(Human_model,k,Signe,Forearm_Mass,[Signe 'Humerus_ElbowJointNode']);

%% Ajout d'une main
[Human_model]=Hand(Human_model,k,Signe,Mass,[Signe 'Forearm_WristJointNode']);

end
