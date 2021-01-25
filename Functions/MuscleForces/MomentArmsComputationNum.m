function [R] = MomentArmsComputationNum(BiomechanicalModel,qval,dp)
% Computation of the moment arms matrix (numerical version)
%
%   INPUT
%   - Biomechanical model: osteo-articular model (see the Documentation for the structure)
%   - q : current coordinates of the model
%   - dp: differentiation step
%   - Ucall : is a unique call for finding
%   OUTPUT
%   - R: moment arms matrix at the current frame
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
% nq=numel(qval);

idxm=find([Muscles.exist]);
nmr=numel(idxm);

%
if length(qval)==numel(BiomechanicalModel.OsteoArticularModel(:)) && ~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0'))
    q=qval(1:end-6); %only degrees of freedom of the body, not the floating base.
else
    q=qval;
end

if isfield(BiomechanicalModel,'Coupling')
    C=BiomechanicalModel.Coupling;
else
    C= ones(nmr,length(q));
end
[row,col] = find(C);

%% Computation of moment arms
R=zeros(nmr,length(q));%init R

for k=1:length(row)
    i = col(k); % q indice
    dq=zeros(length(q),1); %differentiation step vector
    dq(i)=dp;
    
    j= row(k) ; % muscle indice 
    % compute the length of the muscle at q+dq
    Lpdq = Muscle_lengthNum(Human_model,Muscles(idxm(j)),q+dq);
    % compute the length of the muscle at q-dq
    Lmdq = Muscle_lengthNum(Human_model,Muscles(idxm(j)),q-dq);

    R(j,i)=(-Lpdq+Lmdq)/(2*dp); % it is -dl/dq
end
% beware that the matrix is finally nq*nm
R=R';





end