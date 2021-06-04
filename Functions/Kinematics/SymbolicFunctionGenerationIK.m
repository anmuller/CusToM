function [Human_model,Generalized_Coordinates]=SymbolicFunctionGenerationIK(Human_model,Markers_set)
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

% %% Jacobian matrix computation (thanks to several matrix)
E = [Markers_set.exist]';
ind_mk = find(E==1);


%% Création des fonctions pour chaque marqueurs et chaque solide de coupure

for ii=1:length(ind_mk)
    m = ind_mk(ii);
    dX((ii-1)*3+1:3*ii,:) = Markers_set(m).position_symbolic ;
end
% One function for all markers
matlabFunction(dX,'file',['Symbolic_function/X_markers'],'vars',{q_red,pcut,Rcut});

% Cut solid

ind_Kcut = find(cellfun(@isempty,{Human_model.KinematicsCut} )==0);

for ii=1:length(ind_Kcut) % solide i
    i_Kc = ind_Kcut(ii);
    fRcut_all(:,:,Human_model(i_Kc).KinematicsCut) = Human_model(i_Kc).R;
    fpcut_all(:,:,Human_model(i_Kc).KinematicsCut) = Human_model(i_Kc).p;
end

cutfunc = matlabFunction(fRcut_all,fpcut_all,'Outputs',{['Rcut' ],['pcut' ]}, 'vars',{q_red,pcut,Rcut});

pcutsave = pcut;    
Rcutsave = Rcut;    
for c=1:length(ind_Kcut)
    [Rcutsave,pcutsave]=cutfunc(q_red,pcutsave,Rcutsave);
end

matlabFunction(Rcutsave,pcutsave,'File',['Symbolic_function/fcut.m'],'Outputs',{['Rcut' ],['pcut' ]},'vars',{q_red});
        
% Closed loops
Fullc_ClosedLoop = [c_ClosedLoop{:}];
Fullceq_ClosedLoop = [ceq_ClosedLoop{:}];
Fullc_ClosedLoop = Fullc_ClosedLoop(:);
Fullceq_ClosedLoop = Fullceq_ClosedLoop(:);

if  ~isempty(Fullceq_ClosedLoop)
    matlabFunction(Fullc_ClosedLoop,Fullceq_ClosedLoop,'File',['Symbolic_function/fCL.m'],'Outputs',{'c','ceq'},'vars',{q_red});
end


%We delete p and R fields
Human_model = rmfield(Human_model, 'p');
Human_model = rmfield(Human_model, 'R');

end





