function [OsteoArticularModel]= UpperTrunkClavicle(OsteoArticularModel,k,Mass,AttachmentPoint)
% Addition of an upper trunk model
%   This upper trunk model contains 3 solids (thorax, right clavicle and
%   left clavicle), exhibits 3 dof for lower trunk / upper trunk joint, 3
%   dof for each upper trunk / clavicle joint
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
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
list_solid={'UpperTrunk_J1' 'UpperTrunk_J2' 'Thorax' ...
        'RClavicle_J1' 'RClavicle_J2' 'RClavicle' ...
        'LClavicle_J1' 'LClavicle_J2' 'LClavicle'};
 
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


%%                     Definition of anatomical landmarks

% ------------------------- Thorax ----------------------------------------

% Center of mass location with respect to the reference frame
CoM_Thorax = k*[0.060 0.303 0];

% Node locations
Thorax_T12L1JointNode = k*[0.022 0.154 0] - CoM_Thorax;
Thorax_C1HatNode = k*[0.026 0.6 0] - CoM_Thorax;
Thorax_T1C5 = k*[0.013 0.462 0] - CoM_Thorax;
Thorax_scjJointRightNode = k*[0.0010 0.1240 0.0207]-Thorax_T12L1JointNode;
Thorax_scjJointLeftNode = k*[0.0010 0.1240 -0.0207]-Thorax_T12L1JointNode;
Thorax_ShoulderRightNode=k*[-0.0408 0.1099 0.1929]-Thorax_T12L1JointNode;
Thorax_ShoulderLeftNode=k*[-0.0408 0.1099 -0.1929]-Thorax_T12L1JointNode;
Thorax_scjJointCenter=k*[0 0.1240 0]-Thorax_T12L1JointNode; %#ok<NASGU>
NeckNode=Thorax_C1HatNode;

Thorax_osim2antoine = [k k Thorax_ShoulderRightNode(3)/0.17]; % scaling coef based on shoulder width
% RThorax_Triceps = ([-0.05365 -0.01373 0.14723]-[-0.017545 -0.007 0.17]).*Thorax_osim2antoine; % in the frame osimarm26
% LThorax_Triceps = ([-0.05365 -0.01373 -0.14723]-[-0.017545 -0.007 -0.17]).*Thorax_osim2antoine; % in the frame osimarm26
% RThorax_BicepsL_o = ([-0.039235 0.00347 0.14795]-[-0.017545 -0.007 0.17]).*Thorax_osim2antoine; % in the frame osimarm26
% LThorax_BicepsL_o = ([-0.039235 0.00347 -0.14795]-[-0.017545 -0.007 -0.17]).*Thorax_osim2antoine; % in the frame osimarm26
% RThorax_BicepsL_via1 = ([-0.028945 0.01391 0.15639]-[-0.017545 -0.007 0.17]).*Thorax_osim2antoine; % in the frame osimarm26;
% LThorax_BicepsL_via1 = ([-0.028945 0.01391 -0.15639]-[-0.017545 -0.007 -0.17]).*Thorax_osim2antoine; % in the frame osimarm26;
% RThorax_BicepsS_o = ([0.004675 -0.01231 0.13475]-[-0.017545 -0.007 0.17]).*Thorax_osim2antoine; % in the frame osimarm26
% LThorax_BicepsS_o = ([0.004675 -0.01231 -0.13475]-[-0.017545 -0.007 -0.17]).*Thorax_osim2antoine; % in the frame osimarm26
% RThorax_BicepsS_via1 = ([-0.007075 -0.04004 0.14507]-[-0.017545 -0.007 0.17]).*Thorax_osim2antoine; % in the frame osimarm26;
% LThorax_BicepsS_via1 = ([-0.007075 -0.04004 -0.14507]-[-0.017545 -0.007 -0.17]).*Thorax_osim2antoine; % in the frame osimarm26;

RThorax_Triceps = ([-0.05365 -0.01373 0.14723]).*Thorax_osim2antoine; % in the frame osimarm26
LThorax_Triceps = ([-0.05365 -0.01373 -0.14723]).*Thorax_osim2antoine; % in the frame osimarm26
RThorax_BicepsL_o = ([-0.039235 0.00347 0.14795]).*Thorax_osim2antoine; % in the frame osimarm26
LThorax_BicepsL_o = ([-0.039235 0.00347 -0.14795]).*Thorax_osim2antoine; % in the frame osimarm26
RThorax_BicepsL_via1 = ([-0.028945 0.01391 0.15639]).*Thorax_osim2antoine; % in the frame osimarm26;
LThorax_BicepsL_via1 = ([-0.028945 0.01391 -0.15639]).*Thorax_osim2antoine; % in the frame osimarm26;
RThorax_BicepsS_o = ([0.004675 -0.01231 0.13475]).*Thorax_osim2antoine; % in the frame osimarm26
LThorax_BicepsS_o = ([0.004675 -0.01231 -0.13475]).*Thorax_osim2antoine; % in the frame osimarm26
RThorax_BicepsS_via1 = ([-0.007075 -0.04004 0.14507]).*Thorax_osim2antoine; % in the frame osimarm26;
LThorax_BicepsS_via1 = ([-0.007075 -0.04004 -0.14507]).*Thorax_osim2antoine; % in the frame osimarm26;

%% Definition of anatomical landmarks (with respect to the center of mass of the solid)

Thorax_position_set= {...
    'STRN', k*[0.095 -0.055 0]'; ...
    'CLAV', k*[0.01 0.13 0]'; ...
    'T10', k*[-0.12 -0.115 0]'; ...
    'T8', k*[-0.13 -0.05 0]'; ...
    'T12', k*[-0.10 -0.175 0]'; ...
    'C7', k*[-0.105 0.165 0]'; ...
    'NeckNode', NeckNode'; ...
    'Thorax_T1C5', Thorax_T1C5'; ...
    'Thorax_scjJointRightNode', Thorax_scjJointRightNode'; ...
    'Thorax_scjJointLeftNode', Thorax_scjJointLeftNode'; ...
    'Thorax_T12L1JointNode', Thorax_T12L1JointNode'; ...
    % BULLSHIT
    ['Thorax_PectoralisMajor_o'],[0 0 0]';...
    };
    
RClavicle_position_set= {...    
    'RSHO', k*[-0.0416 0.1707 0.1853]'-Thorax_T12L1JointNode'-Thorax_scjJointRightNode'; ...
    'CLAVD', k*[0.005 0.02 0.07]'; ...
    'Thorax_ShoulderRightNode', Thorax_ShoulderRightNode'-Thorax_scjJointRightNode'; ...
    'RThorax_Triceps_o',RThorax_Triceps'-Thorax_scjJointRightNode'+Thorax_scjJointCenter';...
    'LThorax_Triceps_o',LThorax_Triceps'-Thorax_scjJointRightNode'+Thorax_scjJointCenter';...
    'RThorax_BicepsL_o',RThorax_BicepsL_o'-Thorax_scjJointRightNode'+Thorax_scjJointCenter';...
    'LThorax_BicepsL_o',LThorax_BicepsL_o'-Thorax_scjJointRightNode'+Thorax_scjJointCenter';...
    'RThorax_BicepsL_via1',RThorax_BicepsL_via1'-Thorax_scjJointRightNode'+Thorax_scjJointCenter';...
    'LThorax_BicepsL_via1',LThorax_BicepsL_via1'-Thorax_scjJointRightNode'+Thorax_scjJointCenter';...
    'RThorax_BicepsS_o',RThorax_BicepsS_o'-Thorax_scjJointRightNode'+Thorax_scjJointCenter';...
    'LThorax_BicepsS_o',LThorax_BicepsS_o'-Thorax_scjJointRightNode'+Thorax_scjJointCenter';...
    'RThorax_BicepsS_via1',RThorax_BicepsS_via1'-Thorax_scjJointRightNode'+Thorax_scjJointCenter';...
    'LThorax_BicepsS_via1',LThorax_BicepsS_via1'-Thorax_scjJointRightNode'+Thorax_scjJointCenter';...
    };

LClavicle_position_set= {...
    'LSHO', k*[-0.0416 0.1707 -0.1853]'-Thorax_T12L1JointNode'-Thorax_scjJointLeftNode'; ...
    'CLAVG', k*[0.005 0.02 -0.07]'; ...
    'Thorax_ShoulderLeftNode', Thorax_ShoulderLeftNode'-Thorax_scjJointLeftNode'; ...
    };

%%                     Scaling inertial parameters

% longueur entre 'Pelvis_L5JointNode' et 'Thorax_T1C5'
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
Lenght_Thorax = distance_point(Lpts{1,3},Lpts{1,2},Lpts{2,3},Lpts{2,2},OsteoArticularModel,zeros(numel(OsteoArticularModel),1)) ...
    +norm(Thorax_T12L1JointNode-Thorax_T1C5);

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % ------------------------- Thorax ----------------------------------------
    [I_Thorax]=rgyration2inertia([27 25 28 18 2 4*1i], Mass.UpperTrunk_Mass, [0 0 0], Lenght_Thorax);

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

    % Thorax
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=s_RClavicle_J1;                   
    OsteoArticularModel(incr_solid).mother=s_UpperTrunk_J2;           
    OsteoArticularModel(incr_solid).a=[0 1 0]';    
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-0.2;
    OsteoArticularModel(incr_solid).limit_sup=0.2;
    OsteoArticularModel(incr_solid).Visual=1;
    OsteoArticularModel(incr_solid).calib_k_constraint=[];
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).c=-Thorax_T12L1JointNode';
    OsteoArticularModel(incr_solid).m=Mass.UpperTrunk_Mass;                 
    OsteoArticularModel(incr_solid).I=[I_Thorax(1) I_Thorax(4) I_Thorax(5); I_Thorax(4) I_Thorax(2) I_Thorax(6); I_Thorax(5) I_Thorax(6) I_Thorax(3)];
    OsteoArticularModel(incr_solid).anat_position=Thorax_position_set;
    OsteoArticularModel(incr_solid).L={'Pelvis_LowerTrunkNode';'Thorax_T1C5'};
    
    %% Rclavicle
    % RClavicle_J1
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=s_LClavicle_J1;              
    OsteoArticularModel(incr_solid).child=s_RClavicle_J2;                   
    OsteoArticularModel(incr_solid).mother=s_Thorax;           
    OsteoArticularModel(incr_solid).a=[0 0 1]';
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/2;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).b=Thorax_scjJointRightNode';  
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    
    % RClavicle_J2
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;              
    OsteoArticularModel(incr_solid).child=s_RClavicle;                   
    OsteoArticularModel(incr_solid).mother=s_RClavicle_J1;           
    OsteoArticularModel(incr_solid).a=[1 0 0]';
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/2;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    
    % RClavicle
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=0;                   
    OsteoArticularModel(incr_solid).mother=s_RClavicle_J2;           
    OsteoArticularModel(incr_solid).a=[0 1 0]';    
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/2;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).Visual=1;
    OsteoArticularModel(incr_solid).calib_k_constraint=s_Thorax;
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    OsteoArticularModel(incr_solid).anat_position=RClavicle_position_set;

    %% Lclavicle
    % LClavicle_J1
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;              
    OsteoArticularModel(incr_solid).child=s_LClavicle_J2;                   
    OsteoArticularModel(incr_solid).mother=s_Thorax;           
    OsteoArticularModel(incr_solid).a=[0 0 1]';
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/2;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).b=Thorax_scjJointLeftNode';  
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    
    % LClavicle_J2
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;              
    OsteoArticularModel(incr_solid).child=s_LClavicle;                   
    OsteoArticularModel(incr_solid).mother=s_LClavicle_J1;           
    OsteoArticularModel(incr_solid).a=[1 0 0]';
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/2;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    
    % LClavicle
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=0;                   
    OsteoArticularModel(incr_solid).mother=s_LClavicle_J2;           
    OsteoArticularModel(incr_solid).a=[0 1 0]';    
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/2;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).Visual=1;
    OsteoArticularModel(incr_solid).calib_k_constraint=s_Thorax;
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    OsteoArticularModel(incr_solid).anat_position=LClavicle_position_set;

end
