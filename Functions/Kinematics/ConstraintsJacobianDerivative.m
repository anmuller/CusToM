function Kdev=ConstraintsJacobianDerivative(BiomechanicalModel,q,solid_path1,solid_path2,num_solid,num_markers,k,dq,dependancies)
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
    Kp =  ConstraintsJacobian(BiomechanicalModel,qp,solid_path1,solid_path2,num_solid,num_markers,k,dq,dependancies);
    Km =  ConstraintsJacobian(BiomechanicalModel,qm,solid_path1,solid_path2,num_solid,num_markers,k,dq,dependancies);
    Kdev(:,:,qchoix) =  (Kp - Km)/(2*dq);
    
%    Kdev2(:,:,qchoix) = ConstraintProjectionDerivative(BiomechanicalModel.OsteoArticularModel,solid_path1,solid_path2,num_solid,num_markers,q,k,qchoix,"one");

end











end