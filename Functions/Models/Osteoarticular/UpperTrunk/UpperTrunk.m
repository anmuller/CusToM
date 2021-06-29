function [OsteoArticularModel]= UpperTrunk(OsteoArticularModel,k,Mass,AttachmentPoint)
% Addition of an upper trunk model
%   This upper trunk model contains one solid (thorax), exhibits 3 dofs for
%   lower trunk / upper trunk joint
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
list_solid={'UpperTrunk_J1' 'UpperTrunk_J2' 'Thorax'};
    
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


%%                     Definition of anatomical landmarks

% ------------------------- Thorax ----------------------------------------

% Center of mass location with respect to the reference frame
CoM_Thorax = k*[0.060 0.303 0];

% Node locations
Thorax_T12L1JointNode = k*[0.022 0.154 0] - CoM_Thorax;
Thorax_C1HatNode = k*[0.026 0.6 0] - CoM_Thorax;
Thorax_T1C5 = k*[0.013 0.462 0] - CoM_Thorax;
Thorax_scjJointRightNode = k*[0.0010 0.1240 0.0207]-Thorax_T12L1JointNode; %#ok<NASGU>
Thorax_scjJointLeftNode = k*[0.0010 0.1240 -0.0207]-Thorax_T12L1JointNode; %#ok<NASGU>
Thorax_ShoulderRightNode=k*[-0.0408 0.1099 0.1929]-Thorax_T12L1JointNode;
Thorax_ShoulderLeftNode=k*[-0.0408 0.1099 -0.1929]-Thorax_T12L1JointNode;
Thorax_scjJointCenter=k*[0 0.1240 0]-Thorax_T12L1JointNode; %#ok<NASGU>
NeckNode=Thorax_C1HatNode;


% Pennestri to Custom vector transformation
dh = -0.140;
eh = 0.140;
L_humerus = 2*0.1674;
k_Pennestri2custom = L_humerus/(eh-dh)*k; % Humerus length equality
Pennestri2custom = k_Pennestri2custom*[0 0 1;-1 0 0;0 -1 0];

%% Definition of anatomical landmarks

Thorax_position_set= {...
    'STRN', k*[0.095 -0.055 0]'; ...
    'CLAV', k*[0.01 0.13 0]'; ...
    'T10', k*[-0.12 -0.115 0]'; ...
    'T8', k*[-0.13 -0.05 0]'; ...
    'T12', k*[-0.10 -0.175 0]'; ...
    'C7', k*[-0.105 0.165 0]'; ...
    'RSHO', k*[-0.0416 0.1707 0.1853]'; ...
    'LSHO', k*[-0.0416 0.1707 -0.1853]'; ...
    'Thorax_ShoulderRightNode', Thorax_ShoulderRightNode'+Thorax_T12L1JointNode'; ...
    'Thorax_ShoulderLeftNode', Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode'; ...
    'NeckNode', NeckNode'; ...
    'Thorax_T1C5', Thorax_T1C5'; ...
    
    % Muscles extracted from (Pennestri et al., 2007)
%     ['RThorax_TricepsBrachii2_i'],Pennestri2custom*[0.038 0.027 -0.02]'+Thorax_ShoulderRightNode'+Thorax_T12L1JointNode';...
    ['RRadius_TricepsBrachii2_o'], Pennestri2custom*[-0.025 0.02 -0.02]'+Thorax_ShoulderRightNode'+Thorax_T12L1JointNode';...
%     ['RThorax_BicepsBrachii1_i'],Pennestri2custom*[0.038 0 0.01]'+Thorax_ShoulderRightNode'+Thorax_T12L1JointNode';...
    ['RUlna_BicepsBrachii1_o'], Pennestri2custom*[0 -0.015 0.01]'+Thorax_ShoulderRightNode'+Thorax_T12L1JointNode';...
    ['RHumerus_Coracobrachialis_o'],Pennestri2custom*[0.02 0.03 0.035]'+Thorax_ShoulderRightNode'+Thorax_T12L1JointNode';...
    ['RHumerus_Deltoid_o'],Pennestri2custom*[ -0.03 0.04 0.015]'+Thorax_ShoulderRightNode'+Thorax_T12L1JointNode';...
    ['RHumerus_LatissimusDorsi_o'],Pennestri2custom*[ -0.035 0.09 -0.125]'+Thorax_ShoulderRightNode'+Thorax_T12L1JointNode';...
    ['RHumerus_PectoralisMajor_o'],Pennestri2custom*[ 0.045 0.095 -0.125]'+Thorax_ShoulderRightNode'+Thorax_T12L1JointNode';...
    ['RHumerus_Supraspinatus_o'],Pennestri2custom*[ -0.02 0.09 0.035]'+Thorax_ShoulderRightNode'+Thorax_T12L1JointNode';...
    ['RHumerus_Infraspinatus_o'],Pennestri2custom*[ -0.015 0.08 -0.04]'+Thorax_ShoulderRightNode'+Thorax_T12L1JointNode';...
    ['RHumerus_Trapezius_o'],Pennestri2custom*[0 0.08 0.01]'+Thorax_ShoulderRightNode'+Thorax_T12L1JointNode';...
    ['RHumerus_BicepsBrachii2_o'],Pennestri2custom*[0 -0.015 0.01]'+Thorax_ShoulderRightNode'+Thorax_T12L1JointNode';...
    
%     ['LThorax_TricepsBrachii2_i'],[1 0 0;0 1 0;0 0 -1]*Pennestri2custom*[0.038 0.027 -0.02]'+Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode';...
    ['LRadius_TricepsBrachii2_o'], Pennestri2custom*[-0.025 0.02 -0.02]'+Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode';...
%     ['LThorax_BicepsBrachii1_i'],[1 0 0;0 1 0;0 0 -1]*Pennestri2custom*[0.038 0 0.01]'+Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode';...
    ['LUlna_BicepsBrachii1_o'], [1 0 0;0 1 0;0 0 -1]*Pennestri2custom*[0 -0.015 0.01]'+Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode';...    
    ['LHumerus_Coracobrachialis_o'],[1 0 0;0 1 0;0 0 -1]*Pennestri2custom*[0.02 0.03 0.035]'+Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode';...
    ['LHumerus_Deltoid_o'],[1 0 0;0 1 0;0 0 -1]*Pennestri2custom*[ -0.03 0.04 0.015]'+Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode';...
    ['LHumerus_LatissimusDorsi_o'],[1 0 0;0 1 0;0 0 -1]*Pennestri2custom*[ -0.035 0.09 -0.125]'+Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode';...
    ['LHumerus_PectoralisMajor_o'],[1 0 0;0 1 0;0 0 -1]*Pennestri2custom*[ 0.045 0.095 -0.125]'+Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode';...
    ['LHumerus_Supraspinatus_o'],[1 0 0;0 1 0;0 0 -1]*Pennestri2custom*[ -0.02 0.09 0.035]'+Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode';...
    ['LHumerus_Infraspinatus_o'],[1 0 0;0 1 0;0 0 -1]*Pennestri2custom*[ -0.015 0.08 -0.04]'+Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode';...
    ['LHumerus_Trapezius_o'],[1 0 0;0 1 0;0 0 -1]*Pennestri2custom*[0 0.08 0.01]'+Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode';...
    ['LHumerus_BicepsBrachii2_o'],[1 0 0;0 1 0;0 0 -1]*Pennestri2custom*[0 -0.015 0.01]'+Thorax_ShoulderLeftNode'+Thorax_T12L1JointNode';...
};

%%                     Scaling inertial parameters

% Rigid upper trunk segments mass
UpperTrunk_Mass = Mass.Thorax_Mass + 2*(Mass.Scapula_Mass + Mass.Clavicle_Mass); % equal to McConville uppertrunk mass

% distance between 'Pelvis_L5JointNode' and 'Thorax_T1C5'
Lpts={'Pelvis_LowerTrunkNode';'LowerTrunk_UpperTrunkNode'};
for pp=1:2
    test=0;
    for i=1:numel(OsteoArticularModel)
        for j=1:size(OsteoArticularModel(i).anat_position,1)
            if strcmp(Lpts{pp},OsteoArticularModel(i).anat_position{j,1})
               Lpts{pp,2}=i; % solid number
               Lpts{pp,3}=j; % number of the anatomical landmarks
               test=1;
               break
            end
        end
        if i==numel(OsteoArticularModel) && test==0
            error([Lpts{pp} ' is no existent'])        
        end       
    end
end
Length_Thorax = distance_point(Lpts{1,3},Lpts{1,2},Lpts{2,3},Lpts{2,2},OsteoArticularModel,zeros(numel(OsteoArticularModel),1)) ...
    +norm(Thorax_T12L1JointNode-Thorax_T1C5);

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % ------------------------- Thorax ----------------------------------------
    [I_Thorax]=rgyration2inertia([27 25 28 18 2 4*1i], UpperTrunk_Mass, [0 0 0], Length_Thorax);

                    %% %% "Human_model" structure generation
 
num_solid=0;
%% Thorax
    % UpperTrunk_J1
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=s_UpperTrunk_J2;                   
    OsteoArticularModel(incr_solid).mother=s_mother;           
    OsteoArticularModel(incr_solid).a=[0 0 1]'; 
    OsteoArticularModel(incr_solid).joint=1;  
    OsteoArticularModel(incr_solid).limit_inf=-0.2;
    OsteoArticularModel(incr_solid).limit_sup=0.2;
    OsteoArticularModel(incr_solid).linear_constraint=[];
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).b=pos_attachment_pt;
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).comment='Trunk Flexion(-)/Extension(+)';

    % UpperTrunk_J2
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=s_Thorax;                   
    OsteoArticularModel(incr_solid).mother=s_UpperTrunk_J1;           
    OsteoArticularModel(incr_solid).a=[1 0 0]';
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-0.2;
    OsteoArticularModel(incr_solid).limit_sup=0.2;
    OsteoArticularModel(incr_solid).linear_constraint=[];
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).comment='Trunk Axial Rotation Right(+)/Left(-)';

    % Thorax
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=0;                   
    OsteoArticularModel(incr_solid).mother=s_UpperTrunk_J2;           
    OsteoArticularModel(incr_solid).a=[0 1 0]';    
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-0.2;
    OsteoArticularModel(incr_solid).limit_sup=0.2;
    OsteoArticularModel(incr_solid).Visual=1;
    OsteoArticularModel(incr_solid).calib_k_constraint=[];
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).c=-Thorax_T12L1JointNode';
    OsteoArticularModel(incr_solid).m=UpperTrunk_Mass;                 
    OsteoArticularModel(incr_solid).I=[I_Thorax(1) I_Thorax(4) I_Thorax(5); I_Thorax(4) I_Thorax(2) I_Thorax(6); I_Thorax(5) I_Thorax(6) I_Thorax(3)];
    OsteoArticularModel(incr_solid).anat_position=Thorax_position_set;
    OsteoArticularModel(incr_solid).L={'Pelvis_L5JointNode';'Thorax_T1C5'};
    OsteoArticularModel(incr_solid).visual_file = ['gait2354/torso.mat'];
    OsteoArticularModel(incr_solid).comment='Trunk Lateral Bending Right(+)/Left(-)';

end
