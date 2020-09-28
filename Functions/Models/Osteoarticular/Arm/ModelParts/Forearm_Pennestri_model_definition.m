function [Human_model]= Forearm_Pennestri_model_definition(Human_model,k,Signe,Mass,varargin)
% Addition of an forearm model
%
%	Based on:
%	-Pennestrì, E., Stefanelli, R., Valentini, P. P., & Vita, L. (2007).
%Virtual musculo-skeletal model for the biomechanical analysis of the upper limb.
% Journal of Biomechanics, 40(6), 1350–1361. https://doi.org/10.1016/j.jbiomech.2006.05.013
%
%   INPUT
%   - Human_model: osteo-articular model of an already existing
%   model (see the Documentation for the structure)
%   - k: homothety coefficient for the geometrical parameters (defined as
%   the subject size in cm divided by 180)
%   - Signe: side of the arm model ('R' for right side or 'L' for left side)
%   - Mass: mass of the solids
%   - AttachmentPoint: name of the attachment point of the model on the
%   already existing model (character string)
%   OUTPUT
%   - Human_model: new osteo-articular model (see the Documentation
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


%% Liste des solides
list_solid={'Radius_J1' 'Radius_J2' 'Radius' 'Ulna' 'UlnaRadius_J1' 'UlnaRadius_J2' 'UlnaRadius_J3' 'UlnaRadius'};

%% Choix bras droite ou gauche
if Signe == 'R'
    Mirror=[1 0 0; 0 1 0; 0 0 1];
else
    if Signe == 'L'
        Mirror=[1 0 0; 0 1 0; 0 0 -1];
    end
end


%% Incr�mentation de la num�rotation des solides

s=size(Human_model,2)+1;  %#ok<NASGU> % num�ro du premier solide
for i=1:size(list_solid,2)      % num�rotation de chaque solide : s_"nom du solide"
    if i==1
        eval(strcat('s_',list_solid{i},'=s;'))
    else
        eval(strcat('s_',list_solid{i},'=s_',list_solid{i-1},'+1;'))
    end
end

% trouver le num�ro de la m�re � partir du nom du point d'attache : 'attachment_pt'
if numel(Human_model) == 0
    s_mother=0;
    pos_attachment_pt=[0 0 0]';
else
    attachment_pt=varargin{1};
    test=0;
    for i=1:numel(Human_model)
        for j=1:size(Human_model(i).anat_position,1)
            if strcmp(attachment_pt,Human_model(i).anat_position{j,1})
                s_mother=i;
                pos_attachment_pt=Human_model(i).anat_position{j,2}+Human_model(s_mother).c;
                test=1;
                break
            end
        end
        if i==numel(Human_model) && test==0
            error([attachment_pt ' is no existent'])
        end
    end
    if Human_model(s_mother).child == 0      % si la m�re n'a pas d'enfant
        Human_model(s_mother).child = eval(['s_' list_solid{1}]);    % l'enfant de cette m�re est ce solide
    else
        [Human_model]=sister_actualize(Human_model,Human_model(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la derni�re soeur
    end
end

%%                      D�finition des noeuds

% ------------------------- Radius ----------------------------------------

% Position des noeuds
Radius_ElbowJointNode = (k*[0 0.1741 0])*Mirror;
Radius_WristJointNode = (k*[0 -0.0887 0])*Mirror;
Radius_UlnaJointNode = (k*[0 -0.0777 -0.0382])*Mirror;

% ------------------------- Ulna ------------------------------------------

% Position des noeuds
Ulna_HumerusJointNode = (k*[0 0.1088 0])*Mirror;
Ulna_RadiusJointNode = (k*[0 -0.1430 0])*Mirror;


% Vector between RadiusElbow and UlnaElbow
Radius_Ulna_distal = (k*[0 0 -0.0382])*Mirror;

% ------------------------- Definition of rotation axis
Pro_supi_axis= Radius_ElbowJointNode - Radius_UlnaJointNode;
Pro_supi_axis=Pro_supi_axis'/norm(Pro_supi_axis);
Zrot=[0;0;1];
Xrot=cross(Pro_supi_axis,Zrot);
Xrot=Xrot'/norm(Xrot);


% Adaptation of (Pennestri et al., 2007) node positions
dr = 0.159;
er = 0.081;
cr = 0.071;
du = 0.078;
L_forearm = 0.2628;
k_Pennestri2custom = L_forearm/(cr+dr)*k*Mirror; % Forearm length homothety
%k_Pennestri2custom = L_forearm/(cr+dr)*k; % Forearm length homothety
Pennestri2custom = k_Pennestri2custom*[0 0 1;-1 0 0;0 -1 0];
%Pennestri2custom = [0 0 1;-1 0 0;0 -1 0];
bh = 2*0.0191/(L_forearm/(cr+dr));

% From OpenSim
Forearm_osim2antoine = [k (Radius_ElbowJointNode(2)-Radius_WristJointNode(2))/0.23559 k];
Radius_origin =Mirror*Forearm_osim2antoine'.*[0.0004 -0.011503 0.019999]';




% % ------------------------- Radius ----------------------------------------
% Radius_ElbowJointNode = Pennestri2custom* [-dr 0 0]';
% Radius_WristJointNode = Pennestri2custom* [er 0 0]';
% Radius_UlnaJointNode = Pennestri2custom* [cr bh 0]';
% 
% % ------------------------- Ulna ------------------------------------------
% Ulna_HumerusJointNode = Pennestri2custom* [-du 0 0]';
% Ulna_RadiusJointNode = Pennestri2custom* [cr+dr-du 0 0]';


%%              D�finition des positions anatomiques

Radius_position_set = {...
    [Signe 'RAD'], k*Mirror*[0 0.15 0.023]'; ...
    [Signe 'WRA'], k*Mirror*[0 -0.09 0.03]'; ...
    [Signe 'Forearm_WristJointNode'], Radius_WristJointNode'; ...
    [Signe 'Radius_UlnaJointNode'], Radius_UlnaJointNode';
%     [Signe 'Radius_SupinatorBrevis_i'], Radius_ElbowJointNode'+Pennestri2custom*[0.028 0.01 -0.01]';...
%     [Signe 'Radius_Brachialis_i'],Radius_ElbowJointNode'+Pennestri2custom*[0.033 0.005 0.001]';...
%     
%     [Signe 'Radius_Brachioradialis_i'], Radius_ElbowJointNode'+L_forearm/(cr+dr)*k*[0 0 -1;-1 0 0;0 -1 0]*[0.238 -0.012 0]';...
%         % Ajout d'un terme correctif
%     [Signe 'Radius_PronatorTeres_i'], Radius_ElbowJointNode'+k_Pennestri2custom*[0 0 -1;-1 0 0;0 -1 0]*[0.055 -0.011 0.024]' + k*Mirror*[0.01 0 -0.01]';... 
% 
%      [Signe 'Radius_PronatorQuadrus_i'], Radius_ElbowJointNode'+k_Pennestri2custom*[0 0 -1;-1 0 0;0 -1 0]*[0.236 -0.005 0.012]' + k*Mirror*[0  0 -0.01]';...

     
 %   [Signe 'Radius_TricepsBrachii2_o'], Radius_ElbowJointNode'+Pennestri2custom*[-0.025 0.02 -0.02]';...
    [Signe 'Thorax_TricepsBrachii2_i'],Radius_ElbowJointNode'+Pennestri2custom*[0.038 0.027 -0.02]';...
    
    
    
        % Muscles from Holzbaur model
    [Signe 'Radius_Brachioradialis_i'],Mirror*Forearm_osim2antoine'.*([0.0419;-0.221;0.0224]) + Radius_origin + Radius_Ulna_distal'   + Radius_ElbowJointNode';...
    [Signe 'Radius_Brachioradialis_VP2'], k*Mirror*[0.0240 ; -0.1134 ; -0.0053] + Radius_ElbowJointNode' ;... 
    
    [Signe 'Radius_SupinatorBrevis_o'],Mirror*Forearm_osim2antoine'.*([0.01201;-0.0517;-0.00107]) + Radius_origin + Radius_Ulna_distal'   + Radius_ElbowJointNode';...
    [Signe 'Radius_SupinatorBrevis_VP1'], k*Mirror*[0.0066 ; -0.0621 ; -0.0172] + Radius_ElbowJointNode' ;... 
    
    [Signe 'Radius_PronatorQuadratus_o'],Mirror*Forearm_osim2antoine'.*([0.03245;-0.19998;0.01962]) + Radius_origin + Radius_Ulna_distal'   + Radius_ElbowJointNode';...
    [Signe 'Radius_PronatorQuadratus_VP1'], k*Mirror*[-0.0103 ; -0.2328 ; -0.0320]  + Radius_ElbowJointNode' ;... 
    
    [Signe 'Radius_PronatorTeres_i'],Mirror*Forearm_osim2antoine'.*([0.0254;-0.1088;0.0198])+ Radius_origin + Radius_Ulna_distal'   + Radius_ElbowJointNode';...
     [Signe 'Radius_PronatorTeres_VP2'], k*Mirror*[0.0213 ; -0.1052 ; -0.0123] + Radius_ElbowJointNode' ;... 
    
    [Signe 'Radius_ExtensorCarpiRadialisLongus_VP2'], k*Mirror*[0.0233 ; -0.2154 ; -0.0043] + Radius_ElbowJointNode' ;... 
    [Signe 'Radius_ExtensorCarpiRadialisLongus_VP3'], k*Mirror*[-0.0086 ; -0.2263 ; 0.0230] + Radius_ElbowJointNode' ;... 
        
    [Signe 'Radius_ExtensorCarpiRadialisBrevis_VP2'], k*Mirror*[-0.0022 ; -0.0100 ; -0.0039] + Radius_ElbowJointNode' ;... 
    [Signe 'Radius_ExtensorCarpiRadialisBrevis_VP3'], k*Mirror*[-0.0230 ; -0.1614 ; 0.0086] + Radius_ElbowJointNode' ;... 
    
    [Signe 'Radius_ExtensorCarpiUlnaris_VP2'], k*Mirror*[-0.0038 ; -0.0177 ; -0.0067] + Radius_ElbowJointNode' ;... 
    [Signe 'Radius_ExtensorCarpiUlnaris_VP3'], k*Mirror*[-0.0003 ; -0.2431 ; -0.0246] + Radius_ElbowJointNode' ;... 
    
    [Signe 'Radius_FlexorCarpiUlnaris_VP2'], k*Mirror*[0.0025 ; -0.1029 ; -0.0244] + Radius_ElbowJointNode' ;... 
    [Signe 'Radius_FlexorCarpiUlnaris_VP3'], k*Mirror*[0.0195 ; -0.2406 ; -0.0149]  + Radius_ElbowJointNode' ;... 
    
    [Signe 'Radius_FlexorCarpiRadialis_VP2'], k*Mirror*[0.0064 ; -0.0939 ; -0.0237] + Radius_ElbowJointNode' ;... 
    [Signe 'Radius_FlexorCarpiRadialis_VP3'], k*Mirror*[0.0231 ; -0.2605 ; 0.0084]  + Radius_ElbowJointNode' ;... 
    
    [Signe 'Radius_PalmarisLongus_VP2'], k*Mirror*[0.0066 ; -0.0885 ; -0.0237] + Radius_ElbowJointNode' ;... 
    [Signe 'Radius_PalmarisLongus_VP3'], k*Mirror*[-0.0068 ; -0.3094 ; 0.0068] + Radius_ElbowJointNode' ;... 
    
    
    
    % Wraps
    ['Wrap' Signe 'RadiusQuadratus'],Mirror*[0.0281 -0.1986 0.0288]'+Radius_ElbowJointNode';...
       
 };

Ulna_position_set = {...
    [Signe 'WRB'], k*Mirror*[0 -0.1570 0]'; ...
%     [Signe 'Ulna_SupinatorBrevis_o'], Ulna_HumerusJointNode'+Pennestri2custom*[-0.013 -0.027 -0.012]' + k*Mirror*[0  0 0.02]';... % with manual correction
%     [Signe 'Ulna_AbductorDigitiV_o'], Ulna_HumerusJointNode'+Pennestri2custom*[0.115 -0.015 -0.005]';...
%     [Signe 'Ulna_PronatorQuadrus_o'], Ulna_HumerusJointNode'+Pennestri2custom*[0.2 0.012 0.009]';...
%     [Signe 'Ulna_TricepsBrachii1_i'], Ulna_HumerusJointNode'+Pennestri2custom*[0.038 -0.027 -0.015]';...
%     [Signe 'Ulna_Triceps_i'], Ulna_HumerusJointNode'+Pennestri2custom*[0.038 -0.027 -0.015]'+ k*Mirror*[-0.01  0.03 0]';...% with manual correction
%     [Signe 'Ulna_Anconeus_i'], Ulna_HumerusJointNode'+Pennestri2custom*[0.042 0.012 0.029]'+ k*Mirror*[0  0 -0.02]';...
%     [Signe 'Ulna_BicepsBrachii1_o'], Ulna_HumerusJointNode'-Pennestri2custom*[0 -0.015 0.01]';...
   % [Signe 'Thorax_BicepsBrachii1_i'],Ulna_HumerusJointNode'+Pennestri2custom*[0.038 0 0.01]';...
         [Signe 'Ulna_Biceps_i'], Ulna_HumerusJointNode'-Pennestri2custom*[0 -0.015 0.01]';...

    

     % Muscles from Holzbaur model


    [Signe 'Ulna_TricepsLat_i'],Mirror*Forearm_osim2antoine'.*([-0.0219;0.01046;-0.00078])+Ulna_HumerusJointNode' ;...
    [Signe 'Ulna_TricepsLat_VP2'], k*Mirror*[-0.0216 ; 0.0177 ; -0.0007] + Ulna_HumerusJointNode' ;... 
    
    [Signe 'Ulna_TricepsMed_i'],Mirror*Forearm_osim2antoine'.*([-0.0219;0.01046;-0.00078])+Ulna_HumerusJointNode'  ;...
    [Signe 'Ulna_TricepsMed_VP2'], k*Mirror*[-0.0205 ; 0.0181 ; -0.0034] + Ulna_HumerusJointNode' ;... 
    
    [Signe 'Ulna_Anconeus_i'],Mirror*Forearm_osim2antoine'.*([-0.02532;-0.00124;0.006])+Ulna_HumerusJointNode' ;...
    [Signe 'Ulna_Anconeus_VP2'], k*Mirror*[-0.0210 ; 0.0001 ; 0.0066] + Ulna_HumerusJointNode' ;... 
    
    [Signe 'Ulna_SupinatorBrevis_i'],Mirror*Forearm_osim2antoine'.*([-0.0136;-0.03384;0.02013])+Ulna_HumerusJointNode' ;...
    [Signe 'Ulna_SupinatorBrevis_VP2'], k*Mirror*[0.0101 ; -0.0631 ; 0.0279] + Ulna_HumerusJointNode' ;... 
 
   
    [Signe 'Ulna_Brachialis_i'],Mirror*Forearm_osim2antoine'.*([-0.0032;-0.0239;0.0009])+Ulna_HumerusJointNode' ;...
    [Signe 'Ulna_Brachialis_VP2'], k*Mirror*[0.0065 ; -0.0239 ; 0.0222] + Ulna_HumerusJointNode' ;... 
    
    [Signe 'Ulna_PronatorQuadratus_i'],Mirror*Forearm_osim2antoine'.*([0.00193;-0.20972;0.03632])+Ulna_HumerusJointNode';...
    [Signe 'Ulna_PronatorQuadratus_VP2'], k*Mirror*[0.0051 ; -0.2389 ; 0.0232] + Ulna_HumerusJointNode' ;... 
 
    };

    




%%                     Mise � l'�chelle des inerties


%% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
% Forearm
Forearm_Mass=Mass.Forearm_Mass;
Radius_Mass=Forearm_Mass*(0.498)/(0.498+0.752);
Ulna_Mass=Forearm_Mass*(0.752)/(0.498+0.752);
% ------------------------- Radius ----------------------------------------
Radius_radius_sagittal = k*0.033;
Radius_radius_transverse = k*0.079;
Radius_radius_longitudinal = k*0.079;
I_Radius=[Radius_radius_sagittal*Radius_radius_sagittal*Radius_Mass, Radius_radius_longitudinal*Radius_radius_longitudinal*Radius_Mass, Radius_radius_transverse*Radius_radius_transverse*Radius_Mass, 0, 0, 0];
% ------------------------- Ulna ------------------------------------------
Radius_ulna_sagittal = k*0.02;
Radius_ulna_transverse = k*0.0745;
Radius_ulna_longitudinal = k*0.0745;
I_Ulna=[Radius_ulna_sagittal*Radius_ulna_sagittal*Ulna_Mass, Radius_ulna_longitudinal*Radius_ulna_longitudinal*Ulna_Mass, Radius_ulna_transverse*Radius_ulna_transverse*Ulna_Mass, 0, 0, 0];



%% Cr�ation de la structure "Human_model"

num_solid=0;
%% Radius
% Radius_J1
num_solid=num_solid+1;        % solide num�ro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % num�ro du solide dans le mod�le
Human_model(incr_solid).name=[Signe name];
Human_model(incr_solid).sister=s_Ulna;
Human_model(incr_solid).child=s_Radius_J2;
Human_model(incr_solid).mother=s_mother;
Human_model(incr_solid).a=[0 0 1]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=0;
Human_model(incr_solid).limit_sup=pi;
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).m=0;
Human_model(incr_solid).b=pos_attachment_pt;
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';
Human_model(incr_solid).Visual=0;

% Radius_J2
num_solid=num_solid+1;        % solide num�ro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % num�ro du solide dans le mod�le
Human_model(incr_solid).name=[Signe name];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=s_Radius;
Human_model(incr_solid).mother=s_Radius_J1;
Human_model(incr_solid).a=[1 0 0]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi/4;
Human_model(incr_solid).limit_sup=pi/4;
Human_model(incr_solid).ActiveJoint=0;
Human_model(incr_solid).m=0;
Human_model(incr_solid).b=[0 0 0]';
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';
Human_model(incr_solid).Visual=0;

% Radius
num_solid=num_solid+1;        % solide num�ro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % num�ro du solide dans le mod�le
Human_model(incr_solid).name=[Signe name];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=0;
Human_model(incr_solid).mother=s_Radius_J2;
Human_model(incr_solid).a=[0 1 0]';
Human_model(incr_solid).joint=1;
if Signe == 'R'
    Human_model(incr_solid).limit_inf=0;
    Human_model(incr_solid).limit_sup=pi;
else
    Human_model(incr_solid).limit_inf=-pi;
    Human_model(incr_solid).limit_sup=0;
end
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).m=Radius_Mass;
% Human_model(incr_solid).Group=[n_group 2];
Human_model(incr_solid).b=[0 0 0]';
Human_model(incr_solid).I=[I_Radius(1) I_Radius(4) I_Radius(5); I_Radius(4) I_Radius(2) I_Radius(6); I_Radius(5) I_Radius(6) I_Radius(3)];
Human_model(incr_solid).c=-Radius_ElbowJointNode';
Human_model(incr_solid).anat_position=Radius_position_set;
Human_model(incr_solid).Visual=1;


% Wrapping 1
Human_model(incr_solid).wrap(1).name=['Wrap' Signe 'RadiusQuadratus'];
Human_model(incr_solid).wrap(1).anat_position=['Wrap' Signe 'RadiusQuadratus'];
Human_model(incr_solid).wrap(1).type='C'; % C: Cylinder or S: Sphere
Human_model(incr_solid).wrap(1).radius=k*0.01;
Human_model(incr_solid).wrap(1).R=[ -0.8998    0.4361   -0.0127;
                                            0.0046    0.0387    0.9992;
                                            0.4363    0.8990   -0.0368];
Human_model(incr_solid).wrap(1).location=Mirror*[0.0281 -0.1986 0.0288]'+Radius_ElbowJointNode';
Human_model(incr_solid).wrap(1).h=k*0.1;
Human_model(incr_solid).wrap(1).num_solid=incr_solid;


%% Ulna

% Ulna
num_solid=num_solid+1;        % solide num�ro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % num�ro du solide dans le mod�le
Human_model(incr_solid).name=[Signe name];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=s_UlnaRadius_J1;
Human_model(incr_solid).mother=s_mother;
Human_model(incr_solid).a=[0 0 1]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=0;
Human_model(incr_solid).limit_sup=pi;
Human_model(incr_solid).m=Ulna_Mass;
Human_model(incr_solid).I=[I_Ulna(1) I_Ulna(4) I_Ulna(5); I_Ulna(4) I_Ulna(2) I_Ulna(6); I_Ulna(5) I_Ulna(6) I_Ulna(3)];
Human_model(incr_solid).c=-Ulna_HumerusJointNode';
Human_model(incr_solid).ActiveJoint=0;
Human_model(incr_solid).b=pos_attachment_pt+(k*[0 0 -0.0382]*Mirror)';
Human_model(incr_solid).calib_k_constraint=s_Radius;
Human_model(incr_solid).anat_position=Ulna_position_set;
Human_model(incr_solid).Visual=1;

% UlnaRadius_J1
num_solid=num_solid+1;        % solide num�ro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % num�ro du solide dans le mod�le
Human_model(incr_solid).name=[Signe name];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=s_UlnaRadius_J2;
Human_model(incr_solid).mother=s_Ulna;
Human_model(incr_solid).a=[0 1 0]';
Human_model(incr_solid).joint=2;
Human_model(incr_solid).limit_inf=-0.1;
Human_model(incr_solid).limit_sup=0.1;
Human_model(incr_solid).ActiveJoint=0;
Human_model(incr_solid).m=0;
Human_model(incr_solid).b=(Ulna_RadiusJointNode-Ulna_HumerusJointNode)';
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';
Human_model(incr_solid).Visual=0;

% UlnaRadius_J2
num_solid=num_solid+1;        % solide num�ro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % num�ro du solide dans le mod�le
Human_model(incr_solid).name=[Signe name];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=s_UlnaRadius_J3;
Human_model(incr_solid).mother=s_UlnaRadius_J1;
Human_model(incr_solid).a=[0 0 1]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi;
Human_model(incr_solid).limit_sup=pi;
Human_model(incr_solid).ActiveJoint=0;
Human_model(incr_solid).m=0;
Human_model(incr_solid).b=[0 0 0]';
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';
Human_model(incr_solid).Visual=0;

% UlnaRadius_J3
num_solid=num_solid+1;        % solide num�ro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % num�ro du solide dans le mod�le
Human_model(incr_solid).name=[Signe name];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=s_UlnaRadius;
Human_model(incr_solid).mother=s_UlnaRadius_J2;
Human_model(incr_solid).a=[0 1 0]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi;
Human_model(incr_solid).limit_sup=pi;
Human_model(incr_solid).ActiveJoint=0;
Human_model(incr_solid).m=0;
Human_model(incr_solid).b=[0 0 0]';
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';
Human_model(incr_solid).Visual=0;

% UlnaRadius
num_solid=num_solid+1;        % solide num�ro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % num�ro du solide dans le mod�le
Human_model(incr_solid).name=[Signe name];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=0;
Human_model(incr_solid).mother=s_UlnaRadius_J3;
Human_model(incr_solid).a=[1 0 0]';
Human_model(incr_solid).m=0;
Human_model(incr_solid).b=[0 0 0]';
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi;
Human_model(incr_solid).limit_sup=pi;
Human_model(incr_solid).ActiveJoint=0;
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).ClosedLoop = [Signe 'Radius_UlnaJointNode'];
end