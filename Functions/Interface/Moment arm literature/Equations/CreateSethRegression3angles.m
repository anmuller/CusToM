function [MomentsArm,RegressionStructure] = CreateSethRegression3angles(MuscleStruct,axis,joints_names,q)

Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};


for k = 1:length(Joints)
    
    RegressionStructure(k).joints=   Joints;
    RegressionStructure(k).axe=Joints{k};
    
    
    [X,Y,Z] = ndgrid(unique(MuscleStruct.sampling_grid(:,1)),...
        unique(MuscleStruct.sampling_grid(:,2)),...
        unique(MuscleStruct.sampling_grid(:,3)));
    
                [~, idMuscles] = sortrows(MuscleStruct.sampling_grid );
                [~, idX] = sortrows([X(:) Y(:) Z(:)]);
                
                MomentArmMat(idX) = MuscleStruct.moment_arm(idMuscles,k);
                
                MomentArmMat = reshape(MomentArmMat,10,10,10);
                
                
            RegressionStructure(k).EquationHandle  = @(q) interpn(X,...
                Y,...
                Z,...
                MomentArmMat,...
                q(:,1),q(:,2),q(:,3),'spline');
                
    
    
end

[~,ind1] = intersect(joints_names,{'GH plane of elevation'});
[~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
[~,ind3] = intersect(joints_names,{'GH axial rotation'});

[~,indaxis] = intersect(axis,  Joints);

MomentsArm=[];

if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) && ~isempty(indaxis)
    
    newq = [q(ind1,:) ; q(ind2,:) ;q(ind3,:)];
    MomentsArm =RegressionStructure(indaxis).EquationHandle(newq');
    
end





end