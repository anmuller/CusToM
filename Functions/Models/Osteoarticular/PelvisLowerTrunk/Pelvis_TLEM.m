function [OsteoArticularModel]= Pelvis_TLEM(OsteoArticularModel,k,Mass,AttachmentPoint)
% Addition of a pelvis/lower trunk model
%   This pelvis/lower trunk model contains 2 solids (pelvis and lower
%   trunk), exhibits 3 dofs for pelvis/lower trunk joint
%
%	Based on:
%	- Damsgaard, M., Rasmussen, J., Christensen, S. T., Surma, E., & De Zee, M., 2006.
% 	Analysis of musculoskeletal systems in the AnyBody Modeling System. Simulation Modelling Practice and Theory, 14(8), 1100-1111.
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
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
[OsteoArticularModel]= Pelvis_TLEMNoTrunk(OsteoArticularModel,k,Mass,AttachmentPoint);

list_solid={'LowerTrunk_J1' 'LowerTrunk_J2' 'LowerTrunk'};
    
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
attachment_pt = 'Pelvis_LowerTrunkNode';
test=0;
for i=1:numel(OsteoArticularModel)
    for j=1:size(OsteoArticularModel(i).anat_position,1)
        if strcmp(attachment_pt,OsteoArticularModel(i).anat_position{j,1})
           s_mother=i;
           pos_attachment_pt=OsteoArticularModel(i).anat_position{j,2}+OsteoArticularModel(s_mother).c;
           test=1;
           break
        end
    end
    if i==numel(OsteoArticularModel) && test==0
        error([attachment_pt ' is no existent'])        
    end       
end
if OsteoArticularModel(s_mother).child == 0      % if the mother don't have any child
    OsteoArticularModel(s_mother).child = eval(['s_' list_solid{1}]);    % the child of this mother is this solid
else
    [OsteoArticularModel]=sister_actualize(OsteoArticularModel,OsteoArticularModel(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la dernière soeur
end   


%%                     Definition of anatomical landmarks

% ------------------------- L5 --------------------------------------------

% Center of mass location with respect to the reference frame
CoM_L5 = k*[0.051 0.009 0];

% Node locations
L5_SacrumJointNode = k*[0.043 -0.005 0] - CoM_L5;
L5_L4JointNode = k*[0.050 0.027 0] - CoM_L5;
Lenght_L5=norm(L5_L4JointNode-L5_SacrumJointNode); %#ok<NASGU>

% ------------------------- L4 --------------------------------------------

% Center of mass location with respect to the reference frame
CoM_L4 = k*[0.056 0.044 0];

% Node locations
L4_L5JointNode = k*[0.050 0.027 0] - CoM_L4;
L4_L3JointNode = k*[0.050 0.061 0] - CoM_L4;
Lenght_L4=norm(L4_L3JointNode-L4_L5JointNode); %#ok<NASGU>

% ------------------------- L3 --------------------------------------------

% Center of mass location with respect to the reference frame
CoM_L3 = k*[0.051 0.079 0];

% Node locations
L3_L4JointNode = k*[0.050 0.061 0] - CoM_L3;
L3_L2JointNode = k*[0.044 0.094 0] - CoM_L3;
Lenght_L3=norm(L3_L2JointNode-L3_L4JointNode); %#ok<NASGU>

% ------------------------- L2 --------------------------------------------

% Center of mass location with respect to the reference frame
CoM_L2 = k*[0.043 0.110 0];

% Node locations
L2_L3JointNode = k*[0.044 0.094 0] - CoM_L2;
L2_L1JointNode = k*[0.034 0.123 0] - CoM_L2;
Lenght_L2=norm(L2_L1JointNode-L2_L3JointNode); %#ok<NASGU>

% ------------------------- L1 --------------------------------------------

% Center of mass location with respect to the reference frame
CoM_L1 = k*[0.031 0.139 0];

% Node locations
L1_L2JointNode = k*[0.034 0.123 0] - CoM_L1;
L1_T12JointNode = k*[0.022 0.154 0] - CoM_L1;
Lenght_L1=norm(L1_T12JointNode-L1_L2JointNode); %#ok<NASGU>

%% Definition of anatomical landmarks

LowerTrunk_position_set= {...
    'LowerTrunk_UpperTrunkNode', (L5_L4JointNode-L5_SacrumJointNode)' + (L4_L3JointNode-L4_L5JointNode)' + ...
        (L3_L2JointNode-L3_L4JointNode)' + (L2_L1JointNode-L2_L3JointNode)' + (L1_T12JointNode-L1_L2JointNode)'; ...
    'LowerTrunk_Origin', [0 0 0]'; ...
    };

%%                     Scaling inertial parameters

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % ------------------------- LowerTrunk ----------------------------------------
    I_LowerTrunk=[0 0 0 0 0 0];

                    %% %% "Human_model" structure generation
 
num_solid=0;
%% Lower Trunk

    % LowerTrunk_J1
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=s_LowerTrunk_J2;                   
    OsteoArticularModel(incr_solid).mother=s_mother;           
    OsteoArticularModel(incr_solid).a=[0 0 1]'; 
    OsteoArticularModel(incr_solid).joint=1;  
    OsteoArticularModel(incr_solid).limit_inf=-pi/3;
    OsteoArticularModel(incr_solid).limit_sup=pi/4;
    OsteoArticularModel(incr_solid).linear_constraint=[];
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).b=pos_attachment_pt;
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).I=zeros(3,3);

    % LowerTrunk_J2
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=s_LowerTrunk;                   
    OsteoArticularModel(incr_solid).mother=s_LowerTrunk_J1;           
    OsteoArticularModel(incr_solid).a=[1 0 0]';
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/4;
    OsteoArticularModel(incr_solid).limit_sup=pi/4;
    OsteoArticularModel(incr_solid).linear_constraint=[];
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).I=zeros(3,3);

    % LowerTrunk
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=0;                   
    OsteoArticularModel(incr_solid).mother=s_LowerTrunk_J2;           
    OsteoArticularModel(incr_solid).a=[0 1 0]'; 
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/2;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).linear_constraint=[];
    OsteoArticularModel(incr_solid).Visual=1;
    OsteoArticularModel(incr_solid).calib_k_constraint=[];
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    OsteoArticularModel(incr_solid).m=Mass.LowerTrunk_Mass;                 
    OsteoArticularModel(incr_solid).I=[I_LowerTrunk(1) I_LowerTrunk(4) I_LowerTrunk(5); I_LowerTrunk(4) I_LowerTrunk(2) I_LowerTrunk(6); I_LowerTrunk(5) I_LowerTrunk(6) I_LowerTrunk(3)];
    OsteoArticularModel(incr_solid).anat_position=LowerTrunk_position_set;
    OsteoArticularModel(incr_solid).L={'LowerTrunk_Origin';'LowerTrunk_UpperTrunkNode'};
    
end
