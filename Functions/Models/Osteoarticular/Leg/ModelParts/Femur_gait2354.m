function [Human_model]= Femur_gait2354(Human_model,k,Signe,Mass,AttachmentPoint)

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

%% Liste des solides
list_solid={'Hip_J1' 'Hip_J2' 'femur'};

%% Choix jambe droite ou gauche
if Signe == 'R'
    Mirror=[1 0 0; 0 1 0; 0 0 1];
else
    if Signe == 'L'
        Mirror=[1 0 0; 0 1 0; 0 0 -1];
    end
end

%% Incrémentation de la numérotation des solides

s=size(Human_model,2)+1;  %#ok<NASGU> % numéro du premier solide
for i=1:size(list_solid,2)      % numérotation de chaque solide : s_"nom du solide"
    if i==1
        eval(strcat('s_',list_solid{i},'=s;'))
    else
        eval(strcat('s_',list_solid{i},'=s_',list_solid{i-1},'+1;'))
    end
end

% trouver le numéro de la mère à partir du nom du point d'attache : 'attachment_pt'
if numel(Human_model) == 0
    s_mother=0;
    pos_attachment_pt=[0 0 0]';
else
    test=0;
    for i=1:numel(Human_model)
        for j=1:size(Human_model(i).anat_position,1)
            if strcmp(AttachmentPoint,Human_model(i).anat_position{j,1})
                s_mother=i;
                pos_attachment_pt=Human_model(i).anat_position{j,2}+Human_model(s_mother).c;
                test=1;
                break
            end
        end
        if i==numel(Human_model) && test==0
            error([AttachmentPoint ' is no existent'])
        end
    end
    if Human_model(s_mother).child == 0      % si la mère n'a pas d'enfant
        Human_model(s_mother).child = eval(['s_' list_solid{1}]);    % l'enfant de cette mère est ce solide
    else
        [Human_model]=sister_actualize(Human_model,Human_model(s_mother).child,eval(['s_' list_solid{1}]));   % recherche de la dernière soeur
    end
end

% ---------------------------- Thigh --------------------------------------

%Centre de masse
CoM_femur=(k*Mirror*[0; -0.17; 0]); % dans le repère femur

Thigh_HipJointNode = (k*Mirror*[0 ; 0 ;	0])             -CoM_femur;
Thigh_KneeJointNode = (k*Mirror*[-0.0045 ; -0.3958;0]) -CoM_femur;

%% Définition des positions anatomiques

Thigh_position_set = {...
    [Signe 'Thigh.Upper'],k*Mirror*([0.018;-0.2;0.064])-CoM_femur;...
    [Signe 'Thigh.Front'],k*Mirror*([0.08;-0.25;0.0047])-CoM_femur;...
    [Signe 'Thigh.Rear'],k*Mirror*([0.01;-0.3;0.06])-CoM_femur;...
    [Signe 'KNE'],k*Mirror*([0;-0.404;0.05])-CoM_femur;...
    [Signe 'KNEMED'],k*Mirror*([0;-0.404;-0.05])-CoM_femur;...    
    [Signe 'Thigh_HipJointNode'],Thigh_HipJointNode; ...
    [Signe 'Thigh_KneeJointNode'],Thigh_KneeJointNode; ...
    ['glut_med1_' lower(Signe) '-P2'],k*Mirror*([-0.0218;-0.0117;0.0555])-CoM_femur;...
    ['glut_med2_' lower(Signe) '-P2'],k*Mirror*([-0.0258;-0.0058;0.0527])-CoM_femur;...
    ['glut_med3_' lower(Signe) '-P2'],k*Mirror*([-0.0309;-0.0047;0.0518])-CoM_femur;...
    ['bifemsh_' lower(Signe) '-P1'],k*Mirror*([0.005;-0.2111;0.0234])-CoM_femur;...
    ['sar_' lower(Signe) '-P2'],k*Mirror*([-0.003;-0.3568;-0.0421])-CoM_femur;...
    ['add_mag2_' lower(Signe) '-P2'],k*Mirror*([0.0054;-0.2285;0.0227])-CoM_femur;...
    ['tfl_' lower(Signe) '-P2'],k*Mirror*([0.0294;-0.0995;0.0597])-CoM_femur;...
    ['tfl_' lower(Signe) '-P3'],k*Mirror*([0.0054;-0.4049;0.0357])-CoM_femur;...
    ['pect_' lower(Signe) '-P2'],k*Mirror*([-0.0122;-0.0822;0.0253])-CoM_femur;...
    ['glut_max1_' lower(Signe) '-P3'],k*Mirror*([-0.0457;-0.0248;0.0392])-CoM_femur;...
    ['glut_max1_' lower(Signe) '-P4'],k*Mirror*([-0.0277;-0.0566;0.047])-CoM_femur;...
    ['glut_max2_' lower(Signe) '-P3'],k*Mirror*([-0.0426;-0.053;0.0293])-CoM_femur;...
    ['glut_max2_' lower(Signe) '-P4'],k*Mirror*([-0.0156;-0.1016;0.0419])-CoM_femur;...
    ['glut_max3_' lower(Signe) '-P3'],k*Mirror*([-0.0299;-0.1041;0.0135])-CoM_femur;...
    ['glut_max3_' lower(Signe) '-P4'],k*Mirror*([-0.006;-0.1419;0.0411])-CoM_femur;...
    ['iliacus_' lower(Signe) '-P4'],k*Mirror*([0.0017;-0.0543;0.0057])-CoM_femur;...
    ['iliacus_' lower(Signe) '-P5'],k*Mirror*([-0.0193;-0.0621;0.0129])-CoM_femur;...
    ['psoas_' lower(Signe) '-P4'],k*Mirror*([0.0016;-0.0507;0.0038])-CoM_femur;...
    ['psoas_' lower(Signe) '-P5'],k*Mirror*([-0.0188;-0.0597;0.0104])-CoM_femur;...
    ['quad_fem_' lower(Signe) '-P2'],k*Mirror*([-0.0381;-0.0359;0.0366])-CoM_femur;...
    ['gem_' lower(Signe) '-P2'],k*Mirror*([-0.0142;-0.0033;0.0443])-CoM_femur;...
    ['peri_' lower(Signe) '-P3'],k*Mirror*([-0.0148;-0.0036;0.0437])-CoM_femur;...
    ['vas_int_' lower(Signe) '-P1'],k*Mirror*([0.029;-0.1924;0.031])-CoM_femur;...
    ['vas_int_' lower(Signe) '-P2'],k*Mirror*([0.0335;-0.2084;0.0285])-CoM_femur;...
    ['med_gas_' lower(Signe) '-P1'],k*Mirror*([-0.019;-0.3929;-0.0235])-CoM_femur;...
    ['med_gas_' lower(Signe) '-P2'],k*Mirror*([-0.030000;-0.40220;-0.025800])-CoM_femur;...
    };


%%                     Mise à l'échelle des inerties
    %% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
    % ---------------------------- Thigh --------------------------------------
    Length_Thigh=norm(Thigh_KneeJointNode-Thigh_HipJointNode);
    [I_Thigh]=rgyration2inertia([29 15 30 7 2*1i 7*1i], Mass.Thigh_Mass, [0 0 0], Length_Thigh, Signe);


%% Création de la structure "Human_model"

num_solid=0;
%% Thigh
% Hip_J1
num_solid=num_solid+1;        % solide numéro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % numéro du solide dans le modèle
Human_model(incr_solid).name=[Signe name];   % nom du solide ('R' ou 'L' en suffixe)
Human_model(incr_solid).sister=0;                 % sister : définit en entrée de la fonction
Human_model(incr_solid).child=s_Hip_J2;                % child : Shank
Human_model(incr_solid).mother=s_mother;                 % mother : définit en fonction du pt d'attache
Human_model(incr_solid).a=[0 0 1]';                    % rotation /z
Human_model(incr_solid).joint=1;                        % liaison pivot
Human_model(incr_solid).limit_inf=-pi/4;               % butée articulaire inférieure
Human_model(incr_solid).limit_sup=2*pi/3;                % butée articulaire supérieure
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).m=0;                           % masse de référence
Human_model(incr_solid).b=pos_attachment_pt;              % position du point d'attache par rapport au repère parent                     A MODIFIER
Human_model(incr_solid).I=zeros(3,3);                  % matrice d'inertie de référence
Human_model(incr_solid).c=[0 0 0]';                    % position du centre de masse dans le repère local
Human_model(incr_solid).calib_k_constraint=[];
Human_model(incr_solid).u=[];                          % rotation fixe selon l'axe u d'un angle theta (après la rotation q)
Human_model(incr_solid).theta=[];
Human_model(incr_solid).KinematicsCut=[];              % coupure cinématique
Human_model(incr_solid).ClosedLoop=[];                 % si solide de fermeture de boucle : {numéro du solide i sur lequel est attaché ce solide ; point d'attache (repère du solide i)}
Human_model(incr_solid).linear_constraint=[];
Human_model(incr_solid).comment='Hip Flexion(+)/Extension(-)';
    

% Hip_J2
num_solid=num_solid+1;        % solide numéro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % numéro du solide dans le modèle
Human_model(incr_solid).name=[Signe name];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=s_femur;
Human_model(incr_solid).mother=s_Hip_J1;
Human_model(incr_solid).a=[1 0 0]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi/4;
Human_model(incr_solid).limit_sup=pi/4;
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).m=0;
Human_model(incr_solid).b=[0 0 0]';
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';
if Signe=='R'
    Human_model(incr_solid).comment='Hip Abduction(-)/Adduction(+) - X-Rotation';
else
    Human_model(incr_solid).comment='Hip Abduction(+)/Adduction(-) - X-Rotation';
end

% Thigh
num_solid=num_solid+1;        % solide numéro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % numéro du solide dans le modèle
Human_model(incr_solid).name=[name '_' lower(Signe)];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=0;
Human_model(incr_solid).mother=s_Hip_J2;
Human_model(incr_solid).a=[0 1 0]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi/2;
Human_model(incr_solid).limit_sup=pi/2;
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).Visual=1;
Human_model(incr_solid).visual_file = ['gait2354/femur_'  lower(Signe) '.mat'];
Human_model(incr_solid).m=Mass.Thigh_Mass;
Human_model(incr_solid).b=[0 0 0]';
Human_model(incr_solid).I=[I_Thigh(1) I_Thigh(4) I_Thigh(5); I_Thigh(4) I_Thigh(2) I_Thigh(6); I_Thigh(5) I_Thigh(6) I_Thigh(3)];
Human_model(incr_solid).c=-Thigh_HipJointNode;
Human_model(incr_solid).anat_position=Thigh_position_set;
Human_model(incr_solid).L={[Signe 'Thigh_HipJointNode'];[Signe 'Thigh_KneeJointNode']};
if Signe=='R'
    Human_model(incr_solid).comment='Hip Internal(+)/External(-) Rotation';
else
    Human_model(incr_solid).comment='Hip Internal(-)/External(+) Rotation';
end

end
