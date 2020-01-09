function [Human_model]= Hand_model_definition(Human_model,k,Signe,Mass,varargin)
%% Fichier de description du mod�le de bras
% Human_model : partie du mod�le d�j� construite (si il existe)
% attachment_pt : nom du points d'attache (si il existe)
% k : coefficient multiplicateur pour le scaling lin�aire
% Signe : 'R' ou 'L' (Right ou Left)
% Mass : masse du mod�le complet
% scaling_choice  : choix de la m�thode de mise � l'�chelle des donn�es inertielles
% Density : densit� du corps

%% Variables de sortie : 
% "enrichissement de la structure "Human_model""

%% Liste des solides
list_solid={'Wrist_J1' 'Hand'};

%% Choix bras droite ou gauche
if Signe == 'R'
Mirror=[1 0 0; 0 1 0; 0 0 1];
else
    if Signe == 'L'
    Mirror=[1 0 0; 0 1 0; 0 0 -1];
    end
end

%% Incr�mentation du num�ro des groupes
% n_group=0;
% for i=1:numel(Human_model)
%     if size(Human_model(i).Group) ~= [0 0] %#ok<BDSCA>
%         n_group=max(n_group,Human_model(i).Group(1,1));
%     end
% end
% n_group=n_group+1;

%% Incr�mentation de la num�rotation des solides

s=size(Human_model,2)+1;  %#ok<NASGU> % num�ro du premier solide
for i=1:size(list_solid,2)      % num�rotation de chaque solide : s_"nom du solide"
    if i==1
        eval(strcat('s_',list_solid{i},'=s;'))
    else
        eval(strcat('s_',list_solid{i},'=s_',list_solid{i-1},'+1;'))
    end
end

% trouver le num�ro de la m�re � partir du nom du point d'attache : 'attachment_pt'
if numel(Human_model) == 0
    s_mother=0;
    pos_attachment_pt=[0 0 0]';
else
    attachment_pt=varargin{1};
    test=0;
    for i=1:numel(Human_model)
        for j=1:size(Human_model(i).anat_position,1)
            if strcmp(attachment_pt,Human_model(i).anat_position{j,1})
               s_mother=i;
               pos_attachment_pt=Human_model(i).anat_position{j,2}+Human_model(s_mother).c;
               test=1;
               break
            end
        end
        if i==numel(Human_model) && test==0
            error([attachment_pt ' is no existent'])        
        end       
    end
    if Human_model(s_mother).child == 0      % si la m�re n'a pas d'enfant
        Human_model(s_mother).child = eval(['s_' list_solid{1}]);    % l'enfant de cette m�re est ce solide
    else
        [Human_model]=sister_actualize(Human_model,Human_model(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la derni�re soeur
    end
end

%%                      D�finition des noeuds

% ------------------------- Hand ------------------------------------------

% Position des noeuds
Hand_WristJointNode = (k*[0 0.0528 0])*Mirror;
Hand_EndNode = (k*[0 -0.1416 0])*Mirror;

%%              D�finition des positions anatomiques

Hand_position_set= {...
    [Signe 'Hand_WristJointNode'], Hand_WristJointNode'; ...
    [Signe 'Hand_EndNode'], Hand_EndNode'; ...
    % 1 marqueur sur la main
    [Signe 'CAR1'], k*Mirror*[-0.02 -0.045 0]'; ...
    % 2 marqueurs sur la main
    [Signe 'CAR2'], k*Mirror*[-0.02 -0.045 0.025]'; ...
    [Signe 'OHAND'], k*Mirror*[-0.02 -0.025 -0.035]'; ...
    % 3 marqueurs sur la main
    [Signe 'CAR3'], k*Mirror*[-0.02 0 0]'; ...
    [Signe 'IDX3'], k*Mirror*[-0.02 -0.09 0.025]'; ...
    [Signe 'PNK3'], k*Mirror*[-0.02 -0.095 -0.02]'; ...
    % Pr�diction d'efforts
    [Signe 'HandPrediction1'], k*Mirror*[0.015 0 0]';...
    [Signe 'HandPrediction2'], k*Mirror*[0.015 0.02 -0.02]';...
    [Signe 'HandPrediction3'], k*Mirror*[0.015 0.02 0.02]';...
    [Signe 'HandPrediction4'], k*Mirror*[0.015 0.04 0]';...
    [Signe 'HandPrediction5'], k*Mirror*[0.015 -0.02 -0.03]';...
    [Signe 'HandPrediction6'], k*Mirror*[0.015 -0.03 0]';...
    [Signe 'HandPrediction7'], k*Mirror*[0.015 -0.025 0.03]';...
    [Signe 'HandPrediction8'], k*Mirror*[0.015 -0.06 -0.04]';...
    [Signe 'HandPrediction9'], k*Mirror*[0.015 -0.07 0]';...
    [Signe 'HandPrediction10'], k*Mirror*[0.015 -0.06 0.03]';...
    [Signe 'HandPrediction11'], k*Mirror*[0.015 -0.01 0.05]';...
    % BULLSHIT
    [Signe 'Hand_CubitalisAnterior_i'],[0 0 0]';
    [Signe 'Hand_FlexorCarpiUlnaris_i'],[0 0 0]';
    [Signe 'Hand_ExtensorCarpiUlnaris_i'],[0 0 0]';
    [Signe 'Hand_ExtensorDigitorum_i'],[0 0 0]';
    [Signe 'Hand_FlexorDigitorumSuperior_i'],[0 0 0]';
    [Signe 'Hand_FlexorCapriRadialis_i'],[0 0 0]';
    [Signe 'Hand_AbductorDigitiV_i'],[0 0 0]';
    };

%%                     Mise � l'�chelle des inerties

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % ------------------------- Hand ------------------------------------------
    Length_Hand=norm(Hand_WristJointNode-Hand_EndNode);
    [I_Hand]=rgyration2inertia([61 38 56 22 15 20*1i], Mass, [0 0 0], Length_Hand, Signe);  
    
                %% Cr�ation de la structure "Human_model"

num_solid=0;
%% Hand
    % Wrist_J1
    num_solid=num_solid+1;        % solide num�ro ...
    name=list_solid{num_solid}; % nom du solide
    eval(['incr_solid=s_' name ';'])  % num�ro du solide dans le mod�le
    Human_model(incr_solid).name=[Signe name];
    Human_model(incr_solid).sister=0;                
    Human_model(incr_solid).child=s_Hand;                   
    Human_model(incr_solid).mother=s_mother;           
    Human_model(incr_solid).a=[0 0 1]';
    Human_model(incr_solid).joint=1;
    Human_model(incr_solid).limit_inf=-pi/2;
    Human_model(incr_solid).limit_sup=pi/2;
    Human_model(incr_solid).ActiveJoint=1;
    Human_model(incr_solid).m=0;                 
    Human_model(incr_solid).b=pos_attachment_pt;  
    Human_model(incr_solid).I=zeros(3,3);
    Human_model(incr_solid).c=[0 0 0]';
    Human_model(incr_solid).Visual=0;
    
    % Hand
    num_solid=num_solid+1;        % solide num�ro ...
    name=list_solid{num_solid}; % nom du solide
    eval(['incr_solid=s_' name ';'])  % num�ro du solide dans le mod�le
    Human_model(incr_solid).name=[Signe name];
    Human_model(incr_solid).sister=0;    
    Human_model(incr_solid).child=0;
    Human_model(incr_solid).mother=s_Wrist_J1;
    Human_model(incr_solid).a=[1 0 0]';
    Human_model(incr_solid).joint=1;
    if Signe == 'R'
        Human_model(incr_solid).limit_inf=-pi/4;
        Human_model(incr_solid).limit_sup=pi/2;
    else
        Human_model(incr_solid).limit_inf=-pi/2;
        Human_model(incr_solid).limit_sup=pi/4;
    end
    Human_model(incr_solid).ActiveJoint=1;
%     Human_model(incr_solid).Group=[n_group 3];
    Human_model(incr_solid).m=Mass;
    Human_model(incr_solid).b=[0 0 0]';
    Human_model(incr_solid).I=[I_Hand(1) I_Hand(4) I_Hand(5); I_Hand(4) I_Hand(2) I_Hand(6); I_Hand(5) I_Hand(6) I_Hand(3)];
    Human_model(incr_solid).c=-Hand_WristJointNode';
    Human_model(incr_solid).anat_position=Hand_position_set;
    Human_model(incr_solid).Visual=1;
    Human_model(incr_solid).L={[Signe 'Hand_WristJointNode'];[Signe 'Hand_EndNode']};

end