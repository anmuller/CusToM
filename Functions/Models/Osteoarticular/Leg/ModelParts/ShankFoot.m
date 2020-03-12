function [OsteoArticularModel]= ShankFoot(OsteoArticularModel,k,Signe,Mass,AttachmentPoint)
% Addition of a shank/foot model
%   This shank/foot model contains one solid (shank/foot), exhibits 1 dof for the
%   knee
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the shank/foot model ('R' for right side or 'L' for left side)
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
list_solid={'ShankFoot'};

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

% --------------------------- Shank ---------------------------------------

MetatarsalJoint2Node = (k*[0 -0.0725 0.015])*Mirror;
MalleousLateralNode = (k*[0.065 0.053 0.025])*Mirror;
CoM_Foot=0.5*(MetatarsalJoint2Node-MalleousLateralNode)+MalleousLateralNode;
%
%
% % Node locations
Shank_AnkleJointNode = (k*[0 -0.2608 0])*Mirror;
Shank_KneeJointNode = (k*[0 0.1992 0])*Mirror;

Foot_AnkleJointNode = (k*[0.06 0.06 0])*Mirror - CoM_Foot; %center of masse of the foot
Foot_ToetipNode = (k*[-0.012 -0.126 0.023])*Mirror-CoM_Foot;
Foot_HellNode = (k*[0.009 0.115 0])*Mirror-CoM_Foot;
Rot=Rodrigues([0 0 1]',pi/2);

HEE=Rot*(k*Mirror*[-0.009479;0.12946;-0.02]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
TAR= Rot*(k*Mirror*[-0.021708;-0.04;0.04]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
TOE= Rot*(k*Mirror*[-0.02;-0.11625;-0.015]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
TARI = Rot*(k*Mirror*[-0.021708;-0.055;-0.05]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
MetatarsalJoint1 = Rot*(k*Mirror*[-0.0275;-0.06025;-0.03]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
MetatarsalJoint2 =  Rot*(k*Mirror*[-0.0325;-0.06275;-0.005]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
MetatarsalJoint3 = Rot*(k*Mirror*[-0.0325;-0.05525;0.007]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
MetatarsalJoint4 =  Rot*(k*Mirror*[-0.0375;-0.04025;0.017] -Foot_AnkleJointNode')+Shank_AnkleJointNode';
MetatarsalJoint5 =  Rot*(k*Mirror*[-0.0375;-0.03325;0.03] -Foot_AnkleJointNode')+Shank_AnkleJointNode';
MalleousLateral= Rot*(k*Mirror*[0.0325;0.06275;0.005]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
Soleus= Rot*(k*Mirror*[-0.0045;0.11775;-0.021]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
Gastrocnemius=Rot*(k*Mirror*[-0.0045;0.11775;-0.021]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
TibialisPosterior=Rot*(k*Mirror*[-0.0205;0.01675;-0.04]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
TibialisPosteriorVia=Rot*(k*Mirror*[0.0045;0.09475;-0.04]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FlexorDigitorumLongus=Rot*(k*Mirror*[-0.0455;-0.09025;0.02]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FlexorDigitorumLongusVia=Rot*(k*Mirror*[0.0045;0.07975;-0.04]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FlexorHallucisLongus=Rot*(k*Mirror*[-0.0405;-0.10325;-0.021]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FlexorHallucisLongusVia=Rot*(k*Mirror*[-0.0055;0.08975;-0.03]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
PeroneusBrevis=Rot*(k*Mirror*[-0.0285;0.03475;0.016]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
PeroneusBrevisVia=Rot*(k*Mirror*[0.0045;0.07975;-0.002]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
TibialisAnterior=Rot*(k*Mirror*[-0.0025;0.00975;-0.04]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
TibialisAnteriorVia=Rot*(k*Mirror*[0.0225;0.02475;-0.03]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
ExtensorDigitorumLongus=Rot*(k*Mirror*[-0.0395;-0.09025;0.02]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
ExtensorDigitorumVia=Rot*(k*Mirror*[0.0225;0.02475;-0.01]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
ExtensorHallucisLongus=Rot*(k*Mirror*[-0.0355;-0.10325;-0.021]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
ExtensorHallucisVia=Rot*(k*Mirror*[0.0225;0.02475;-0.02]-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction1=Rot*(k*Mirror*[-0.04;0.1185;-0.03]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction2=Rot*(k*Mirror*[-0.04;0.1185;-0.007]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction3=Rot*(k*Mirror*[-0.03;0.035;0.015]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction4=Rot*(k*Mirror*[-0.025;0.01;-0.04]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction5=Rot*(k*Mirror*[-0.04;-0.0525;-0.035]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction6=Rot*(k*Mirror*[-0.035;-0.0525;-0.0125]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction7=Rot*(k*Mirror*[-0.03;-0.045;0.0015]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction8=Rot*(k*Mirror*[-0.04;-0.035;0.015]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction9=Rot*(k*Mirror*[-0.04;-0.02;0.025]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction10=Rot*(k*Mirror*[-0.04;-0.075;0.04]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction11=Rot*(k*Mirror*[-0.045;-0.117;0.002]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction12=Rot*(k*Mirror*[-0.04;-0.095;-0.025]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction13=Rot*(k*Mirror*[-0.045;-0.1;0.015]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
FootPrediction14=Rot*(k*Mirror*[-0.045;-0.09;0.03]*0.9359-Foot_AnkleJointNode')+Shank_AnkleJointNode';
Foot_HellNode = Rot*(Foot_HellNode'-Foot_AnkleJointNode')+Shank_AnkleJointNode'; %#ok<NASGU>

%%                     Scaling of inertia parameters

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % --------------------------- Shank ---------------------------------------
    Length_Shank=norm(Shank_AnkleJointNode-Shank_KneeJointNode);
    [I_Shank]=rgyration2inertia([28 10 28 4*1i 2*1i 5], Mass.Shank_Mass, [0 0 0], Length_Shank, Signe);

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % --------------------------- Foot ----------------------------------------
    Length_Foot = norm(Foot_AnkleJointNode-Foot_ToetipNode);
    [I_Foot]=rgyration2inertia([37 17 36 13 0 8*1i], Mass.Foot_Mass, [0 0 0], Length_Foot, Signe);

    
Knee_CoMFoot=-Rot*Foot_AnkleJointNode'+Shank_AnkleJointNode'-Shank_KneeJointNode';
CoM_bary=(Knee_CoMFoot*Mass.Foot_Mass-Shank_KneeJointNode'*Mass.Shank_Mass)/(Mass.Foot_Mass+Mass.Shank_Mass);

Ishank=[I_Shank(1) I_Shank(4) I_Shank(5); I_Shank(4) I_Shank(2) I_Shank(6); I_Shank(5) I_Shank(6) I_Shank(3)];
Ishank_dep=Huygens(-Shank_KneeJointNode-CoM_bary,Ishank,Mass.Shank_Mass);

Ifoot=[I_Foot(1) I_Foot(4) I_Foot(5); I_Foot(4) I_Foot(2) I_Foot(6); I_Foot(5) I_Foot(6) I_Foot(3)];
Ifoot=Ifoot*Rot;
Ifoot_dep=Huygens(Knee_CoMFoot-CoM_bary,Ifoot,Mass.Foot_Mass);

Iglob=Ishank_dep+Ifoot_dep;
diff=(-Shank_KneeJointNode'-CoM_bary);
Foot_ToetipNode = Rot*(Foot_ToetipNode'-Foot_AnkleJointNode')+Shank_AnkleJointNode';

%% Definition of anatomical landmarks
Shank_position_set= {...
    [Signe 'ANE'], k*Mirror*[0 -0.27 0.041487]'+diff; ...
    [Signe 'ANI'], k*Mirror*[0.02 -0.24892 -0.04]'+diff; ...
    [Signe 'KNI'], k*Mirror*[0 0.17 -0.056]'+diff; ...
    [Signe 'Shank_KneeJointNode'], Shank_KneeJointNode'+diff; ...
%     [Signe 'Shank_AnkleJointNode'], Shank_AnkleJointNode'+diff; ...
    ['Quadriceps' Signe 'Shank'],k*Mirror*[0.032;0.11;0.01]+diff;...
    ['SemitendinosusVia' Signe 'Shank'],k*Mirror*[-0.025;0.15;-0.032]+diff;...
    ['Semitendinosus' Signe 'Shank'],k*Mirror*[0;0.125;-0.016]+diff;...
    ['Semimembranosus' Signe 'Shank'],k*Mirror*[-0.024;0.155;-0.018]+diff;...
    ['SemimembranosusVia' Signe 'Shank'],k*Mirror*[-0.027;0.165;-0.018]+diff;...
    ['BicepsFemorisCaputLongum' Signe 'Shank'],k*Mirror*[-0.015;0.16;0.043]+diff;...
    ['BicepsFemorisCaputLongumVia' Signe 'Shank'],k*Mirror*[-0.0185;0.17;0.043]+diff;...
    ['BicepsFemorisCaputBreve' Signe 'Shank'],k*Mirror*[-0.015;0.16;0.043]+diff;...
    ['BicepsFemorisCaputBreveVia' Signe 'Shank'],k*Mirror*[-0.0185;0.17;0.043]+diff;...
    ['Soleus' Signe 'Shank'],k*Mirror*[-0.02;0.1292;0]+diff;...
    ['GastrocnemiusVia' Signe 'Shank'],k*Mirror*[-0.05;0.05;0]+diff;...
    ['FlexorDigitorumLongus' Signe 'Shank'],k*Mirror*[0;0.04;-0.01]+diff;...
    ['FlexorHallucisLongus' Signe 'Shank'],k*Mirror*[0;-0.04;0.01]+diff;...
    ['TibialisPosterior' Signe 'Shank'],k*Mirror*[0;0.13;0]+diff;...
    ['PeroneusBrevis' Signe 'Shank'],k*Mirror*[0;-0.04;0.03]+diff;...
    ['TibialisAnterior' Signe 'Shank'],k*Mirror*[0;0.0115;-0.01]+diff;...
    ['ExtensorDigitorumLongus' Signe 'Shank'],k*Mirror*[0;0.16;0.01]+diff;...
    ['ExtensorHallucisLongus' Signe 'Shank'],k*Mirror*[0;-0.05;0]+diff;...
    ['SartoriusVia2' Signe 'Shank'],k*Mirror*[0.0065;0.18;-0.038]+diff;...
    ['SartoriusVia3' Signe 'Shank'],k*Mirror*[0.01;0.15;-0.047]+diff;...
    ['Sartorius' Signe 'Shank'],k*Mirror*[0.018;0.13;-0.016]+diff;...
    ['GracilisVia' Signe 'Shank'],k*Mirror*[-0.0185;0.18;-0.018]+diff;...
    ['GracilisVia1' Signe 'Shank'],k*Mirror*[0.005;0.15;-0.042]+diff;...
    ['Gracilis' Signe 'Shank'],k*Mirror*[0.018;0.13;-0.016]+diff;...
    ['GluteusMaximus1' Signe 'Shank'],k*Mirror*[-0.0185;0.185;0.043]+diff;...
    ['GluteusMaximus2' Signe 'Shank'],k*Mirror*[-0.0185;0.185;0.043]+diff;...
    ['TensorFasciaeLatae' Signe 'Shank'],k*Mirror*[-0.0185;0.185;0.043]+diff;...
    [Signe 'HEE'], HEE+diff; ...
    [Signe 'TAR'], TAR+diff; ...
    [Signe 'TOE'], TOE+diff; ...
    [Signe 'TARI'], TARI+diff; ...
    [Signe 'Foot_AnkleJointNode'], Shank_AnkleJointNode'+diff; ...
    [Signe 'Foot_ToetipNode'], Foot_ToetipNode+diff; ...
    ['MetatarsalJoint1' Signe 'Foot'],MetatarsalJoint1+diff;...
    ['MetatarsalJoint2' Signe 'Foot'],MetatarsalJoint2+diff;...
    ['MetatarsalJoint3' Signe 'Foot'],MetatarsalJoint3+diff;...
    ['MetatarsalJoint4' Signe 'Foot'],MetatarsalJoint4+diff;...
    ['MetatarsalJoint5' Signe 'Foot'],MetatarsalJoint5+diff;...
    ['MalleousLateral' Signe 'Foot'],MalleousLateral+diff;...
    ['Soleus' Signe 'Foot'],Soleus+diff;...
    ['Gastrocnemius' Signe 'Foot'],Gastrocnemius+diff;...
    ['TibialisPosterior' Signe 'Foot'],TibialisPosterior+diff;...
    ['TibialisPosteriorVia' Signe 'Foot'],TibialisPosteriorVia+diff;...
    ['FlexorDigitorumLongus' Signe 'Foot'],FlexorDigitorumLongus+diff;...
    ['FlexorDigitorumLongusVia' Signe 'Foot'],FlexorDigitorumLongusVia+diff;...
    ['FlexorHallucisLongus' Signe 'Foot'],FlexorHallucisLongus+diff;...
    ['FlexorHallucisLongusVia' Signe 'Foot'],FlexorHallucisLongusVia+diff;...
    ['PeroneusBrevis' Signe 'Foot'],PeroneusBrevis+diff;...
    ['PeroneusBrevisVia' Signe 'Foot'],PeroneusBrevisVia+diff;...
    ['TibialisAnterior' Signe 'Foot'],TibialisAnterior+diff;...
    ['TibialisAnteriorVia' Signe 'Foot'],TibialisAnteriorVia+diff;...
    ['ExtensorDigitorumLongus' Signe 'Foot'],ExtensorDigitorumLongus+diff;...
    ['ExtensorDigitorumVia' Signe 'Foot'],ExtensorDigitorumVia+diff;...
    ['ExtensorHallucisLongus' Signe 'Foot'],ExtensorHallucisLongus+diff;...
    ['ExtensorHallucisVia' Signe 'Foot'],ExtensorHallucisVia+diff;...
    [Signe 'FootPrediction1'], FootPrediction1+diff;...
    [Signe 'FootPrediction2'], FootPrediction2+diff;...
    [Signe 'FootPrediction3'], FootPrediction3+diff;...
    [Signe 'FootPrediction4'], FootPrediction4+diff;...
    [Signe 'FootPrediction5'], FootPrediction5+diff;...
    [Signe 'FootPrediction6'], FootPrediction6+diff;...
    [Signe 'FootPrediction7'], FootPrediction7+diff;...
    [Signe 'FootPrediction8'], FootPrediction8+diff;...
    [Signe 'FootPrediction9'], FootPrediction9+diff;...
    [Signe 'FootPrediction10'], FootPrediction10+diff;...
    [Signe 'FootPrediction11'], FootPrediction11+diff;...
    [Signe 'FootPrediction12'], FootPrediction12+diff;...
    [Signe 'FootPrediction13'], FootPrediction13+diff;...
    [Signe 'FootPrediction14'], FootPrediction14+diff;...
    };

%% %% "Human_model" structure generation

num_solid=0;
%% Shank/Foot
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
OsteoArticularModel(incr_solid).name=[Signe name];
OsteoArticularModel(incr_solid).sister=0;
OsteoArticularModel(incr_solid).child=0;
OsteoArticularModel(incr_solid).mother=s_mother;
OsteoArticularModel(incr_solid).a=[0 0 1]';
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).limit_inf=-pi;
OsteoArticularModel(incr_solid).limit_sup=0;
OsteoArticularModel(incr_solid).Visual=1;
OsteoArticularModel(incr_solid).m=Mass.Shank_Mass+Mass.Foot_Mass;
OsteoArticularModel(incr_solid).b=pos_attachment_pt;
OsteoArticularModel(incr_solid).I=Iglob;
OsteoArticularModel(incr_solid).c=CoM_bary;
OsteoArticularModel(incr_solid).anat_position=Shank_position_set;
OsteoArticularModel(incr_solid).L={[Signe 'Shank_KneeJointNode'];[Signe 'Shank_AnkleJointNode']};

%Axis of rotation calibration
OsteoArticularModel(incr_solid).limit_alpha= [ 20 , 30;...
    -20, -30] ;
OsteoArticularModel(incr_solid).v= [ [1; 0; 0] , [0 ;1;0] ] ;
OsteoArticularModel(incr_solid).comment= 'Knee Flexion(-)/Extension(+)' ;

end
