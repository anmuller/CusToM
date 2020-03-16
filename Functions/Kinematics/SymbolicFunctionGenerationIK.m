function [Human_model,Jacob,Generalized_Coordinates]=SymbolicFunctionGenerationIK(Human_model,Markers_set)
% Computation of function used in the inverse kinematics step
%   Generated functions contain the global position of each marker and its
%   Jacobian matrix. All functions are evaluated according to the joint
%   coordinates
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - Markers_set: set of markers (see the Documentation for the structure)
%   OUPUT
%   - Human_model: osteo-articular model with additionnal informations about
%   the generated functions (see the Documentation for the structure)
%   - Jacob: structure containing functions related to the Jacobian matrix
%   - nbClosedLoop: number of closed loop contained in the model
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
%
% Modification : Pierre Puchaud 2018
% Jacobian matrix generation more efficient.
%
%% list of markers from the model
list_markers={};
for i=1:numel(Markers_set)
    if Markers_set(i).exist
        list_markers=[list_markers;Markers_set(i).name]; %#ok<AGROW>
    end
end

%% variables initialization
q = sym('q', [numel(Human_model) 1]);  % joint coordinates initialization (number of solids - 1 (pelvis))
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

for ii=1:size(q_dep_map,2)
    ind_q_dependancy=Human_model(logical(q_dep_map(:,ii))).kinematic_dependancy.Joint;
    q_handle=Human_model(logical(q_dep_map(:,ii))).kinematic_dependancy.q;
    q_dependancy = q(ind_q_dependancy);
    q_handle_input = cell(length(q_dependancy),1);
    for jj=1:size(q_handle_input)
        q_handle_input{jj} = q_dependancy(jj);
    end
    q_dep(ii)=q_handle(q_handle_input{:});
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

k=ones(numel(Human_model),1);
p_adapt=zeros(sum([Markers_set.exist]),3);
pPelvis=zeros(3,1);
RPelvis=eye(3,3);


%% Symbolic function generation for each coordinate frame position
s_root=find([Human_model.mother]==0); % number of the root solid

% initialization of the pelvis position and rotation
Human_model(s_root).p=pPelvis;
Human_model(s_root).R=RPelvis;

% Computation of the symbolic markers position
%[Human_model,Markers_set,~,~,p_ClosedLoop,R_ClosedLoop]=Symbolic_ForwardKinematicsCoupure(Human_model,Markers_set,s_root,q,k,p_adapt,1,1);
[Human_model,Markers_set,~,~,c_ClosedLoop,ceq_ClosedLoop]=Symbolic_ForwardKinematicsCoupure(Human_model,Markers_set,s_root,q_complete,k,p_adapt,1,1);

% position and rotation of the solids used as cuts
for ii=1:max([Human_model.KinematicsCut])
    eval(['p' num2str(ii) 'cut = sym([''p'' num2str(ii) ''cut''], [3 1]);'])
    eval(['R' num2str(ii) 'cut = sym([''R'' num2str(ii) ''cut''], [3 3]);'])
    for i=1:3
        eval(['assume(p' num2str(ii) 'cut(' num2str(i) ',1),''real'');'])
        for z=1:3
            eval(['assume(R' num2str(ii) 'cut(' num2str(i) ',' num2str(z) '),''real'');'])
        end
    end
    pcut(:,:,ii)=eval(['p' num2str(ii) 'cut']); %#ok<AGROW>
    Rcut(:,:,ii)=eval(['R' num2str(ii) 'cut']); %#ok<AGROW>
end

% "Symbolic_function" folder generation
if exist([cd '/Symbolic_function'])~=7 %#ok<EXIST>
    mkdir('Symbolic_function')
end

%% Jacobian matrix computation (thanks to several matrix)
E = [Markers_set.exist]';
ind_mk = find(E==1);
pos_root =find([Human_model.mother]==0);
% ind_s = 1:numel(Human_model)~=pos_root;
ind_s = logical(q_map'*(1:numel(Human_model)~=pos_root)');

% what if cuts are not in the reduce set ???
ind_Kcut = find(cellfun(@isempty,{Human_model.KinematicsCut} )==0);
% ind_Kcut = logical(q_map'*not(cellfun(@isempty,{Human_model.KinematicsCut} ))');

%Nb_q = numel(Human_model)-1;
Nb_q = numel(q_red);%-1;
Nb_mk=numel(list_markers);
Nb_dir_mk=3*Nb_mk;

% Array of marker functions for each direction of space x,y,z 
f=sym(zeros(Nb_dir_mk,1));
for ii=1:Nb_mk
    iie = ind_mk(ii);
    for jj=1:3
        ind = sub2ind([3 Nb_mk],jj,ii);
        f(ind) = Markers_set(iie).position_symbolic(jj);
    end
end

% Jfq
Jfq_sym = jacobian(f,q_red(ind_s));
%Jfq_sym = jacobian(f,q(ind_s)); q_complete

Jfq =zeros(Nb_dir_mk,Nb_q);
% idx=Jfq_sym(:)==0;
% Jfq(idx)=0;
idx=Jfq_sym(:)==1;
Jfq(idx)=1;

indexesNumericJfq = find(Jfq_sym~=0 & Jfq_sym~=1)';
% nonNumericJfq = matlabFunction(Jfq_sym(indexesNumericJfq), 'Vars', {q,pcut,Rcut});
nonNumericJfq = matlabFunction(Jfq_sym(indexesNumericJfq), 'Vars', {q_red,pcut,Rcut});

% Jfcut
Nb_cut = size(pcut,3);
Nb_param_1cut= 12; %3 coordinates in translations, 9 in rotations
Nb_param_cut = Nb_param_1cut*Nb_cut;

% kinematic cuts parameters
param=[pcut,permute(Rcut,[2,1,3])];

Jfcut_sym = jacobian(f,param(:));

Jfcut = zeros(Nb_dir_mk,Nb_param_cut);
% idx=Jfcut_sym(:)==0;
% Jfcut(idx)=0;
idx=Jfcut_sym(:)==1;
Jfcut(idx)=1;

indexesNumericJfcut = find(Jfcut_sym~=0 & Jfcut_sym~=1)';
%nonNumericJfcut = matlabFunction(Jfcut_sym(indexesNumericJfcut), 'Vars', {q,pcut,Rcut});
nonNumericJfcut = matlabFunction(Jfcut_sym(indexesNumericJfcut), 'Vars', {q_red,pcut,Rcut});

% Fonctions pcut and Rcut for kinematic cut indices
fcut=sym(zeros(Nb_param_1cut,Nb_cut));
num_cut = [Human_model(ind_Kcut).KinematicsCut];
for ii=1:Nb_cut
    i_cut=ind_Kcut(ii);
    fpcut = [Human_model(i_cut).p];
    fpcut = fpcut(:);
    
    fRcut = [Human_model(i_cut).R];
    fRcut = permute(fRcut,[2,1,3]);
    fRcut = fRcut(:);
    fcut(:,num_cut(ii))=[fpcut;fRcut]; % ordered by the number of the cut
end
fcut=fcut(:);

% Jcutq
Jcutq_sym = jacobian(fcut,q_red(ind_s));
% Jcutq_sym=jacobian(fcut,q(ind_s)); %complete

Jcutq = zeros(Nb_param_cut,Nb_q); 
% idx=Jcutq_sym(:)==0;
% Jcutq(idx)=0;
idx=Jcutq_sym(:)==1;
Jcutq(idx)=1;

indexesNumericJcutq=find(Jcutq_sym~=0 & Jcutq_sym~=1);
% nonNumericJcutq = matlabFunction(Jcutq_sym(indexesNumericJcutq), 'Vars', {q,pcut,Rcut});
nonNumericJcutq = matlabFunction(Jcutq_sym(indexesNumericJcutq), 'Vars', {q_red,pcut,Rcut});

% Jcutcut
Jcutcut_sym=jacobian(fcut,param(:));

Jcutcut = eye(Nb_param_cut,Nb_param_cut);
% Diagonal terms are the derivatives of themselves 
% dy/dy=1
% idx=Jcutcut_sym(:)==0;
% Jcutcut(idx)=0;
idx=Jcutcut_sym(:)==1;
Jcutcut(idx)=1;

indexesNumericJcutcut=find(Jcutcut_sym~=0 & Jcutcut_sym~=1);
% if ~isempty(indexesNumericJcutcut)
%     nonNumericJcutcut = matlabFunction(Jcutcut_sym(indexesNumericJcutcut), 'Vars', {q,pcut,Rcut});
nonNumericJcutcut = matlabFunction(Jcutcut_sym(indexesNumericJcutcut), 'Vars', {q_red,pcut,Rcut});
% end

% Find solides without marqueurs at the end of the chains.
RmvInd_q = intersect(find(sum(Jcutq_sym,1)==0),find(sum(Jfq_sym,1)==0));
%% Sauvegarde des données relatives à la matrice Jacobienne
Jacob.Jfq = Jfq;
Jacob.indexesNumericJfq = indexesNumericJfq;
Jacob.nonNumericJfq = nonNumericJfq;
Jacob.Jfcut = Jfcut;
Jacob.indexesNumericJfcut = indexesNumericJfcut;
Jacob.nonNumericJfcut = nonNumericJfcut;
Jacob.Jcutq = Jcutq;
Jacob.indexesNumericJcutq = indexesNumericJcutq;
Jacob.nonNumericJcutq = nonNumericJcutq;
Jacob.Jcutcut = Jcutcut;
Jacob.indexesNumericJcutcut = indexesNumericJcutcut;
Jacob.nonNumericJcutcut = nonNumericJcutcut;
Jacob.RmvInd_q=RmvInd_q;
%% Création des fonctions pour chaque marqueurs et chaque solide de coupure

for ii=1:length(ind_mk)
    m = ind_mk(ii);
%     matlabFunction(Markers_set(m).position_symbolic,'file',['Symbolic_function/' Markers_set(m).name '_Position.m'],'vars',{q,pcut,Rcut});
    matlabFunction(Markers_set(m).position_symbolic,'file',['Symbolic_function/' Markers_set(m).name '_Position.m'],'vars',{q_red,pcut,Rcut});
end

% Cut solid
for ii=1:length(ind_Kcut) % solide i
    i_Kc = ind_Kcut(ii);
%     matlabFunction(Human_model(i_Kc).R,Human_model(i_Kc).p,'File',['Symbolic_function/f' num2str(Human_model(i_Kc).KinematicsCut) 'cut.m'],...
%         'Outputs',{['R' num2str(num2str(Human_model(i_Kc).KinematicsCut)) 'cut' ],['p' num2str(num2str(Human_model(i_Kc).KinematicsCut)) 'cut' ]},...;
%         'vars',{q,pcut,Rcut});
    matlabFunction(Human_model(i_Kc).R,Human_model(i_Kc).p,'File',['Symbolic_function/f' num2str(Human_model(i_Kc).KinematicsCut) 'cut.m'],...
        'Outputs',{['R' num2str(num2str(Human_model(i_Kc).KinematicsCut)) 'cut' ],['p' num2str(num2str(Human_model(i_Kc).KinematicsCut)) 'cut' ]},...;
        'vars',{q_red,pcut,Rcut});
end

% Closed loops
for i=1:numel(c_ClosedLoop)
    matlabFunction(c_ClosedLoop{i},ceq_ClosedLoop{i},'File',['Symbolic_function/fCL' num2str(i) '.m'],...
            'Outputs',{'c','ceq'},'vars',{q_red});   
end

%We delete p and R fields
Human_model = rmfield(Human_model, 'p');
Human_model = rmfield(Human_model, 'R');

%% find kinematic cuts to add them again to human model
% if bool_kd
%     ind_reduce = find(~cellfun(@isempty,{Human_model.KinematicsCut}')==1);
%     for ii=1:length(ind_reduce)
%         [~,ind_complete]=intersect({Human_model_save.name}',Human_model(ind_reduce(ii)).name);
%         Human_model_save(ind_complete).KinematicsCut=Human_model(ind_reduce(ii)).KinematicsCut;
%     end
%     Human_model = Human_model_save;
% end

end





