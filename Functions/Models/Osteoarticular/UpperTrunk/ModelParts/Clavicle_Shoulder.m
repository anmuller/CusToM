function [Human_model]= Clavicle_Shoulder(Human_model,k,Mass,Side,AttachmentPoint)
% Addition of a thorax model
%   INPUT
%   - Human_model: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Mass: mass of the solids
%   - AttachmentPoint: name of the attachment point of the model on the
%   already existing model (character string)
%   OUTPUT
%   - Human_model: new osteo-articular model (see the Documentation
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
%% Solid list

list_solid={'Clavicle_J1' 'Clavicle_J2' 'Clavicle' 'AcromioClavicular_J1' 'AcromioClavicular_J2' 'AcromioClavicular_J3'};

%% Choix jambe droite ou gauche
if Side == 'R'
    Mirror=[1 0 0; 0 1 0; 0 0 1];
    Sign=1;
    Cote='D';
    FullSide='Right';
elseif Side == 'L'
    Mirror=[1 0 0; 0 1 0; 0 0 -1];
    Sign=-1;
    Cote='G';
    FullSide='Left';
end

%% Solid numbering incremation

s=size(Human_model,2)+1;  %#ok<NASGU> % num�ro du premier solide
for i=1:size(list_solid,2)      % num�rotation de chaque solide : s_"nom du solide"
    if i==1
        eval(strcat('s_',list_solid{i},'=s;'))
    else
        eval(strcat('s_',list_solid{i},'=s_',list_solid{i-1},'+1;'))
    end
end

% find the number of the mother from the attachment point: 'attachment_pt'
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
    if Human_model(s_mother).child == 0      % si la m�re n'a pas d'enfant
        Human_model(s_mother).child = eval(['s_' list_solid{1}]);    % l'enfant de cette m�re est ce solide
    else
        [Human_model]=sister_actualize(Human_model,Human_model(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la derni�re soeur
    end
end

%%                     Definition of anatomical landmarks

% ------------------------- Thorax ----------------------------------------
% scaling coef based on shoulder width

CoM_Thorax = k*[0.060 0.303 0];
Thorax_T12L1JointNode = k*[0.022 0.154 0] - CoM_Thorax;
Thorax_ShoulderRightNode=k*[-0.0408 0.1099 0.1929]-Thorax_T12L1JointNode;
Thorax_osim2antoine = [k k Thorax_ShoulderRightNode(3)/0.17];

% ------------------------ Clavicle ---------------------------------------
% Center of mass location with respect to the reference frame
CoM_Clavicle = Thorax_osim2antoine.*Mirror*[-0.011096 0.0063723 0.054168]';
% Node locations in CusToM frame
Clavicle_acJointNode = Thorax_osim2antoine.*Mirror*[-0.02924 0.02024 0.12005]' - CoM_Clavicle;
Clavicle_scJointNode = Thorax_osim2antoine.*Mirror*[0 0 0]' - CoM_Clavicle;
% Clavicle_marker_set1 = Thorax_osim2antoine.*Mirror*[0.005 0.02 0.07]';
Clavicle_marker_set1 = Thorax_osim2antoine.*Mirror*[0.0147438 0.0128003 0.0544239]'-CoM_Clavicle;


%----------------- Scapula -------------------------------------------
Scapula_acJointNode = Thorax_osim2antoine.*Mirror*[-0.01357; 0.00011; -0.01523];

Scapula_position_set = {...

    % Muscles adapted from ArmMuscles
    [Side 'ShadowScapula_BicepsL_o'],Thorax_osim2antoine.*Mirror*([-0.03123;-0.02353;-0.01305])+Scapula_acJointNode;...
    [Side 'ShadowScapula_BicepsL_via1'],Thorax_osim2antoine.*Mirror*([-0.02094;-0.01309;-0.00461])+Scapula_acJointNode;...
    [Side 'ShadowScapula_BicepsS_o'],Thorax_osim2antoine.*Mirror*([0.01268;-0.03931;-0.02625])+Scapula_acJointNode;...
    [Side 'ShadowScapula_BicepsS_via1'],Thorax_osim2antoine.*Mirror*([0.00093;-0.06704;-0.01593])+Scapula_acJointNode;...
    [Side 'ShadowScapula_Triceps_o'],Thorax_osim2antoine.*Mirror*([-0.04565;-0.04073;-0.01377])+Scapula_acJointNode;...
    
    % Muscles adapted from (Puchaud et al. 2019)
    [Side 'ShadowScapula_DELT1-P3'],Thorax_osim2antoine.*Mirror*([0.04347;-0.03252;0.00099])+Scapula_acJointNode;...
    [Side 'ShadowScapula_DELT2-P3'],Thorax_osim2antoine.*Mirror*([5e-05;0.00294;0.02233])+Scapula_acJointNode;...
    [Side 'ShadowScapula_DELT2-P4'],Thorax_osim2antoine.*Mirror*([-0.0577 -0.0069 -0.0272]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_DELT3-P1'],Thorax_osim2antoine.*Mirror*([-0.0160 0.0020 0.0078]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_DELT3-P2'],Thorax_osim2antoine.*Mirror*([-0.07247;-0.03285;0.01233])+Scapula_acJointNode;...
    [Side 'ShadowScapula_SUPSP-P2'],Thorax_osim2antoine.*Mirror*([-0.01918;0.00127;-0.01271])+Scapula_acJointNode;...
    [Side 'ShadowScapula_SUPSP-P3'],Thorax_osim2antoine.*Mirror*([-0.048993120109923384 0.0013557026203117424 -0.069247307314771744]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_SUPSP-P4'],Thorax_osim2antoine.*Mirror*([-0.060529648695612823 -0.0013800523081562756 -0.049452565861000421]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_INFSP-P2'],Thorax_osim2antoine.*Mirror*([-0.099069480462564738 -0.080853263486170973 -0.081261223309262887]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_INFSP-P3'],Thorax_osim2antoine.*Mirror*([-0.083429499432317811 -0.032271286292091625 -0.086879319969381641]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_SUBSC-P1'],Thorax_osim2antoine.*Mirror*([-0.095069431859492709 -0.097653948106590768 -0.085369758259368406]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_SUBSC-P2'],Thorax_osim2antoine.*Mirror*([-0.078789527055875025 -0.031271199112899918 -0.090268111570563608]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_SUBSC-P3'],Thorax_osim2antoine.*Mirror*([-0.078789527055875025 -0.031271199112899918 -0.090268111570563608]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_TMIN-P2'],Thorax_osim2antoine.*Mirror*([-0.09473;-0.07991;-0.04737])+Scapula_acJointNode;...
    [Side 'ShadowScapula_TMIN-P3'],Thorax_osim2antoine.*Mirror*([-0.09643;-0.08121;-0.05298])+Scapula_acJointNode;...
    [Side 'ShadowScapula_TMAJ-P2'],Thorax_osim2antoine.*Mirror*([-0.10264;-0.10319;-0.05829])+Scapula_acJointNode;...
    [Side 'ShadowScapula_TMAJ-P3'],Thorax_osim2antoine.*Mirror*([-0.10489;-0.10895;-0.07117])+Scapula_acJointNode;...
    [Side 'ShadowScapula_LAT1-P2'],Thorax_osim2antoine.*Mirror*([-0.07982;-0.079943;-0.02428])+Scapula_acJointNode;...
    [Side 'ShadowScapula_LAT1-P3'],Thorax_osim2antoine.*Mirror*([-0.11118;-0.089323;-0.06022])+Scapula_acJointNode;...
    [Side 'ShadowScapula_LAT2-P2'],Thorax_osim2antoine.*Mirror*([-0.07875;-0.097117;-0.02023])+Scapula_acJointNode;...
    [Side 'ShadowScapula_LAT2-P3'],Thorax_osim2antoine.*Mirror*([-0.10544;-0.12896;-0.064597])+Scapula_acJointNode;...
    [Side 'ShadowScapula_LAT3-P2'],Thorax_osim2antoine.*Mirror*([-0.06598;-0.12735;-0.024183])+Scapula_acJointNode;...
    [Side 'ShadowScapula_LAT3-P3'],Thorax_osim2antoine.*Mirror*([-0.10059;-0.16313;-0.059077])+Scapula_acJointNode;...
    [Side 'ShadowScapula_CORB-P1'],Thorax_osim2antoine.*Mirror*([0.0082682171668854807 -0.042434755999553653 -0.028091382979780092]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_CORB-P2'],Thorax_osim2antoine.*Mirror*([0.00483;-0.06958;-0.01563])+Scapula_acJointNode;...
    [Side 'ShadowScapula_trap_acr-P1'],Thorax_osim2antoine.*Mirror*([-0.02;0.0004;-0.0125])+Scapula_acJointNode;...
    [Side 'ShadowScapula_levator_scap-P1'],Thorax_osim2antoine.*Mirror*([-0.069;0.0062;-0.0938])+Scapula_acJointNode;...
    [Side 'ShadowScapula_trap_acr-P1'],Thorax_osim2antoine.*Mirror*([-0.02;0.0004;-0.0125])+Scapula_acJointNode;...
    [Side 'ShadowScapula_rhomboid_S-P2'],Thorax_osim2antoine.*Mirror*([-0.0827 -0.0229 -0.1017]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_rhomboid_I-P2'],Thorax_osim2antoine.*Mirror*([-0.1063 -0.1067 -0.0927]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_serr_ant_1-P1'],Thorax_osim2antoine.*Mirror*([-0.1135 -0.1122 -0.0855]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_serr_ant_2-P1'],Thorax_osim2antoine.*Mirror*([-0.1031 -0.0831 -0.0986]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_serr_ant_3-P1'],Thorax_osim2antoine.*Mirror*([-0.0485 0.0090 -0.0846]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_TrapeziusScapula_M-P2'],Thorax_osim2antoine.*Mirror*([-0.0582;-0.0020;-0.0363])+Scapula_acJointNode;...
    [Side 'ShadowScapula_TrapeziusScapula_S-P2'],Thorax_osim2antoine.*Mirror*([-0.0517;0.0069;-0.0244])+Scapula_acJointNode;...
    [Side 'ShadowScapula_TrapeziusScapula_I-P2'],Thorax_osim2antoine.*Mirror*([-0.0757;-0.0095;-0.0739])+Scapula_acJointNode;...
    [Side 'ShadowScapula_TeresMajor-P1'],Thorax_osim2antoine.*Mirror*([-0.10440887882290427 -0.11741549476967501 -0.072094492045888692]')+Scapula_acJointNode;...
    [Side 'ShadowScapula_TeresMinor-P1'],Thorax_osim2antoine.*Mirror*([-0.0844 ; -0.0661 ; -0.0423])+Scapula_acJointNode;...

    [Side 'ShadowScapula_r_PECM1'],Thorax_osim2antoine.*Mirror*([0.01087460399498133 -0.035041350780721695 -0.022940819603399599]')+Scapula_acJointNode;...
    
    % Via points from moment arm optimization
    
    [Side 'ShadowScapula_Rhomboideus_I_VP2'], k*Mirror*[-0.0203 ; -0.0141 ; 0.0030] + Scapula_acJointNode ;... 
    
    [Side 'ShadowScapula_DeltoideusScapula_P_VP1'], k*Mirror*[0.0021 ; 0.0068 ; 0.0720] + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_DeltoideusScapula_M_VP1'], k*Mirror*[0.0561 ; 0.0316 ; 0.0933] + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_TrapeziusScapula_M_VP2'], k*Mirror*[-0.0172 ; 0.0204 ; -0.0067]  + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_TrapeziusScapula_S_VP2'], k*Mirror*[-0.0141 ; 0.0147 ; -0.0028]+ Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_TrapeziusScapula_I_VP2'], k*Mirror*[-0.0163 ; 0.0325 ; -0.0073] + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_Supraspinatus_P_VP1'], k*Mirror*[-0.0040 ; 0.0398 ; 0.0115]  + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_Supraspinatus_A_VP1'], k*Mirror*[-0.0176 ; 0.0694 ; -0.0654] + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_Infraspinatus_I_VP1'], k*Mirror*[-0.0649 ; -0.0304 ; 0.0004] + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_Infraspinatus_S_VP1'], k*Mirror*[-0.0649 ; 0.0318 ; -0.0041]  + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_Coracobrachialis_VP1'], k*Mirror*[0.0691 ; -0.0039 ; 0.0345]+ Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_TeresMajor_VP1'], k*Mirror*[-0.0465 ; -0.0784 ; 0.0122] + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_TeresMinor_VP1'], k*Mirror*[-0.0292 ; -0.0290 ; 0.0193] + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_Subscapularis_I_VP1'], k*Mirror*[-0.0069 ; -0.0503 ; 0.0072] + Scapula_acJointNode ;...

    [Side 'ShadowScapula_Subscapularis_M_VP1'], k*Mirror*[-0.0393 ; -0.0928 ; -0.0652] + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_Subscapularis_S_VP1'], k*Mirror*[0.0272 ; -0.0259 ; 0.0133] + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_SerratusAnterior_M_VP2'], k*Mirror*[-0.0373 ; -0.0060 ; 0.0286] + Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_SerratusAnterior_I_VP2'], k*Mirror*[-0.0379 ; -0.0112 ; 0.0328]+ Scapula_acJointNode ;...
    
    [Side 'ShadowScapula_PectoralisMinor_VP2'], k*Mirror*[-0.0223 ; -0.0027 ; 0.0027] + Scapula_acJointNode ;...

    [Side 'ShadowScapula_PectoralisMajorThorax_I_VP2'], k*Mirror*[0.0003 ; -0.0154 ; -0.0084] + Scapula_acJointNode ;... 
    [Side 'ShadowScapula_PectoralisMajorThorax_I_VP3'], k*Mirror*[0.0532 ; -0.0066 ; 0.0709] + Scapula_acJointNode ;... *
    
    [Side 'ShadowScapula_PectoralisMajorThorax_M_VP2'], k*Mirror*[0.0100 ; -0.0011 ; -0.0044] + Scapula_acJointNode ;... 
    [Side 'ShadowScapula_PectoralisMajorThorax_M_VP3'], k*Mirror*[0.0543 ; -0.0166 ; 0.0616] + Scapula_acJointNode ;... 
    
    [Side 'ShadowScapula_LatissimusDorsi_S_VP2'], k*Mirror*[0.0112 ; 0.0143 ; -0.0236] + Scapula_acJointNode ;... 
    [Side 'ShadowScapula_LatissimusDorsi_S_VP3'], k*Mirror*[0.0552 ; 0.0065 ; 0.0666] + Scapula_acJointNode ;... 
    
    [Side 'ShadowScapula_LatissimusDorsi_I_VP2'], k*Mirror*[0.0177 ; 0.0144 ; -0.0240] + Scapula_acJointNode ;... 
    [Side 'ShadowScapula_LatissimusDorsi_I_VP3'], k*Mirror*[0.0593 ; 0.0153 ; 0.0624] + Scapula_acJointNode ;... 
    
    [Side 'ShadowScapula_DeltoideusClavicle-P2'],Thorax_osim2antoine.*Mirror*([0.019562226742916928 -0.0065870855556006396 0.01039769231874158]')+Scapula_acJointNode;...

        



};

%% Definition of anatomical landmarks (with respect to the center of mass of the solid)

Clavicle_position_set= {...
    % Markers
    ['CLAV' Cote], Clavicle_marker_set1; ...
    % Joint Nodes
    [Side 'Clavicle_AcromioClavicularJointNode'], Clavicle_acJointNode;...
    % Muscle paths
    [Side 'clavicle_r_DELT1_r-P4'],Thorax_osim2antoine.*Mirror*([-0.014;0.01106;0.08021])-CoM_Clavicle;...
    [Side 'clavicle_r_PECM1_r-P4'],Thorax_osim2antoine.*Mirror*([0.00321;-0.00013;0.05113])-CoM_Clavicle;...
    [Side 'clavicle_r_cleid_mast_r-P1'],Thorax_osim2antoine.*Mirror*([0.0022;0.0043;0.0257])-CoM_Clavicle;...
    [Side 'clavicle_r_cleid_occ_r-P1'],Thorax_osim2antoine.*Mirror*([0.0022;0.0043;0.0257])-CoM_Clavicle;...
    [Side 'clavicle_r_trap_cl_r-P1'],Thorax_osim2antoine.*Mirror*([-0.0171;0.019;0.0727])-CoM_Clavicle;...
    [Side 'Clavicle_TrapeziusClavicle_S-P2'],Thorax_osim2antoine.*Mirror*([-0.0301;0.0249;0.0910])-CoM_Clavicle;...
    [Side 'Clavicle_TrapeziusClavicle_S_VP2'],Thorax_osim2antoine.*Mirror*([-0.0168 ; 0.0061 ; 0.1032])-CoM_Clavicle;...

    [Side 'Clavicle_DeltoideusClavicle-P1'],Thorax_osim2antoine.*Mirror*([-0.022762490803495135 0.019491266287305724 0.084093007753211754]')-CoM_Clavicle;...
    [Side 'Clavicle_PectoralisMajorClavicle1-P1'],Thorax_osim2antoine.*Mirror*([0.0045991607738268781 0.0068185965088977942 0.04738913830637137]')-CoM_Clavicle;...
    
    
    };

%% Scaling inertial parameters

% Generic Inertia extraced from (Klein Breteler et al. 1999)
Clavicle_Mass_generic=0.156;
I_clavicle_generic=[0.00024259 0.00025526 0.00004442 -0.00001898 Sign*-0.00006994 Sign*0.00005371];
I_clavicle=(norm(Thorax_osim2antoine)^2*Mass.Clavicle_Mass/Clavicle_Mass_generic).*I_clavicle_generic;

%% "Human_model" structure generation
 
num_solid=0;
% Clavicle_J1
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
Human_model(incr_solid).name=[Side name];               % solid name
Human_model(incr_solid).sister=0;              
Human_model(incr_solid).child=s_Clavicle_J2;                   
Human_model(incr_solid).mother=s_mother;           
Human_model(incr_solid).a=[0 1 0]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi/6;
Human_model(incr_solid).limit_sup=pi/6;
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).m=0;                 
Human_model(incr_solid).b=pos_attachment_pt;  
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';
if Sign==1
    Human_model(incr_solid).comment='Right Clavicle Protraction(+)/Retraction(-)';
    Human_model(incr_solid).FunctionalAngle='Right Clavicle Protraction(+)/Retraction(-)';
else
    Human_model(incr_solid).comment='Left Clavicle Protraction(-)/Retraction(+)';
    Human_model(incr_solid).FunctionalAngle='Left Clavicle Protraction(-)/Retraction(+)';
end

% Clavicle_J2
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
Human_model(incr_solid).name=[Side name];               % solid name
Human_model(incr_solid).sister=0;              
Human_model(incr_solid).child=s_Clavicle;                   
Human_model(incr_solid).mother=s_Clavicle_J1;           
Human_model(incr_solid).a=[1 0 0]';
Human_model(incr_solid).joint=1;
if Sign==1
    Human_model(incr_solid).limit_inf=-pi/4;
    Human_model(incr_solid).limit_sup=0.2;
    Human_model(incr_solid).comment='Right Clavicle Depression(+)/Elevation(-)';
    Human_model(incr_solid).FunctionalAngle='Right Clavicle Depression(+)/Elevation(-)';
else
    Human_model(incr_solid).limit_inf=-0.2;
    Human_model(incr_solid).limit_sup=pi/4;
    Human_model(incr_solid).comment='Left Clavicle Depression(-)/Elevation(+)';
    Human_model(incr_solid).FunctionalAngle='Left Clavicle Depression(-)/Elevation(+)';
end
Human_model(incr_solid).limit_inf=-pi/2;
Human_model(incr_solid).limit_sup=pi/2;
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).m=0;                 
Human_model(incr_solid).b=[0 0 0]';  
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';


% Clavicle
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
Human_model(incr_solid).name=[Side name];               % solid name
Human_model(incr_solid).sister=0;                
Human_model(incr_solid).child=s_AcromioClavicular_J1;                   
Human_model(incr_solid).mother=s_Clavicle_J2;           
Human_model(incr_solid).a=[0 0 1]';    
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi/4;
Human_model(incr_solid).limit_sup=pi/4;
Human_model(incr_solid).Visual=1;
Human_model(incr_solid).calib_k_constraint=[];
Human_model(incr_solid).m=Mass.Clavicle_Mass;                 
Human_model(incr_solid).b=[0 0 0]';  
Human_model(incr_solid).I=[I_clavicle(1) I_clavicle(4) I_clavicle(5); I_clavicle(4) I_clavicle(2) I_clavicle(6); I_clavicle(5) I_clavicle(6) I_clavicle(3)];
Human_model(incr_solid).c=-Clavicle_scJointNode;
Human_model(incr_solid).anat_position=Clavicle_position_set;
Human_model(incr_solid).visual_file = ['Holzbaur/clavicle_' lower(Side) '.mat'];
Human_model(incr_solid).comment=[FullSide 'Clavicle Axial Rotation Forward(-)/Backward(+)'];
Human_model(incr_solid).FunctionalAngle=[FullSide 'Clavicle Axial Rotation Forward(-)/Backward(+)'];
Human_model(incr_solid).density=1.04; %kg.L-1

% AcromioClavicular_J1
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
Human_model(incr_solid).name=[Side name];          % solid name with side
Human_model(incr_solid).sister=0;                   % Solid's sister
Human_model(incr_solid).child=s_AcromioClavicular_J2;         % Solid's child
Human_model(incr_solid).mother=s_Clavicle;            % Solid's mother
Human_model(incr_solid).a=[0 1 0]';                          
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi;
Human_model(incr_solid).limit_sup=pi;
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).m=0;                        % Reference mass
Human_model(incr_solid).b=Clavicle_acJointNode-Clavicle_scJointNode;        % Attachment point position in mother's frame
Human_model(incr_solid).I=zeros(3,3);               % Reference inertia matrix
Human_model(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
Human_model(incr_solid).calib_k_constraint=[];
Human_model(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
Human_model(incr_solid).theta=[];
Human_model(incr_solid).KinematicsCut=[];           % kinematic cut
Human_model(incr_solid).linear_constraint=[];
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).comment='to be completed';
Human_model(incr_solid).FunctionalAngle=[Side name];


% AcromioClavicular_J2
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
Human_model(incr_solid).name=[Side name];          % solid name with side
Human_model(incr_solid).sister=0;                   % Solid's sister
Human_model(incr_solid).child=s_AcromioClavicular_J3;            % Solid's child
Human_model(incr_solid).mother=s_AcromioClavicular_J1;            % Solid's mother
Human_model(incr_solid).a=[1 0 0]';                          
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi;
Human_model(incr_solid).limit_sup=pi;
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).m=0;                        % Reference mass
Human_model(incr_solid).b=[0 0 0]';        % Attachment point position in mother's frame
Human_model(incr_solid).I=zeros(3,3);               % Reference inertia matrix
Human_model(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
Human_model(incr_solid).calib_k_constraint=[];
Human_model(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
Human_model(incr_solid).theta=[];
Human_model(incr_solid).KinematicsCut=[];           % kinematic cut
Human_model(incr_solid).linear_constraint=[];
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).comment='to be completed';
Human_model(incr_solid).FunctionalAngle=[Side name];


% AcromioClavicular_J3
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
Human_model(incr_solid).name=[Side name];          % solid name with side
Human_model(incr_solid).sister=0;                   % Solid's sister
Human_model(incr_solid).child=0;         % Solid's child
Human_model(incr_solid).mother=s_AcromioClavicular_J2;            % Solid's mother
Human_model(incr_solid).a=[0 0 1]';                          
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi;
Human_model(incr_solid).limit_sup=pi;
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).m=0;        % Reference mass
Human_model(incr_solid).b=[0 0 0]';        % Attachment point position in mother's frame
Human_model(incr_solid).I=zeros(3,3);               % Reference inertia matrix
Human_model(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
Human_model(incr_solid).calib_k_constraint=[];
Human_model(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
Human_model(incr_solid).theta=[];
Human_model(incr_solid).KinematicsCut=[];           % kinematic cut
Human_model(incr_solid).ClosedLoop=[Side 'Scapula_AcromioClavicularJointNode'];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
Human_model(incr_solid).linear_constraint=[];
Human_model(incr_solid).Visual=1;
Human_model(incr_solid).comment='to be completed';
Human_model(incr_solid).FunctionalAngle=[Side name];
Human_model(incr_solid).anat_position=Scapula_position_set;

end

