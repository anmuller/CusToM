function [Moment_Arms_sub,C,L] = MomentArmsComputation(BiomechanicalModel)
% Computation of the moment arms matrix
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the structure)
%   - Muscles: set of muscles (see the Documentation for the structure)
%   OUTPUT
%   - Moment_Arms: moment arms matrix
%   - C: muscular coupling matrix
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
% Modification : Pierre Puchaud 
%________________________________________________________
Human_model=BiomechanicalModel.OsteoArticularModel;
Muscles=BiomechanicalModel.Muscles;

%
if  ~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0')) %&& length(q0)==numel(BiomechanicalModel.OsteoArticularModel(:))
    Nb_q = numel(Human_model)-6 ;%only degrees of freedom of the body, not the floating base.
else
     Nb_q= numel(Human_model);
end

q = sym('q',[Nb_q,1],'real'); % nb de degrees of freedom
Nb_m = numel(Muscles);

%% Compute muscle lengths

L = sym(zeros(Nb_m,1));
for i_m=1:Nb_m % for each muscle
    if Muscles(i_m).exist% if this muscle exist on the model
        % compute the length of the muscle
        L(i_m) = Muscle_length(Human_model,Muscles(i_m),q);
    end
end

%% Computation of moment arms

R=-jacobian(L,q)';
R=R(:);
sizeMA_Lin=Nb_q*Nb_m; % Last 6 degrees of freedom are not taken into account after the jacobian
sizeMA_Sub=[Nb_q Nb_m];
Moment_Arms_lin=num2cell(zeros(sizeMA_Lin,1));
Moment_Arms_sub=cell(sizeMA_Sub);

ind = find(R~=0);
R_temp = R(ind); sizeMA_Lin_temp= length(ind);
Moment_Arms_lin_temp = cell(sizeMA_Lin_temp,1);

parfor ii=1:sizeMA_Lin_temp 
    %     Moment_Arms_lin_temp{ii} = matlabFunction(simplify(R_temp(ii)),'Vars',{q});
    Moment_Arms_lin_temp{ii} = matlabFunction(R_temp(ii),'Vars',{q});
end
Moment_Arms_lin(ind)=Moment_Arms_lin_temp;

% Reordering the matrix
for ii=1:sizeMA_Lin %subscript indexing
    [I,J]=ind2sub(sizeMA_Sub,ii);
    Moment_Arms_sub{I,J}=Moment_Arms_lin{ii};
end

%% Computation of muscular coupling matrix
sizeCSub=[Nb_q Nb_q];
C = zeros(sizeCSub);
dR = jacobian(R,q);
for ii=1:Nb_q
    ind = find(dR(:,ii)~=0);
    [I,~]=ind2sub(sizeMA_Sub,ind); % corresponding indexing
    C(ii,I)=1; C(I,ii)=1;
end

end