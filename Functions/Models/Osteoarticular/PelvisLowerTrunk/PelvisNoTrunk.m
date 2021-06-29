function [OsteoArticularModel]= PelvisNoTrunk(OsteoArticularModel,k,Mass,AttachmentPoint)
% Addition of a pelvis model
%   This foot model contains one solid (pelvis), exhibits 0 dof
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
list_solid={'PelvisSacrum'};
    
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

% ------------------------- Pelvis ----------------------------------------

% Center of mass location with respect to the reference frame
CoM_Pelvis = k*[0.038 -0.050 0];

% Node locations
Pelvis_HipJointRightNode = k*[0.03 -0.10 0.08] - CoM_Pelvis;
Pelvis_HipJointLeftNode = k*[0.03 -0.10 -0.08] - CoM_Pelvis;
Pelvis_HipJointsCenterNode = k*[0.03 -0.10 0] - CoM_Pelvis;
Pelvis_SacrumJointNode = k*[0.027 -0.030 0] - CoM_Pelvis;

% ------------------------- Sacrum ----------------------------------------

% Node locations
Sacrum_L5JointNode = k*[0.043 -0.005 0];
Sacrum_PelvisJointNode = k*[0.027 -0.030 0];

%% Definition of anatomical landmarks

Pelvis_position_set= {...
    'RFWT', k*[0.08 0.01 0.14]'; ...
    'LFWT', k*[0.08 0.01 -0.14]'; ...
    'RBWT', k*[-0.09 0.02 0.04]'; ...
    'LBWT', k*[-0.09 0.02 -0.04]'; ...
    'Pelvis_HipJointRightNode', Pelvis_HipJointRightNode'; ...
    'Pelvis_HipJointLeftNode', Pelvis_HipJointLeftNode'; ...
    'Pelvis_LowerTrunkNode', Pelvis_SacrumJointNode' + (Sacrum_L5JointNode-Sacrum_PelvisJointNode)';  ...
    'Pelvis_L5JointNode', Pelvis_SacrumJointNode'-Sacrum_L5JointNode'; ...
    'Pelvis_SacrumJointNode', Pelvis_SacrumJointNode'; ...
    'Pelvis_HipJointsCenterNode', Pelvis_HipJointsCenterNode'; ...
    'CoMPelvis', k*[0 0 0]';...
    };
Side={{'R';[1 0 0;0 1 0;0 0 1]},{'L';[1 0 0;0 1 0;0 0 -1]}};
for i=1:2 % anatomical landmarks on each side
    Signe=Side{i}{1}; Mirror=Side{i}{2};
    Pelvis_position_set = [Pelvis_position_set;
        {...
            ['GluteusMinimus1' Signe 'Pelvis'],k*Mirror*([0.024;-0.035;0.132]-CoM_Pelvis');...
            ['GluteusMinimus2' Signe 'Pelvis'],k*Mirror*([0.007;-0.025;0.107]-CoM_Pelvis');...
            ['GluteusMinimus3' Signe 'Pelvis'],k*Mirror*([-0.016;-0.035;0.078]-CoM_Pelvis');...
            ['GluteusMedius1' Signe 'Pelvis'],k*Mirror*([0.057;-0.022;0.143]-CoM_Pelvis');...
            ['GluteusMedius2' Signe 'Pelvis'],k*Mirror*([0.010;0.034;0.112]-CoM_Pelvis');...
            ['GluteusMedius3' Signe 'Pelvis'],k*Mirror*([-0.040;0.021;0.062]-CoM_Pelvis');...
            ['GluteusMaximus1' Signe 'Pelvis'],k*Mirror*([-0.043;-0.009;0.052]-CoM_Pelvis');...
            ['GluteusMaximus1Via1' Signe 'Pelvis'],k*Mirror*([-0.050;-0.075;0.12]-CoM_Pelvis');...
            ['GluteusMaximus2' Signe 'Pelvis'],k*Mirror*([-0.046;-0.039;0.041]-CoM_Pelvis');...
            ['GluteusMaximus2Via1' Signe 'Pelvis'],k*Mirror*([-0.060;-0.07;0.07]-CoM_Pelvis');...
            ['GluteusMaximus2Via2' Signe 'Pelvis'],k*Mirror*([-0.060;-0.105;0.10]-CoM_Pelvis');...
            ['GluteusMaximus3' Signe 'Pelvis'],k*Mirror*([-0.038;-0.067;0.018]-CoM_Pelvis');...
            ['GluteusMaximus3Via1' Signe 'Pelvis'],k*Mirror*([-0.060;-0.173;0.060]-CoM_Pelvis');...
            ['TensorFasciaeLatae' Signe 'Pelvis'],k*Mirror*([0.068;-0.038;0.152]-CoM_Pelvis');...
            ['Piriformis' Signe 'Pelvis'],k*Mirror*([-0.038;-0.058;0.037]-CoM_Pelvis');...
            ['PiriformisVia' Signe 'Pelvis'],k*Mirror*([-0.02;-0.095;0.106]-CoM_Pelvis');...
            ['AdductorLongus' Signe 'Pelvis'],k*Mirror*([0.074;-0.166;0.024]-CoM_Pelvis');...
            ['AdductorMagnus' Signe 'Pelvis'],k*Mirror*([-0.004;-0.197;0.022]-CoM_Pelvis');...
            ['RectusFemoris' Signe 'Pelvis'],k*Mirror*([0.031;-0.093;0.116]-CoM_Pelvis');...
            ['Semitendinosus' Signe 'Pelvis'],k*Mirror*([-0.058;-0.178;0.055]-CoM_Pelvis');...
            ['Semimembranosus' Signe 'Pelvis'],k*Mirror*([-0.058;-0.178;0.055]-CoM_Pelvis');...
            ['BicepsFemorisCaputLongum' Signe 'Pelvis'],k*Mirror*([-0.058;-0.178;0.055]-CoM_Pelvis');...
            ['Iliopsoas' Signe 'Pelvis'],k*Mirror*([0.030;0.015;0.096]-CoM_Pelvis');...
            ['IliopsoasVia1' Signe 'Pelvis'],k*Mirror*([0.042;-0.111;0.093]-CoM_Pelvis');...
            ['Sartorius' Signe 'Pelvis'],k*Mirror*([0.068;-0.038;0.152]-CoM_Pelvis');...
            ['Gracilis' Signe 'Pelvis'],k*Mirror*([0.035;-0.181;0.023]-CoM_Pelvis');... 
            ['QuadratusFemoris' Signe 'Pelvis'],k*Mirror*([-0.01;-0.16;0.06]-CoM_Pelvis');...
            ['AbductorBrevis' Signe 'Pelvis'],k*Mirror*([0.045;-0.16;0.045]-CoM_Pelvis');...
            ['ObturatoriusExternus' Signe 'Pelvis'],k*Mirror*([-0.015;-0.17;0.05]-CoM_Pelvis');...
            ['ObturatoriusInternus' Signe 'Pelvis'],k*Mirror*([-0.03;-0.17;0.04]-CoM_Pelvis');...
            ['ObturatoriusInternusVia' Signe 'Pelvis'],k*Mirror*(0.5*([-0.025;0.01;0.01]+[-0.025;-0.015;0.02])-CoM_Pelvis');...  
            ['ObturatoriusInternusVia2' Signe 'Pelvis'],k*Mirror*([-0.044;-0.13;0.055]-CoM_Pelvis');...   
            ['Pictineus' Signe 'Pelvis'],k*Mirror*([0.065;-0.15;0.045]-CoM_Pelvis');...
            ['GemellusInferior' Signe 'Pelvis'],k*Mirror*([-0.05;-0.15;0.055]-CoM_Pelvis');...
            ['GemellusSuperior' Signe 'Pelvis'],k*Mirror*([-0.04;-0.11;0.045]-CoM_Pelvis');...
            ['GemellusSuperiorVia' Signe 'Pelvis'],k*Mirror*([-0.025;0.01;0.01]-CoM_Pelvis');...
            ['GemellusInferiorVia' Signe 'Pelvis'],k*Mirror*([-0.025;-0.015;0.02]-CoM_Pelvis');...
        }]; %#ok<AGROW>
end

%%                     Scaling inertial parameters

    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % ------------------------- Pelvis ----------------------------------------
    Lenght_Pelvis = norm(Pelvis_SacrumJointNode-Pelvis_HipJointsCenterNode+Sacrum_L5JointNode-Sacrum_PelvisJointNode);
    [I_Pelvis]=rgyration2inertia([101 106 95 25*1i 12*1i 8*1i], Mass.Pelvis_Mass, [0 0 0], Lenght_Pelvis);

                    %% Structure generation
 
num_solid=0;
%% Pelvis
    % Pelvis
    num_solid=num_solid+1;        % number of the solid ...
    name=list_solid{num_solid}; % solid name
    eval(['incr_solid=s_' name ';'])  % number of the solid in the model
    OsteoArticularModel(incr_solid).name=name;               % solid name
    OsteoArticularModel(incr_solid).sister=0;                      % sister
    OsteoArticularModel(incr_solid).child=0;       % child
    OsteoArticularModel(incr_solid).mother=s_mother;                      % mother
    OsteoArticularModel(incr_solid).a=[0 0 0]';                    % axe de rotation
    OsteoArticularModel(incr_solid).joint=1;                       % type d'articulation : 1:pivot / 2:glissière
    OsteoArticularModel(incr_solid).calib_k_constraint=[];         % initialisation des contraintes d'optimisation pour la calibration de la longueur des membres
    OsteoArticularModel(incr_solid).u=[];                          % fixed rotation with respect to u axis of theta angle
    OsteoArticularModel(incr_solid).theta=[];
    OsteoArticularModel(incr_solid).KinematicsCut=[];              % kinematic cut
    OsteoArticularModel(incr_solid).ClosedLoop=[];                 % if this solid close a closed-loop chain : {number of solid i on which is attached this solid ; attachement point (local frame of solid i}
    OsteoArticularModel(incr_solid).Visual=1;                      % 1 si il y a un visuel associé / 0 sinon
    OsteoArticularModel(incr_solid).b=pos_attachment_pt;                    % attachment point with respect to the parent's frame
    OsteoArticularModel(incr_solid).c=[0 0 0]';                    % center of mass location in the local frame
    OsteoArticularModel(incr_solid).m=Mass.Pelvis_Mass;                 % masse
    OsteoArticularModel(incr_solid).I=[I_Pelvis(1) I_Pelvis(4) I_Pelvis(5); I_Pelvis(4) I_Pelvis(2) I_Pelvis(6); I_Pelvis(5) I_Pelvis(6) I_Pelvis(3)];                  % reference inertia matrix
    OsteoArticularModel(incr_solid).anat_position=Pelvis_position_set;
    OsteoArticularModel(incr_solid).linear_constraint=[];
    OsteoArticularModel(incr_solid).L={'Pelvis_HipJointsCenterNode';'Pelvis_LowerTrunkNode'};
    OsteoArticularModel(incr_solid).limit_alpha= [];
    OsteoArticularModel(incr_solid).v= [] ;
    
end
