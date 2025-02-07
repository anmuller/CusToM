function [OsteoArticularModel]= Hand(OsteoArticularModel,k,Signe,Mass,AttachmentPoint)
% Addition of a hand model
%   This forearm model contains one solid (hand), exhibits 2 dof for the
%   wrist
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the hand model ('R' for right side or 'L' for left side)
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
list_solid={'Wrist_J1' 'Hand'};

%% Choose right or left arm
if Signe == 'R'
    Mirror=[1 0 0; 0 1 0; 0 0 1];
    FullSide='Right';
elseif Signe == 'L'
    Mirror=[1 0 0; 0 1 0; 0 0 -1];
    FullSide='Left';
end

%% solid numbering incremation

s=size(OsteoArticularModel,2)+1;  %#ok<NASGU> % number of the first solid
for i=1:size(list_solid,2)     % each solid numbering: s_"nom du solide"
    if i==1
        eval(strcat('s_',list_solid{i},'=s;'))
    else
        eval(strcat('s_',list_solid{i},'=s_',list_solid{i-1},'+1;'))
    end
end

% find the number of the mother from the attachment point: 'attachment_pt'
if ~numel(AttachmentPoint)
    s_mother=0;
    pos_attachment_pt=[0 0 0]';
else
    test=0;
    for i=1:numel(OsteoArticularModel)
        for j=1:size(OsteoArticularModel(i).anat_position,1)
            if strcmp(AttachmentPoint,OsteoArticularModel(i).anat_position{j,1})
               s_mother=i;
               pos_attachment_pt=OsteoArticularModel(i).anat_position{j,2}+OsteoArticularModel(s_mother).c;
               test=1;
               break
            end
        end
        if i==numel(OsteoArticularModel) && test==0
            error([AttachmentPoint ' is no existent'])        
        end       
    end
    if OsteoArticularModel(s_mother).child == 0      % if the mother don't have any child
        OsteoArticularModel(s_mother).child = eval(['s_' list_solid{1}]);    % the child of this mother is this solid
    else
        [OsteoArticularModel]=sister_actualize(OsteoArticularModel,OsteoArticularModel(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la derni�re soeur
    end
end

%%                     Node Definition

% ------------------------- Hand ------------------------------------------

% Node positions
Hand_WristJointNode = (k*[0 0.0528 0])*Mirror;
Hand_EndNode = (k*[0 -0.1416 0])*Mirror;

% Adaptation of Pennestri node positions
dr = -0.159;
cr = 0.071;
L_forearm = 0.2628;
k_Pennestri2custom = L_forearm/(cr-dr)*k*Mirror; % Forearm length homotethy
Pennestri2custom = k_Pennestri2custom*[0 0 1;-1 0 0;0 -1 0];

% From OpenSim
osim2antoine = [k (Hand_WristJointNode(2)-Hand_EndNode(2))/0.23559 k];
Wrist_origin =Mirror*osim2antoine'.*([0.003992 -0.015054 0.002327]');

%%              Definition of anatomical landmarks

Hand_position_set= {...
    [Signe 'Hand_WristJointNode'], Hand_WristJointNode'; ...
    [Signe 'Hand_EndNode'], Hand_EndNode'; ...
    % 1 marker on the hand
    [Signe 'CAR1'], k*Mirror*[-0.02 -0.045 0]'; ...

    % 
        % 2 markers on the hand
    [Signe 'CAR2'], k*Mirror*[-0.02 -0.045 0.025]'; ...
    [Signe 'OHAND'], k*Mirror*[-0.02 -0.025 -0.035]'; ...
    % 3 markers on the hand
    [Signe 'CAR3'], k*Mirror*[-0.02 0 0]'; ...
    [Signe 'IDX3'], k*Mirror*[-0.02 -0.095 -0.02]'; ...
    [Signe 'PNK3'], k*Mirror*[-0.02 -0.09 0.025]'; ...
    
    % wrist exoskeleton
%     'EXO4', k*Mirror*[-0.03 -0.045 0.05]'; ...
%     'EXO6', k*Mirror*[-0.03 -0.045 -0.05]'; ...
%     'EXO5', k*Mirror*([-0.03 -0.045 -0.05]'+[-0.0539   -0.0635   -0.0043]'); ...
    
    
    
%     % for VR setup
%     [Signe '500G1'], k*Mirror*[-0.02+0.124 -0.045+0.067 0+0.066]'; ...
%     [Signe '500G2'], k*Mirror*[-0.02-0.030 -0.045-0.100 0+0.056]'; ...
%     [Signe '500G3'], k*Mirror*[-0.02+0.051 -0.045-0.093 0+0.041]'; ...
%     [Signe '500G4'], k*Mirror*[-0.02+0.124 -0.045-0.100 0+0.066]'; ...
%     [Signe '1000G1'], k*Mirror*[-0.02+0.114 -0.045-0.021 0+0.071]'; ...
%     [Signe '1000G2'], k*Mirror*[-0.02-0.013 -0.045+0.045 0+0.077]'; ...
%     [Signe '1000G3'], k*Mirror*[-0.02-0.014 -0.045-0.090 0+0.074]'; ...
%     [Signe '1000G4'], k*Mirror*[-0.02+0.051 -0.045-0.095 0+0.039]'; ...
    % Force Prediction
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
    % Muscles extracted from (Pennestri et al., 2007)
    [Signe 'Hand_CubitalisAnterior_i'],Pennestri2custom*[0.006 0.0027 0.007]'+Hand_WristJointNode';
    [Signe 'Hand_FlexorCarpiUlnaris_i'],Pennestri2custom*[0.005 0.03 0.007]'+Hand_WristJointNode';
    [Signe 'Hand_ExtensorCarpiUlnaris_i'],Pennestri2custom*[0.005 0.03 -0.007]'+Hand_WristJointNode';
    [Signe 'Hand_ExtensorDigitorum_i'],Pennestri2custom*[0.038 0 -0.01]'+Hand_WristJointNode';
    [Signe 'Hand_FlexorDigitorumSuperior_i'],Pennestri2custom*[0.005 -0.018 -0.006]'+Hand_WristJointNode';
    [Signe 'Hand_FlexorCapriRadialis_i'],Pennestri2custom*[0.003 0.012 0.005]'+Hand_WristJointNode';
    [Signe 'Hand_AbductorDigitiV_i'],Pennestri2custom*[0.01 -0.018 -0.007]'+Hand_WristJointNode';
    };


%%                     Scaling inertial parameters

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % ------------------------- Hand ------------------------------------------
    Length_Hand=norm(Hand_WristJointNode-Hand_EndNode);
    [I_Hand]=rgyration2inertia([61 38 56 22 15 20*1i], Mass.Hand_Mass, [0 0 0], Length_Hand, Signe);  

                %% "Human_model" structure generation

num_solid=0;
%% Hand
% Wrist_J1
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % name of the solid
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
OsteoArticularModel(incr_solid).name=[Signe name];
OsteoArticularModel(incr_solid).sister=0;
OsteoArticularModel(incr_solid).child=s_Hand;
OsteoArticularModel(incr_solid).mother=s_mother;
OsteoArticularModel(incr_solid).a=[0 0 1]';
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).limit_inf=-90*pi/180;
OsteoArticularModel(incr_solid).limit_sup=90*pi/180;
OsteoArticularModel(incr_solid).m=0;
OsteoArticularModel(incr_solid).b=pos_attachment_pt;
OsteoArticularModel(incr_solid).I=zeros(3,3);
OsteoArticularModel(incr_solid).c=[0 0 0]';
OsteoArticularModel(incr_solid).Visual=0;
OsteoArticularModel(incr_solid).FunctionalAngle=[FullSide 'Wrist flexion(+)/extension(-)'];


% Hand
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % name of the solid
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
OsteoArticularModel(incr_solid).name=[Signe name];
OsteoArticularModel(incr_solid).sister=0;
OsteoArticularModel(incr_solid).child=0;
OsteoArticularModel(incr_solid).mother=s_Wrist_J1;
OsteoArticularModel(incr_solid).a=[1 0 0]';
OsteoArticularModel(incr_solid).joint=1;
if Signe == 'R'
    OsteoArticularModel(incr_solid).limit_inf=-45*pi/180;
    OsteoArticularModel(incr_solid).limit_sup=90*pi/180;
    OsteoArticularModel(incr_solid).FunctionalAngle='Right Wrist deviation ulnar(+)/radial(-)' ;
else
    OsteoArticularModel(incr_solid).limit_inf=-90*pi/180;
    OsteoArticularModel(incr_solid).limit_sup=45*pi/180;
    OsteoArticularModel(incr_solid).FunctionalAngle='Left Wrist deviation ulnar(-)/radial(+)' ;
end
OsteoArticularModel(incr_solid).m=Mass.Hand_Mass;
OsteoArticularModel(incr_solid).b=[0 0 0]';
OsteoArticularModel(incr_solid).I=[I_Hand(1) I_Hand(4) I_Hand(5); I_Hand(4) I_Hand(2) I_Hand(6); I_Hand(5) I_Hand(6) I_Hand(3)];
OsteoArticularModel(incr_solid).c=-Hand_WristJointNode';
OsteoArticularModel(incr_solid).anat_position=Hand_position_set;
OsteoArticularModel(incr_solid).Visual=1;
OsteoArticularModel(incr_solid).visual_file = ['Holzbaur/hand_' Signe '.mat'];
OsteoArticularModel(incr_solid).L={[Signe 'Hand_WristJointNode'];[Signe 'Hand_EndNode']};
OsteoArticularModel(incr_solid).density=1.16; %kg.L-1
end