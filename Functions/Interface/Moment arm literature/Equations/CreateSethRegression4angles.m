function  [MomentsArm,RegressionStructure] = CreateSethRegression4angles(MuscleStruct,axis,joints_names,q)

Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' };

for k = 1:length(Joints)
    
    RegressionStructure(k).joints=   Joints;
    RegressionStructure(k).axe=Joints{k};
    
    [X,Y,Z,W] = ndgrid(unique(MuscleStruct.sampling_grid(:,1)),...
        unique(MuscleStruct.sampling_grid(:,2)),...
        unique(MuscleStruct.sampling_grid(:,3)),...
        unique(MuscleStruct.sampling_grid(:,4)));
    
        [~, idMuscles] = sortrows(MuscleStruct.sampling_grid );
        [~, idX] = sortrows([X(:) Y(:) Z(:) W(:)]);

        MomentArmMat(idX) = MuscleStruct.moment_arm(idMuscles,k);

        MomentArmMat = reshape(MomentArmMat,10,10,10,10);


    RegressionStructure(k).EquationHandle  = @(q) interpn(X,...
        Y,...
        Z,...
        W,...
        MomentArmMat,...
        q(:,1),q(:,2),q(:,3),q(:,4),'spline');
                
end

     [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        
        [~,indaxis] = intersect(axis,Joints);
        
        MomentsArm=[];

        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
                        
                newq = [q(ind1,:);q(ind2,:);q(ind3,:);q(ind4,:)];
                MomentsArm =RegressionStructure(indaxis).EquationHandle(newq');
        end






end