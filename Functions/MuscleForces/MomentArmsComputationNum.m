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

%% Dependancies
q_complete=BiomechanicalModel.Generalized_Coordinates.q_complete;
q_map_unsix =BiomechanicalModel.Generalized_Coordinates.q_map_unsix;
q_red_unsix = q_map_unsix'*q_complete;
nqred_unsix=numel(q_red_unsix);

q_map=BiomechanicalModel.Generalized_Coordinates.q_map;
% q_red=q_map'*qval; % real_coordinates

fq_dep=BiomechanicalModel.Generalized_Coordinates.fq_dep;
q_dep_map=BiomechanicalModel.Generalized_Coordinates.q_dep_map;
% q=q_complet+q_dep_map*fq_dep(qval); % add dependancies

q=qval(1:end-6); %only degrees of freedom of the body, not the floating base.

%% Computation of moment arms
R=zeros(nmr,nqred_unsix);%init R

for i=1:nqred_unsix
    dq=zeros(nqred_unsix,1); %differentiation step vector
    dq(i)=dp;
    
    dq_complet=q_map_unsix*dq;
    dq_p=dq_complet+q_dep_map*fq_dep(dq);% plus
    dq_m=-dq_complet+q_dep_map*fq_dep(-dq);% minus
    
    dq_p=dq_p(1:end-6);
    dq_m=dq_m(1:end-6);
    
    Lpdq=zeros(nmr,1);
    Lmdq=zeros(nmr,1);
    for j=1:nmr % for each muscle
        if C(j,i)==1
        % compute the length of the muscle at q+dq
        Lpdq(j) = Muscle_lengthNum(Human_model,Muscles(idxm(j)),q+dq_p); % q+dq
        % compute the length of the muscle at q-dq
        Lmdq(j) = Muscle_lengthNum(Human_model,Muscles(idxm(j)),q+dq_m); % q-dq
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