function [R] = MomentArmsComputationAnalytic(BiomechanicalModel,qval)
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

%
Muscles=BiomechanicalModel.Muscles;
% nq=numel(qval);

idxm=find([Muscles.exist]);
nmr=numel(idxm);

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
R=zeros(nmr,length(q));%init R


MatP1P2 = MomentArmP1P2(q);
MatP4P3 = MomentArmP4P3(q);


for i=unique(col)'
    
    liste = find(col==i);
   
    for k=liste'
        
        j= row(k) ; % muscle indice

        R(j,i) = - 1/vecnorm(MatP1P2(j,i,:))*reshape(MatP1P2(j,i,:),1,3) * reshape(MatP4P3(j,i,:),3,1);
        
    end
end

R = R';



end