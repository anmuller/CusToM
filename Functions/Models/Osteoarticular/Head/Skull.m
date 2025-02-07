function [OsteoArticularModel]= Skull(OsteoArticularModel,k,Mass,AttachmentPoint)
% Addition of a skull model
%   This skull model contains one solid (skull), exhibits 3 dof for the
%   neck
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
list_solid={'ThoraxSkull_J1' 'ThoraxSkull_J2' 'Skull'};
       
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

% ------------------------- Skull -----------------------------------------
% Node locations
Skull_NeckNode = k*[0 0 0];
Skull_TopOfHead = k*[0 0.14 0];

%% Definition of anatomical landmarks

Skull_position_set= {...
    'RFHD', k*[0.09 0.095 0.065]'; ...
    'LFHD', k*[0.09 0.095 -0.065]'; ...
    'RBHD', k*[-0.08 0.08 0.07]'; ...
    'LBHD', k*[-0.08 0.08 -0.07]'; ...
    'RMHD', 0.5*(k*[-0.08 0.08 0.07]'+k*[0.09 0.095 0.065]'); ...
    'LMHD', 0.5*(k*[-0.08 0.08 -0.07]'+k*[0.09 0.095 -0.065]'); ...
    'Skull_TopOfHead', Skull_TopOfHead'; ...
    'Skull_NeckNode', Skull_NeckNode'; ...
    'GLASS1', [0.13 0.105 0.079]'; ...
    'GLASS2', [0.13 0.105 -0.079]'; ...
    'GLASS3', [0.155 0.005 -0.0925]'; ...
    'GLASS4', [0.155 0.005 0.0925]'; ...
    'NEZ', k*[0.12 0.02 0]'; ...
    'VERTEX', k*[-0.09 0.11 0]'; ...
    'NUQUE', k*[-0.06 -0.03 0]'; ...
    };

%%                     Scaling inertial parameters

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % ------------------------- Skull -----------------------------------------
    Lenght_Skull = norm(Skull_TopOfHead - Skull_NeckNode);
    [I_Skull]=rgyration2inertia([31 25 33 9*1i 2*1i 3], Mass.Skull_Mass, [0 0 0], Lenght_Skull); 

                    %% Création de la structure "Human_model"
 
num_solid=0;
%% Skull
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % nom du solide
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % nom du solide
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=s_ThoraxSkull_J2;                   
    OsteoArticularModel(incr_solid).mother=s_mother;           
    OsteoArticularModel(incr_solid).a=[0 0 1]';
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/2;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).b=pos_attachment_pt;  
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    OsteoArticularModel(incr_solid).comment = 'Neck Flexion(-)/Extension(+)';

    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % nom du solide
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % nom du solide
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=s_Skull;                   
    OsteoArticularModel(incr_solid).mother=s_ThoraxSkull_J1;           
    OsteoArticularModel(incr_solid).a=[1 0 0]'; 
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/2;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    OsteoArticularModel(incr_solid).comment = 'Neck Axial Rotation Right(+)/Left(-)';

    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % nom du solide
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % nom du solide
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=0;                   
    OsteoArticularModel(incr_solid).mother=s_ThoraxSkull_J2;           
    OsteoArticularModel(incr_solid).a=[0 1 0]';    
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/2;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).Visual=1;
    OsteoArticularModel(incr_solid).m=Mass.Skull_Mass;                 
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).I=[I_Skull(1) I_Skull(4) I_Skull(5); I_Skull(4) I_Skull(2) I_Skull(6); I_Skull(5) I_Skull(6) I_Skull(3)];
    OsteoArticularModel(incr_solid).c=-Skull_NeckNode';
    OsteoArticularModel(incr_solid).anat_position=Skull_position_set;
    OsteoArticularModel(incr_solid).L={'Skull_TopOfHead';'Thorax_T1C5'};
    OsteoArticularModel(incr_solid).visual_file = ['Holzbaur/skull.mat'];
    OsteoArticularModel(incr_solid).comment = 'Neck Lateral Bending Right(+)/Left(-)';
    
end
