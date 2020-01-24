function [OsteoArticularModel]= Upperarm_Shoulder(OsteoArticularModel,k,Signe,Mass,AttachmentPoint)
% Addition of an upper arm model
%   This upper arm model contains two solids (humerus, scapula), exhibits ? dof for the
%   shoulder
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the upper arm model ('R' for right side or 'L' for left side)
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
list_solid={'Clavicle_J1' 'Clavicle_J2' 'Scapula' 'Glenohumeral_J1' 'Glenohumeral_J2' 'Humerus' 'Scapulothoracic_J1' 'Scapulothoracic_J2' 'Scapulothoracic_J3' 'Scapulothoracic_J4' 'Scapulothoracic_J5' 'Scapulothoracic_J6'};

%% Choose right or left arm
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
        [OsteoArticularModel]=sister_actualize(OsteoArticularModel,OsteoArticularModel(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la derni�re soeur
    end
end

%%                      Node Definition

% ------------------------- Humerus ---------------------------------------

% Humerus centre of motion as defined in (Seth et al. 2019)
CoM_humerus = k*Mirror*[ 0 0 0]';

% Node positions
Humerus_ghJointNode = (k*[0 0.1674 0])*Mirror;
Humerus_ElbowJointNode = (k*[0 -0.1674 0])*Mirror;
osim2antoine=[k (Humerus_ghJointNode(2)-Humerus_ElbowJointNode(2))/0.2904 k];
Humerus_RadiusJointNode = (k*[0 -0.1674 0.0191])*Mirror;
Humerus_UlnaJointNode = (k*[0 -0.1674 -0.0191])*Mirror;
Humerus_Brachioradialis = (k*[-0.006 -0.209 -0.007])*Mirror; %in local frame gh Murray2001
% Humerus_Biceps = (k*[0.025 0.009 0.006])*Mirror; %in local frame gh Murray2001
Humerus_BicepsL_via2 = (osim2antoine.*[0.02131 0.01793 0.01028])*Mirror;  %in local frame OSIMarm26
Humerus_BicepsL_via3 = (osim2antoine.*[0.02378 -0.00511 0.01201])*Mirror;  %in local frame OSIMarm26
Humerus_BicepsL_via4 = (osim2antoine.*[0.01345 -0.02827 0.00136])*Mirror;  %in local frame OSIMarm26
Humerus_BicepsL_via5 = (osim2antoine.*[0.01068 -0.07736 -0.00165])*Mirror;  %in local frame OSIMarm26
Humerus_BicepsL_via6 = (osim2antoine.*[0.01703 -0.12125 0.00024])*Mirror;  %in local frame OSIMarm26
Humerus_BicepsS_via2 = (osim2antoine.*[0.01117 -0.07576 -0.01101])*Mirror;  %in local frame OSIMarm26
Humerus_BicepsS_via3 = (osim2antoine.*[0.01703 -0.12125 -0.01079])*Mirror;  %in local frame OSIMarm26
Humerus_Biceps_via7 = (osim2antoine.*[0.0228 -0.1754 -0.0063])*Mirror;  %in local frame OSIMarm26

Humerus_ECRL = (k*[-0.005 -0.260 -0.002])*Mirror; %in local frame gh Murray2001
% Humerus_Brachialis = (k*[0.008 -0.184 -0.013])*Mirror; %in local frame gh Murray2001
Humerus_Brachialis = (k*[0.0068 -0.1739 -0.0036])*Mirror; %in local frame OSIMarm26
Humerus_PronatorTeres = (k*[0.003 -0.270 -0.051])*Mirror; %in local frame gh Murray2001

% Humerus_Triceps = (k*[-0.004 -0.039 -0.006])*Mirror; %in local frame gh Murray2001
Humerus_TricepsLg_via1 = (osim2antoine.*[-0.02714 -0.11441 -0.00664])*Mirror;  %in local frame OSIMarm26
Humerus_TricepsLat_o = (osim2antoine.*[-0.00599 -0.12646 0.00428])*Mirror;     %in local frame OSIMarm26
Humerus_TricepsLat_via1 = (osim2antoine.*[-0.02344 -0.14528 0.00928])*Mirror;  %in local frame OSIMarm26
Humerus_TricepsMed_o = (osim2antoine.*[-0.00838 -0.13695 -0.00906])*Mirror;    %in local frame OSIMarm26
Humerus_TricepsMed_via1 = (osim2antoine.*[-0.02601 -0.15139 -0.0108])*Mirror;  %in local frame OSIMarm26
Humerus_Triceps_via2 = (osim2antoine.*[-0.03184 -0.22637 -0.01217])*Mirror; %in local frame OSIMarm26
Humerus_Triceps_via3 = (osim2antoine.*[-0.01743 -0.26757 -0.01208])*Mirror; %in local frame OSIMarm26


% ------------------------- Scapula ---------------------------------------

% Scapula centre of motion as defined in (Seth et al. 2019)
CoM_humerus = k*Mirror*[ 0 0 0]';


%%              Definition of anatomical landmarks

Humerus_position_set = {...
    [Signe 'HUM'], k*Mirror*[0 -0.1674 -0.05]'; ...
    [Signe 'Humerus_RadiusJointNode'], Humerus_RadiusJointNode'; ...
    [Signe 'Humerus_UlnaJointNode'], Humerus_UlnaJointNode'; ...
    [Signe 'Humerus_ElbowJointNode'], Humerus_ElbowJointNode'; ...
    [Signe 'Humerus_ghJointNode'], Humerus_ghJointNode'; ...
    %     [Signe 'Humerus_Brachioradialis_o'], (Humerus_Brachioradialis+Humerus_ghJointNode)'; ...
    [Signe 'Humerus_Brachioradialis_o'], Humerus_RadiusJointNode'+[0 0.07 0]'; ...
    ...[Signe 'Humerus_Biceps'], (Humerus_Biceps+Humerus_ghJointNode)'; ...
    [Signe 'Humerus_BicepsL_via2'], (Humerus_BicepsL_via2+Humerus_ghJointNode)';
    [Signe 'Humerus_BicepsL_via3'], (Humerus_BicepsL_via3+Humerus_ghJointNode)';
    [Signe 'Humerus_BicepsL_via4'], (Humerus_BicepsL_via4+Humerus_ghJointNode)';
    [Signe 'Humerus_BicepsL_via5'], (Humerus_BicepsL_via5+Humerus_ghJointNode)';
    [Signe 'Humerus_BicepsL_via6'], (Humerus_BicepsL_via6+Humerus_ghJointNode)';
    [Signe 'Humerus_BicepsS_via2'], (Humerus_BicepsS_via2+Humerus_ghJointNode)';
    [Signe 'Humerus_BicepsS_via3'], (Humerus_BicepsS_via3+Humerus_ghJointNode)';
    [Signe 'Humerus_Biceps_via7'], (Humerus_Biceps_via7+Humerus_ghJointNode)';
    ...
    %     [Signe 'Humerus_ECRL_o'], (Humerus_ECRL+Humerus_ghJointNode)'; ...
    [Signe 'Humerus_ECRL_o'], Humerus_RadiusJointNode'+[0 0.03 0]'; ...
    [Signe 'Humerus_Brachialis_o'], (Humerus_Brachialis+Humerus_ghJointNode)'; ...
    %     [Signe 'Humerus_PronatorTeres_o'], (Humerus_PronatorTeres+Humerus_ghJointNode)'; ...
    [Signe 'Humerus_PronatorTeres_o'], Humerus_UlnaJointNode'+[0 0.02 0.01]'; ...
    ...
    ...[Signe 'Humerus_Triceps_o'], (Humerus_Triceps+Humerus_ghJointNode)'; ...
    [Signe 'Humerus_TricepsLg_via1'], (Humerus_TricepsLg_via1+Humerus_ghJointNode)';
    [Signe 'Humerus_TricepsLat_o'], (Humerus_TricepsLat_o+Humerus_ghJointNode)';
    [Signe 'Humerus_TricepsLat_via1'], (Humerus_TricepsLat_via1+Humerus_ghJointNode)';
    [Signe 'Humerus_TricepsMed_o'], (Humerus_TricepsMed_o+Humerus_ghJointNode)';
    [Signe 'Humerus_TricepsMed_via1'], (Humerus_TricepsMed_via1+Humerus_ghJointNode)';
    [Signe 'Humerus_Triceps_via2'], (Humerus_Triceps_via2+Humerus_ghJointNode)';
    [Signe 'Humerus_Triceps_via3'], (Humerus_Triceps_via3+Humerus_ghJointNode)';
    [Signe 'Humerus_Triceps_via4'], Humerus_ElbowJointNode' + k*[-0.028 0 0]';...
    
    
    % TO BE MODIFIED
    [Signe '_humerus_Coracobrachialis2-P2'],k*Mirror*([-0.00231;-0.145;-0.0093299])-CoM_humerus;...
    [Signe '_humerus_DeltoideusClavicle2-P3'],k*Mirror*([0.0066437;-0.10981;0.0011474])-CoM_humerus;...
    [Signe '_humerus_DeltoideusScapulaPost2-P3'],k*Mirror*([-0.0047659;-0.086163;0.0062391])-CoM_humerus;...
    [Signe '_humerus_DeltoideusScapulaLat10-P3'],k*Mirror*([-0.0043128;-0.10045;0.0038455])-CoM_humerus;...
    [Signe '_humerus_LatissimusDorsi1-P5'],k*Mirror*([0.00588;-0.01904;-0.00345])-CoM_humerus;...
    [Signe '_humerus_LatissimusDorsi3-P5'],k*Mirror*([0.00578;-0.041;-0.001])-CoM_humerus;...
    [Signe '_humerus_LatissimusDorsi6-P4'],k*Mirror*([0.00422;-0.049998;-0.00018])-CoM_humerus;...
    [Signe '_humerus_PectoralisMajorClavicle1-P2'],k*Mirror*([0.010075;-0.042145;-0.0026007])-CoM_humerus;...
    [Signe '_humerus_PectoralisMajorThorax2-P2'],k*Mirror*([0.0099999;-0.03;0])-CoM_humerus;...
    [Signe '_humerus_PectoralisMajorThorax5-P2'],k*Mirror*([0.010185;-0.026204;-0.0031507])-CoM_humerus;...
    [Signe '_humerus_TeresMajor1-P2'],k*Mirror*([0.00432;-0.039;-0.0017])-CoM_humerus;...
    [Signe '_humerus_Infraspinatus3-P2'],k*Mirror*([-0.017162;-0.00573;0.024807])-CoM_humerus;...
    [Signe '_humerus_Infraspinatus5-P2'],k*Mirror*([-0.014334;0.0027191;0.022204])-CoM_humerus;...
    [Signe '_humerus_TeresMinor2-P2'],k*Mirror*([-0.01587;-0.00936;0.01085])-CoM_humerus;...
    [Signe '_humerus_Subscapularis3-P2'],k*Mirror*([0.018;-0.00023;-0.012])-CoM_humerus;...
    [Signe '_humerus_Subscapularis4-P2'],k*Mirror*([0.016391;0.00095781;-0.019435])-CoM_humerus;...
    [Signe '_humerus_Subscapularis9-P2'],k*Mirror*([0.010984;-0.0034073;-0.019526])-CoM_humerus;...
    [Signe '_humerus_Supraspinatus2-P2'],k*Mirror*([0.01017;0.0095678;0.02005])-CoM_humerus;...
    [Signe '_humerus_Supraspinatus4-P2'],k*Mirror*([0.01778;0.01764;0.0096499])-CoM_humerus;...
    [Signe '_humerus_BIC_long-P2'],k*Mirror*([0.011831;0.028142;0.020038])-CoM_humerus;...
    };



    % TO BE MODIFIED
Scapula_position_set={...
    [Signe '_scapula_TrapeziusScapula5-P2'],k*Mirror*([-0.058246;-0.0019567;-0.03632])-CoM_scapula;...
    [Signe '_scapula_TrapeziusScapula2-P2'],k*Mirror*([-0.05175;0.0068903;-0.024441])-CoM_scapula;...
    [Signe '_scapula_TrapeziusScapula10-P2'],k*Mirror*([-0.07572;-0.0094504;-0.073864])-CoM_scapula;...
    [Signe '_scapula_SerratusAnterior4-P1'],k*Mirror*([-0.11355;-0.11221;-0.085518])-CoM_scapula;...
    [Signe '_scapula_SerratusAnterior7-P1'],k*Mirror*([-0.10312;-0.083084;-0.098597])-CoM_scapula;...
    [Signe '_scapula_SerratusAnterior12-P1'],k*Mirror*([-0.04851;0.0090004;-0.08464])-CoM_scapula;...
    [Signe '_scapula_Rhomboideus1-P2'],k*Mirror*([-0.082669;-0.022911;-0.10173])-CoM_scapula;...
    [Signe '_scapula_Rhomboideus4-P2'],k*Mirror*([-0.10626;-0.10671;-0.092724])-CoM_scapula;...
    [Signe '_scapula_LevatorScapulae1-P2'],k*Mirror*([-0.07801;-0.0080803;-0.10288])-CoM_scapula;...
    [Signe '_scapula_Coracobrachialis2-P1'],k*Mirror*([0.0082682;-0.042435;-0.028091])-CoM_scapula;...
    [Signe '_scapula_DeltoideusClavicle2-P2'],k*Mirror*([0.019562;-0.0065871;0.010398])-CoM_scapula;...
    [Signe '_scapula_DeltoideusScapulaPost2-P1'],k*Mirror*([-0.057738;-0.0069116;-0.027229])-CoM_scapula;...
    [Signe '_scapula_DeltoideusScapulaPost2-P2'],k*Mirror*([-0.055003;-0.032366;0.0073527])-CoM_scapula;...
    [Signe '_scapula_DeltoideusScapulaLat10-P1'],k*Mirror*([-0.01602;0.002034;0.0077979])-CoM_scapula;...
    [Signe '_scapula_DeltoideusScapulaLat10-P2'],k*Mirror*([-0.0051378;-0.0067412;0.031029])-CoM_scapula;...
    [Signe '_scapula_TeresMajor1-P1'],k*Mirror*([-0.10441;-0.11742;-0.072094])-CoM_scapula;...
    [Signe '_scapula_Infraspinatus3-P1'],k*Mirror*([-0.099069;-0.080853;-0.081261])-CoM_scapula;...
    [Signe '_scapula_Infraspinatus5-P1'],k*Mirror*([-0.083429;-0.032271;-0.086879])-CoM_scapula;...
    [Signe '_scapula_PectoralisMinor3-P2'],k*Mirror*([0.010875;-0.035041;-0.022941])-CoM_scapula;...
    [Signe '_scapula_TeresMinor2-P1'],k*Mirror*([-0.084369;-0.066053;-0.042285])-CoM_scapula;...
    [Signe '_scapula_Subscapularis3-P1'],k*Mirror*([-0.07879;-0.031271;-0.090268])-CoM_scapula;...
    [Signe '_scapula_Subscapularis4-P1'],k*Mirror*([-0.08357;-0.054912;-0.074744])-CoM_scapula;...
    [Signe '_scapula_Subscapularis9-P1'],k*Mirror*([-0.095069;-0.097654;-0.08537])-CoM_scapula;...
    [Signe '_scapula_Supraspinatus2-P1'],k*Mirror*([-0.06053;-0.0013801;-0.049453])-CoM_scapula;...
    [Signe '_scapula_Supraspinatus4-P1'],k*Mirror*([-0.048993;0.0013557;-0.069247])-CoM_scapula;...
    [Signe '_scapula_TRIlong2-P2'],k*Mirror*([-0.0421;-0.051905;-0.012921])-CoM_scapula;...
    [Signe '_scapula_BIC_long-P1'],k*Mirror*([-0.022587;-0.016329;-0.018136])-CoM_scapula;...
    [Signe '_scapula_BIC_brevis2-P1'],k*Mirror*([0.0095474;-0.038224;-0.024239])-CoM_scapula;...
    };
%END OF TO BE MODIFIED

%%                     Mise ? l'?chelle des inerties


%% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas

% ------------------------- Scapula ---------------------------------------

% ------------------------- Humerus ---------------------------------------
Length_Humerus=norm(Humerus_ghJointNode-Humerus_ElbowJointNode);
[I_Humerus]=rgyration2inertia([31 14 32 6 5 2], Mass.UpperArm_Mass, [0 0 0], Length_Humerus, Signe);


%% "Human model" structure generation

num_solid=0;

%% Scapula
% Clavicle_J1
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Signe name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=s_Clavicle_J2;         % Solid's child
OsteoArticularModel(incr_solid).mother=s_mother;            % Solid's mother
OsteoArticularModel(incr_solid).a=[0 1 0]';                          
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=0;                        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;

% Clavicle_J2
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Signe name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=s_Scapula;            % Solid's child
OsteoArticularModel(incr_solid).mother=s_Clavicle_J1;            % Solid's mother
OsteoArticularModel(incr_solid).a=[1 0 0]';                          
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=0;                        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;

% Scapula
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Signe name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=s_Scapulothoracic_J1;         % Solid's child
OsteoArticularModel(incr_solid).mother=s_Clavicle_J2;            % Solid's mother
OsteoArticularModel(incr_solid).a=[0 1 0]';                          
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=Mass.Scapula_Mass;        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;


%% Humerus
% Glenohumeral_J1
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Signe name];          % solid name with side
OsteoArticularModel(incr_solid).sister=s_Scapulothoracic_J1;                   % Solid's sister
OsteoArticularModel(incr_solid).child=s_Glenohumeral_J2;         % Solid's child
OsteoArticularModel(incr_solid).mother=0;            % Solid's mother
OsteoArticularModel(incr_solid).a=[0 1 0]';                          
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=0;                        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;

% Glenohumeral_J2
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Signe name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=s_Humerus;         % Solid's child
OsteoArticularModel(incr_solid).mother=s_Glenohumeral_J1;            % Solid's mother
OsteoArticularModel(incr_solid).a=[1 0 0]';                          
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=0;                        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;

% Humerus
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Signe name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=0;                    % Solid's child
OsteoArticularModel(incr_solid).mother=s_Glenohumeral_J2;            % Solid's mother
OsteoArticularModel(incr_solid).a=[0 1 0]';                          
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).limit_inf=-2*pi/3;
OsteoArticularModel(incr_solid).limit_sup=2*pi/3;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=Mass.Humerus_Mass;                        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=[I_Humerus(1) I_Humerus(4) I_Humerus(5); I_Humerus(4) I_Humerus(2) I_Humerus(6); I_Humerus(5) I_Humerus(6) I_Humerus(3)];               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=-Humerus_ghJointNode';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).anat_position=Humerus_position_set;
OsteoArticularModel(incr_solid).Visual=1;
OsteoArticularModel(incr_solid).L={[Signe 'Humerus_ghJointNode'];[Signe 'Humerus_ElbowJointNode']};


%% Scapulo-thoracic joint
% Scapulothoracic_J1
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Signe name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=s_Scapulothoracic_J2;         % Solid's child
OsteoArticularModel(incr_solid).mother=s_Scapula;            % Solid's mother
OsteoArticularModel(incr_solid).a=[1 0 0]';                          
OsteoArticularModel(incr_solid).joint=2;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=0;                        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;

% Scapulothoracic_J2
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Signe name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=s_Scapulothoracic_J3;         % Solid's child
OsteoArticularModel(incr_solid).mother=sScapulothoracic_J1;            % Solid's mother
OsteoArticularModel(incr_solid).a=[0 1 0]';                          
OsteoArticularModel(incr_solid).joint=2;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=0;                        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;

% Scapulothoracic_J3
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Signe name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=s_Scapulothoracic_J2;         % Solid's child
OsteoArticularModel(incr_solid).mother=s_Scapulothoracic_J4;            % Solid's mother
OsteoArticularModel(incr_solid).a=[0 0 1]';                          
OsteoArticularModel(incr_solid).joint=2;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=0;                        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;


% Scapulothoracic_J4
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Signe name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=s_Scapulothoracic_J5;         % Solid's child
OsteoArticularModel(incr_solid).mother=s_Scapulothoracic_J3;            % Solid's mother
OsteoArticularModel(incr_solid).a=[1 0 0]';                          
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=0;                        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;


% Scapulothoracic_J5
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Signe name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=s_Scapulothoracic_J6;         % Solid's child
OsteoArticularModel(incr_solid).mother=s_Scapulothoracic_J4;            % Solid's mother
OsteoArticularModel(incr_solid).a=[0 1 0]';                          
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=0;                        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;


% Scapulothoracic_J6
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Signe name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=0;         % Solid's child
OsteoArticularModel(incr_solid).mother=s_Scapulothoracic_J5;            % Solid's mother
OsteoArticularModel(incr_solid).a=[0 0 1]';                          
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=0;                        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[Signe 'Thorax_ScapulaJointNode'];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;

end