%% Optimisation des bras de levier

%load('/home/clivet/Documents/Thèse/Developpement_CusToM/thesis/Fichiers_tests/Donnees a traiter/Ana Lucia Data - Sbj 1 - Trial 1 - Forearm model/BiomechanicalModel.mat')
load('BiomechanicalModel.mat')
name_mus='ExtensorDigitorum';
%name_mus='FlexorDigitorumSuperior';

%% Ajout des champs utiles pour l'ExtensorDigitorum

Sign={'R','L'};
for k=1:2
    [~,num_muscle(k)]=intersect({BiomechanicalModel.Muscles.name},[Sign{k},name_mus]);
    BiomechanicalModel.Muscles(num_muscle(k)).lmax=306e-3;
    BiomechanicalModel.Muscles(num_muscle(k)).lmaxangles{1,1}=[Sign{k},'Radius_J1'];
    BiomechanicalModel.Muscles(num_muscle(k)).lmaxangles{2,1}=[Sign{k},'Radius'];
    BiomechanicalModel.Muscles(num_muscle(k)).lmaxangles{3,1}=[Sign{k},'Hand'];
    BiomechanicalModel.Muscles(num_muscle(k)).lmaxangles{4,1}=[Sign{k},'Wrist_J1'];
    BiomechanicalModel.Muscles(num_muscle(k)).lmaxangles{1,2}=-1;
    BiomechanicalModel.Muscles(num_muscle(k)).lmaxangles{2,2}=-2*k+3; %1 for R, -1 for L
    BiomechanicalModel.Muscles(num_muscle(k)).lmaxangles{3,2}=-2*k+3;
    BiomechanicalModel.Muscles(num_muscle(k)).lmaxangles{4,2}=2*k-3; %-1 for R, 1 for L
end

    
    



[Pts,involved_solids,BiomechanicalModel]=MomentArmOptimisation(name_mus,BiomechanicalModel);


