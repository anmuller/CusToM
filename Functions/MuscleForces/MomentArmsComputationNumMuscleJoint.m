function [R] = MomentArmsComputationNumMuscleJoint(BiomechanicalModel,qval,dp,nummuscle,numarti)
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
%
if length(qval)==numel(BiomechanicalModel.OsteoArticularModel(:)) && ~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0'))  
    q=qval(1:end-6); %only degrees of freedom of the body, not the floating base.
else
    q=qval;
end
%% Computation of moment arms
R=zeros(length(numarti));%init R

for i=1:length(numarti)
    dq=zeros(length(q),1); %differentiation step vector
    dq(numarti(i))=dp;
    % compute the length of the muscle at q+dq
    Lpdq = Muscle_lengthNum(Human_model,Muscles(nummuscle),q+dq);
    % compute the length of the muscle at q-dq
    Lmdq = Muscle_lengthNum(Human_model,Muscles(nummuscle),q-dq);

    R(i)=(-Lpdq+Lmdq)/(2*dp); % it is -dl/dq
end


end