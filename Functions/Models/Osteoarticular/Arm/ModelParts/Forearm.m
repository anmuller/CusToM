function [OsteoArticularJoint]= Forearm(OsteoArticularJoint,k,Signe,Mass,AttachmentPoint)
% Addition of a forearm model
%   This forearm model contains one solid (forearm), exhibits 2 dof for the
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
list_solid={'Elbow_J1' 'Forearm'};

%% Choose arm right or left
if Signe == 'R'
    Mirror=[1 0 0; 0 1 0; 0 0 1];
    FullSide='Right';
elseif Signe == 'L'
    Mirror=[1 0 0; 0 1 0; 0 0 -1];
    FullSide='Left';
end

%% solid numbering incremation

s=size(OsteoArticularJoint,2)+1;  %#ok<NASGU> % number of the first solid
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
    for i=1:numel(OsteoArticularJoint)
        for j=1:size(OsteoArticularJoint(i).anat_position,1)
            if strcmp(AttachmentPoint,OsteoArticularJoint(i).anat_position{j,1})
               s_mother=i;
               pos_attachment_pt=OsteoArticularJoint(i).anat_position{j,2}+OsteoArticularJoint(s_mother).c;
               test=1;
               break
            end
        end
        if i==numel(OsteoArticularJoint) && test==0
            error([AttachmentPoint ' is no existent'])        
        end       
    end
    if OsteoArticularJoint(s_mother).child == 0      % if the mother don't have any child
        OsteoArticularJoint(s_mother).child = eval(['s_' list_solid{1}]);    % the child of this mother is this solid
    else
        [OsteoArticularJoint]=sister_actualize(OsteoArticularJoint,OsteoArticularJoint(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la dernière soeur
    end
end

%%                      Definition of anatomical landmarks

% ------------------------- Forearm ---------------------------------------

% Node locations
Humerus_ghJointNode = (k*[0 0.1674 0])*Mirror;
Humerus_ElbowJointNode = (k*[0 -0.1674 0])*Mirror;
Humerus_RadiusJointNode = (k*[0 -0.1674 0.0191])*Mirror;
Humerus_osim2antoine = [k (Humerus_ghJointNode(2)-Humerus_ElbowJointNode(2))/0.2904 k];
Forearm_ElbowJointNode = (k*[0 0.1202 0])*Mirror;
Forearm_WristJointNode = (k*[0 -0.1426 0])*Mirror;
Forearm_ghJointNode = Forearm_ElbowJointNode-Humerus_ElbowJointNode+Humerus_ghJointNode;
Forearm_osim2antoine = [k (Forearm_ElbowJointNode(2)-Forearm_WristJointNode(2))/0.23559 k];
Forearm_Brachioradialis = (k*[0.039 -0.499 0.012])*Mirror; %in the local frameRADIUS Murray2001
% Forearm_Biceps = (k*[0.004 -0.331 -0.012])*Mirror;%in the local frameRADIUS Murray2001
Forearm_Biceps = (k*[0.004 -0.301 -0.012])*Mirror;%in the local frameRADIUS Murray2001
Forearm_ECRL = (k*[0.042 -0.531 0.011])*Mirror;%in the local frameRADIUS Murray2001
% Forearm_Brachialis = (k*[-0.002 -0.319 -0.019])*Mirror; %in the local frameULNA Murray2001
Forearm_Brachialis = Forearm_ElbowJointNode+(Forearm_osim2antoine.*[-0.0032 -0.0239 0.0009])*Mirror;
Forearm_PronatorTeres = (k*[0.033 -0.398 0.005])*Mirror;%in the local frameRADIUS Murray2001
% Forearm_Triceps = (k*[-0.016 -0.272 -0.023])*Mirror; %in the local frameULNA Murray2001
Forearm_Triceps_i = Forearm_ElbowJointNode+(Forearm_osim2antoine.*[-0.0219 0.01046 -0.00078])*Mirror;
Forearm_Biceps_i = Forearm_ElbowJointNode+(Forearm_osim2antoine.*[0.00751 -0.04839 0.02179])*Mirror;
% RadiusJointNode = (k*[0 0 0.0191])*Mirror; %with respect to the elbow joint center PENNESTRI
% UlnaJointNode = (k*[0 0 -0.0191])*Mirror; %with respect to the elbow joint center PENNESTRI
% Longueur de l'humerus

%%              Definition of anatomical landmarks

Elbow_J1_position_set= {...
    [Signe 'RAD'], k*Mirror*[0 0.1 0.04]'; ...
    ...[Signe 'Forearm_Biceps'], (Forearm_ElbowJointNode+Forearm_Biceps+(Humerus_ghJointNode-Humerus_ElbowJointNode))'; ...
    [Signe 'Forearm_Biceps_i'], Forearm_Biceps_i'; ...
    ...[Signe 'Forearm_Brachialis'], (Forearm_ElbowJointNode+Forearm_Brachialis+(Humerus_ghJointNode-Humerus_ElbowJointNode))'; ...
    [Signe 'Forearm_Brachialis'], Forearm_Brachialis'; ...
    ...[Signe 'Forearm_Triceps'], (Forearm_ElbowJointNode+Forearm_Triceps+(Humerus_ghJointNode-Humerus_ElbowJointNode))'; ...
    [Signe 'Forearm_Triceps_via5'], Forearm_ElbowJointNode' + k*[-0.028 0 0]';...
    [Signe 'Forearm_Triceps_i'], Forearm_Triceps_i'; ...
    };

Forearm_position_set= {...
    [Signe 'WRA'], k*Mirror*[0 -0.15 0.048]'; ... radius
    [Signe 'WRB'], k*Mirror*[0 -0.14 -0.030]'; ... ulna
    [Signe 'Forearm_WristJointNode'], Forearm_WristJointNode'; ...
    [Signe 'Forearm_ElbowJointNode'], Forearm_ElbowJointNode'; ...
    ...[Signe 'Forearm_Brachioradialis_i'], (Forearm_ElbowJointNode+Forearm_Brachioradialis+(Humerus_ghJointNode-Humerus_ElbowJointNode))'; ...
    [Signe 'Forearm_Brachioradialis_i'], (k*Mirror*[0 -0.15 0.048]'); ... styloid lat
    ...[Signe 'Forearm_ECRL_i'], (Forearm_ElbowJointNode+Forearm_ECRL+(Humerus_ghJointNode-Humerus_ElbowJointNode))'; ...
    [Signe 'Forearm_ECRL_i'], (Forearm_ElbowJointNode+Forearm_ECRL+(Humerus_ghJointNode-Humerus_ElbowJointNode))'; ...
    ...[Signe 'Forearm_PronatorTeres'], (Forearm_ElbowJointNode+Forearm_PronatorTeres+(Humerus_ghJointNode-Humerus_ElbowJointNode))'; ...
    [Signe 'Forearm_PronatorTeres_i'], (k*Mirror*[0 -0.15 0.048]'+(Humerus_ghJointNode+Humerus_RadiusJointNode)')/2; ... milieu epidondyle-styloid lat
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
    name=list_solid{num_solid}; % nom du solide
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularJoint(incr_solid).name=[Signe name];   
    OsteoArticularJoint(incr_solid).sister=0;                
    OsteoArticularJoint(incr_solid).child=s_Forearm;                   
    OsteoArticularJoint(incr_solid).mother=s_mother;           
    OsteoArticularJoint(incr_solid).a=[0 0 1]';
    OsteoArticularJoint(incr_solid).joint=1;
    OsteoArticularJoint(incr_solid).limit_inf=0;
    OsteoArticularJoint(incr_solid).limit_sup=pi;
    OsteoArticularJoint(incr_solid).m=0;                 
    OsteoArticularJoint(incr_solid).b=pos_attachment_pt;  
    OsteoArticularJoint(incr_solid).I=zeros(3,3);
    OsteoArticularJoint(incr_solid).c=-Forearm_ElbowJointNode';
    OsteoArticularJoint(incr_solid).anat_position=Elbow_J1_position_set;
    OsteoArticularJoint(incr_solid).Visual=0;
    OsteoArticularJoint(incr_solid).FunctionalAngle=[FullSide 'Elbow flexion(+)/extension(-)'] ;
    % Forearm
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % nom du solide
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularJoint(incr_solid).name=[Signe name];
    OsteoArticularJoint(incr_solid).sister=0;    
    OsteoArticularJoint(incr_solid).child=0;
    OsteoArticularJoint(incr_solid).mother=s_Elbow_J1;
    OsteoArticularJoint(incr_solid).a=[0 1 0]';
    OsteoArticularJoint(incr_solid).joint=1;
    if Signe == 'R'
        OsteoArticularJoint(incr_solid).limit_inf=0;
        OsteoArticularJoint(incr_solid).limit_sup=pi;
        OsteoArticularJoint(incr_solid).FunctionalAngle='Right Forearm Pronation(+)';
    else
        OsteoArticularJoint(incr_solid).limit_inf=-pi;
        OsteoArticularJoint(incr_solid).limit_sup=0;
        OsteoArticularJoint(incr_solid).FunctionalAngle='Left Forearm Pronation(-)';
    end
    OsteoArticularJoint(incr_solid).m=Mass.Forearm_Mass;
    OsteoArticularJoint(incr_solid).b=[0 0 0]';
    OsteoArticularJoint(incr_solid).I=[I_Forearm(1) I_Forearm(4) I_Forearm(5); I_Forearm(4) I_Forearm(2) I_Forearm(6); I_Forearm(5) I_Forearm(6) I_Forearm(3)];
    OsteoArticularJoint(incr_solid).c=-Forearm_ElbowJointNode';
    OsteoArticularJoint(incr_solid).anat_position=Forearm_position_set;
    OsteoArticularJoint(incr_solid).Visual=1;
    OsteoArticularJoint(incr_solid).visual_file = ['Holzbaur/radius_' Signe '.mat'];
    OsteoArticularJoint(incr_solid).L={[Signe 'Forearm_ElbowJointNode'];[Signe 'Forearm_WristJointNode']};
end