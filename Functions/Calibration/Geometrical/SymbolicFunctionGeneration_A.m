function [Human_model,nbClosedLoop,Generalized_Coordinates,nb_k,k_map,nb_p,p_map,nb_alpha,alpha_map,...
A_norm,b_norm]=SymbolicFunctionGeneration_A(Human_model, Markers_set)
% Generation of symbolic function containing the position of markers according to joint coordinates and geometrical parameters
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the²
%   structure) 
%   - Markers_set: set of markers (see the Documentation for the structure)
%   OUTPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure) 
%   - nbClosedLoop: number of closed loop in the model
%   - q: symbolic vector of joint coordinates
%   - nk_k: number of variables k to optimize
%   - k_map: matrix allowing the mapping of variables k in the global
%   vector
%   - nk_p: number of variables p to optimize
%   - p_map: matrix allowing the mapping of variables p in the global
%   vector
%   - nk_alpha: number of variables alpha to optimize
%   - alpha_map: matrix allowing the mapping of variables alpha in the global
%   vector
%   - A_norm / b_norm : matrix allowing the normalization of optimization
%   variables
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

%% liste des marqueurs à partir du modèle (Markers list from the model)
list_markers={};
for i=1:numel(Markers_set)
    if Markers_set(i).exist
        list_markers=[list_markers;Markers_set(i).name]; %#ok<AGROW>
    end
end
nb_markers=size(list_markers,1);

%% initialisation des variables (initialisation of variables)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coordonnées articulaires
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
q = sym('q', [numel(Human_model) 1]);  %initialisation de q (nb de solides -1 (pelvis))
assume(q,'real')

q_map=eye(numel(Human_model));
q_dep_map=zeros(numel(Human_model));

bool_kd = isfield(Human_model,'kinematic_dependancy');
if bool_kd
    X={Human_model.kinematic_dependancy};
    ind_q=find(~cellfun(@isempty,X)==1);
    for ii=1:length(ind_q)
        q_map(ind_q(ii),ind_q(ii))=0;% q is reduced in case of dependant variables.
        q_dep_map(ind_q(ii),ind_q(ii))=1;% indexing
    end
end
s_root=find([Human_model.mother]==0);
q_map(s_root,s_root)=0;

[~,col]=find(sum(q_map,1)==0); q_map(:,col)=[];
% q_map=orth(q_map); %kernel of A in A*K=K (Kernal of A matrix)
[~,col]=find(sum(q_dep_map,1)==0); q_dep_map(:,col)=[];
%q_dep_map=orth(q_dep_map); %kernel of A in A*K=K (Kernal of A matrix)
% matrix mapping coordinates without the moving basis.
q_map_unsix=q_map;[~,col]=find(q_map_unsix(end-5:end,:));
    q_map_unsix(:,col)=[];

q_red=q_map'*q;
q_dep=q_dep_map'*q;
q_dep_scaled=zeros(size(q_dep_map,2),1);
ind_q_dependancy=cell(size(q_dep_map,2),1);

for ii=1:size(q_dep_map,2)
    ind_q_dependancy_current=Human_model(logical(q_dep_map(:,ii))).kinematic_dependancy.Joint;
    ind_q_dependancy{ii}=ind_q_dependancy_current';
    q_dependancy = q(ind_q_dependancy_current);
    q_handle_input = cell(length(q_dependancy),1);
    for jj=1:size(q_handle_input,1)
        q_handle_input{jj} = q_dependancy(jj);
    end
    q_handle=Human_model(logical(q_dep_map(:,ii))).kinematic_dependancy.q;
    q_dep(ii)=q_handle(q_handle_input{:});
    if Human_model(logical(q_dep_map(:,ii))).joint ==2 % scaling the kinematic constraints if its a translation
        q_dep_scaled(ii)=1;
    end
end

fq_dep=matlabFunction(q_dep,'vars',{q_red});
q_complete=q_dep_map*q_dep+ q_map*q_red;

Generalized_Coordinates.q_red=q_red;
Generalized_Coordinates.q_dep=q_dep;
Generalized_Coordinates.fq_dep=fq_dep;
Generalized_Coordinates.q_map=q_map;
Generalized_Coordinates.q_map_unsix=q_map_unsix;
Generalized_Coordinates.q_dep_map=q_dep_map;
Generalized_Coordinates.q_complete=q_complete;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% facteurs d'homothétie (homothetic factors)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind=1:numel(Human_model);
ind_k = unique([Markers_set.num_solid]);% takes solids with markers 
ind_k = unique([ind_k  find(not(cellfun(@isempty,{Human_model.anat_position})))]); % takes solids without markers

nb_k= length(ind_k);
k_map=zeros(numel(Human_model));
for i=1:nb_k
k_map(ind_k(i),ind_k(i))=1;
end
%k_map=orth(k_map); %Noyau de A dans le système d'equation linéaire A*K=K (Kernal of A matrix)
[~,col]=find(sum(k_map,1)==0); k_map(:,col)=[];
[~,V]=setdiff(ind,ind_k);
k_map(V,nb_k+1)=1;

% k_map=zeros(numel(Human_model),length(ind_k)+1);
% for i=1:length(ind_k)
% k_map(ind_k(i),i)=1;
% end
% [~,V]=setdiff(ind,ind_k);
% k_map(V,length(ind_k)+1)=1;

k_sym = sym('k_sym', [nb_k 1]);  %initialisation de k (nb de solides)
assume(k_sym,'real');

% Scaling the kinematic dependancies.
k_sym_tot=k_map*[k_sym,;1];
% get the homethetic coefficients of the parent coordinate of the dependant coordinate
% only for sliders
vect=ones(size(k_sym));
k_test_tot=k_map*[vect,;0];
ind_k_dep=zeros(size(ind_q_dependancy,1),1);
k_dep=sym(zeros(size(ind_q_dependancy,1),1));
for ii=1:length(ind_q_dependancy)
    if q_dep_scaled(ii) % if it is a slider
        ind_q_dependancy_holder=ind_q_dependancy{ii};
        for jj=1:length(ind_q_dependancy_holder)
            ij = Human_model(ind_q_dependancy_holder(jj)).mother;
            while k_test_tot(ij)==0
                ij = Human_model(ij).mother;
            end 
            ind_k_dep(ii)=ij;
            k_dep(ii)=k_sym_tot(ij);
        end
    else % if it is a hinge
        ind_k_dep(ii)=0;
        k_dep(ii)=1;
    end
end
q_dep_k=k_dep.*q_dep;
fq_dep_k=matlabFunction(q_dep_k,'vars',{q_red,k_sym});
q_complete_k=q_dep_map*q_dep_k+ q_map*q_red;

Generalized_Coordinates.k_dep=k_dep;
Generalized_Coordinates.ind_k_dep=ind_k_dep;
Generalized_Coordinates.q_dep_k=q_dep_k;
Generalized_Coordinates.fq_dep_k=fq_dep_k;
Generalized_Coordinates.q_complete_k=q_complete_k;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% déplacement des marqueurs p (displacement of markers p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
list_dir={};
for i=1:numel(Markers_set)
    if Markers_set(i).exist
        try
            list_dir=[list_dir;Markers_set(i).calib_dir];
        catch
            list_dir=[list_dir;Markers_set(i).calib_dir'];
        end
    end
end
list_dir=strcmp(list_dir,'On');
[ind_m] = find(list_dir==1);
nb_p = length(ind_m);
% nb_markers_dir=size(list_dir,1);
% p_map=zeros(nb_markers_dir,length(ind_m));
% 
% for i=1:length(ind_m)
% p_map(ind_m(i),i)=1;
% end
p_map=zeros(length(list_dir),length(list_dir));
for i=1:nb_p
p_map(ind_m(i),ind_m(i))=1;
end
p_map=orth(p_map); % Noyau de A dans le système d'equation linéaire A*P=P

p_adapt_sym = sym('p_adapt_sym',[nb_p 1]);  % déplacement des marqueurs lors de la calibration (Markers displacement due to calibration)
assume(p_adapt_sym,'real');

% Rotation orientation du pelvis (position and orientation of pelvis)
pPelvis = sym('pPelvis', [3 1]);
RPelvis = sym('RPelvis', [3 3]);

assume(pPelvis,'real');
assume(RPelvis,'real');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Angles associés (associated angles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nb_alpha =0;
if isfield(Human_model,'v')
    limit_alpha = [];
    ind_alpha=zeros(0,0);
    ind_nalpha=zeros(0,0);
    test = 0;
    for i=1:numel(Human_model)
        if ~isempty(Human_model(i).v)
            test = 1;
            nb_alpha = nb_alpha + size(Human_model(i).v,2); %Compte
            ind_alpha= [ind_alpha,i*2-1:i*2];
            limit_alpha = [limit_alpha; Human_model(i).limit_alpha];
        else
            ind_nalpha = [ind_nalpha,i*2-1:i*2];
        end
    end
    alpha_map = eye(2*numel(Human_model),2*numel(Human_model));
    alpha_map(:,ind_nalpha)=[];
    % alpha_map = zeros(2*numel(Human_model),2*numel(Human_model));
    % for i=1:nb_alpha
    % alpha_map(ind_alpha(i),ind_alpha(i))=1;
    % end
    % alpha_map=orth(alpha_map); %Noyau de A dans le système d'equation linéaire A*ALPHA=ALPHA;
    
    alpha_sym = sym('alpha', [nb_alpha 1]);  %initialiation de q (nb de solides -1 (pelvis))
    assume(alpha_sym,'real');
    
%     limit_alpha = [Human_model.limit_alpha]';
    if test
        limit_alpha_sup = limit_alpha(:,2);
        limit_alpha_inf = limit_alpha(:,1);
    else
        alpha_map=[];
        alpha_sym=[];
        limit_alpha_inf=[];
        limit_alpha_sup=[];
    end
else
    alpha_map=[];
    alpha_sym=[];
    limit_alpha_inf=[];
    limit_alpha_sup=[];
end

%% toutes les variables
var_sym = [k_sym;p_adapt_sym;alpha_sym];
%% Normalisation des variables
% limites : 0.8<k<1.2 et déplacement max de 5 cm pour chaque marqueur dans chaque direction
% et limites angulaire pour alpha
% On veut faire varier toutes les variables seulement entre -1 et 1 lors de
% l'optimisation
%% variable normalization within boundaries (0.8<k<1.2) and max displacement of 5cm for each marker in each direction and angular limits for alpha
% all variables should vary only between-1 and +1 during optimisation process

limit_inf_calib=[0.8*ones([nb_k 1]) ; -0.05*ones([nb_p 1]) ; limit_alpha_inf];
limit_sup_calib=[1.2*ones([nb_k 1]) ;  0.05*ones([nb_p 1]) ; limit_alpha_sup];

%Normaliser Variables toutes les variables sont normalisés entre -1 et 1 de
%sorte que l'optimisation fasse varier les variables de la même manière.
% All variables are normalized between -1 and +1 to ensure same weight for every variable
% a'= 2*(a-a_min)/(a_max-a_min)-1
% Mise sous forme matricielle A'=AX+b (under a matrix form A'=AX+b)
taille =nb_k+nb_p+nb_alpha;
A_norm = eye(taille);
for ii=1:taille
A_norm(ii,ii) = 2*A_norm(ii,ii)/( limit_sup_calib(ii) - limit_inf_calib(ii));
end
b_norm(:,1) = -2*limit_inf_calib(:)./( limit_sup_calib(:) - limit_inf_calib(:) )-ones(taille,1);
var_unnormalized = A_norm\(var_sym - b_norm);


%% Optimized variables are put back in the initial global set of variables

k=k_map*[var_unnormalized(1:nb_k);1];

p_adapt=p_map*var_unnormalized(nb_k+1:nb_k+nb_p);
p_adapt_mat=reshape(p_adapt,3,nb_markers)';

alpha=alpha_map*var_unnormalized(nb_k+nb_p+1:taille);


%% détermination des fonctions symbolique pour chaque position de repère 
%% Computation of symbolic functions for markers and cuts

s_root=find([Human_model.mother]==0); % numéro du solide root (Number of root solid)

% initialisation de la position et de la rotation du pelvis (setting initial position and rotation for pelvis)
Human_model(s_root).p=pPelvis;
Human_model(s_root).R=RPelvis;

% Calcul de la position de chaque marqueurs de façon symbolique (computation of markers position under a symbolic form)
[Human_model,Markers_set,~,~,c_ClosedLoop,ceq_ClosedLoop]=Symbolic_ForwardKinematicsCoupure_A(Human_model,Markers_set,s_root,q_complete_k,k,p_adapt_mat,alpha,1,1);
% [Human_model,Markers_set,~,~,p_ClosedLoop,R_ClosedLoop]=Symbolic_ForwardKinematicsCoupure_A(Human_model,Markers_set,s_root,q,k,p_adapt_mat,alpha,1,1);

% position et rotation des solides servant de coupure (position and rotation of solids defining the cuts)
for ii=1:max([Human_model.KinematicsCut])
    eval(['p' num2str(ii) 'cut = sym([''p'' num2str(ii) ''cut''], [3 1]);'])
    eval(['R' num2str(ii) 'cut = sym([''R'' num2str(ii) ''cut''], [3 3]);'])
        for i=1:3
            eval(['assume(p' num2str(ii) 'cut(' num2str(i) ',1),''real'');'])
            for z=1:3
                eval(['assume(R' num2str(ii) 'cut(' num2str(i) ',' num2str(z) '),''real'');'])
            end
        end   
        pcut(:,:,ii)=eval(['p' num2str(ii) 'cut']);
        Rcut(:,:,ii)=eval(['R' num2str(ii) 'cut']);
end

%% création des fonctions pour chaque marqueur et chaque solide de coupure
%% computation, i-under a symbolic expression, for every marker and every solid

% Création du dossier "Symbolic_function"
if exist([cd '/Symbolic_function'])~=7 %#ok<EXIST>
    mkdir('Symbolic_function')
end

% marqueurs % trop long avec les nouvelles variables
for i=1:numel(Markers_set)
   if Markers_set(i).exist
       matlabFunction(Markers_set(i).position_symbolic,'file',['Symbolic_function/' Markers_set(i).name '_Position.m'],'vars',{pPelvis,RPelvis,q_red,var_sym,pcut,Rcut});
   end
end

% % marqueurs
% E = [Markers_set.exist]';
% ind = find(E==1);
% parfor ii=1:length(ind) 
%     x = ind(ii);
%     matlabFunction(Markers_set(x).position_symbolic,'file',['Symbolic_function/' Markers_set(x).name '_Position.m'],'vars',{pPelvis,RPelvis,q,k,p_adapt,alpha,pcut,Rcut});
% end
% poolobj = gcp('nocreate');
% delete(poolobj);

% solide(s) de coupure (Solids where cuts are performed)
for i=1:numel(Human_model)  % solide i
    if size(Human_model(i).KinematicsCut) ~= 0
        matlabFunction(Human_model(i).R,Human_model(i).p,'File',['Symbolic_function/f' num2str(Human_model(i).KinematicsCut) 'cut.m'],...
            'Outputs',{['R' num2str(num2str(Human_model(i).KinematicsCut)) 'cut' ],['p' num2str(num2str(Human_model(i).KinematicsCut)) 'cut' ]},...;
            'vars',{pPelvis,RPelvis,q_red,var_sym,pcut,Rcut});
    end
end

% boucle(s) fermée(s) (Closed loops)
for i=1:numel(c_ClosedLoop)
    matlabFunction(c_ClosedLoop{i},ceq_ClosedLoop{i},'File',['Symbolic_function/fCL' num2str(i) '.m'],...
            'Outputs',{'c','ceq'},'vars',{pPelvis,RPelvis,q_red,var_sym,pcut,Rcut});   
end
nbClosedLoop=numel(c_ClosedLoop);

end







