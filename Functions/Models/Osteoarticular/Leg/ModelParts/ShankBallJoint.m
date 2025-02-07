function [OsteoArticularJoint]= ShankBallJoint(OsteoArticularJoint,k,Signe,Mass,AttachmentPoint)
% Addition of a shank model
%   This shank model contains one solid (shank), exhibits 3 dof for the
%   knee
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the shank model ('R' for right side or 'L' for left side)
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
list_solid={'Knee_J1', 'Knee_J2' ,'Shank'};

%% Choose leg right or left
if Signe == 'R'
    Mirror=[1 0 0; 0 1 0; 0 0 1];
else
    if Signe == 'L'
        Mirror=[1 0 0; 0 1 0; 0 0 -1];
    end
end

%% solid numbering incremation

s=size(OsteoArticularJoint,2)+1;  %#ok<NASGU> % number of the first solid
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
    for i=1:numel(OsteoArticularJoint)
        for j=1:size(OsteoArticularJoint(i).anat_position,1)
            if strcmp(AttachmentPoint,OsteoArticularJoint(i).anat_position{j,1})
                s_mother=i;
                pos_attachment_pt=OsteoArticularJoint(i).anat_position{j,2}+OsteoArticularJoint(s_mother).c;
                test=1;
                break
            end
        end
        if i==numel(OsteoArticularJoint) && test==0
            error([AttachmentPoint ' is no existent'])
        end
    end
    if OsteoArticularJoint(s_mother).child == 0      % if the mother don't have any child
        OsteoArticularJoint(s_mother).child = eval(['s_' list_solid{1}]);    % the child of this mother is this solid
    else
        [OsteoArticularJoint]=sister_actualize(OsteoArticularJoint,OsteoArticularJoint(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la dernière soeur
    end
end

%%                      Definition of anatomical landmarks (joint)

% --------------------------- Shank ---------------------------------------

% Node locations
Shank_AnkleJointNode = (k*[0 -0.2608 0])*Mirror;
Shank_KneeJointNode = (k*[0 0.1992 0])*Mirror;

%% Definition of anatomical landmarks

Shank_position_set= {...
    [Signe 'ANE'], k*Mirror*[0 -0.27 0.041487]'; ...
    [Signe 'ANI'], k*Mirror*[0.02 -0.24892 -0.04]'; ...
    [Signe 'KNI'], k*Mirror*[0 0.17 -0.056]'; ...
    [Signe 'Shank_KneeJointNode'], Shank_KneeJointNode'; ...
    [Signe 'Shank_AnkleJointNode'], Shank_AnkleJointNode'; ...
    ['Quadriceps' Signe 'Shank'],k*Mirror*[0.032;0.11;0.01];...
    ['SemitendinosusVia' Signe 'Shank'],k*Mirror*[-0.025;0.15;-0.032];...
    ['Semitendinosus' Signe 'Shank'],k*Mirror*[0;0.125;-0.016];...
    ['Semimembranosus' Signe 'Shank'],k*Mirror*[-0.024;0.155;-0.018];...
    ['SemimembranosusVia' Signe 'Shank'],k*Mirror*[-0.027;0.165;-0.018];...
    ['BicepsFemorisCaputLongum' Signe 'Shank'],k*Mirror*[-0.015;0.16;0.043];...
    ['BicepsFemorisCaputLongumVia' Signe 'Shank'],k*Mirror*[-0.0185;0.17;0.043];...
    ['BicepsFemorisCaputBreve' Signe 'Shank'],k*Mirror*[-0.015;0.16;0.043];...
    ['BicepsFemorisCaputBreveVia' Signe 'Shank'],k*Mirror*[-0.0185;0.17;0.043];...
    ['Soleus' Signe 'Shank'],k*Mirror*[-0.02;0.1292;0];...
    ['GastrocnemiusVia' Signe 'Shank'],k*Mirror*[-0.05;0.05;0];...
    ['FlexorDigitorumLongus' Signe 'Shank'],k*Mirror*[0;0.04;-0.01];...
    ['FlexorHallucisLongus' Signe 'Shank'],k*Mirror*[0;-0.04;0.01];...
    ['TibialisPosterior' Signe 'Shank'],k*Mirror*[0;0.13;0];...
    ['PeroneusBrevis' Signe 'Shank'],k*Mirror*[0;-0.04;0.03];...
    ['TibialisAnterior' Signe 'Shank'],k*Mirror*[0;0.0115;-0.01];...
    ['ExtensorDigitorumLongus' Signe 'Shank'],k*Mirror*[0;0.16;0.01];...
    ['ExtensorHallucisLongus' Signe 'Shank'],k*Mirror*[0;-0.05;0];...
    ['SartoriusVia2' Signe 'Shank'],k*Mirror*[0.0065;0.18;-0.038];...
    ['SartoriusVia3' Signe 'Shank'],k*Mirror*[0.01;0.15;-0.047];...
    ['Sartorius' Signe 'Shank'],k*Mirror*[0.018;0.13;-0.016];...
    ['GracilisVia' Signe 'Shank'],k*Mirror*[-0.0185;0.18;-0.018];...
    ['GracilisVia1' Signe 'Shank'],k*Mirror*[0.005;0.15;-0.042];...
    ['Gracilis' Signe 'Shank'],k*Mirror*[0.018;0.13;-0.016];...
    ['GluteusMaximus1' Signe 'Shank'],k*Mirror*[-0.0185;0.185;0.043];...
    ['GluteusMaximus2' Signe 'Shank'],k*Mirror*[-0.0185;0.185;0.043];...
    ['TensorFasciaeLatae' Signe 'Shank'],k*Mirror*[-0.0185;0.185;0.043]...
    };

%%                     Scaling inertial parameters

%% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
% --------------------------- Shank ---------------------------------------
Length_Shank=norm(Shank_AnkleJointNode-Shank_KneeJointNode);
[I_Shank]=rgyration2inertia([28 10 28 4*1i 2*1i 5], Mass.Shank_Mass, [0 0 0], Length_Shank, Signe);

%% %% "Human_model" structure generation

num_solid=0;
%% Knee_J1
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
OsteoArticularJoint(incr_solid).name=[Signe name];
OsteoArticularJoint(incr_solid).sister=0;
OsteoArticularJoint(incr_solid).child=s_Knee_J2;
OsteoArticularJoint(incr_solid).mother=s_mother;
OsteoArticularJoint(incr_solid).a=[0 0 1]';
OsteoArticularJoint(incr_solid).joint=1;
OsteoArticularJoint(incr_solid).limit_inf=-pi;
OsteoArticularJoint(incr_solid).limit_sup=0;
OsteoArticularJoint(incr_solid).Visual=0;
OsteoArticularJoint(incr_solid).m=0;
OsteoArticularJoint(incr_solid).b=pos_attachment_pt;
OsteoArticularJoint(incr_solid).I=zeros(3,3);
OsteoArticularJoint(incr_solid).c=[0 0 0]';
OsteoArticularJoint(incr_solid).comment='Knee Flexion(-)/Extension(-)';

%% Knee_J2
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
OsteoArticularJoint(incr_solid).name=[Signe name];
OsteoArticularJoint(incr_solid).sister=0;
OsteoArticularJoint(incr_solid).child=s_Shank;
OsteoArticularJoint(incr_solid).mother=s_Knee_J1;
OsteoArticularJoint(incr_solid).a=[1 0 0]';
OsteoArticularJoint(incr_solid).joint=1;
OsteoArticularJoint(incr_solid).joint=1;
OsteoArticularJoint(incr_solid).limit_inf=-pi/4;
OsteoArticularJoint(incr_solid).limit_sup=pi/4;
OsteoArticularJoint(incr_solid).Visual=0;
OsteoArticularJoint(incr_solid).m=0;
OsteoArticularJoint(incr_solid).b=[0 0 0]';
OsteoArticularJoint(incr_solid).I=zeros(3,3);
OsteoArticularJoint(incr_solid).c=[0 0 0]';
if Signe=='R'
    OsteoArticularJoint(incr_solid).comment='Knee Abduction(-)/Adduction(+) - X-Rotation';
else
    OsteoArticularJoint(incr_solid).comment='Knee Abduction(+)/Adduction(-) - X-Rotation';
end

%% Shank
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
OsteoArticularJoint(incr_solid).name=[Signe name];
OsteoArticularJoint(incr_solid).sister=0;
OsteoArticularJoint(incr_solid).child=0;
OsteoArticularJoint(incr_solid).mother=s_Knee_J2;
OsteoArticularJoint(incr_solid).a=[0 1 0]';
OsteoArticularJoint(incr_solid).joint=1;
OsteoArticularJoint(incr_solid).limit_inf=-pi/4;
OsteoArticularJoint(incr_solid).limit_sup=pi/4;
OsteoArticularJoint(incr_solid).Visual=1;
OsteoArticularJoint(incr_solid).m=Mass.Shank_Mass;
OsteoArticularJoint(incr_solid).b=[0 0 0]';
OsteoArticularJoint(incr_solid).I=[I_Shank(1) I_Shank(4) I_Shank(5); I_Shank(4) I_Shank(2) I_Shank(6); I_Shank(5) I_Shank(6) I_Shank(3)];
OsteoArticularJoint(incr_solid).c=-Shank_KneeJointNode';
OsteoArticularJoint(incr_solid).anat_position=Shank_position_set;
OsteoArticularJoint(incr_solid).L={[Signe 'Shank_KneeJointNode'];[Signe 'Shank_AnkleJointNode']};
if Signe=='R'
    OsteoArticularJoint(incr_solid).comment='Knee Internal(+)/External(-) Rotation';
else
    OsteoArticularJoint(incr_solid).comment='Knee Internal(-)/External(+) Rotation';
end

end
