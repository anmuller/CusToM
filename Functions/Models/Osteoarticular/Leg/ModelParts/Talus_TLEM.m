function [Human_model]= Talus_TLEM(Human_model,k,Signe,Mass,AttachmentPoint)
%   Based on:
%	V. Carbone et al., “TLEM 2.0 - A comprehensive musculoskeletal geometry dataset for subject-specific modeling of lower extremity,” J. Biomech., vol. 48, no. 5, pp. 734–741, 2015.
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
list_solid={'Talus'};

%% Choix jambe droite ou gauche
if Signe == 'R'
    Mirror=[1 0 0; 0 1 0; 0 0 1];
else
    if Signe == 'L'
        Mirror=[1 0 0; 0 1 0; 0 0 -1];
    end
end

%% Incrémentation du numéro des groupes
% n_group=0;
% for i=1:numel(Human_model)
%     if size(Human_model(i).Group) ~= [0 0] %#ok<BDSCA>
%         n_group=max(n_group,Human_model(i).Group(1,1));
%     end
% end
% n_group=n_group+1;

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

%%                      Définition des noeuds (articulaires)
% TLEM 2.0 – A COMPREHENSIVE MUSCULOSKELETAL GEOMETRY DATASET FOR SUBJECT-SPECIFIC MODELING OF LOWER EXTREMITY
%
%  V. Carbonea*, R. Fluita*, P. Pellikaana, M.M. van der Krogta,b, D. Janssenc, M. Damsgaardd, L. Vignerone, T. Feilkasf, H.F.J.M. Koopmana, N. Verdonschota,c
%
%  aLaboratory of Biomechanical Engineering, MIRA Institute, University of Twente, Enschede, The Netherlands
%  bDepartment of Rehabilitation Medicine, Research Institute MOVE, VU University Medical Center, Amsterdam, The Netherlands
%  cOrthopaedic Research Laboratory, Radboud University Medical Centre, Nijmegen, The Netherlands
%  dAnyBody Technology A/S, Aalborg, Denmark
%  eMaterialise N.V., Leuven, Belgium
%  fBrainlab AG, Munich, Germany
% *The authors Carbone and Fluit contributed equally.
% Journal of Biomechanics, Available online 8 January 2015, http://dx.doi.org/10.1016/j.jbiomech.2014.12.034
%% Adjustement of k
k=k*1.2063; %to fit 50th percentile person of 1.80m height 
% --------------------------- Talus----------------------------------------

% Position du CoM par rapport au repère de référence
CoM_Talus=k*Mirror*[0;	0	;0];

% Position des noeuds
Talus_SubtalarJointNode = (k*Mirror*[-0.0065	;-0.0243;	0.0058])-CoM_Talus;
Talus_TalocruralJointNode = (k*Mirror*[-0.0013	;-0.0113;	0.0014])-CoM_Talus;

%% Définition des positions anatomiques

Talus_position_set= {...
    [Signe 'Talus_SubtalarJointNode'], Talus_SubtalarJointNode; ...
     [Signe 'Talus_TalocruralJointNode'], Talus_TalocruralJointNode; ...
    };

%%                     Mise à l'échelle des inerties
I_princ_Talus = k*eye(3)*10e-4; % directly from Carbone et al. 2015
R_principal = [ 0.0155	-0.0246	-0.9996;...
                0.0964	-0.9950	 0.0260;...
               -0.9952	-0.0968	-0.0130];
I_Talus = R_principal\I_princ_Talus*R_principal;
I_Talus = round(I_Talus,6);
%% Création de la structure "Human_model"

num_solid=0;
%% Talus
num_solid=num_solid+1;        % solide numéro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % numéro du solide dans le modèle
Human_model(incr_solid).name=[Signe name];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=0;
Human_model(incr_solid).mother=s_mother;
Human_model(incr_solid).a=-[Mirror(3,3)*0.3628	Mirror(3,3)*0.1305	-0.9227]'; % Carbone
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi/4;
Human_model(incr_solid).limit_sup=pi/2;
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).Visual=1;
% Human_model(incr_solid).Group=[n_group 3];
% Human_model(incr_solid).m=Mass;
Human_model(incr_solid).m=k*0.045582; % directly from Carbone et al. 2015
Human_model(incr_solid).b=pos_attachment_pt;
Human_model(incr_solid).I=I_Talus;
Human_model(incr_solid).c=-Talus_TalocruralJointNode;
Human_model(incr_solid).anat_position=Talus_position_set;
Human_model(incr_solid).L={[Signe 'Talus_TalocruralJointNode'];[Signe 'Talus_SubtalarJointNode']};
%Calibration des axes de rotations
a1=Human_model(incr_solid).a;
[~,Ind]=max(abs(a1));
a2=zeros(3,1);
a2(Ind)=1;
R=Rodrigues_from_two_axes(a2,a1); % Recherche des axes orthogonaux à l'axes de rotation

Human_model(incr_solid).limit_alpha= [ 10 , -10;... limit sup premier axe, limit inf premier axe
                                      10, -10]; %limit sup 2e axe, limit inf 2e axe
Human_model(incr_solid).v= [ R(:,1) , R(:,2) ];
Human_model(incr_solid).calib_a=1;
Human_model(incr_solid).visual_file = ['TLEM/' Signe 'Talus.mat'];
Human_model(incr_solid).comment='Ankle Flexion(+)/Extension(-)';
end
