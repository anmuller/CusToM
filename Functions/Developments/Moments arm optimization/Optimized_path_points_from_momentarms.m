%% Optimisation des bras de levier

%load('/home/clivet/Documents/Thèse/Developpement_CusToM/thesis/Fichiers_tests/Donnees a traiter/Ana Lucia Data - Sbj 1 - Trial 1 - Forearm model/BiomechanicalModel.mat')
load('BiomechanicalModel.mat')
name_mus='Brachioradialis';
%name_mus='ExtensorDigitorum';
%name_mus='FlexorDigitorumSuperior';

%% Ajout des champs utiles pour l'ExtensorDigitorum

Sign={'R','L'};
for k=1:2
    [~,num_muscle(k)]=intersect({BiomechanicalModel.Muscles.name},[Sign{k},name_mus]);
   %  BiomechanicalModel.Muscles(num_muscle(k)).lmax=306e-3; %ExtensorDigitorum
     BiomechanicalModel.Muscles(num_muscle(k)).lmax=276e-3; %Brachioradialis
end

    
    
MomentsArmRegression=MomentsArmRegression_creation();

[Pts,involved_solids,BiomechanicalModel]=MomentArmOptimisation(name_mus,BiomechanicalModel,MomentsArmRegression);


