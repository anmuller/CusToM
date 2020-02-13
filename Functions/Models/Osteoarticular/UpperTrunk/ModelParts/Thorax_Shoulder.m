function [Human_model]= Thorax_Shoulder(Human_model,k,Mass,AttachmentPoint)
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

list_solid={'UpperTrunk_J1' 'UpperTrunk_J2' 'Thorax'};

%% Solid numbering incremation

s=size(Human_model,2)+1;  %#ok<NASGU> % numéro du premier solide
for i=1:size(list_solid,2)      % numérotation de chaque solide : s_"nom du solide"
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
    if Human_model(s_mother).child == 0      % si la mère n'a pas d'enfant
        Human_model(s_mother).child = eval(['s_' list_solid{1}]);    % l'enfant de cette mère est ce solide
    else
        [Human_model]=sister_actualize(Human_model,Human_model(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la dernière soeur
    end
end


%%                     Definition of anatomical landmarks

% ------------------------- Thorax ----------------------------------------

% Center of mass location with respect to the reference frame
CoM_Thorax = k*[0.060 0.303 0];

CoM_Thorax_ibhgc = k*[-0.0591 -0.1486 0];

% Node locations
Thorax_T12L1JointNode = k*[0.022 0.154 0] - CoM_Thorax;
Thorax_C1HatNode = k*[0.026 0.6 0] - CoM_Thorax;
Thorax_T1C5 = k*[0.013 0.462 0] - CoM_Thorax;
R_Thorax_scJointNode = k*[0.006325 0.00693 0.025465] - CoM_Thorax_ibhgc;
L_Thorax_scJointNode = k*[0.006325 0.00693 -0.025465] - CoM_Thorax_ibhgc;
Thorax_scjJointCenter=k*[0 0.1240 0]-Thorax_T12L1JointNode; %#ok<NASGU>
NeckNode=Thorax_C1HatNode;
Thorax_EllipsoidNode = k*[-0.02 -0.0173 0.0609] - CoM_Thorax_ibhgc;


%% Definition of anatomical landmarks (with respect to the center of mass of the solid)

Thorax_position_set= {...
    % Markers
    'STRN', k*[0.095 -0.055 0]'; ...
    'CLAV', k*[0.01 0.13 0]'; ...
    'T10', k*[-0.12 -0.115 0]'; ...
    'T8', k*[-0.13 -0.05 0]'; ...
    'T12', k*[-0.10 -0.175 0]'; ...
    'C7', k*[-0.105 0.165 0]'; ...
    % Joint Nodes
    'NeckNode', NeckNode'; ...
    'Thorax_T1C5', Thorax_T1C5'; ...
    'R_Thorax_scJointNode', R_Thorax_scJointNode'; ...
    'L_Thorax_scJointNode', L_Thorax_scJointNode'; ...
    'Thorax_T12L1JointNode', Thorax_T12L1JointNode'; ...
    'R_Thorax_EllipsoidNode', [1 0 0; 0 1 0; 0 0 1]*Thorax_EllipsoidNode'; ... 
    'L_Thorax_EllipsoidNode', [1 0 0; 0 1 0; 0 0 -1]*Thorax_EllipsoidNode'; ... 
    % Muscle paths   
    ['Thorax_PECM1_r-P3'],k*([0.0063633;-0.0073233;0.11927])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM2_r-P3'],k*([0.020397;-0.03445;0.12312])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM2_r-P4'],k*([0.03091;-0.03922;0.09705])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM2_r-P5'],k*([0.02769;-0.04498;0.02271])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM3_r-P3'],k*([0.02984;-0.069739;0.1151])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM3_r-P4'],k*([0.0525;-0.08417;0.08935])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM3_r-P5'],k*([0.05724;-0.11654;0.03787])-CoM_Thorax_ibhgc;...
    ['Thorax_LAT1_r-P4'],k*([-0.11828;-0.10118;0.03316])-CoM_Thorax_ibhgc;...
    ['Thorax_LAT1_r-P5'],k*([-0.09578;-0.11724;0.00882])-CoM_Thorax_ibhgc;...
    ['Thorax_LAT2_r-P4'],k*([-0.10992;-0.16908;0.02878])-CoM_Thorax_ibhgc;...
    ['Thorax_LAT2_r-P5'],k*([-0.07186;-0.18818;0.00815])-CoM_Thorax_ibhgc;...
    ['Thorax_LAT3_r-P4'],k*([-0.11157;-0.19387;0.05532])-CoM_Thorax_ibhgc;...
    ['Thorax_LAT3_r-P5'],k*([-0.07117;-0.24858;0.00907])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM1_l-P3'],k*([0.0063633;-0.0073233;-0.11927])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM2_l-P3'],k*([0.020397;-0.03445;-0.12312])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM2_l-P4'],k*([0.03091;-0.03922;-0.09705])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM2_l-P5'],k*([0.02769;-0.04498;-0.02271])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM3_l-P3'],k*([0.02984;-0.069739;-0.1151])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM3_l-P4'],k*([0.0525;-0.08417;-0.08935])-CoM_Thorax_ibhgc;...
    ['Thorax_PECM3_l-P5'],k*([0.05724;-0.11654;-0.03787])-CoM_Thorax_ibhgc;...
    ['Thorax_LAT1_l-P4'],k*([-0.11828;-0.10118;-0.03316])-CoM_Thorax_ibhgc;...
    ['Thorax_LAT1_l-P5'],k*([-0.09578;-0.11724;-0.00882])-CoM_Thorax_ibhgc;...
    ['Thorax_LAT2_l-P4'],k*([-0.10992;-0.16908;-0.02878])-CoM_Thorax_ibhgc;...
    ['Thorax_LAT2_l-P5'],k*([-0.07186;-0.18818;-0.00815])-CoM_Thorax_ibhgc;...
    ['Thorax_LAT3_l-P4'],k*([-0.11157;-0.19387;-0.05532])-CoM_Thorax_ibhgc;...
    ['Thorax_LAT3_l-P5'],k*([-0.07117;-0.24858;-0.00907])-CoM_Thorax_ibhgc;...
    ['Thorax_stern_mast_r-P1'],k*([-0.002;-0.0005;0.0087])-CoM_Thorax_ibhgc;...
    ['Thorax_stern_mast_l-P1'],k*([-0.002;-0.0005;-0.0087])-CoM_Thorax_ibhgc;...
    ['Thorax_rhomboid_min_r-P1'],k*([-0.078;0.03;0])-CoM_Thorax_ibhgc;...
    ['Thorax_rhomboid_maj_r-P1'],k*([-0.1;-0.038;0])-CoM_Thorax_ibhgc;...
    ['Thorax_rhomboid_min_l-P1'],k*([-0.078;0.03;0])-CoM_Thorax_ibhgc;...
    ['Thorax_rhomboid_maj_l-P1'],k*([-0.1;-0.038;0])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_1_r-P2'],k*([-0.0353;-0.2;0.125])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_2_r-P2'],k*([-0.0149;-0.175;0.1327])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_3_r-P2'],k*([-0.0024;-0.15;0.135])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_4_r-P2'],k*([0.0031;-0.129;0.135])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_5_r-P2'],k*([-0.0041;-0.09;0.14])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_6_r-P2'],k*([-0.019;-0.07;0.126])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_7_r-P2'],k*([-0.033;-0.04;0.12])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_8_r-P2'],k*([-0.0552;-0.02;0.101])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_9_r-P2'],k*([-0.0546;0.0062;0.098])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant10_r-P2'],k*([-0.0595;0.0109;0.0944])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant11_r-P2'],k*([-0.0546;0.0062;0.098])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant12_r-P2'],k*([-0.047;0.0009;0.1005])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_1_l-P2'],k*([-0.0353;-0.2;-0.125])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_2_l-P2'],k*([-0.0149;-0.175;-0.1327])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_3_l-P2'],k*([-0.0024;-0.15;-0.135])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_4_l-P2'],k*([0.0031;-0.129;-0.135])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_5_l-P2'],k*([-0.0041;-0.09;-0.14])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_6_l-P2'],k*([-0.019;-0.07;-0.126])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_7_l-P2'],k*([-0.033;-0.04;-0.12])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_8_l-P2'],k*([-0.0552;-0.02;-0.101])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant_9_l-P2'],k*([-0.0546;0.0062;-0.098])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant10_l-P2'],k*([-0.0595;0.0109;-0.0944])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant11_l-P2'],k*([-0.0546;0.0062;-0.098])-CoM_Thorax_ibhgc;...
    ['Thorax_serr_ant12_l-P2'],k*([-0.047;0.0009;-0.1005])-CoM_Thorax_ibhgc;...
    
    };

%% Scaling inertial parameters

% longueur entre 'Pelvis_L5JointNode' et 'Thorax_T1C5'
Lpts={'Pelvis_LowerTrunkNode';'LowerTrunk_UpperTrunkNode'};
for pp=1:2
    test=0;
    for i=1:numel(Human_model)
        for j=1:size(Human_model(i).anat_position,1)
            if strcmp(Lpts{pp},Human_model(i).anat_position{j,1})
               Lpts{pp,2}=i; % solid number
               Lpts{pp,3}=j; % number of the anatomical landmarks
               test=1;
               break
            end
        end
        if i==numel(Human_model) && test==0
            error([Lpts{pp} ' is no existent'])        
        end       
    end
end
Length_Thorax = distance_point(Lpts{1,3},Lpts{1,2},Lpts{2,3},Lpts{2,2},Human_model,zeros(numel(Human_model),1)) ...
    +norm(Thorax_T12L1JointNode-Thorax_T1C5);

%% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas

[I_Thorax]=rgyration2inertia([27 25 28 18 2 4*1i], Mass.Thorax_Mass, [0 0 0], Length_Thorax);

%% "Human_model" structure generation
 
num_solid=0;
% UpperTrunk_J1
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
Human_model(incr_solid).name=name;               % solid name
Human_model(incr_solid).sister=0;                
Human_model(incr_solid).child=s_UpperTrunk_J2;                   
Human_model(incr_solid).mother=s_mother;           
Human_model(incr_solid).a=[0 0 1]'; 
Human_model(incr_solid).joint=1;  
Human_model(incr_solid).limit_inf=-0.2;
Human_model(incr_solid).limit_sup=0.2;
Human_model(incr_solid).linear_constraint=[];
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).b=pos_attachment_pt;
Human_model(incr_solid).c=[0 0 0]';
Human_model(incr_solid).m=0;                 
Human_model(incr_solid).I=zeros(3,3);

% UpperTrunk_J2
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
Human_model(incr_solid).name=name;               % solid name
Human_model(incr_solid).sister=0;                
Human_model(incr_solid).child=s_Thorax;                   
Human_model(incr_solid).mother=s_UpperTrunk_J1;           
Human_model(incr_solid).a=[1 0 0]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-0.2;
Human_model(incr_solid).limit_sup=0.2;
Human_model(incr_solid).linear_constraint=[];
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).b=[0 0 0]';  
Human_model(incr_solid).c=[0 0 0]';
Human_model(incr_solid).m=0;                 
Human_model(incr_solid).I=zeros(3,3);

% Thorax
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
Human_model(incr_solid).name=name;               % solid name
Human_model(incr_solid).sister=0;                
Human_model(incr_solid).child=0;                   
Human_model(incr_solid).mother=s_UpperTrunk_J2;           
Human_model(incr_solid).a=[0 1 0]';    
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-0.2;
Human_model(incr_solid).limit_sup=0.2;
Human_model(incr_solid).Visual=1;
Human_model(incr_solid).Visual_file='Holzbaur/torso.mat';
Human_model(incr_solid).calib_k_constraint=[];
Human_model(incr_solid).b=[0 0 0]';  
Human_model(incr_solid).c=-Thorax_T12L1JointNode';
Human_model(incr_solid).m=Mass.Thorax_Mass;                 
Human_model(incr_solid).I=[I_Thorax(1) I_Thorax(4) I_Thorax(5); I_Thorax(4) I_Thorax(2) I_Thorax(6); I_Thorax(5) I_Thorax(6) I_Thorax(3)];
Human_model(incr_solid).anat_position=Thorax_position_set;
Human_model(incr_solid).L={'Pelvis_LowerTrunkNode';'Thorax_T1C5'};

end