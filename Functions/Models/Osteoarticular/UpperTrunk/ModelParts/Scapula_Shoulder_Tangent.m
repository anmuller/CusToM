function [Human_model]= Scapula_Shoulder_Tangent(Human_model,k,Mass,Side,AttachmentPoint,varargin)
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

list_solid={'ScapuloThoracic_J0' 'ScapuloThoracic_J1' 'ScapuloThoracic_J2' 'ScapuloThoracic_J3' 'ScapuloThoracic_J4' 'ScapuloThoracic_J5' 'ScapuloThoracic_Jalpha' 'ScapuloThoracic_J6' 'Scapula'};

%% Choix jambe droite ou gauche
if Side == 'R'
    Mirror=[1 0 0; 0 1 0; 0 0 1];
    Sign=1;
    Cote='D';
    FullSide='Right';
else
    if Side == 'L'
        Mirror=[1 0 0; 0 1 0; 0 0 -1];
        Sign=-1;
        Cote='G';
        FullSide='Left';
    end
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
CoM_Thorax               = k*[0.060 0.303 0];
Thorax_T12L1JointNode    = k*[0.022 0.154 0] - CoM_Thorax;
Thorax_ShoulderRightNode = k*[-0.0408 0.1099 0.1929]-Thorax_T12L1JointNode;
Thorax_osim2antoine      = [k k Thorax_ShoulderRightNode(3)/0.17]; 

% ------------------------ Scapula ----------------------------------------
% Centre of mass location in OpenSim frame
Scapula_CoM = Thorax_osim2antoine.*Mirror*[-0.054694 -0.035032 -0.043734]';
% Landmarks location in CusToM frame
Scapula_ghJointNode = Thorax_osim2antoine.*Mirror*[-0.00955; -0.034; 0.009] - Scapula_CoM;
Scapula_stJointNode = Thorax_osim2antoine.*Mirror*[-0.05982; -0.03904; -0.056] - Scapula_CoM;
Scapula_acJointNode = Thorax_osim2antoine.*Mirror*[-0.01357; 0.00011; -0.01523] - Scapula_CoM;
Scapula_acromion    = Thorax_osim2antoine.*Mirror*[-0.0142761 0.0131922 -0.00563961]' - Scapula_CoM;
Scapula_cluster_med = Thorax_osim2antoine.*Mirror*[-0.0860033 0.0298369 -0.00786593]' - Scapula_CoM;
Scapula_cluster_lat = Thorax_osim2antoine.*Mirror*[-0.0956621 0.0398035 -0.0552027]' - Scapula_CoM;
Scapula_cluster_mid = Thorax_osim2antoine.*Mirror*[-0.119492 0.0147336 -0.0385808]' - Scapula_CoM;
Scapula_locator_AI  = Thorax_osim2antoine.*Mirror*[-0.109351 -0.1132 -0.0903848]' - Scapula_CoM;
Scapula_locator_TS  = Thorax_osim2antoine.*Mirror*[-0.0874576 -0.0120416 -0.098654]' - Scapula_CoM;
Scapula_locator_AA  = Thorax_osim2antoine.*Mirror*[-0.0393614 -0.00318483 0.0080672]' - Scapula_CoM;
Thorax_Rx           = Thorax_osim2antoine(1)*0.07;
Thorax_Ry           = Thorax_osim2antoine(2)*0.15;
Thorax_Rz           = Thorax_osim2antoine(3)*0.07;

%% Definition of anatomical landmarThorax_osim2antoine.s (with respect to the center of mass of the solid)

Scapula_position_set = {...
    % Joint Nodes
    [Side 'Scapula_AcromioClavicularJointNode'], Scapula_acJointNode;...
    ['Thorax_Shoulder' FullSide 'Node'], Scapula_ghJointNode;...
    % MarThorax_osim2antoine.ers
    [Side 'SHO'], Scapula_acromion;...
    ['MTAC' Cote 'M'], Scapula_cluster_med;...
    ['MTAC' Cote 'B'], Scapula_cluster_mid;...
    ['MTAC' Cote 'L'], Scapula_cluster_lat;...
    'ThoracicEllipsoid_radius', [Thorax_Rx Thorax_Ry Thorax_Rz]';...
    % Muscle paths
    
    % Muscles adapted from ArmMuscles
    [Side 'Scapula_BicepsL_o'],Thorax_osim2antoine.*Mirror*([-0.03123;-0.02353;-0.01305])-Scapula_CoM;...
    [Side 'Scapula_BicepsL_via1'],Thorax_osim2antoine.*Mirror*([-0.02094;-0.01309;-0.00461])-Scapula_CoM;...
    [Side 'Scapula_BicepsS_o'],Thorax_osim2antoine.*Mirror*([0.01268;-0.03931;-0.02625])-Scapula_CoM;...
    [Side 'Scapula_BicepsS_via1'],Thorax_osim2antoine.*Mirror*([0.00093;-0.06704;-0.01593])-Scapula_CoM;...
    [Side 'Scapula_Triceps_o'],Thorax_osim2antoine.*Mirror*([-0.04565;-0.04073;-0.01377])-Scapula_CoM;...
    
    % Muscles adapted from (Puchaud et al. 2019)
    [Side 'Scapula_DELT1-P3'],Thorax_osim2antoine.*Mirror*([0.04347;-0.03252;0.00099])-Scapula_CoM;...
    [Side 'Scapula_DELT2-P3'],Thorax_osim2antoine.*Mirror*([5e-05;0.00294;0.02233])-Scapula_CoM;...
    [Side 'Scapula_DELT2-P4'],Thorax_osim2antoine.*Mirror*([-0.0577 -0.0069 -0.0272]')-Scapula_CoM;...
    [Side 'Scapula_DELT3-P1'],Thorax_osim2antoine.*Mirror*([-0.0160 0.0020 0.0078]')-Scapula_CoM;...
    [Side 'Scapula_DELT3-P2'],Thorax_osim2antoine.*Mirror*([-0.07247;-0.03285;0.01233])-Scapula_CoM;...
    [Side 'Scapula_SUPSP-P2'],Thorax_osim2antoine.*Mirror*([-0.01918;0.00127;-0.01271])-Scapula_CoM;...
    [Side 'Scapula_SUPSP-P3'],Thorax_osim2antoine.*Mirror*([-0.048993120109923384 0.0013557026203117424 -0.069247307314771744]')-Scapula_CoM;...
    [Side 'Scapula_SUPSP-P4'],Thorax_osim2antoine.*Mirror*([-0.060529648695612823 -0.0013800523081562756 -0.049452565861000421]')-Scapula_CoM;...
    [Side 'Scapula_INFSP-P2'],Thorax_osim2antoine.*Mirror*([-0.099069480462564738 -0.080853263486170973 -0.081261223309262887]')-Scapula_CoM;...
    [Side 'Scapula_INFSP-P3'],Thorax_osim2antoine.*Mirror*([-0.083429499432317811 -0.032271286292091625 -0.086879319969381641]')-Scapula_CoM;...
    [Side 'Scapula_SUBSC-P1'],Thorax_osim2antoine.*Mirror*([-0.095069431859492709 -0.097653948106590768 -0.085369758259368406]')-Scapula_CoM;...
    [Side 'Scapula_SUBSC-P2'],Thorax_osim2antoine.*Mirror*([-0.078789527055875025 -0.031271199112899918 -0.090268111570563608]')-Scapula_CoM;...
    [Side 'Scapula_SUBSC-P3'],Thorax_osim2antoine.*Mirror*([-0.078789527055875025 -0.031271199112899918 -0.090268111570563608]')-Scapula_CoM;...
    [Side 'Scapula_TMIN-P2'],Thorax_osim2antoine.*Mirror*([-0.09473;-0.07991;-0.04737])-Scapula_CoM;...
    [Side 'Scapula_TMIN-P3'],Thorax_osim2antoine.*Mirror*([-0.09643;-0.08121;-0.05298])-Scapula_CoM;...
    [Side 'Scapula_TMAJ-P2'],Thorax_osim2antoine.*Mirror*([-0.10264;-0.10319;-0.05829])-Scapula_CoM;...
    [Side 'Scapula_TMAJ-P3'],Thorax_osim2antoine.*Mirror*([-0.10489;-0.10895;-0.07117])-Scapula_CoM;...
    [Side 'Scapula_LAT1-P2'],Thorax_osim2antoine.*Mirror*([-0.07982;-0.079943;-0.02428])-Scapula_CoM;...
    [Side 'Scapula_LAT1-P3'],Thorax_osim2antoine.*Mirror*([-0.11118;-0.089323;-0.06022])-Scapula_CoM;...
    [Side 'Scapula_LAT2-P2'],Thorax_osim2antoine.*Mirror*([-0.07875;-0.097117;-0.02023])-Scapula_CoM;...
    [Side 'Scapula_LAT2-P3'],Thorax_osim2antoine.*Mirror*([-0.10544;-0.12896;-0.064597])-Scapula_CoM;...
    [Side 'Scapula_LAT3-P2'],Thorax_osim2antoine.*Mirror*([-0.06598;-0.12735;-0.024183])-Scapula_CoM;...
    [Side 'Scapula_LAT3-P3'],Thorax_osim2antoine.*Mirror*([-0.10059;-0.16313;-0.059077])-Scapula_CoM;...
    [Side 'Scapula_CORB-P1'],Thorax_osim2antoine.*Mirror*([0.0082682171668854807 -0.042434755999553653 -0.028091382979780092]')-Scapula_CoM;...
    [Side 'Scapula_CORB-P2'],Thorax_osim2antoine.*Mirror*([0.00483;-0.06958;-0.01563])-Scapula_CoM;...
    [Side 'Scapula_trap_acr-P1'],Thorax_osim2antoine.*Mirror*([-0.02;0.0004;-0.0125])-Scapula_CoM;...
    [Side 'Scapula_levator_scap-P1'],Thorax_osim2antoine.*Mirror*([-0.069;0.0062;-0.0938])-Scapula_CoM;...
    [Side 'Scapula_trap_acr-P1'],Thorax_osim2antoine.*Mirror*([-0.02;0.0004;-0.0125])-Scapula_CoM;...
    [Side 'Scapula_rhomboid_S-P2'],Thorax_osim2antoine.*Mirror*([-0.0827 -0.0229 -0.1017]')-Scapula_CoM;...
    [Side 'Scapula_rhomboid_I-P2'],Thorax_osim2antoine.*Mirror*([-0.1063 -0.1067 -0.0927]')-Scapula_CoM;...
    [Side 'Scapula_serr_ant_1-P1'],Thorax_osim2antoine.*Mirror*([-0.1135 -0.1122 -0.0855]')-Scapula_CoM;...
    [Side 'Scapula_serr_ant_2-P1'],Thorax_osim2antoine.*Mirror*([-0.1031 -0.0831 -0.0986]')-Scapula_CoM;...
    [Side 'Scapula_serr_ant_3-P1'],Thorax_osim2antoine.*Mirror*([-0.0485 0.0090 -0.0846]')-Scapula_CoM;...
    [Side 'Scapula_TrapeziusScapula_M-P2'],Thorax_osim2antoine.*Mirror*([-0.0582;-0.0020;-0.0363])-Scapula_CoM;...
    [Side 'Scapula_TrapeziusScapula_S-P2'],Thorax_osim2antoine.*Mirror*([-0.0517;0.0069;-0.0244])-Scapula_CoM;...
    [Side 'Scapula_TrapeziusScapula_I-P2'],Thorax_osim2antoine.*Mirror*([-0.0757;-0.0095;-0.0739])-Scapula_CoM;...
    [Side 'Scapula_TeresMajor-P1'],Thorax_osim2antoine.*Mirror*([-0.10440887882290427 -0.11741549476967501 -0.072094492045888692]')-Scapula_CoM;...
    [Side 'Scapula_TeresMinor-P1'],Thorax_osim2antoine.*Mirror*([-0.0844 ; -0.0661 ; -0.0423])-Scapula_CoM;...

    [Side 'Scapula_r_PECM1'],Thorax_osim2antoine.*Mirror*([0.01087460399498133 -0.035041350780721695 -0.022940819603399599]')-Scapula_CoM;...
    
    
    
    };
    
if ~isempty(varargin)
    Scapulalocator = varargin{1};
    Scapulalocator = Scapulalocator{1, 1};
    if Scapulalocator.active
        if ~isempty(find(strcmp(Scapulalocator.side,Side),1))
            vec_1 = Scapula_locator_AA - Scapula_locator_AI;
            vec_2 = Scapula_locator_TS - Scapula_locator_AI;
            normal= Sign*cross(vec_1,vec_2)/norm(cross(vec_1,vec_2));
            ind = find(strcmp(Scapulalocator.side,Side),1);
            Scapula_locator_AA = Scapula_locator_AA + Scapulalocator.height(ind)*normal*1e-2;
            Scapula_locator_AI = Scapula_locator_AI + Scapulalocator.height(ind)*normal*1e-2;
            Scapula_locator_TS = Scapula_locator_TS + Scapulalocator.height(ind)*normal*1e-2;
            
            Scapula_position_set =  [Scapula_position_set ; ...
            {['ScapLoc_AA_' Side]}, {Scapula_locator_AA};...
            {['ScapLoc_AI_' Side]}, {Scapula_locator_AI};...
            {['ScapLoc_TS_' Side]}, {Scapula_locator_TS};...
            ];
            
        end
    end
end



%%                     Scaling inertial parameters

% Generic Inertia extraced from (Klein Breteler et al. 1999)
Scapula_Mass_generic=0.70396;
I_Scapula_generic=[0.0012429 0.0011504 0.0013651 0.0004494 Sign*0.00040922 Sign*0.0002411];
I_Scapula=(norm(Thorax_osim2antoine)^2*Mass.Scapula_Mass/Scapula_Mass_generic)*I_Scapula_generic;

%% "Human_model" structure generation
 
num_solid=0;
%% Scapulo-thoracic joint



syms phi lambda real% latitude longitude
x= Thorax_Rx*sin(lambda);

y= -Thorax_Ry*sin(phi)*cos(lambda);


z= Mirror(3,3)*Thorax_Rz*cos(phi)*cos(lambda);

PHI = atan((Thorax_Rz*Thorax_Ry*tan(lambda)*(1 - tan(phi)^2))/(Thorax_Rx*Thorax_Ry-Thorax_Rx*Thorax_Rz*tan(phi)^2));

ALPHA = atan( tan(phi)*(Thorax_Rz*(1 - tan(phi)^2)/(Thorax_Ry- Thorax_Rz*tan(phi)^2) -1));
                                                                                                                                                


% ScapuloThoracic_J0 : theta_2
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
Human_model(incr_solid).name=[Side name];          % solid name with side
Human_model(incr_solid).sister=s_ScapuloThoracic_J1;                   % Solid's sister
Human_model(incr_solid).child=0;         % Solid's child
Human_model(incr_solid).mother=s_mother;            % Solid's mother
Human_model(incr_solid).a=[1 0 0]';                          
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-Inf;
Human_model(incr_solid).limit_sup=Inf;
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).m=0;                        % Reference mass
Human_model(incr_solid).b=[0 0 0]';          % Attachment point position in mother's frame
Human_model(incr_solid).I=zeros(3,3);               % Reference inertia matrix
Human_model(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
Human_model(incr_solid).calib_k_constraint=[];
Human_model(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
Human_model(incr_solid).theta=[];
Human_model(incr_solid).KinematicsCut=[];           % kinematic cut
Human_model(incr_solid).linear_constraint=[];
Human_model(incr_solid).Visual=0;



% ScapuloThoracic_J1
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
Human_model(incr_solid).name=[Side name];          % solid name with side
Human_model(incr_solid).sister=0;                   % Solid's sister
Human_model(incr_solid).child=s_ScapuloThoracic_J2;         % Solid's child
Human_model(incr_solid).mother=s_mother;            % Solid's mother
Human_model(incr_solid).a=[1 0 0]';                          
Human_model(incr_solid).joint=2;
Human_model(incr_solid).limit_inf=-Inf;
Human_model(incr_solid).limit_sup=Inf;
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).m=0;                        % Reference mass
Human_model(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
Human_model(incr_solid).I=zeros(3,3);               % Reference inertia matrix
Human_model(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
Human_model(incr_solid).calib_k_constraint=[];
Human_model(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
Human_model(incr_solid).theta=[];
Human_model(incr_solid).KinematicsCut=[];           % kinematic cut
Human_model(incr_solid).linear_constraint=[];
Human_model(incr_solid).Visual=0;
% Dependancy
Human_model(incr_solid).kinematic_dependancy.active=1;
Human_model(incr_solid).kinematic_dependancy.Joint=[incr_solid-1]; % Thoracicellips
% Kinematic dependancy function
f_tx = matlabFunction( x,'vars',{lambda});
Human_model(incr_solid).kinematic_dependancy.q=f_tx;
Human_model(incr_solid).comment='scapulothoracic x regression';
Human_model(incr_solid).FunctionalAngle=[name];

% ScapuloThoracic_J2
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
Human_model(incr_solid).name=[Side name];          % solid name with side
Human_model(incr_solid).sister=0;                   % Solid's sister
Human_model(incr_solid).child=s_ScapuloThoracic_J3;         % Solid's child
Human_model(incr_solid).mother=s_ScapuloThoracic_J1;            % Solid's mother
Human_model(incr_solid).a=[0 1 0]';                          
Human_model(incr_solid).joint=2;
Human_model(incr_solid).limit_inf=-Inf;
Human_model(incr_solid).limit_sup=Inf;
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
Human_model(incr_solid).comment='scapulothoracic y regression';
Human_model(incr_solid).FunctionalAngle=[name];
% Dependancy
Human_model(incr_solid).kinematic_dependancy.active=1;
Human_model(incr_solid).kinematic_dependancy.Joint=[incr_solid+2; incr_solid-2]; % Thoracicellips
% Kinematic dependancy function
f_ty = matlabFunction(y,'vars',{phi,lambda});
Human_model(incr_solid).kinematic_dependancy.q=f_ty;

% ScapuloThoracic_J3
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
Human_model(incr_solid).name=[Side name];          % solid name with side
Human_model(incr_solid).sister=0;                   % Solid's sister
Human_model(incr_solid).child=s_ScapuloThoracic_J4;         % Solid's child
Human_model(incr_solid).mother=s_ScapuloThoracic_J2;            % Solid's mother
Human_model(incr_solid).a=[0 0 1]';                          
Human_model(incr_solid).joint=2;
Human_model(incr_solid).limit_inf=-Inf;
Human_model(incr_solid).limit_sup=Inf;
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
Human_model(incr_solid).FunctionalAngle=[name];
Human_model(incr_solid).comment='scapulothoracic z regression';
% Dependancy
Human_model(incr_solid).kinematic_dependancy.active=1;
Human_model(incr_solid).kinematic_dependancy.Joint=[incr_solid+1; incr_solid-3]; % Thoracicellips
% Kinematic dependancy function
f_tz = matlabFunction(z,'vars',{phi,lambda});
Human_model(incr_solid).kinematic_dependancy.q=f_tz;

% ScapuloThoracic_J4
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
Human_model(incr_solid).name=[Side name];          % solid name with side
Human_model(incr_solid).sister=0;                   % Solid's sister
Human_model(incr_solid).child=s_ScapuloThoracic_J5;         % Solid's child
Human_model(incr_solid).mother=s_ScapuloThoracic_J3;            % Solid's mother
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
Human_model(incr_solid).FunctionalAngle=[name];
Human_model(incr_solid).comment='Scapula abduction - adduction';


% ScapuloThoracic_J5
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
Human_model(incr_solid).name=[Side name];          % solid name with side
Human_model(incr_solid).sister=0;                   % Solid's sister
Human_model(incr_solid).child=s_ScapuloThoracic_Jalpha;         % Solid's child
Human_model(incr_solid).mother=s_ScapuloThoracic_J4;            % Solid's mother
Human_model(incr_solid).a=[0 1 0]';                          
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi/2;
Human_model(incr_solid).limit_sup=pi/2;
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
Human_model(incr_solid).FunctionalAngle=[name];
Human_model(incr_solid).comment='Scapula elevation - depression';
% Dependancy
Human_model(incr_solid).kinematic_dependancy.active=1;
Human_model(incr_solid).kinematic_dependancy.Joint=[incr_solid-1; incr_solid-5]; % Thoracicellips
% Kinematic dependancy function
Ft_PHI= matlabFunction(PHI,'vars',{phi,lambda});
Human_model(incr_solid).kinematic_dependancy.q=Ft_PHI;


% ScapuloThoracic_alpha_tangence
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
Human_model(incr_solid).name=[Side name];          % solid name with side
Human_model(incr_solid).sister=0;                   % Solid's sister
Human_model(incr_solid).child=s_ScapuloThoracic_J6;         % Solid's child
Human_model(incr_solid).mother=s_ScapuloThoracic_J5;            % Solid's mother
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
Human_model(incr_solid).comment='Scapula tangency angle';
Human_model(incr_solid).FunctionalAngle=[name];
% Dependancy
Human_model(incr_solid).kinematic_dependancy.active=1;
Human_model(incr_solid).kinematic_dependancy.Joint=[incr_solid-2]; % Thoracicellips
% Kinematic dependancy function
Ft_ALPHA= matlabFunction(ALPHA,'vars',{phi});
Human_model(incr_solid).kinematic_dependancy.q=Ft_ALPHA;


% ScapuloThoracic_J6
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
Human_model(incr_solid).name=[Side name];          % solid name with side
Human_model(incr_solid).sister=0;                   % Solid's sister
Human_model(incr_solid).child=s_Scapula;         % Solid's child
Human_model(incr_solid).mother=s_ScapuloThoracic_Jalpha;            % Solid's mother
Human_model(incr_solid).a=[0 0 1]';                          
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi/2;
Human_model(incr_solid).limit_sup=pi/2;
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
Human_model(incr_solid).comment='Scapula upward rotation';
Human_model(incr_solid).FunctionalAngle=[name];

% Scapula
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
Human_model(incr_solid).name=[Side name];          % solid name with side
Human_model(incr_solid).sister=0;                   % Solid's sister
Human_model(incr_solid).child=0;         % Solid's child
Human_model(incr_solid).mother=s_ScapuloThoracic_J6;            % Solid's mother
Human_model(incr_solid).a=[0 1 0]';                          
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi/2;
Human_model(incr_solid).limit_sup=pi/2;
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).m=Mass.Scapula_Mass;                        % Reference mass
Human_model(incr_solid).b=[0 0 0]';        % Attachment point position in mother's frame
Human_model(incr_solid).I=[I_Scapula(1) I_Scapula(4) I_Scapula(5); I_Scapula(4) I_Scapula(2) I_Scapula(6); I_Scapula(5) I_Scapula(6) I_Scapula(3)];               % Reference inertia matrix
Human_model(incr_solid).c=-Scapula_stJointNode;                 % Centre of mass position in local frame
Human_model(incr_solid).calib_k_constraint=[];
Human_model(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
Human_model(incr_solid).theta=[];
Human_model(incr_solid).KinematicsCut=[];           % kinematic cut
Human_model(incr_solid).linear_constraint=[];
Human_model(incr_solid).anat_position=Scapula_position_set;
Human_model(incr_solid).Visual=1;
Human_model(incr_solid).visual_file=['Holzbaur/Scapula_' lower(Side) '.mat'];
Human_model(incr_solid).comment='Scapula internal rotation';
Human_model(incr_solid).FunctionalAngle=[name];
Human_model(incr_solid).density=1.04; %kg.L-1


% AcromioClavicular Joint

% % AcromioClavicular_J1
% num_solid=num_solid+1;                                      % solid number
% name=list_solid{num_solid};                                 % solid name
% eval(['incr_solid=s_' name ';'])                            % solid number in model tree
% Human_model(incr_solid).name=[Side name];          % solid name with side
% Human_model(incr_solid).sister=0;                   % Solid's sister
% Human_model(incr_solid).child=s_AcromioClavicular_J2;         % Solid's child
% Human_model(incr_solid).mother=s_Scapula;            % Solid's mother
% Human_model(incr_solid).a=[0 1 0]';                          
% Human_model(incr_solid).joint=1;
% Human_model(incr_solid).limit_inf=-pi;
% Human_model(incr_solid).limit_sup=pi;
% Human_model(incr_solid).ActiveJoint=1;
% Human_model(incr_solid).m=0;                        % Reference mass
% Human_model(incr_solid).b=Scapula_acJointNode-Scapula_stJointNode;        % Attachment point position in mother's frame
% Human_model(incr_solid).I=zeros(3,3);               % Reference inertia matrix
% Human_model(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
% Human_model(incr_solid).calib_k_constraint=[];
% Human_model(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
% Human_model(incr_solid).theta=[];
% Human_model(incr_solid).KinematicsCut=[];           % kinematic cut
% Human_model(incr_solid).linear_constraint=[];
% Human_model(incr_solid).Visual=0;
% Human_model(incr_solid).comment='to be completed';
% Human_model(incr_solid).FunctionalAngle=[Side name];
% 
% 
% % AcromioClavicular_J2
% num_solid=num_solid+1;                                      % solid number
% name=list_solid{num_solid};                                 % solid name
% eval(['incr_solid=s_' name ';'])                            % solid number in model tree
% Human_model(incr_solid).name=[Side name];          % solid name with side
% Human_model(incr_solid).sister=0;                   % Solid's sister
% Human_model(incr_solid).child=s_AcromioClavicular_J3;            % Solid's child
% Human_model(incr_solid).mother=s_AcromioClavicular_J1;            % Solid's mother
% Human_model(incr_solid).a=[1 0 0]';                          
% Human_model(incr_solid).joint=1;
% Human_model(incr_solid).limit_inf=-pi;
% Human_model(incr_solid).limit_sup=pi;
% Human_model(incr_solid).ActiveJoint=1;
% Human_model(incr_solid).m=0;                        % Reference mass
% Human_model(incr_solid).b=[0 0 0]';        % Attachment point position in mother's frame
% Human_model(incr_solid).I=zeros(3,3);               % Reference inertia matrix
% Human_model(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
% Human_model(incr_solid).calib_k_constraint=[];
% Human_model(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
% Human_model(incr_solid).theta=[];
% Human_model(incr_solid).KinematicsCut=[];           % kinematic cut
% Human_model(incr_solid).linear_constraint=[];
% Human_model(incr_solid).Visual=0;
% Human_model(incr_solid).comment='to be completed';
% Human_model(incr_solid).FunctionalAngle=[Side name];
% 
% 
% % AcromioClavicular_J3
% num_solid=num_solid+1;                                      % solid number
% name=list_solid{num_solid};                                 % solid name
% eval(['incr_solid=s_' name ';'])                            % solid number in model tree
% Human_model(incr_solid).name=[Side name];          % solid name with side
% Human_model(incr_solid).sister=0;                   % Solid's sister
% Human_model(incr_solid).child=0;         % Solid's child
% Human_model(incr_solid).mother=s_AcromioClavicular_J2;            % Solid's mother
% Human_model(incr_solid).a=[0 1 0]';                          
% Human_model(incr_solid).joint=1;
% Human_model(incr_solid).limit_inf=-pi;
% Human_model(incr_solid).limit_sup=pi;
% Human_model(incr_solid).ActiveJoint=1;
% Human_model(incr_solid).m=0;        % Reference mass
% Human_model(incr_solid).b=[0 0 0]';        % Attachment point position in mother's frame
% Human_model(incr_solid).I=zeros(3,3);               % Reference inertia matrix
% Human_model(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
% Human_model(incr_solid).calib_k_constraint=[];
% Human_model(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
% Human_model(incr_solid).theta=[];
% Human_model(incr_solid).KinematicsCut=[];           % kinematic cut
% Human_model(incr_solid).ClosedLoop=[Side 'Clavicle_AcromioClavicularJointNode'];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
% Human_model(incr_solid).linear_constraint=[];
% Human_model(incr_solid).Visual=0;
% Human_model(incr_solid).comment='to be completed';
% Human_model(incr_solid).FunctionalAngle=[Side name];

end
