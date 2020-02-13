function [OsteoArticularModel]= Upperarm_Shoulder(OsteoArticularModel,k,Side,Mass,AttachmentPoint)
% Addition of an upper arm model
%   This upper arm model contains two solids (humerus, scapula), exhibits ? dof for the
%   shoulder
%
%   INPUT
%   - OsteoArticularModel: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Side: side of the upper arm model ('R' for right side or 'L' for left side)
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
list_solid={'Glenohumeral_J1' 'Glenohumeral_J2' 'Humerus'};

%% Choose right or left arm
if Side == 'R'
Mirror=[1 0 0; 0 1 0; 0 0 1];
else
    if Side == 'L'
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
        [OsteoArticularModel]=sister_actualize(OsteoArticularModel,OsteoArticularModel(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la derni�re soeur
    end
end

%%                      Node Definition

% ------------------------- Humerus ---------------------------------------

% Humerus centre of motion as defined in (Puchaud et al. 2019)
CoM_humerus = k*Mirror*[0.018064 -0.140141 -0.012746]';

% Node positions
Humerus_ghJointNode = (k*[0 0 0])*Mirror - CoM_humerus;
Humerus_ElbowJointNode = (k*[0 -0.1674 0])*Mirror;
Humerus_RadiusJointNode = (k*[0 -0.1674 0.0191])*Mirror;
Humerus_UlnaJointNode = (k*[0 -0.1674 -0.0191])*Mirror;


%%              Definition of anatomical landmarks

Humerus_position_set = {...
    [Side 'HUM'], k*Mirror*[0 -0.1674 -0.05]'; ...
    [Side 'Humerus_RadiusJointNode'], Humerus_RadiusJointNode'; ...
    [Side 'Humerus_UlnaJointNode'], Humerus_UlnaJointNode'; ...
    [Side 'Humerus_ElbowJointNode'], Humerus_ElbowJointNode'; ...
    [Side 'Humerus_ghJointNode'], Humerus_ghJointNode'; ...  
    % Muscle pathpoints as defined in (Puchaud et al. 2019)
    [Side '_humerus_DELT1-P1'],k*Mirror*([0.00896;-0.11883;0.00585])-CoM_humerus;...
    [Side '_humerus_DELT1-P2'],k*Mirror*([0.01623;-0.11033;0.00412])-CoM_humerus;...
    [Side '_humerus_DELT2-P1'],k*Mirror*([0.00461;-0.13611;0.0056])-CoM_humerus;...
    [Side '_humerus_DELT3-P3'],k*Mirror*([0.00206;-0.07602;0.01045])-CoM_humerus;...
    [Side '_humerus_SUPSP-P1'],k*Mirror*([0.00256;0.01063;0.02593])-CoM_humerus;...
    [Side '_humerus_INFSP-P1'],k*Mirror*([-0.00887;0.00484;0.02448])-CoM_humerus;...
    [Side '_humerus_SUBSC-P1'],k*Mirror*([0.01403;0.0084;-0.01331])-CoM_humerus;...
    [Side '_humerus_TMIN-P1'],k*Mirror*([-0.0011;-0.01264;0.02156])-CoM_humerus;...
    [Side '_humerus_TMAJ-P1'],k*Mirror*([0.00998;-0.05419;-0.00568])-CoM_humerus;...
    [Side '_humerus_PECM1-P1'],k*Mirror*([0.01169;-0.04191;0.0078])-CoM_humerus;...
    [Side '_humerus_PECM1-P2'],k*Mirror*([0.017133;-0.037;-0.00337])-CoM_humerus;...
    [Side '_humerus_PECM2-P1'],k*Mirror*([0.01274;-0.04289;0.00785])-CoM_humerus;...
    [Side '_humerus_PECM2-P2'],k*Mirror*([0.015513;-0.04223;-0.00447])-CoM_humerus;...
    [Side '_humerus_PECM3-P1'],k*Mirror*([0.01269;-0.04375;0.0075])-CoM_humerus;...
    [Side '_humerus_PECM3-P2'],k*Mirror*([0.014239;-0.049652;-0.0093637])-CoM_humerus;...
    [Side '_humerus_LAT1-P1'],k*Mirror*([0.0105;-0.03415;-0.00653])-CoM_humerus;...
    [Side '_humerus_LAT2-P1'],k*Mirror*([0.00968;-0.04071;-0.00611])-CoM_humerus;...
    [Side '_humerus_LAT3-P1'],k*Mirror*([0.01208;-0.03922;-0.00416])-CoM_humerus;...
    [Side '_humerus_CORB-P3'],k*Mirror*([0.00743;-0.15048;-0.00782])-CoM_humerus;...
    [Side '_humerus_TRIlong-P2'],k*Mirror*([-0.02714;-0.11441;-0.00664])-CoM_humerus;...
    [Side '_humerus_TRIlong-P3'],k*Mirror*([-0.03184;-0.22637;-0.01217])-CoM_humerus;...
    [Side '_humerus_TRIlong-P4'],k*Mirror*([-0.01743;-0.26757;-0.01208])-CoM_humerus;...
    [Side '_humerus_TRIlat-P1'],k*Mirror*([-0.00599;-0.12646;0.00428])-CoM_humerus;...
    [Side '_humerus_TRIlat-P2'],k*Mirror*([-0.02344;-0.14528;0.00928])-CoM_humerus;...
    [Side '_humerus_TRIlat-P3'],k*Mirror*([-0.03184;-0.22637;-0.01217])-CoM_humerus;...
    [Side '_humerus_TRIlat-P4'],k*Mirror*([-0.01743;-0.26757;-0.01208])-CoM_humerus;...
    [Side '_humerus_TRImed-P1'],k*Mirror*([-0.00838;-0.13695;-0.00906])-CoM_humerus;...
    [Side '_humerus_TRImed-P2'],k*Mirror*([-0.02601;-0.15139;-0.0108])-CoM_humerus;...
    [Side '_humerus_TRImed-P3'],k*Mirror*([-0.03184;-0.22637;-0.01217])-CoM_humerus;...
    [Side '_humerus_TRImed-P4'],k*Mirror*([-0.01743;-0.26757;-0.01208])-CoM_humerus;...
    [Side '_humerus_ANC-P1'],k*Mirror*([-0.00744;-0.28359;0.00979])-CoM_humerus;...
    [Side '_humerus_BIClong-P3'],k*Mirror*([0.02131;0.01793;0.01028])-CoM_humerus;...
    [Side '_humerus_BIClong-P4'],k*Mirror*([0.02378;-0.00511;0.01201])-CoM_humerus;...
    [Side '_humerus_BIClong-P5'],k*Mirror*([0.01345;-0.02827;0.00136])-CoM_humerus;...
    [Side '_humerus_BIClong-P6'],k*Mirror*([0.01068;-0.07736;-0.00165])-CoM_humerus;...
    [Side '_humerus_BIClong-P7'],k*Mirror*([0.01703;-0.12125;0.00024])-CoM_humerus;...
    [Side '_humerus_BIClong-P8'],k*Mirror*([0.0228;-0.1754;-0.0063])-CoM_humerus;...
    [Side '_humerus_BICshort-P3'],k*Mirror*([0.01117;-0.07576;-0.01101])-CoM_humerus;...
    [Side '_humerus_BICshort-P4'],k*Mirror*([0.01703;-0.12125;-0.01079])-CoM_humerus;...
    [Side '_humerus_BICshort-P5'],k*Mirror*([0.0228;-0.1754;-0.0063])-CoM_humerus;...
    [Side '_humerus_BRA-P1'],k*Mirror*([0.0068;-0.1739;-0.0036])-CoM_humerus;...
    [Side '_humerus_BRD-P1'],k*Mirror*([-0.0098;-0.19963;0.00223])-CoM_humerus;...
    [Side '_humerus_ECRL-P1'],k*Mirror*([-0.0073;-0.2609;0.0091])-CoM_humerus;...
    [Side '_humerus_ECRB-P1'],k*Mirror*([0.01349;-0.29048;0.01698])-CoM_humerus;...
    [Side '_humerus_ECU-P1'],k*Mirror*([0.00083;-0.28955;0.0188])-CoM_humerus;...
    [Side '_humerus_FCR-P1'],k*Mirror*([0.00758;-0.27806;-0.03705])-CoM_humerus;...
    [Side '_humerus_FCU-P1'],k*Mirror*([0.00219;-0.2774;-0.0388])-CoM_humerus;...
    [Side '_humerus_PL-P1'],k*Mirror*([0.00457;-0.27519;-0.03865])-CoM_humerus;...
    [Side '_humerus_PT-P1'],k*Mirror*([0.0036;-0.2759;-0.0365])-CoM_humerus;...
    [Side '_humerus_FDSL-P1'],k*Mirror*([0.00421;-0.27598;-0.03864])-CoM_humerus;...
    [Side '_humerus_FDSR-P1'],k*Mirror*([0.00479;-0.2788;-0.03731])-CoM_humerus;...
    [Side '_humerus_EDCL-P1'],k*Mirror*([-0.0004;-0.28831;0.0187])-CoM_humerus;...
    [Side '_humerus_EDCR-P1'],k*Mirror*([-0.00156;-0.28936;0.01782])-CoM_humerus;...
    [Side '_humerus_EDCM-P1'],k*Mirror*([0.00051;-0.28984;0.01949])-CoM_humerus;...
    };


%% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas

Length_Humerus=norm(Humerus_ghJointNode-Humerus_ElbowJointNode);
[I_Humerus]=rgyration2inertia([31 14 32 6 5 2], Mass.UpperArm_Mass, [0 0 0], Length_Humerus, Side);


%% "Human model" structure generation

num_solid=0;
% Glenohumeral_J1
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Side name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=s_Glenohumeral_J2;         % Solid's child
OsteoArticularModel(incr_solid).mother=s_mother;            % Solid's mother
OsteoArticularModel(incr_solid).a=[0 1 0]';                          
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=0;                        % Reference mass
OsteoArticularModel(incr_solid).b=pos_attachment_pt;        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;

% Glenohumeral_J2
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Side name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=s_Humerus;         % Solid's child
OsteoArticularModel(incr_solid).mother=s_Glenohumeral_J1;            % Solid's mother
OsteoArticularModel(incr_solid).a=[1 0 0]';                          
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=0;                        % Reference mass
OsteoArticularModel(incr_solid).b=[0 0 0]';        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=zeros(3,3);               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=[0 0 0]';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).Visual=0;

% Humerus
num_solid=num_solid+1;                                      % solid number
name=list_solid{num_solid};                                 % solid name
eval(['incr_solid=s_' name ';'])                            % solid number in model tree
OsteoArticularModel(incr_solid).name=[Side name];          % solid name with side
OsteoArticularModel(incr_solid).sister=0;                   % Solid's sister
OsteoArticularModel(incr_solid).child=0;                    % Solid's child
OsteoArticularModel(incr_solid).mother=s_Glenohumeral_J2;            % Solid's mother
OsteoArticularModel(incr_solid).a=[0 1 0]';                          
OsteoArticularModel(incr_solid).joint=1;
OsteoArticularModel(incr_solid).limit_inf=-2*pi/3;
OsteoArticularModel(incr_solid).limit_sup=2*pi/3;
OsteoArticularModel(incr_solid).ActiveJoint=1;
OsteoArticularModel(incr_solid).m=Mass.Humerus_Mass;                        % Reference mass
OsteoArticularModel(incr_solid).b=[0 0 0]';        % Attachment point position in mother's frame
OsteoArticularModel(incr_solid).I=[I_Humerus(1) I_Humerus(4) I_Humerus(5); I_Humerus(4) I_Humerus(2) I_Humerus(6); I_Humerus(5) I_Humerus(6) I_Humerus(3)];               % Reference inertia matrix
OsteoArticularModel(incr_solid).c=-Humerus_ghJointNode';                 % Centre of mass position in local frame
OsteoArticularModel(incr_solid).calib_k_constraint=[];
OsteoArticularModel(incr_solid).u=[];                       % fixed rotation with respect to u axis of theta angle
OsteoArticularModel(incr_solid).theta=[];
OsteoArticularModel(incr_solid).KinematicsCut=[];           % kinematic cut
OsteoArticularModel(incr_solid).ClosedLoop=[];              % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
OsteoArticularModel(incr_solid).linear_constraint=[];
OsteoArticularModel(incr_solid).anat_position=Humerus_position_set;
OsteoArticularModel(incr_solid).Visual=1;
OsteoArticularModel(incr_solid).Visual_file=['Holzbaur/humerus_' lower(Side) '.mat'];
OsteoArticularModel(incr_solid).L={[Side 'Humerus_ghJointNode'];[Side 'Humerus_ElbowJointNode']};

end