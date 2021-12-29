function [MomentsArm,RegressionStructure] = CreateSethRegression2angles(MuscleStruct,axis,joints_names,q)


Joints = {'Clavicle_J1', 'Clavicle_J2' };


for k = 1:length(Joints)
    
    RegressionStructure(k).joints=   Joints;
    RegressionStructure(k).axe=Joints{k};
    
    
    [X,Y] = ndgrid(unique(MuscleStruct.sampling_grid(:,1)),...
        unique(MuscleStruct.sampling_grid(:,2)));
    
                [~, idMuscles] = sortrows(MuscleStruct.sampling_grid );
                [~, idX] = sortrows([X(:) Y(:)]);
                
                MomentArmMat(idX) = MuscleStruct.moment_arm(idMuscles,k);
                
                MomentArmMat = reshape(MomentArmMat,10,10);
                
                
            RegressionStructure(k).EquationHandle  = @(q) interpn(X,...
                Y,...
                MomentArmMat,...
                q(:,1),q(:,2),'spline');
                
    
    
end

[~,ind1] = intersect(joints_names,{'Clavicle_J1'});
[~,ind2] = intersect(joints_names,{'Clavicle_J2'});

[~,indaxis] = intersect(axis,  {'Clavicle_J1', 'Clavicle_J2' });


if ~isempty(ind1) && ~isempty(ind2) && ~isempty(indaxis)
    newq = [q(ind1,:);q(ind2,:)];
    MomentsArm =RegressionStructure(indaxis).EquationHandle(newq');
    
end




end