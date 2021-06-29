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

list_solid={'Clavicle_J1' 'Clavicle_J2' 'Clavicle'};

%% Choix jambe droite ou gauche
if Side == 'R'
    Mirror=[1 0 0; 0 1 0; 0 0 1];
    Sign=1;
    Cote='D';
elseif Side == 'L'
    Mirror=[1 0 0; 0 1 0; 0 0 -1];
    Sign=-1;
    Cote='G';
end

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
Clavicle_marker_set1 = Thorax_osim2antoine.*Mirror*[0.005 0.02 0.07]';


%% Definition of anatomical landmarks (with respect to the center of mass of the solid)

Clavicle_position_set= {...
    % Markers
    ['CLAV' Cote], Clavicle_marker_set1; ...
    % Joint Nodes
    [Side '_Clavicle_acJointNode'], Clavicle_acJointNode;...
    % Muscle paths
    [Side '_clavicle_r_DELT1_r-P4'],Thorax_osim2antoine.*Mirror*([-0.014;0.01106;0.08021])-CoM_Clavicle;...
    [Side '_clavicle_r_PECM1_r-P4'],Thorax_osim2antoine.*Mirror*([0.00321;-0.00013;0.05113])-CoM_Clavicle;...
    [Side '_clavicle_r_cleid_mast_r-P1'],Thorax_osim2antoine.*Mirror*([0.0022;0.0043;0.0257])-CoM_Clavicle;...
    [Side '_clavicle_r_cleid_occ_r-P1'],Thorax_osim2antoine.*Mirror*([0.0022;0.0043;0.0257])-CoM_Clavicle;...
    [Side '_clavicle_r_trap_cl_r-P1'],Thorax_osim2antoine.*Mirror*([-0.0171;0.019;0.0727])-CoM_Clavicle;...
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
Human_model(incr_solid).a=[0 0 1]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi/2;
Human_model(incr_solid).limit_sup=pi/2;
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).m=0;                 
Human_model(incr_solid).b=pos_attachment_pt;  
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';
Human_model(incr_solid).comment='Clavicle Axial Rotation Forward(-)/Backward(+)';

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
Human_model(incr_solid).limit_inf=-pi/2;
Human_model(incr_solid).limit_sup=pi/2;
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).m=0;                 
Human_model(incr_solid).b=[0 0 0]';  
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';
Human_model(incr_solid).comment='Clavivle Depression(-)/Elevation(+)';

% Clavicle
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
Human_model(incr_solid).name=[Side name];               % solid name
Human_model(incr_solid).sister=0;                
Human_model(incr_solid).child=0;                   
Human_model(incr_solid).mother=s_Clavicle_J2;           
Human_model(incr_solid).a=[0 1 0]';    
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi/2;
Human_model(incr_solid).limit_sup=pi/2;
Human_model(incr_solid).Visual=1;
Human_model(incr_solid).calib_k_constraint=s_mother;
Human_model(incr_solid).m=Mass.Clavicle_Mass;                 
Human_model(incr_solid).b=[0 0 0]';  
Human_model(incr_solid).I=[I_clavicle(1) I_clavicle(4) I_clavicle(5); I_clavicle(4) I_clavicle(2) I_clavicle(6); I_clavicle(5) I_clavicle(6) I_clavicle(3)];
Human_model(incr_solid).c=-Clavicle_scJointNode;
Human_model(incr_solid).anat_position=Clavicle_position_set;
Human_model(incr_solid).visual_file = ['Holzbaur/clavicle_' lower(Side) '.mat'];
Human_model(incr_solid).comment='Clavivle Protraction(+)/Retraction(-)';

end

