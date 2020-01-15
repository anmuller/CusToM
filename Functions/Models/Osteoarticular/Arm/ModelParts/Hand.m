function [OsteoArticularModel]= Hand(OsteoArticularModel,k,Signe,Mass,AttachmentPoint)
% Addition of a hand model
%   This forearm model contains one solid (hand), exhibits 2 dof for the
%   wrist
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the hand model ('R' for right side or 'L' for left side)
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
list_solid={'Wrist_J1' 'Hand'};

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
        [OsteoArticularModel]=sister_actualize(OsteoArticularModel,OsteoArticularModel(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la derni�re soeur
    end
end

%%                     Node Definition

% ------------------------- Hand ------------------------------------------

% Node positions
Hand_WristJointNode = (k*[0 0.0528 0])*Mirror;
Hand_EndNode = (k*[0 -0.1416 0])*Mirror;

%%              Definition of anatomical landmarks

Hand_position_set= {...
    [Signe 'Hand_WristJointNode'], Hand_WristJointNode'; ...
    [Signe 'Hand_EndNode'], Hand_EndNode'; ...
    % 1 marker on the hand
    [Signe 'CAR1'], k*Mirror*[-0.02 -0.045 0]'; ...
    % 2 markers on the hand
    [Signe 'CAR2'], k*Mirror*[-0.02 -0.045 0.025]'; ...
    [Signe 'OHAND'], k*Mirror*[-0.02 -0.025 -0.035]'; ...
    % 3 markers on the hand
    [Signe 'CAR3'], k*Mirror*[-0.02 0 0]'; ...
    [Signe 'IDX3'], k*Mirror*[-0.02 -0.09 0.025]'; ...
    [Signe 'PNK3'], k*Mirror*[-0.02 -0.095 -0.02]'; ...
    % Force Prediction
    [Signe 'HandPrediction1'], k*Mirror*[0.015 0 0]';...
    [Signe 'HandPrediction2'], k*Mirror*[0.015 0.02 -0.02]';...
    [Signe 'HandPrediction3'], k*Mirror*[0.015 0.02 0.02]';...
    [Signe 'HandPrediction4'], k*Mirror*[0.015 0.04 0]';...
    [Signe 'HandPrediction5'], k*Mirror*[0.015 -0.02 -0.03]';...
    [Signe 'HandPrediction6'], k*Mirror*[0.015 -0.03 0]';...
    [Signe 'HandPrediction7'], k*Mirror*[0.015 -0.025 0.03]';...
    [Signe 'HandPrediction8'], k*Mirror*[0.015 -0.06 -0.04]';...
    [Signe 'HandPrediction9'], k*Mirror*[0.015 -0.07 0]';...
    [Signe 'HandPrediction10'], k*Mirror*[0.015 -0.06 0.03]';...
    [Signe 'HandPrediction11'], k*Mirror*[0.015 -0.01 0.05]';...
    % TO BE MODIFIED
    [Signe 'Hand_CubitalisAnterior_i'],[0 0 0]';
    [Signe 'Hand_FlexorCarpiUlnaris_i'],[0 0 0]';
    [Signe 'Hand_ExtensorCarpiUlnaris_i'],[0 0 0]';
    [Signe 'Hand_ExtensorDigitorum_i'],[0 0 0]';
    [Signe 'Hand_FlexorDigitorumSuperior_i'],[0 0 0]';
    [Signe 'Hand_FlexorCapriRadialis_i'],[0 0 0]';
    [Signe 'Hand_AbductorDigitiV_i'],[0 0 0]';
    };


%%                     Scaling inertial parameters

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % ------------------------- Hand ------------------------------------------
    Length_Hand=norm(Hand_WristJointNode-Hand_EndNode);
    [I_Hand]=rgyration2inertia([61 38 56 22 15 20*1i], Mass.Hand_Mass, [0 0 0], Length_Hand, Signe);  

                %% "Human_model" structure generation

num_solid=0;
%% Hand
    % Wrist_J1
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % name of the solid
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=[Signe name];
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=s_Hand;                   
    OsteoArticularModel(incr_solid).mother=s_mother;           
    OsteoArticularModel(incr_solid).a=[0 0 1]';
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/2;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).b=pos_attachment_pt;  
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    OsteoArticularModel(incr_solid).Visual=0;
    
    % Hand
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % name of the solid
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=[Signe name];
    OsteoArticularModel(incr_solid).sister=0;    
    OsteoArticularModel(incr_solid).child=0;
    OsteoArticularModel(incr_solid).mother=s_Wrist_J1;
    OsteoArticularModel(incr_solid).a=[1 0 0]';
    OsteoArticularModel(incr_solid).joint=1;
    if Signe == 'R'
        OsteoArticularModel(incr_solid).limit_inf=-pi/4;
        OsteoArticularModel(incr_solid).limit_sup=pi/2;
    else
        OsteoArticularModel(incr_solid).limit_inf=-pi/2;
        OsteoArticularModel(incr_solid).limit_sup=pi/4;
    end
    OsteoArticularModel(incr_solid).m=Mass.Hand_Mass;
    OsteoArticularModel(incr_solid).b=[0 0 0]';
    OsteoArticularModel(incr_solid).I=[I_Hand(1) I_Hand(4) I_Hand(5); I_Hand(4) I_Hand(2) I_Hand(6); I_Hand(5) I_Hand(6) I_Hand(3)];
    OsteoArticularModel(incr_solid).c=-Hand_WristJointNode';
    OsteoArticularModel(incr_solid).anat_position=Hand_position_set;
    OsteoArticularModel(incr_solid).Visual=1;
    OsteoArticularModel(incr_solid).L={[Signe 'Hand_WristJointNode'];[Signe 'Hand_EndNode']};

end