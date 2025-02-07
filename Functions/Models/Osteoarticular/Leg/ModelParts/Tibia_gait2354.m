function [Human_model]= Tibia_gait2354(Human_model,k,Signe,Mass,AttachmentPoint)

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
list_solid={'Knee_Tx','Knee_Ty','tibia'};

%% Choix jambe droite ou gauche
if Signe == 'R'
    Mirror=[1 0 0; 0 1 0; 0 0 1];
else
    if Signe == 'L'
        Mirror=[1 0 0; 0 1 0; 0 0 -1];
    end
end

% %% Incrémentation du numéro des groupes
% n_group=0;
% for i=1:numel(Human_model)
%     if size(Human_model(i).Group) ~= [0 0] %#ok<BDSCA>
%         n_group=max(n_group,Human_model(i).Group(1,1));
%     end
% end
% n_group=n_group+1;

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

%%                      Définition des noeuds (articulaires)
% --------------------------- Shank ---------------------------------------

% centre de masse dans le repère de référence du segment
CoM_tibia=k*Mirror*[0   -0.1867         0]';

% Position des noeuds
Shank_KneeJointNode = (k*Mirror*[0 ;	0	;0])  -CoM_tibia;
Shank_TalocruralJointNode = (k*Mirror*[0 -0.43 0]')-CoM_tibia;

% MedialCondyle =	k*Mirror*[0 ; 0.32146 ;-0.038646 ]              -CoM_tibia;
% LateralCondyle=	k*Mirror*[0.016 ; 0.3194  ; 0.038646 ]              -CoM_tibia;
% TibialTuberosity=	k*Mirror*[0.032171 ; 0.27476  ; 0.097883 ] -CoM_tibia;
% FibularHead=	k*Mirror*[-0.028328 ;0.31974 ;0.031814 ]        -CoM_tibia;
% MedialMalleolus=	k*Mirror*[0.017065 ;0.049672 ;-0.027608 ]  -CoM_tibia;
% LateralMalleolus=	k*Mirror*[-0.017065 ;-0.049672 ; 0.027608 ]-CoM_tibia;

ANI=	k*Mirror*([0.06;-0.3888;-0.038])-CoM_tibia;
ANE=	k*Mirror*([-0.05;-0.41;0.053])-CoM_tibia;
KNI =	k*Mirror*[.06 .145 -.0475]';

%% Définition des positions anatomiques

Shank_position_set= {...
    [Signe 'ANE'], ANE; ...
    [Signe 'ANI'], ANI; ...
    [Signe 'KNI'], KNI; ...
    [Signe 'Shank.Upper' ],k*Mirror*([0.05;-0.065;0.05])-CoM_tibia;...
    [Signe 'Shank.Front' ],k*Mirror*([0.05;-0.08;0])-CoM_tibia;...
    [Signe 'Shank.Rear' ],k*Mirror*([0.02;-0.13;0.05])-CoM_tibia;...
    [Signe 'Shank_KneeJointNode'], Shank_KneeJointNode; ...
    [Signe 'Shank_TalocruralJointNode'], Shank_TalocruralJointNode; ...
    ['bifemlh_' lower(Signe) '-P2'],k*Mirror*([-0.0301;-0.036;0.02943])-CoM_tibia;...
    ['bifemlh_' lower(Signe) '-P3'],k*Mirror*([-0.0234;-0.0563;0.0343])-CoM_tibia;...
    ['bifemsh_' lower(Signe) '-P2'],k*Mirror*([-0.0301;-0.036;0.02943])-CoM_tibia;...
    ['bifemsh_' lower(Signe) '-P3'],k*Mirror*([-0.0234;-0.0563;0.0343])-CoM_tibia;...
    ['sar_' lower(Signe) '-P3'],k*Mirror*([-0.056;-0.0419;-0.0399])-CoM_tibia;...
    ['sar_' lower(Signe) '-P4'],k*Mirror*([0.06;-0.0589;-0.0383])-CoM_tibia;...
    ['sar_' lower(Signe) '-P5'],k*Mirror*([0.0243;-0.084;-0.0252])-CoM_tibia;...
    ['tfl_' lower(Signe) '-P4'],k*Mirror*([0.06;-0.0487;0.0297])-CoM_tibia;...
    ['grac_' lower(Signe) '-P3'],k*Mirror*([-0.01943;-0.05153;-0.0358])-CoM_tibia;...
    ['grac_' lower(Signe) '-P4'],k*Mirror*([0.06;-0.0836;-0.0228])-CoM_tibia;...
    ['soleus_' lower(Signe) '-P1'],k*Mirror*([-0.024;-0.1533;0.071])-CoM_tibia;...
    ['tib_post_' lower(Signe) '-P1'],k*Mirror*([-0.094;-0.1348;0.019])-CoM_tibia;...
    ['tib_post_' lower(Signe) '-P2'],k*Mirror*([-0.0144;-0.4051;-0.0229])-CoM_tibia;...
    ['tib_ant_' lower(Signe) '-P1'],k*Mirror*([0.0179;-0.1624;0.0115])-CoM_tibia;...
    ['tib_ant_' lower(Signe) '-P2'],k*Mirror*([0.0329;-0.3951;-0.0177])-CoM_tibia;...
    ['rect_fem_' lower(Signe) '-P3'],k*Mirror*([0.0617576; 0.020984; -0.0014])-CoM_tibia;...
    };

%%                     Mise à l'échelle des inerties
%% ["Adjustments to McConville et al. and Young et al. body segment inertial parameters"] R. Dumas
% --------------------------- Shank ---------------------------------------
Length_Shank=norm(Shank_TalocruralJointNode	-Shank_KneeJointNode);
[I_Shank]=rgyration2inertia([28 10 28 4*1i 2*1i 5], Mass.Shank_Mass, [0 0 0], Length_Shank, Signe);

%% Création de la structure "Human_model"

num_solid=0;
%% Knee_Tx
num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
Human_model(incr_solid).name=[Signe name];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=s_Knee_Ty;
Human_model(incr_solid).mother=s_mother;
Human_model(incr_solid).a=[1 0 0]';
Human_model(incr_solid).joint=2;
Human_model(incr_solid).limit_inf=-1;
Human_model(incr_solid).limit_sup=1;
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).m=0;
Human_model(incr_solid).b=pos_attachment_pt;
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';
Human_model(incr_solid).comment='Knee Antero-Posterior Translation';
% Dependancy
Human_model(incr_solid).kinematic_dependancy.active=1;
Human_model(incr_solid).kinematic_dependancy.Joint=[incr_solid+2]; % tibia_r

% numerical values
theta_g = [-2.09440,-1.745330,-1.396260,-1.04720,-0.6981320,-0.3490660,-0.1745330,0.1973440,0.3373950,0.4901780,1.521460,2.09440]';
tx =k*[-0.0032000,0.0017900,0.0041100,0.0041000,0.0021200,-0.0010000,-0.0031000,-0.0052270,-0.0054350,-0.0055740,-0.0054350,-0.0052500]';
% plot(theta_g,tx,'bo','linewidth',3); title('knee angle function of x translation')
Human_model(incr_solid).kinematic_dependancy.numerical_estimates=[theta_g ,tx];

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Polynomial fitting
%%%%% not efficient %%%%%%
% %not efficient [p,S]=polyfit(theta_g,tx,4); 
% [y, delta]=polyval(p,theta_g(1):0.01:theta_g(end),S); plot(theta_g(1):0.01:theta_g(end),y,'r-','linewidth',3); 

%%%%%%%%%
% spline
%%%%%%
% Efficient mais galere avec les fonctions par morceaux
%%%%%%%%%%%%%%%%%%%%
% pp=spline(theta_g,tx);
% yy=spline(theta_g,tx,theta_g(1):0.01:theta_g(end))
% plot(theta_g(1):0.01:theta_g(end),yy,'g--','linewidth',3); hold on;
% Coef(:,1) = pp.coefs(:,1);
% Coef(:,2) = -3*pp.coefs(:,1).*pp.breaks(1:end-1)' + pp.coefs(:,2);
% Coef(:,3) = 3*pp.coefs(:,1).*(pp.breaks(1:end-1)').^2 - 2*pp.coefs(:,2).*(pp.breaks(1:end-1)')...
%     + pp.coefs(:,3);
% Coef(:,4) = -pp.coefs(:,1).*(pp.breaks(1:end-1)').^3 + pp.coefs(:,2).*(pp.breaks(1:end-1)').^2 ...
%     - pp.coefs(:,3).*(pp.breaks(1:end-1)') + pp.coefs(:,4);
% f_tx_sym=PiecewisePolyFunction(theta_g,Coef);
% Verif
% for ij=theta_g(1):0.01:theta_g(end)
%     yy=subs(f_tx_sym,X,ij);
%     plot(ij,yy,'.'); hold on
% end

% f_tx=matlabFunction(f_tx_sym,'vars',{X}) impossible to save piecewise
% symbolic functions in workspace.
% syms X real
% f_tx=matlabFunction(f_tx_sym,'File',...
%     [Signe '_' name '.m'],...
%     'Outputs',{'ftx'},'vars',{X});
% plot(theta_g(1):0.01:theta_g(end),f_tx(theta_g(1)),'.')
% Handle function
% Human_model(incr_solid).kinematic_dependancy.q=f_tx;
% Human_model(incr_solid).kinematic_dependancy.q_sym=f_tx_sym;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% polynome au cas ou
% %Just in case
%[p,S]=polyfit(theta_g,tx,4)
%alpha_g=sym('alpha_g','real');
%f_tx=sym(zeros(1,1));
%order=length(p);
%for ii=1:order
%    f_tx = alpha_g^(order-ii)*p(ii) + f_tx;
%end
% Handle function
%q=matlabFunction(f_tx);
%Human_model(incr_solid).kinematic_dependancy.q=q;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FOURRIER
%%%%%%% Fonctionne pas trop mal %%%%%%%
% four=fit(theta_g,tx,'fourier3')
% plot(four);
% xlim([min(theta_g) max(theta_g)])
% ylim([min(tx) max(tx)])
% 
% str = strtrim(formula(four));
% c = coeffnames(four); v=coeffvalues(four);
% f_four=matlabFunction(str2sym(str));
% sym X;
% 
% for ii=1:length(c)
% eval([c{ii} '=' num2str(v(ii)) ';']);
% end
%%%%%%%%%%% On donne directement les coefficients.
syms X real;
a0 = k*-0.003014  ;
a1 =   k*0.0005659  ;
b1 =  k*-0.0001508  ;
a2 =    k*0.001183  ;
b2 =   k*-0.005434  ;
a3 =   k*-0.002767  ;
b3 =    k*0.000915  ;
w  =        0.75  ;
f_tx = matlabFunction(a0 + a1*cos(X*w) + b1*sin(X*w) + a2*cos(2*X*w) + b2*sin(2*X*w) + a3*cos(3*X*w) + b3*sin(3*X*w));
Human_model(incr_solid).kinematic_dependancy.q=f_tx;
%% Knee_Ty

num_solid=num_solid+1;        % number of the solid ...
name=list_solid{num_solid}; % solid name
eval(['incr_solid=s_' name ';'])  % number of the solid in the model
Human_model(incr_solid).name=[Signe name];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=s_tibia;
Human_model(incr_solid).mother=s_Knee_Tx;
Human_model(incr_solid).a=[0 1 0]';
Human_model(incr_solid).joint=2;
Human_model(incr_solid).limit_inf=-1;
Human_model(incr_solid).limit_sup=1;
Human_model(incr_solid).Visual=0;
Human_model(incr_solid).m=0;
Human_model(incr_solid).b=[0 0 0]';
Human_model(incr_solid).I=zeros(3,3);
Human_model(incr_solid).c=[0 0 0]';
Human_model(incr_solid).comment='Knee Longitudinal Translation';

% Dependancy
Human_model(incr_solid).kinematic_dependancy.active=1;
Human_model(incr_solid).kinematic_dependancy.Joint=incr_solid+1; % tibia_r

% numerical values
theta_g = [-2.09440,-1.221730,-0.5235990,-0.3490660,-0.1745330,0.1591490,2.09440];
ty = k*[-0.42260,-0.40820,-0.3990,-0.39760,-0.39660,-0.3952640,-0.3960]+0.3958;
% plot(theta_g,ty,'bo','linewidth',3); title('knee angle function of y translation')
Human_model(incr_solid).kinematic_dependancy.numerical_estimates=[theta_g ,ty];

[p,S]=polyfit(theta_g,ty,5); 
% yy=spline(theta_g,ty,theta_g(1):0.01:theta_g(end))
% plot(theta_g(1):0.01:theta_g(end),yy,'g--','linewidth',3); 
% hold on; [y, delta]=polyval(p,theta_g(1):0.01:theta_g(end),S); plot(theta_g(1):0.01:theta_g(end),y,'r-','linewidth',3); 
alpha_g=sym('alpha_g','real'); 
f_ty=sym(zeros(1,1));
order=length(p);
for ii=1:order
    f_ty = alpha_g^(order-ii)*p(ii) + f_ty;
end
% Handle function
q=matlabFunction(f_ty);
Human_model(incr_solid).kinematic_dependancy.q=q;

%% Tibia
num_solid=num_solid+1;        % solide numéro ...
name=list_solid{num_solid}; % nom du solide
eval(['incr_solid=s_' name ';'])  % numéro du solide dans le modèle
Human_model(incr_solid).name=[name '_' lower(Signe)];
Human_model(incr_solid).sister=0;
Human_model(incr_solid).child=0;
Human_model(incr_solid).mother=s_Knee_Ty;
Human_model(incr_solid).a=[Mirror(3,3)*0	Mirror(3,3)*0	1]';
Human_model(incr_solid).joint=1;
Human_model(incr_solid).limit_inf=-pi;
Human_model(incr_solid).limit_sup=pi;
Human_model(incr_solid).ActiveJoint=1;
Human_model(incr_solid).Visual=1;
Human_model(incr_solid).visual_file = ['gait2354/tibia_'  lower(Signe) '.mat'];
% Human_model(incr_solid).Group=[n_group 2];
Human_model(incr_solid).m=Mass.Shank_Mass;
Human_model(incr_solid).b=[0;0;0];
Human_model(incr_solid).I=[I_Shank(1) I_Shank(4) I_Shank(5); I_Shank(4) I_Shank(2) I_Shank(6); I_Shank(5) I_Shank(6) I_Shank(3)];
Human_model(incr_solid).c=-Shank_KneeJointNode; % dans le repère du joint précédent
Human_model(incr_solid).anat_position=Shank_position_set;
Human_model(incr_solid).L={[Signe 'Shank_KneeJointNode'];[Signe 'Shank_TalocruralJointNode']};
Human_model(incr_solid).limit_alpha= [10 , -10;...
    10, -10];
%     OsteoArticularModel(incr_solid).v= [ [1; 0; 0] , [0 ;1;0] ] ;
Human_model(incr_solid).v= [] ;
Human_model(incr_solid).calib_a=1;
Human_model(incr_solid).comment='Knee Flexion(-)/Extension(-)';


end
