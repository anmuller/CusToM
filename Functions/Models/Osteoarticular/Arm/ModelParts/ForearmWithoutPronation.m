function [OsteoArticularModel]= ForearmWithoutPronation(OsteoArticularModel,k,Signe,Mass,AttachmentPoint)
% Addition of a forearm model
%   This forearm model contains one solid (forearm), exhibits 1 dof for the
%   elbow
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the forearm model ('R' for right side or 'L' for left side)
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
list_solid={'Forearm'};

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
for i=1:size(list_solid,2)     % each solid numbering: s_"nom du solide"
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

%%                   Node Definition

% ------------------------- Forearm ---------------------------------------

% Node positions
Humerus_ghJointNode = (k*[0 0.1674 0])*Mirror;
Humerus_ElbowJointNode = (k*[0 -0.1674 0])*Mirror;
Humerus_RadiusJointNode = (k*[0 -0.1674 0.0191])*Mirror;
Humerus_osim2antoine = [k (Humerus_ghJointNode(2)-Humerus_ElbowJointNode(2))/0.2904 k];
Forearm_ElbowJointNode = (k*[0 0.1202 0])*Mirror;
Forearm_WristJointNode = (k*[0 -0.1426 0])*Mirror;
Forearm_ghJointNode = Forearm_ElbowJointNode-Humerus_ElbowJointNode+Humerus_ghJointNode;
% Forearm_osim2antoine = [k (Forearm_ElbowJointNode(2)-Forearm_WristJointNode(2))/0.23559 k];
% Forearm_Brachioradialis = (k*[0.039 -0.499 0.012])*Mirror; %in the local frameRADIUS Murray2001
% Forearm_Biceps = (k*[0.004 -0.331 -0.012])*Mirror;%in the local frameRADIUS Murray2001
% Forearm_Biceps = (k*[0.004 -0.301 -0.012])*Mirror;%in the local frameRADIUS Murray2001
% Forearm_ECRL = (k*[0.042 -0.531 0.011])*Mirror;%in the local frameRADIUS Murray2001
% Forearm_Brachialis = (k*[-0.002 -0.319 -0.019])*Mirror; %in the local frameULNA Murray2001
% Forearm_Brachialis = Forearm_ElbowJointNode+(Forearm_osim2antoine.*[-0.0032 -0.0239 0.0009])*Mirror;
% Forearm_PronatorTeres = (k*[0.033 -0.398 0.005])*Mirror;%in the local frameRADIUS Murray2001
% Forearm_Triceps = (k*[-0.016 -0.272 -0.023])*Mirror; %in the local frameULNA Murray2001
% Forearm_Triceps_i = Forearm_ElbowJointNode+(Forearm_osim2antoine.*[-0.0219 0.01046 -0.00078])*Mirror;
% Forearm_Biceps_i = Forearm_ElbowJointNode+(Forearm_osim2antoine.*[0.00751 -0.04839 0.02179])*Mirror;
% RadiusJointNode = (k*[0 0 0.0191])*Mirror; %with respect to the elbow joint center PENNESTRI
% UlnaJointNode = (k*[0 0 -0.0191])*Mirror; %with respect to the elbow joint center PENNESTRI
% Longueur de l'humerus

%%              Definition of anatomical landmarks

Forearm_position_set= {...
    [Signe 'WRA'], k*Mirror*[0 -0.15 0.048]'; ... radius
    [Signe 'WRB'], k*Mirror*[0 -0.14 -0.030]'; ... ulna
    [Signe 'Forearm_WristJointNode'], Forearm_WristJointNode'; ...
    [Signe 'Forearm_ElbowJointNode'], Forearm_ElbowJointNode'; ...
    };

%%                     Scaling of inertia parameters

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % ------------------------- Forearm ---------------------------------------
    Length_Forearm=norm(Forearm_ElbowJointNode-Forearm_WristJointNode);
    [I_Forearm]=rgyration2inertia([28 11 27 3 2 8*1i], Mass.Forearm_Mass, [0 0 0], Length_Forearm, Signe);  

                %% %% "Human_model" structure generation

num_solid=0;
%% Forearm
    % Elbow_J1
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=[Signe name];                     
    OsteoArticularModel(incr_solid).a=[0 0 1]';
    OsteoArticularModel(incr_solid).joint=1;       
    OsteoArticularModel(incr_solid).b=pos_attachment_pt;  
    OsteoArticularModel(incr_solid).c=-Forearm_ElbowJointNode';
    %Human_model(incr_solid).anat_position=Elbow_J1_position_set;
    % Forearm
    OsteoArticularModel(incr_solid).sister=0;    
    OsteoArticularModel(incr_solid).child=0;
    OsteoArticularModel(incr_solid).mother=s_mother; 
    if Signe == 'R'
        OsteoArticularModel(incr_solid).limit_inf=0;
        OsteoArticularModel(incr_solid).limit_sup=pi;
    else
        OsteoArticularModel(incr_solid).limit_inf=-pi;
        OsteoArticularModel(incr_solid).limit_sup=0;
    end
    OsteoArticularModel(incr_solid).u=[0 1 0]';  % fixed rotation with respect to u axis of theta angle
    if Signe == 'L'
        OsteoArticularModel(incr_solid).theta=pi/2;
    else
        OsteoArticularModel(incr_solid).theta=-pi/2;
    end
    OsteoArticularModel(incr_solid).m=Mass.Forearm_Mass;
    OsteoArticularModel(incr_solid).I=[I_Forearm(1) I_Forearm(4) I_Forearm(5); I_Forearm(4) I_Forearm(2) I_Forearm(6); I_Forearm(5) I_Forearm(6) I_Forearm(3)];
    OsteoArticularModel(incr_solid).c=-Forearm_ElbowJointNode';
    OsteoArticularModel(incr_solid).anat_position=Forearm_position_set;
    OsteoArticularModel(incr_solid).Visual=1;
    OsteoArticularModel(incr_solid).L={[Signe 'Forearm_ElbowJointNode'];[Signe 'Forearm_WristJointNode']};
    
end