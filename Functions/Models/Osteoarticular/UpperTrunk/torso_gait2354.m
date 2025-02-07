function [OsteoArticularModel]= torso_gait2354(OsteoArticularModel,k,Mass,AttachmentPoint)

%	CREDIT
%   Delp S.L., Loan J.P., Hoy M.G., Zajac F.E., Topp E.L., Rosen J.M., Thelen D.G., Anderson F.C., Seth A. 
%   NOTES
%   3D, 23 DOF gait model created by D.G. Thelen, Univ. of Wisconsin-Madison, and Ajay Seth, Frank C. Anderson, and Scott L. Delp, Stanford University. Lower extremity joint defintions based on Delp et al. (1990). Low back joint and anthropometry based on Anderson and Pandy (1999, 2001). Planar knee model of Yamaguchi and Zajac (1989). Seth replaced tibia translation constraints with a CustomJoint for the knee and removed the patella to eliminate all kinematic constraints; insertions of the quadrucepts are handled with moving points in the tibia frame as defined by Delp 1990. 
%   LINK
%   http://simtk-confluence.stanford.edu:8080/display/OpenSim/Gait+2392+and+2354+Models
%   Based on: 
%   - Delp, S.L., Loan, J.P., Hoy, M.G., Zajac, F.E., Topp E.L., Rosen, J.M.: An interactive graphics-based model of the lower extremity to study orthopaedic surgical procedures, IEEE Transactions on Biomedical Engineering, vol. 37, pp. 757-767, 1990. 
%   - Yamaguchi G.T., Zajac F.E.: A planar model of the knee joint to characterize the knee extensor mechanism." J . Biomech. vol. 22. pp. 1-10. 1989. 
%   - Anderson F.C., Pandy M.G.: A dynamic optimization solution for vertical jumping in three dimensions. Computer Methods in Biomechanics and Biomedical Engineering 2:201-231, 1999. Anderson F.C., Pandy M.G.: Dynamic optimization of human walking. Journal of Biomechanical Engineering 123:381-390, 2001.
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the thigh model ('R' for right side or 'L' for left side)
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

%% Variables de sortie :
% "enrichissement de la structure "Human_model""
list_solid={'lumbar_extension' 'lumbar_bending' 'torso'};
   
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
%%
% Center of mass 
CoM_bary = k*[-0.03 0.32 0]';

    %%                     Definition of anatomical landmarks
% ------------------------- Thorax ----------------------------------------
LowerTrunk_UpperTrunkNode = [0 0 0];
Thorax_T12L1JointNode = k*[0.012 0.138 0] - CoM_bary;
Skull_NeckNode=k*([-0.0748473 0.413762 0]')-CoM_bary;
Skull_TopOfHead=k*([0.00084;0.657;0])-CoM_bary;
%% Definition of anatomical landmarks

Thorax_position_set= {...
    ['CLAV'],k*([0.0384447; 0.36731; 0])-CoM_bary;...
    ['RSHO'],k*([-0.03;0.44;0.15])-CoM_bary;...
    ['LSHO'],k*([-0.03;0.44;-0.15])-CoM_bary;...
    ['STRN'],k*([0.0967584; 0.215844; 0])-CoM_bary;...
    'C7', k*[-0.0748473 0.413762 0]'-CoM_bary;...
    ['Skull_TopOfHead'],k*([0.00084;0.657;0])-CoM_bary;...
    ['ercspn_r-P2'],k*([-0.055;0.11;0.0241])-CoM_bary;...
    ['ercspn_l-P2'],k*([-0.055;0.11;-0.0241])-CoM_bary;...
    ['intobl_r-P2'],k*([0.07;0.16;0.015])-CoM_bary;...
    ['intobl_l-P2'],k*([0.07;0.16;-0.015])-CoM_bary;...
    ['extobl_r-P2'],k*([0.065;0.11;0.11])-CoM_bary;...
    ['extobl_l-P2'],k*([0.065;0.11;-0.11])-CoM_bary;...
    'Thorax_T12L1JointNode', Thorax_T12L1JointNode; ...
 ...%   'RFHD', RFHD'; ...
 ...%   'LFHD', LFHD'; ...
 ...%   'RBHD', RBHD'; ...
 ...%   'LBHD', LBHD'; ...
    'Skull_TopOfHead', k*([0.00084;0.657;0])-CoM_bary; ...
    'Skull_NeckNode', k*([-0.019; 0.41; 0])-CoM_bary; ...
    'CoM_bary', CoM_bary;...
    };
%%                     Scaling inertial parameters

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
Lenght_Thorax = norm(Skull_NeckNode - [0 0 0]); % CJC to LJC
Lenght_Skull = norm(Skull_TopOfHead - Skull_NeckNode);

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % ------------------------- Thorax ----------------------------------------
    [I_Thorax]=rgyration2inertia([27 25 28 18 2 4*1i], Mass.Thorax_Mass, [0 0 0], Lenght_Thorax);
    % ------------------------- Skull ----------------------------------------
    [I_Skull]=rgyration2inertia([31 25 33 9*1i 2*1i 3],Mass.Skull_Mass, [0 0 0], Lenght_Skull); 

Ihead=[I_Skull(1) I_Skull(4) I_Skull(5); I_Skull(4) I_Skull(2) I_Skull(6); I_Skull(5) I_Skull(6) I_Skull(3)];
Ithorax=[I_Thorax(1) I_Thorax(4) I_Thorax(5); I_Thorax(4) I_Thorax(2) I_Thorax(6); I_Thorax(5) I_Thorax(6) I_Thorax(3)];

Ihead_dep=Huygens(Skull_NeckNode-CoM_bary,Ihead,Mass.Skull_Mass);
Ithorax_dep=Huygens(Thorax_T12L1JointNode-CoM_bary,Ithorax,Mass.Thorax_Mass);
Iglob=Ihead_dep+Ithorax_dep;
                    %% %% "Human_model" structure generation
 
num_solid=0;
%% Thorax
    % UpperTrunk_J1
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=s_lumbar_bending;                   
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
    OsteoArticularModel(incr_solid).child=s_torso;                   
    OsteoArticularModel(incr_solid).mother=s_lumbar_extension;           
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
    OsteoArticularModel(incr_solid).mother=s_lumbar_bending;           
    OsteoArticularModel(incr_solid).a=[0 1 0]';    
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-0.2;
    OsteoArticularModel(incr_solid).limit_sup=0.2;
    OsteoArticularModel(incr_solid).Visual=1;
    OsteoArticularModel(incr_solid).calib_k_constraint=[];
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).c=CoM_bary;
    OsteoArticularModel(incr_solid).m=Mass.Thorax_Mass+Mass.Skull_Mass;
    OsteoArticularModel(incr_solid).I=Iglob;
    OsteoArticularModel(incr_solid).anat_position=Thorax_position_set;
    OsteoArticularModel(incr_solid).L={'Pelvis_L5JointNode';'Thorax_T1C5'};
    OsteoArticularModel(incr_solid).visual_file = ['gait2354/torso.mat'];
    OsteoArticularModel(incr_solid).comment='Trunk Lateral Bending Right(+)/Left(-)';

end