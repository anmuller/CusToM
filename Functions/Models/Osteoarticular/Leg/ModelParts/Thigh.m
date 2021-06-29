function [OsteoArticularModel]= Thigh(OsteoArticularModel,k,Signe,Mass,AttachmentPoint)
% Addition of a thigh model
%   This thigh model contains one solid (thigh), exhibits 3 dof for the hip
%
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
list_solid={'Hip_J1' 'Hip_J2' 'Thigh'};

%% Choose jambe right or left
if Signe == 'R'
Mirror=[1 0 0; 0 1 0; 0 0 1];
else
    if Signe == 'L'
    Mirror=[1 0 0; 0 1 0; 0 0 -1];
    end
end

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

%%                      Definition of anatomical landmarks (joint)

% ---------------------------- Thigh --------------------------------------

% Node locations
Thigh_KneeJointNode = (k*[-0.025 -0.2580 -0.028])*Mirror;
Thigh_HipJointNode = (k*[0 0.197 -0.038])*Mirror;

%% Definition of anatomical landmarks

Thigh_position_set = {...
    [Signe 'KNE'], k*Mirror*[-0.020623 -0.27 0.035]'; ...
    [Signe 'Thigh_KneeJointNode'], Thigh_KneeJointNode'; ...
    [Signe 'Thigh_HipJointNode'], Thigh_HipJointNode'; ...
    ['CondylusMedialis' Signe 'Thigh'],k*Mirror*[-0.025;-0.29;-0.028];...
    ['GluteusMinimus' Signe 'Thigh'],k*Mirror*[0.003;0.173;0.037];...
    ['GluteusMedius' Signe 'Thigh'],k*Mirror*[-0.010;0.177;0.032];...
    ['GluteusMaximus3' Signe 'Thigh'],k*Mirror*[-0.016;0.075;0.009];...
    ['GluteusMaximus3Via2' Signe 'Thigh'],k*Mirror*[-0.045;0.16;-0.01];...
    ['AdductorLongus' Signe 'Thigh'],k*Mirror*[-0.010;0.0;-0.006];...
    ['AdductorMagnus1' Signe 'Thigh'],k*Mirror*[-0.021;0.078;0.009];...
    ['AdductorMagnus2' Signe 'Thigh'],k*Mirror*[-0.015;-0.029;0.001];...
    ['AdductorMagnus3' Signe 'Thigh'],k*Mirror*[-0.025;-0.226;-0.044];...
    ['Iliopsoas' Signe 'Thigh'],k*Mirror*[0.001;0.120;-0.008];...
    ['VastusLateralis' Signe 'Thigh'],k*Mirror*[0.0;0.0;0.013];...
    ['VastusMedialis' Signe 'Thigh'],k*Mirror*[0.0;0.041;-0.014];...
    ['VastusIntermedius' Signe 'Thigh'],k*Mirror*[0.014;0.0;0.0];...
    ['BicepsFemorisCaputBreve' Signe 'Thigh'],k*Mirror*[-0.014;-0.054;0.0];...
    ['Gastrocnemius' Signe 'Thigh'],k*Mirror*[-0.028;-0.237;-0.023];...
    ['QuadratusFemoris' Signe 'Thigh'],k*Mirror*[-0.025;0.15;0.02];...
    ['AbductorBrevis' Signe 'Thigh'],k*Mirror*[-0.0;0.04;-0.014];...
    ['ObturatoriusExternus' Signe 'Thigh'],k*Mirror*[-0.017;0.17;0.013];...
    ['ObturatoriusInternus' Signe 'Thigh'],k*Mirror*[0.01;0.182;0.019];...
    ['Pectineus' Signe 'Thigh'],k*Mirror*[-0.025;0.10;-0.004];...
    ['GemellusSuperior' Signe 'Thigh'],k*Mirror*[0.013;0.182;0.019];...
    ['GemellusInferior' Signe 'Thigh'],k*Mirror*[0.007;0.182;0.019];...
    ['Piriformis' Signe 'Thigh'],k*Mirror*[0.013;0.183;0.028];...
    ['SartoriusVia1' Signe 'Thigh'],k*Mirror*[0.045;0;-0.03];...
    ['TensorFasciaeLataeVia2' Signe 'Thigh'],k*Mirror*[-0.010;0.13;0.042];...
    ['GluteusMaximus2Via3' Signe 'Thigh'],k*Mirror*[-0.045;0.16;-0.01];...
    ['QuadricepsVia1' Signe 'Thigh'],k*Mirror*[0.021;-0.264;-0.018];...
    ['QuadricepsVia2' Signe 'Thigh'],k*Mirror*[0.007;-0.30;-0.018];...
    ['GluteusMaximus1Via2' Signe 'Thigh'],k*Mirror*[-0.020;0.16;0.045]...
    };


%%                     Scaling inertial parameters


%% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
% ---------------------------- Thigh --------------------------------------
Length_Thigh=norm(Thigh_KneeJointNode-Thigh_HipJointNode);
[I_Thigh]=rgyration2inertia([29 15 30 7 2*1i 7*1i], Mass.Thigh_Mass, [0 0 0], Length_Thigh, Signe);

            %% Création de la structure "Human_model"
    
num_solid=0;
%% Thigh
    % Hip_J1
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % nom du solide
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=[Signe name];   % name of the solid ('R' or 'L' in prefix)
    OsteoArticularModel(incr_solid).sister=0;                 % sister : defined as an input of the function   
    OsteoArticularModel(incr_solid).child=s_Hip_J2;                % child : Shank
    OsteoArticularModel(incr_solid).mother=s_mother;                 % mother : defined as an input of the function  
    OsteoArticularModel(incr_solid).a=[0 0 1]';                    % rotation /z
    OsteoArticularModel(incr_solid).joint=1;                        % pin joint
    OsteoArticularModel(incr_solid).limit_inf=-pi/4;               % inferior joint biomechanical stop
    OsteoArticularModel(incr_solid).limit_sup=2*pi/3;                % superior joint biomechanical stop
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).m=0;                           % reference mass
    OsteoArticularModel(incr_solid).b=pos_attachment_pt;              % attachment point with respect to the parent's frame
    OsteoArticularModel(incr_solid).I=zeros(3,3);                  % reference inertia matrix
    OsteoArticularModel(incr_solid).c=[0 0 0]';                    % center of mass location in the local frame
    OsteoArticularModel(incr_solid).calib_k_constraint=[];   
    OsteoArticularModel(incr_solid).u=[];                          % fixed rotation with respect to u axis of theta angle
    OsteoArticularModel(incr_solid).theta=[];
    OsteoArticularModel(incr_solid).KinematicsCut=[];              % kinematic cut
    OsteoArticularModel(incr_solid).ClosedLoop=[];                 % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
    OsteoArticularModel(incr_solid).linear_constraint=[];
    OsteoArticularModel(incr_solid).comment='Hip Flexion(+)/Extension(-) - Z-Rotation';
    
    % Hip_J2
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % nom du solide
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=[Signe name];
    OsteoArticularModel(incr_solid).sister=0;                
    OsteoArticularModel(incr_solid).child=s_Thigh;                   
    OsteoArticularModel(incr_solid).mother=s_Hip_J1;           
    OsteoArticularModel(incr_solid).a=[1 0 0]'; 
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/4;
    OsteoArticularModel(incr_solid).limit_sup=pi/4;
    OsteoArticularModel(incr_solid).Visual=0;
    OsteoArticularModel(incr_solid).m=0;                 
    OsteoArticularModel(incr_solid).b=[0 0 0]';  
    OsteoArticularModel(incr_solid).I=zeros(3,3);
    OsteoArticularModel(incr_solid).c=[0 0 0]';
    if Signe=='R'
        OsteoArticularModel(incr_solid).comment='Hip Abduction(-)/Adduction(+) - X-Rotation';
    else
        OsteoArticularModel(incr_solid).comment='Hip Abduction(+)/Adduction(-) - X-Rotation';
    end
    % Thigh
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % nom du solide
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=[Signe name];
    OsteoArticularModel(incr_solid).sister=0;    
    OsteoArticularModel(incr_solid).child=0;
    OsteoArticularModel(incr_solid).mother=s_Hip_J2;
    OsteoArticularModel(incr_solid).a=[0 1 0]';
    OsteoArticularModel(incr_solid).joint=1;
    OsteoArticularModel(incr_solid).limit_inf=-pi/2;
    OsteoArticularModel(incr_solid).limit_sup=pi/2;
    OsteoArticularModel(incr_solid).Visual=1;
    OsteoArticularModel(incr_solid).m=Mass.Thigh_Mass;
    OsteoArticularModel(incr_solid).b=[0 0 0]';
    OsteoArticularModel(incr_solid).I=[I_Thigh(1) I_Thigh(4) I_Thigh(5); I_Thigh(4) I_Thigh(2) I_Thigh(6); I_Thigh(5) I_Thigh(6) I_Thigh(3)];
    OsteoArticularModel(incr_solid).c=-Thigh_HipJointNode';
    OsteoArticularModel(incr_solid).anat_position=Thigh_position_set;
    OsteoArticularModel(incr_solid).L={[Signe 'Thigh_HipJointNode'];[Signe 'Thigh_KneeJointNode']};
    if Signe=='R'
        OsteoArticularModel(incr_solid).comment='Hip Internal(+)/External(-) Rotation';
    else
        OsteoArticularModel(incr_solid).comment='Hip Internal(-)/External(+) Rotation';
    end

end
