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
C=BiomechanicalModel.Coupling;
idxm=find([Muscles.exist]);
nmr=numel(idxm);

%
if length(qval)==numel(BiomechanicalModel.OsteoArticularModel(:)) && ~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0'))  
    q=qval(1:end-6); %only degrees of freedom of the body, not the floating base.
else
    q=qval;
end
%% Computation of moment arms
R=zeros(nmr,length(q));%init R

for i=1:length(q)
    dq=zeros(length(q),1); %differentiation step vector
    dq(i)=dp;
    
    Lpdq=zeros(nmr,1);
    Lmdq=zeros(nmr,1);
    for j=1:nmr % for each muscle
        if C(j,i)==1
        % compute the length of the muscle at q+dq
        Lpdq(j) = Muscle_lengthNum(Human_model,Muscles(idxm(j)),q+dq); 
        % compute the length of the muscle at q-dq
        Lmdq(j) = Muscle_lengthNum(Human_model,Muscles(idxm(j)),q-dq); 
    %         R(:,i)=(-Lpdq+Lmdq)/(2*dp); % it is -dl/dq
            % if Lpdq(j)~=0 || Lmdq(j)~=0
            %     R(:,i)=(-Lpdq+Lmdq)/(2*dp); % it is -dl/dq
            % else
            %     R(:,i)=0;
            % end
        end
    end
    R(:,i)=(-Lpdq+Lmdq)/(2*dp); % it is -dl/dq
end
% beware that the matrix is finally nq*nm
R=R';





end