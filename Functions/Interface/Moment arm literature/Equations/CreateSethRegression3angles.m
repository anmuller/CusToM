function [MomentsArm,RegressionStructure] = CreateSethRegression3angles(MuscleStruct,axis,joints_names,q)

Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};


for k = 1:3
    
    RegressionStructure(k).joints=   Joints;
    RegressionStructure(k).axe=Joints{k};
    
    
    [X,Y,Z] = ndgrid(unique(MuscleStruct.sampling_grid(:,1)),...
        unique(MuscleStruct.sampling_grid(:,2)),...
        unique(MuscleStruct.sampling_grid(:,3)));
    
    for ii=1:length(X)
        
        for jj=1:length(Y)
            
            for kk=1:length(Z)
                
                idx = find(sum([MuscleStruct.sampling_grid - [X(ii,jj,kk) Y(ii,jj,kk) Z(ii,jj,kk)]]')==0);
                
                MomentArmMat(ii,jj,kk) = MuscleStruct.moment_arm(idx,k);
                
            end
        end
        
    end
    
    RegressionStructure(k).EquationHandle  = @(q) interpn(X,...
        Y,...
        Z,...
        MomentArmMat,...
        q(:,1),q(:,2),q(:,3));
    
    
    
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