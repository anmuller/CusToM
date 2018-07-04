function [Human_model,Jacob,nbClosedLoop]=SymbolicFunctionGenerationIK(Human_model,Markers_set)
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
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________

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
[Human_model,Markers_set,~,~,p_ClosedLoop,R_ClosedLoop]=Symbolic_ForwardKinematicsCoupure(Human_model,Markers_set,s_root,q,k,p_adapt,1,1);

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
ind_s = find(1:numel(Human_model)~=pos_root);

ind_Kcut = find(cellfun(@isempty,{Human_model.KinematicsCut} )==0);


% Jfq
indexesNumericJfq = [];
nonNumericJfq = [];
Jfq = zeros(3*numel(list_markers),numel(Human_model)-1);
for ii=1:length(ind_mk) % each marker
    m = ind_mk(ii);
    for i_s=1:length(ind_s) % each solid
       num_s=ind_s(i_s);
       for p=1:3
            f = Markers_set(m).position_symbolic(p);
            df = diff(f,q(num_s));
            if df == 0
                Jfq(3*(ii-1)+p,i_s) = 0;
            elseif df == 1
                Jfq(3*(ii-1)+p,i_s) = 1;
            else
                indexesNumericJfq = [indexesNumericJfq (i_s-1)*size(Jfq,1)+3*(ii-1)+p];
                nonNumericJfq = [nonNumericJfq df];
            end
        end 
    end
end
nonNumericJfq = matlabFunction(nonNumericJfq, 'Vars', {q,pcut,Rcut});

% Jfcut
indexesNumericJfcut = [];
nonNumericJfcut = [];
Jfcut = zeros(3*numel(list_markers),12*size(pcut,3));
for ii=1:length(ind_mk)
    m = ind_mk(ii);
    for p=1:3 % x / y / z
        for h=1:size(pcut,3) % for each cut
            for l = 1:3 % pcut
                f = Markers_set(m).position_symbolic(p);
                df = diff(f,pcut(l,:,h));
                if df == 0
                    Jfcut(3*(ii-1)+p,12*(h-1)+l) = 0;
                elseif df == 1
                    Jfcut(3*(ii-1)+p,12*(h-1)+l) = 1;
                else
                    indexesNumericJfcut = [indexesNumericJfcut (12*(h-1)+l-1)*size(Jfcut,1)+3*(ii-1)+p];
                    nonNumericJfcut = [nonNumericJfcut df];
                end
            end
            for l=1:3
                for ll=1:3
                    f = Markers_set(m).position_symbolic(p);
                    df = diff(f,Rcut(l,ll,h));
                    if df == 0
                        Jfcut(3*(ii-1)+p,12*(h-1)+3+3*(l-1)+ll) = 0;
                    elseif df == 1
                        Jfcut(3*(ii-1)+p,12*(h-1)+3+3*(l-1)+ll) = 1;
                    else
                        indexesNumericJfcut = [indexesNumericJfcut (12*(h-1)+3+3*(l-1)+ll-1)*size(Jfcut,1)+3*(ii-1)+p];
                        nonNumericJfcut = [nonNumericJfcut df];
                    end
                end
            end
        end
    end
end
nonNumericJfcut = matlabFunction(nonNumericJfcut, 'Vars', {q,pcut,Rcut});

% Jcutq
indexesNumericJcutq = [];
nonNumericJcutq = [];
Jcutq = zeros(12*size(pcut,3),numel(Human_model)-1);
num_s = 0;
for s=1:numel(Human_model) % for each solid
    if s ~= pos_root
        num_s = num_s+1;
        for hh=1:numel(Human_model) %  for each cut solid
            if size(Human_model(hh).KinematicsCut) ~= 0
                h = Human_model(hh).KinematicsCut; % number of the cut
                for l = 1:3 % pcut (3 termes)
                    df = diff(Human_model(hh).p(l,:),q(s));
                    if df == 0
                        Jcutq(12*(h-1)+l,num_s) = 0;
                    elseif df == 1
                        Jcutq(12*(h-1)+l,num_s) = 1;
                    else
                        indexesNumericJcutq = [indexesNumericJcutq (num_s-1)*size(Jcutq,1)+12*(h-1)+l];
                        nonNumericJcutq = [nonNumericJcutq df];
                    end
                end
                for l=1:3 % Rcut (9 terms)
                    for ll=1:3
                        df=diff(Human_model(hh).R(l,ll),q(s));
                        if df == 0
                            Jcutq(12*(h-1)+3+3*(l-1)+ll,num_s) = 0;
                        elseif df == 1
                            Jcutq(12*(h-1)+3+3*(l-1)+ll,num_s) = 1;
                        else
                            indexesNumericJcutq = [indexesNumericJcutq (num_s-1)*size(Jcutq,1)+12*(h-1)+3+3*(l-1)+ll];
                            nonNumericJcutq = [nonNumericJcutq df];
                        end
                    end
                end
            end
        end
    end
end
nonNumericJcutq = matlabFunction(nonNumericJcutq, 'Vars', {q,pcut,Rcut});

% Jcutcut
indexesNumericJcutcut = [];
nonNumericJcutcut = [];
Jcutcut = zeros(12*size(pcut,3),12*size(pcut,3));
for hh1=1:numel(Human_model) % for each cut solid
    if size(Human_model(hh1).KinematicsCut) ~= 0
        h1 = Human_model(hh1).KinematicsCut; % number of the cut
        % derivative with respect to each cut
        for hh2=1:numel(Human_model) % for each cut solid
            if size(Human_model(hh2).KinematicsCut) ~= 0
                h2 = Human_model(hh2).KinematicsCut; % number of the cut
                for l1 = 1:3 % pcut1 (3 terms)
                    for l2 = 1:3 % pcut2
                        if h1 == h2 && l1 == l2  % derivative = 1
                            Jcutcut(12*(h1-1)+l1,12*(h2-1)+l2) = 1;
                        else
                            df = diff(Human_model(hh1).p(l1,:),pcut(l2,:,h2));
                            if df == 0
                                Jcutcut(12*(h1-1)+l1,12*(h2-1)+l2) = 0;
                            elseif df == 1
                                Jcutcut(12*(h1-1)+l1,12*(h2-1)+l2) = 1;
                            else
                                indexesNumericJcutcut = [indexesNumericJcutcut (12*(h2-1)+l2-1)*size(Jcutcut,1)+12*(h1-1)+l1];
                                nonNumericJcutcut = [nonNumericJcutcut df];
                            end
                        end
                    end
                    for l2=1:3 % Rcut2
                        for ll2=1:3
                            df = diff(Human_model(hh1).p(l1,:),Rcut(l2,ll2,h2));
                            if df == 0
                                Jcutcut(12*(h1-1)+l1,12*(h2-1)+3+3*(l2-1)+ll2) = 0;
                            elseif  df == 1
                                Jcutcut(12*(h1-1)+l1,12*(h2-1)+3+3*(l2-1)+ll2) = 1;
                            else
                                indexesNumericJcutcut = [indexesNumericJcutcut (12*(h2-1)+3+3*(l2-1)+ll2-1)*size(Jcutcut,1)+12*(h1-1)+l1];
                                nonNumericJcutcut = [nonNumericJcutcut df];
                            end
                        end
                    end
                end
                for l1 = 1:3 % Rcut1 (9 terms)
                    for ll1 = 1:3
                        for l2 = 1:3 % pcut2
                            df = diff(Human_model(hh1).R(l1,ll1),pcut(l2,:,h2));
                            if df == 0
                                Jcutcut(12*(h1-1)+3+3*(l1-1)+ll1,12*(h2-1)+l2) = 0;
                            elseif df == 1
                                Jcutcut(12*(h1-1)+3+3*(l1-1)+ll1,12*(h2-1)+l2) = 1;
                            else
                                indexesNumericJcutcut = [indexesNumericJcutcut (12*(h2-1)+l2-1)*size(Jcutcut,1)+12*(h1-1)+3+3*(l1-1)+ll1];
                                nonNumericJcutcut = [nonNumericJcutcut df];
                            end
                        end
                        for l2=1:3 % Rcut2
                            for ll2=1:3
                                if h1 == h2 && l1 == l2 && ll1 == ll2 % derivative = 1
                                    Jcutcut(12*(h1-1)+3+3*(l1-1)+ll1,12*(h2-1)+3+3*(l2-1)+ll2) = 1;
                                else
                                    df = diff(Human_model(hh1).R(l1,ll1),Rcut(l2,ll2,h2));
                                    if df == 0
                                        Jcutcut(12*(h1-1)+3+3*(l1-1)+ll1,12*(h2-1)+3+3*(l2-1)+ll2) = 0;
                                    elseif df == 1
                                        Jcutcut(12*(h1-1)+3+3*(l1-1)+ll1,12*(h2-1)+3+3*(l2-1)+ll2) = 1;
                                    else
                                        indexesNumericJcutcut = [indexesNumericJcutcut (12*(h2-1)+3+3*(l2-1)+ll2-1)*size(Jcutcut,1)+12*(h1-1)+3+3*(l1-1)+ll1];
                                        nonNumericJcutcut = [nonNumericJcutcut df];
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
nonNumericJcutcut = matlabFunction(nonNumericJcutcut, 'Vars', {q,pcut,Rcut});

%% Matrix Jacobian data save
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

%% Function generation for each marker and each cut solid

for ii=1:length(ind_mk)
    m = ind_mk(ii);
    matlabFunction(Markers_set(m).position_symbolic,'file',['Symbolic_function/' Markers_set(m).name '_Position.m'],'vars',{q,pcut,Rcut});
end

% Cut solid
for ii=1:length(ind_Kcut) % solid i
    i_Kc = ind_Kcut(ii);
    matlabFunction(Human_model(i_Kc).R,Human_model(i_Kc).p,'File',['Symbolic_function/f' num2str(Human_model(i_Kc).KinematicsCut) 'cut.m'],...
        'Outputs',{['R' num2str(num2str(Human_model(i_Kc).KinematicsCut)) 'cut' ],['p' num2str(num2str(Human_model(i_Kc).KinematicsCut)) 'cut' ]},...;
        'vars',{q,pcut,Rcut});
end
% Closed loops
for i=1:numel(p_ClosedLoop)
    matlabFunction(R_ClosedLoop{i},p_ClosedLoop{i},'File',['Symbolic_function/fCL' num2str(i) '.m'],...
        'Outputs',{'R','p'},'vars',{q});
end
nbClosedLoop=numel(p_ClosedLoop);

%We delete p and R fields
Human_model = rmfield(Human_model, 'p');
Human_model = rmfield(Human_model, 'R');

end





