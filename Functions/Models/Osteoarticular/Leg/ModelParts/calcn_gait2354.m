function [Human_model]= calcn_gait2354(Human_model,k,Signe,Mass,AttachmentPoint)
%	CREDIT
%   Delp S.L., Loan J.P., Hoy M.G., Zajac F.E., Topp E.L., Rosen J.M., Thelen D.G., Anderson F.C., Seth A. 
%   NOTES
%   3D, 23 DOF gait model created by D.G. Thelen, Univ. of Wisconsin-Madison, and Ajay Seth, Frank C. Anderson, and Scott L. Delp, Stanford University. Lower extremity joint defintions based on Delp et al. (1990). Low back joint and anthropometry based on Anderson and Pandy (1999, 2001). Planar knee model of Yamaguchi and Zajac (1989). Seth replaced tibia translation constraints with a CustomJoint for the knee and removed the patella to eliminate all kinematic constraints; insertions of the quadrucepts are handled with moving points in the tibia frame as defined by Delp 1990. 
%   LINK
%   http://simtk-confluence.stanford.edu:8080/display/OpenSim/Gait+2392+and+2354+Models
%   Based on: 
%   - Delp, S.L., Loan, J.P., Hoy, M.G., Zajac, F.E., Topp E.L., Rosen, J.M.: An interactive graphics-based model of the lower extremity to study orthopaedic surgical procedures, IEEE Transactions on Biomedical Engineering, vol. 37, pp. 757-767, 1990. 
%   - Yamaguchi G.T., Zajac F.E.: A planar model of the knee joint to characterize the knee extensor mechanism." J . Biomech. vol. 22. pp. 1-10. 1989. 
%   - Anderson F.C., Pandy M.G.: A dynamic optimization solution for vertical jumping in three dimensions. Computer Methods in Biomechanics and Biomedical Engineering 2:201-231, 1999. Anderson F.C., Pandy M.G.: Dynamic optimization of human walking. Journal of Biomechanical Engineering 123:381-390, 2001.
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the thigh model ('R' for right side or 'L' for left side)
%   - Mass: mass of the solids
%   - AttachmentPoint: name of the attachment point of the model on the
%   already existing model (character string)
%   OUTPUT
%   - OsteoArticularModel: new osteo-articular model (see the Documentation
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

%% Variables de sortie :
% "enrichissement de la structure "Human_model""

%% Liste des solides
list_solid={'calcn'};

%% Choix jambe droite ou gauche
if Signe == 'R'
    Mirror=[1 0 0; 0 1 0; 0 0 1];
else
    if Signe == 'L'
        Mirror=[1 0 0; 0 1 0; 0 0 -1];
    end
end

%% Incrémentation de la numérotation des solides

s=size(Human_model,2)+1;  %#ok<NASGU> % numéro du premier solide
for i=1:size(list_solid,2)      % numérotation de chaque solide : s_"nom du solide"
    if i==1
        eval(strcat('s_',list_solid{i},'=s;'))
    else
        eval(strcat('s_',list_solid{i},'=s_',list_solid{i-1},'+1;'))
    end
end

% trouver le numéro de la mère à partir du nom du point d'attache : 'attachment_pt'
if numel(Human_model) == 0
    s_mother=0;
    pos_attachment_pt=[0 0 0]';
else
    test=0;
    for i=1:numel(Human_model)
        for j=1:size(Human_model(i).anat_position,1)
            if strcmp(AttachmentPoint,Human_model(i).anat_position{j,1})
                s_mother=i;
                pos_attachment_pt=Human_model(i).anat_position{j,2}+Human_model(s_mother).c;
                test=1;
                break
            end
        end
        if i==numel(Human_model) && test==0
            error([AttachmentPoint ' is no existent'])
        end
    end
    if Human_model(s_mother).child == 0      % si la mère n'a pas d'enfant
        Human_model(s_mother).child = eval(['s_' list_solid{1}]);    % l'enfant de cette mère est ce solide
    else
        [Human_model]=sister_actualize(Human_model,Human_model(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la dernière soeur
    end
end

% ---------------------------- Thigh --------------------------------------

%Centre de masse
CoM_calcn=k*Mirror*[0.1; 0.03; 0];
calcn_talusJointNode = (k*Mirror*[0 ; 0 ;	0])-CoM_calcn;
calcn_toeJointNode = (k*Mirror*[0.1788; -0.002; 0.00108]) -CoM_calcn;

%% Définition des positions anatomiques

calcn_position_set = {...
    [Signe 'calcn_talusJointNode'],calcn_talusJointNode;...
    [Signe 'calcn_toeJointNode'],calcn_toeJointNode;...
    [Signe 'HEE'],k*Mirror*([-0.02;0.02;0])-CoM_calcn;...
    [Signe 'Midfoot.Sup' ],k*Mirror*([0.13;0.03;-0.03])-CoM_calcn;...
    [Signe 'Midfoot.Lat'],k*Mirror*([0.1;0.02;0.04])-CoM_calcn;...
    [Signe 'TAR'],k*Mirror*([0.19;0;0.065])-CoM_calcn;...
    [Signe 'TARI'],k*Mirror*([0.19;0.005;-0.04])-CoM_calcn;...
    [Signe 'TOE'],k*Mirror*([0.26;0.005;0])-CoM_calcn;...
    ['med_gas_' lower(Signe) '-P3'],k*Mirror*([0;0.031;-0.0053])-CoM_calcn;...
    ['soleus_' lower(Signe) '-P2'],k*Mirror*([0;0.031;-0.0053])-CoM_calcn;...
    ['tib_post_' lower(Signe) '-P3'],k*Mirror*([0.0417;0.0334;-0.0286])-CoM_calcn;...
    ['tib_post_' lower(Signe) '-P4'],k*Mirror*([0.0772;0.0159;-0.0281])-CoM_calcn;...
    ['tib_ant_' lower(Signe) '-P3'],k*Mirror*([0.1166;0.0178;-0.0305])-CoM_calcn;...
    };


%%                     Mise à l'échelle des inerties

I_calcn = k*eye(3).*[0.0001;0.0002;0.0001];

%% Création de la structure "Human_model"

num_solid=0;
%% Calcn
num_solid=num_solid+1;        % solide numéro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % numéro du solide dans le modèle
Human_model(incr_solid).name=[name '_' lower(Signe)];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=0;
Human_model(incr_solid).mother=s_mother;
Human_model(incr_solid).a=[Mirror(3,3)*0.78717961 Mirror(3,3)*0.60474746 -0.12094949]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi/2;
Human_model(incr_solid).limit_sup=pi/2;
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).Visual=1;
Human_model(incr_solid).m=k*1.25;
Human_model(incr_solid).b=pos_attachment_pt;
Human_model(incr_solid).I=I_calcn;
Human_model(incr_solid).c=CoM_calcn;
Human_model(incr_solid).anat_position=calcn_position_set;
Human_model(incr_solid).L={[Signe 'calcn_talusJointNode'];[Signe 'calcn_toeJointNode']};
Human_model(incr_solid).visual_file = ['gait2354/calcn_'  lower(Signe) '.mat'];

if Signe == 'R'
    Human_model(incr_solid).comment='Subtalar Inversion(-)/Eversion(+)';
else
    Human_model(incr_solid).comment='Subtalar Inversion(+)/Eversion(-)';
end
end
