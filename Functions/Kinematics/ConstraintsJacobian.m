function K=ConstraintsJacobian(Human_model,q,solid_path1,solid_path2,num_solid,num_markers,dependancies)
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


% for qchoix=1:length(q)
% %     qp=q;
% %     qm=q;
% %     qp(qchoix)=qp(qchoix)+dq;
% %     qm(qchoix)=qm(qchoix)-dq;
% %     [~,dhp]=NonLinCon_ClosedLoop_Num(Human_model,solid_path1,solid_path2,num_solid,num_markers,qp,k);
% %     [~,dhm]=NonLinCon_ClosedLoop_Num(Human_model,solid_path1,solid_path2,num_solid,num_markers,qm,k);
% %     K(:,qchoix)=(dhp-dhm)/(2*dq);       
%     Ktest(:,qchoix) =  ConstraintProjection(Human_model,solid_path1,solid_path2,num_solid,num_markers,q,k,qchoix,"one");
% end

K = sym(zeros(1,length(q)));

for qchoix=1:length(q)
    Human_model(qchoix).q = q(qchoix);
end

for pp=1:numel(num_solid)
    
    path1 = solid_path1{pp};
    path2 = solid_path2{pp};
    ind1 = find(path1==qchoix);

    
    [Human_model.R] = deal(zeros(3));
    [Human_model.Rproj] = deal(zeros(3));
    [Human_model.p] = deal([0 0 0]');
    [Human_model.pproj] = deal([0 0 0]');
    
   
        if Human_model(path1(1)).joint == 1    % liaison pivot
               Human_model(path1(1)).R = Rodrigues(Human_model(path1(1)).a,q(path1(1)))*Rodrigues(Human_model(path1(1)).u,Human_model(path1(1)).theta); % orientation du rep�re
        end
        if Human_model(path1(1)).joint == 2    % liaison glissi�re
            Human_model(path1(1)).p=Human_model(path1(1)).b + angle*Human_model(path1(1)).a;
        end
   
    Human_model=ForwardPositionsandProj(Human_model,2,path1);
    
     Human_model3 = Human_model;
    [Human_model3.R] = deal(zeros(3));
    [Human_model3.Rproj] = deal(zeros(3));
    [Human_model3.p] = deal([0 0 0]');
    [Human_model3.pproj] = deal([0 0 0]');
    
    if Human_model3(path2(1)).joint == 1    % liaison pivot
               Human_model3(path2(1)).R = Rodrigues(Human_model3(path2(1)).a,q(path2(1)))*Rodrigues(Human_model3(path1(1)).u,Human_model(path1(1)).theta); % orientation du rep�re
        end
        if Human_model3(path2(1)).joint == 2    % liaison glissi�re
            Human_model3(path2(1)).p=Human_model3(path2(1)).b + angle*Human_model3(path2(1)).a;
        end

        
    Human_model3=ForwardPositionsandProj(Human_model3,2,path2);

    s = Human_model(num_solid(pp)).c + Human_model(num_solid(pp)).anat_position{num_markers(pp),2}; % position with respects to the position of the mother solid joint of the closed loop

    for kk=1:length(path1)
         if Human_model(path1(kk)).joint ==1
                     K((1:3)+6*(pp-1),path1(kk)) = diag(Human_model(path1(kk)).Rproj*Human_model3(path2(end)).R');
                     K((4:6)+6*(pp-1),path1(kk)) = ~isempty(ind1)*Human_model(path1(kk)).Rproj*s +...
                                                                                                                     (-1)^(isempty(ind1))*(isempty(ind1))*Human_model(path1(kk)).pproj;
         else
                    K((4:6)+6*(pp-1),path1(kk)) = (-1)^(isempty(ind1))*Human_model(path1(kk)).R*Human_model(path1(kk)).a;
         end
    end
    
    
    for kk=1:length(path2)
         if Human_model(path2(kk)).joint ==1
                     K((1:3)+6*(pp-1),path2(kk)) = diag(Human_model3(path2(kk)).Rproj*Human_model(path1(end)).R');
                     K((4:6)+6*(pp-1),path2(kk)) = isempty(ind1)*Human_model3(path2(kk)).Rproj*s+...
                                                                                                                    (-1)^(~isempty(ind1))*(~isempty(ind1))*Human_model3(path2(kk)).pproj;
         else
                    K((4:6)+6*(pp-1),path2(kk)) = (-1)^(~isempty(ind1))*Human_model3(path2(kk)).R*Human_model3(path2(kk)).a;
         end
    end

end


if ~isempty(dependancies)
    for pp=1:size(dependancies,2)
        K(size(K,1)+1,dependancies(pp).solid) = -1;
        
        df = dependancies(pp).dq;
         
         if size(dependancies(pp).Joint,1)==1
                K(size(K,1),dependancies(pp).Joint)= df(q(dependancies(pp).Joint));
                
            else
                if size(dependancies(pp).Joint,1)==2
                    K(size(K,1),dependancies(pp).Joint)= df(q(dependancies(pp).Joint(1)),q(dependancies(pp).Joint(2)));
                end
            end
       
    end
end













end