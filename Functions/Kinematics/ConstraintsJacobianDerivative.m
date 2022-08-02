function Kdev=ConstraintsJacobianDerivative(q,dq)
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
    qp=q;
    qm=q;
    qp(qchoix)=qp(qchoix)+dq;
    qm(qchoix)=qm(qchoix)-dq;
    Kp = Jacobian_closedloop_fullq(qp)';
    Km = Jacobian_closedloop_fullq(qm)';
    Kdev(:,:,qchoix) =  (Kp - Km)/(2*dq);
    
end


% Closed loop constraints
% for qchoix=1:length(q)
% 
% 
% %    Kdev2(:,:,qchoix) = ConstraintProjectionDerivative(BiomechanicalModel.OsteoArticularModel,solid_path1,solid_path2,num_solid,num_markers,q,k,qchoix,"one");
% end
% 
% 
% K=[];
% 
% if ~isempty(dependancies)
%     for pp=1:size(dependancies,2)
%         K(size(K,1)+1,dependancies(pp).solid,dependancies(pp).solid) = 0;
%         
%         ddf = dependancies(pp).ddq;
%         
%         if size(dependancies(pp).Joint,1)==1
%             K(size(K,1),dependancies(pp).Joint,dependancies(pp).Joint)= ddf(q(dependancies(pp).Joint));
%             
%         else
%             if size(dependancies(pp).Joint,1)==2
%                 K(size(K,1),[dependancies(pp).Joint],...
%                     [dependancies(pp).Joint])= ddf(q(dependancies(pp).Joint(1)),q(dependancies(pp).Joint(2)));
%             end
%         end
%         
%     end
% end


end