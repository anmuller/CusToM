function [Moment_Arms_sub,C] = MomentArmsComputation(Human_model,Muscles)
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
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
% Modification : Pierre Puchaud 
%________________________________________________________
Nb_q = numel(Human_model)-6;
Nb_m = numel(Muscles);

% Compute muscle length
q = sym('q',[Nb_q,1],'real'); % nb de degrees of freedom
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
sizeMA_Lin=Nb_q*Nb_m;
sizeMA_Sub=[Nb_q Nb_m];
Moment_Arms_lin=cell(sizeMA_Lin,1);
Moment_Arms_sub=cell(sizeMA_Sub);

parfor ii=1:sizeMA_Lin %parfor, to process faster.
    if R(ii)==0
    Moment_Arms_lin{ii} = 0;    
    else
    Moment_Arms_lin{ii} = matlabFunction(simplify(R(ii)),'Vars',{q});
    end
end
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