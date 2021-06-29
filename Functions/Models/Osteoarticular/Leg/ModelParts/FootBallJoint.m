function [OsteoArticularModel]= FootBallJoint(OsteoArticularModel,k,Signe,Mass,AttachmentPoint)
% Addition of a foot model
%   This foot model contains one solid (foot), exhibits 3 dof for the ankle
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the foot model ('R' for right side or 'L' for left side)
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
list_solid={'Ankle_J1' 'Ankle_J2' 'Foot'};

%% Choose leg right or left
if Signe == 'R'
Mirror=[1 0 0; 0 1 0; 0 0 1];
else
    if Signe == 'L'
    Mirror=[1 0 0; 0 1 0; 0 0 -1];
    end
end

%% solid numbering incremation

s=size(OsteoArticularModel,2)+1;  %#ok<NASGU> % number of the first solid
for i=1:size(list_solid,2)      % each solid numbering: s_"nom du solide"
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
        [OsteoArticularModel]=sister_actualize(OsteoArticularModel,OsteoArticularModel(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la dernière soeur
    end
end

%%                      Definition of anatomical landmarks (joint)

% --------------------------- Foot ----------------------------------------

% Position du CoM par rapport au repère de référence
MetatarsalJoint2Node = (k*[0 -0.0725 0.015])*Mirror;
MalleousLateralNode = (k*[0.065 0.053 0.025])*Mirror;
CoM_Foot=0.5*(MetatarsalJoint2Node-MalleousLateralNode)+MalleousLateralNode;

% Node locations
Foot_AnkleJointNode = (k*[0.06 0.06 0])*Mirror - CoM_Foot;
Foot_ToetipNode = (k*[-0.012 -0.126 0.023])*Mirror-CoM_Foot;
Foot_HellNode = (k*[0.009 0.115 0])*Mirror-CoM_Foot; %#ok<NASGU>

%% Definition of anatomical landmarks

Foot_position_set= {...
    [Signe 'HEE'], k*Mirror*[-0.009479 0.12946 -0.02]'; ...
    [Signe 'TAR'], k*Mirror*[-0.021708 -0.04 0.04]'; ...
    [Signe 'TOE'], k*Mirror*[-0.02 -0.11625 -0.015]'; ...
    [Signe 'TARI'], k*Mirror*[-0.021708 -0.055 -0.05]'; ...
    [Signe 'Foot_AnkleJointNode'], Foot_AnkleJointNode'; ...
    [Signe 'Foot_ToetipNode'], Foot_ToetipNode'; ...
    ['MetatarsalJoint1' Signe 'Foot'],k*Mirror*[-0.0275;-0.06025;-0.03];...
    ['MetatarsalJoint2' Signe 'Foot'],k*Mirror*[-0.0325;-0.06275;-0.005];...
    ['MetatarsalJoint3' Signe 'Foot'],k*Mirror*[-0.0325;-0.05525;0.007];...
    ['MetatarsalJoint4' Signe 'Foot'],k*Mirror*[-0.0375;-0.04025;0.017];...
    ['MetatarsalJoint5' Signe 'Foot'],k*Mirror*[-0.0375;-0.03325;0.03];...
    ['MalleousLateral' Signe 'Foot'],k*Mirror*[0.0325;0.06275;0.005];...
    ['Soleus' Signe 'Foot'],k*Mirror*[-0.0045;0.11775;-0.021];...
    ['Gastrocnemius' Signe 'Foot'],k*Mirror*[-0.0045;0.11775;-0.021];...
    ['TibialisPosterior' Signe 'Foot'],k*Mirror*[-0.0205;0.01675;-0.04];...
    ['TibialisPosteriorVia' Signe 'Foot'],k*Mirror*[0.0045;0.09475;-0.04];...
    ['FlexorDigitorumLongus' Signe 'Foot'],k*Mirror*[-0.0455;-0.09025;0.02];...
    ['FlexorDigitorumLongusVia' Signe 'Foot'],k*Mirror*[0.0045;0.07975;-0.04];...
    ['FlexorHallucisLongus' Signe 'Foot'],k*Mirror*[-0.0405;-0.10325;-0.021];...
    ['FlexorHallucisLongusVia' Signe 'Foot'],k*Mirror*[-0.0055;0.08975;-0.03];...
    ['PeroneusBrevis' Signe 'Foot'],k*Mirror*[-0.0285;0.03475;0.016];...
    ['PeroneusBrevisVia' Signe 'Foot'],k*Mirror*[0.0045;0.07975;-0.002];...
    ['TibialisAnterior' Signe 'Foot'],k*Mirror*[-0.0025;0.00975;-0.04];...
    ['TibialisAnteriorVia' Signe 'Foot'],k*Mirror*[0.0225;0.02475;-0.03];...
    ['ExtensorDigitorumLongus' Signe 'Foot'],k*Mirror*[-0.0395;-0.09025;0.02];...
    ['ExtensorDigitorumVia' Signe 'Foot'],k*Mirror*[0.0225;0.02475;-0.01];...
    ['ExtensorHallucisLongus' Signe 'Foot'],k*Mirror*[-0.0355;-0.10325;-0.021];...
    ['ExtensorHallucisVia' Signe 'Foot'],k*Mirror*[0.0225;0.02475;-0.02];...
    [Signe 'FootPrediction1'], k*Mirror*[-0.04;0.1185;-0.03]*0.9359;...
    [Signe 'FootPrediction2'], k*Mirror*[-0.04;0.1185;-0.007]*0.9359;...
    [Signe 'FootPrediction3'], k*Mirror*[-0.03;0.035;0.015]*0.9359;...
    [Signe 'FootPrediction4'], k*Mirror*[-0.025;0.01;-0.04]*0.9359;...
    [Signe 'FootPrediction5'], k*Mirror*[-0.04;-0.0525;-0.035]*0.9359;...
    [Signe 'FootPrediction6'], k*Mirror*[-0.035;-0.0525;-0.0125]*0.9359;...
    [Signe 'FootPrediction7'], k*Mirror*[-0.03;-0.045;0.0015]*0.9359;...
    [Signe 'FootPrediction8'], k*Mirror*[-0.04;-0.035;0.015]*0.9359;...
    [Signe 'FootPrediction9'], k*Mirror*[-0.04;-0.02;0.025]*0.9359;...
    [Signe 'FootPrediction10'], k*Mirror*[-0.04;-0.075;0.04]*0.9359;...
    [Signe 'FootPrediction11'], k*Mirror*[-0.045;-0.117;0.002]*0.9359;...
    [Signe 'FootPrediction12'], k*Mirror*[-0.04;-0.095;-0.025]*0.9359;...
    [Signe 'FootPrediction13'], k*Mirror*[-0.045;-0.1;0.015]*0.9359;...
    [Signe 'FootPrediction14'], k*Mirror*[-0.045;-0.09;0.03]*0.9359;...
    [Signe 'HEEManutention'], k*Mirror*[0.035 0.12946 -0.02]'; ... 
    [Signe 'TARManutention'], k*Mirror*[-0.01 -0.04 0.04]'; ... 
    [Signe 'TARIManutention'], k*Mirror*[-0.01 -0.055 -0.05]'; ... 
    [Signe 'ANEManutention'], k*Mirror*[0.01 0.05 0.015]'; ... 
    };

%%                     Scaling inertial parameters

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % --------------------------- Foot ----------------------------------------
    Length_Foot = norm(Foot_AnkleJointNode-Foot_ToetipNode);
    [I_Foot]=rgyration2inertia([37 17 36 13 0 8*1i], Mass.Foot_Mass, [0 0 0], Length_Foot, Signe);

            %% %% "Human_model" structure generation
    
num_solid=0;
%% Foot
    % Ankle_J1
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=[Signe name];
    OsteoArticularModel(incr_solid).sister=0;    
    OsteoArticularModel(incr_solid).child=s_Ankle_J2;
    OsteoArticularModel(incr_solid).mother=s_mother;
    OsteoArticularModel(incr_solid).a=[0 0 1]';
    OsteoArticularModel(incr_solid).joint=1; % pin joint
    OsteoArticularModel(incr_solid).limit_inf=-pi/4;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).m=0;
    OsteoArticularModel(incr_solid).b=pos_attachment_pt;
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).c=[0 0 0]';
	OsteoArticularModel(incr_solid).comment='Ankle Flexion(+)/Extension(-)';
    
    % Ankle_J2
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=[Signe name];
    OsteoArticularModel(incr_solid).sister=0;    
    OsteoArticularModel(incr_solid).child=s_Foot;
    OsteoArticularModel(incr_solid).mother=s_Ankle_J1;
    OsteoArticularModel(incr_solid).a=[0 1 0]';
    OsteoArticularModel(incr_solid).joint=1; % pin joint
    OsteoArticularModel(incr_solid).limit_inf=-pi/4;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).m=0;
    OsteoArticularModel(incr_solid).b=[0 0 0]';
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).c=[0 0 0]';
	if Signe=='R'
		OsteoArticularModel(incr_solid).comment='Ankle Inversion(-)/Eversion(+)';
	else
		OsteoArticularModel(incr_solid).comment='Ankle Inversion(+)/Eversion(-)';
	end
    % Ankle_J2
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=[Signe name];
    OsteoArticularModel(incr_solid).sister=0;    
    OsteoArticularModel(incr_solid).child=0;
    OsteoArticularModel(incr_solid).mother=s_Ankle_J2;
    OsteoArticularModel(incr_solid).a=[1 0 0]';
    OsteoArticularModel(incr_solid).joint=1; % pin joint
    OsteoArticularModel(incr_solid).u=[0 0 1]';                  % fixed rotation with respect to u axis of theta angle
    OsteoArticularModel(incr_solid).theta=pi/2;
    OsteoArticularModel(incr_solid).limit_inf=-pi/4;
    OsteoArticularModel(incr_solid).limit_sup=pi/4;
    OsteoArticularModel(incr_solid).Visual=1;
    OsteoArticularModel(incr_solid).m=Mass.Foot_Mass;
    OsteoArticularModel(incr_solid).b=[0 0 0]';
    OsteoArticularModel(incr_solid).I=[I_Foot(1) I_Foot(4) I_Foot(5); I_Foot(4) I_Foot(2) I_Foot(6); I_Foot(5) I_Foot(6) I_Foot(3)];
    OsteoArticularModel(incr_solid).c=-Foot_AnkleJointNode';
    OsteoArticularModel(incr_solid).anat_position=Foot_position_set;
    OsteoArticularModel(incr_solid).L={[Signe 'Foot_AnkleJointNode'];[Signe 'Foot_ToetipNode']};
	if Signe=='R'
		OsteoArticularModel(incr_solid).comment='Ankle Internal(-)/External(+) Rotation';
	else
		OsteoArticularModel(incr_solid).comment='Ankle Internal(+)/External(-) Rotation';
	end
end
