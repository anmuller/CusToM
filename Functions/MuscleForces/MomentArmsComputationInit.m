function [C] = MomentArmsComputationInit(BiomechanicalModel,q,dp)
% Computation of the moment arms matrix (numerical version)
%
%   INPUT
%   - Biomechanical model: osteo-articular model (see the Documentation for the structure)
%   - q : current coordinates of the model
%   - dp: differentiation step
%   - Ucall : is a unique call for finding
%   OUTPUT
%   - C: muscular coupling matrix (meaning, which muscle actuate which
%   joint)
%   - Clines: active joints (joints being actuated by muscles)
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
nq=numel(q);
nm=numel(Muscles);
idxm=find([Muscles.exist]);
nmr=numel(idxm);
%% Compute muscle lengths at current frame
% The current muscle lengths are important for the muscle force computation
L = zeros(nmr,1);

for j=1:nmr % for each muscle
       % compute the length of the muscle
        L(j) = Muscle_length(Human_model,Muscles(idxm(j)),q);
      
end

%% Computation of moment arms
R=zeros(nmr,nq);%init R

for i=1:nq
dq=zeros(nq,1); %differentiation step vector 
dq(i)=dp;
Lpdq=zeros(nmr,1);
Lmdq=zeros(nmr,1);
for j=1:nmr % for each muscle

        % compute the length of the muscle at q+dq
        Lpdq(j) = Muscle_length(Human_model,Muscles(idxm(j)),q+dq);
        % compute the length of the muscle at q-dq
        Lmdq(j) = Muscle_length(Human_model,Muscles(idxm(j)),q-dq);

end
R(:,i)=(-Lpdq+Lmdq)/(2*dp); % it is -dl/dq
end
C=zeros(nmr,nq);

for i=1:nmr
    for j=1:nq
        if R(i,j)~=0
            C(i,j)=1;
        end
    end
end





end