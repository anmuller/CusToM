function K=FullConstraintsJacobian(BiomechanicalModel,q,solid_path1,solid_path2,num_solid,num_markers,k,dq,dependancies)
% Return the constraint matrix K, which is the jacobian of the constraints
% by q

%   INPUT
%  - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - q: vector of joint coordinates at a given instant
%   - solid_path1 : vector of one of the two paths to close the loop
%   - solid_path2 : vector of the other of the two paths to close the loop
%   - num_solid : vector of the number of solid where the anatomical point must join the
%   origin of another joint to close the loo
%   - num_markers : vector of the position in the list "anat_position" that
%   corresponds to the point to close the loop
%   - k: vector of homothety coefficient
%   - dp: differentiation step
%   - dependancies: structure where are defined all kinematic dependancies

%   OUTPUT
%   - K : matrix of the derivatives of the constraints by q
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

for qchoix=1:length(q)
    % length of K(:,qchoix) :  30 if "all", 1*9 if "one"
    %K(:,qchoix) =  ConstraintProjection(BiomechanicalModel.OsteoArticularModel,solid_path1,solid_path2,num_solid,num_markers,q,k,qchoix,"one");
    K(:,(qchoix-1)*6+1 : 6*(qchoix-1)+6)=  ConstraintProjection(BiomechanicalModel.OsteoArticularModel,solid_path1,solid_path2,num_solid,num_markers,q,k,qchoix,"all");
end



if ~isempty(dependancies)
    for pp=1:size(dependancies,2)
        if BiomechanicalModel.OsteoArticularModel(dependancies(pp).solid).joint==1
            ind = find (BiomechanicalModel.OsteoArticularModel(dependancies(pp).solid).a);
            K(size(K,1)+1,(dependancies(pp).solid-1)*6+ind+3)=-1;
        else
            ind = find (BiomechanicalModel.OsteoArticularModel(dependancies(pp).solid).a);
            K(size(K,1)+1,(dependancies(pp).solid-1)*6+ind)=-1;
        end
        
        for j=1:size(dependancies(pp).Joint,1)
            qchoix=dependancies(pp).Joint(j);
            qp=q;
            qm=q;
            qp(qchoix)=qp(qchoix)+dq;
            qm(qchoix)=qm(qchoix)-dq;
            f=dependancies(pp).q;
            if size(dependancies(pp).Joint,1)==1
                dhp=f(qp(dependancies(pp).Joint(1)));
                dhm=f(qm(dependancies(pp).Joint(1)));
                
            else
                if size(dependancies(pp).Joint,1)==2
                    dhp=f(qp(dependancies(pp).Joint(1)),qp(dependancies(pp).Joint(2)));
                    dhm=f(qm(dependancies(pp).Joint(1)),qm(dependancies(pp).Joint(2)));
                end
            end
            if BiomechanicalModel.OsteoArticularModel(qchoix).joint==1
                ind = find (BiomechanicalModel.OsteoArticularModel(qchoix).a);
                K(size(K,1),(qchoix-1)*6+ind+3)=(dhp-dhm)/(2*dq);
            else
                ind = find (BiomechanicalModel.OsteoArticularModel(qchoix).a);
                K(size(K,1),(qchoix-1)*6+ind)=(dhp-dhm)/(2*dq);
            end
        end
    end
end




