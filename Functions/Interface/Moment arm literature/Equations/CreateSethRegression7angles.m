function  [MomentsArm,RegressionStructure] = CreateSethRegression7angles(MuscleStruct,axis,joints_names,q)

        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula',...
            'GH plane of elevation','Negative GH elevation angle','GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
            [X,Y,Z,W] = ndgrid(unique(MuscleStruct.sampling_grid(1:10000,1)),...
                unique(MuscleStruct.sampling_grid(1:10000,2)),...
                unique(MuscleStruct.sampling_grid(1:10000,3)),...
                unique(MuscleStruct.sampling_grid(1:10000,4)));
            
            [A,B,C] = ndgrid(unique(MuscleStruct.sampling_grid(10001:end,5)),...
                unique(MuscleStruct.sampling_grid(10001:end,6)),...
                unique(MuscleStruct.sampling_grid(10001:end,7)));
            
            MomentArmMat =[];
             if find(k==[1 2 3 4])
                [~, idMuscles] = sortrows(MuscleStruct.sampling_grid(1:10000,1:4) );
                [~, idX] = sortrows([X(:) Y(:) Z(:) W(:)]);
                
                MomentArmMat(idX) = MuscleStruct.moment_arm(idMuscles,k);
                
                MomentArmMat = reshape(MomentArmMat,10,10,10,10);
                
                
            RegressionStructure(k).EquationHandle  = @(q) interpn(X,...
                Y,...
                Z,...
                W,...
                MomentArmMat,...
                q(:,1),q(:,2),q(:,3),q(:,4),'spline');
                
             else
                 
                 
                [~, idMuscles] = sortrows(MuscleStruct.sampling_grid(10001:end,5:7) );
                [~, idX] = sortrows([A(:) B(:) C(:)]);
                
                MomentArmMat(idX) = MuscleStruct.moment_arm(idMuscles,k);
                
                MomentArmMat = reshape(MomentArmMat,10,10,10);
                
                
            RegressionStructure(k).EquationHandle  = @(q) interpn(A,...
                B,...
                C,...
                MomentArmMat,...
                q(:,1),q(:,2),q(:,3),'spline');
            
             end
            
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        [~,ind5] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind6] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind7] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula',...
            'GH plane of elevation','Negative GH elevation angle','GH axial rotation'});
        
        MomentsArm=[];

        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            
              if find(indaxis==[1 2 3 4])
            
                        newq = [q(ind1,:);q(ind2,:);q(ind3,:);q(ind4,:)];
                        MomentsArm = RegressionStructure(indaxis).EquationHandle(newq');
              end
              
        elseif ~isempty(ind5) && ~isempty(ind6) && ~isempty(ind7) &&  ~isempty(indaxis)
                  
              if find(indaxis==[5 6 7])
            
                        newq = [q(ind5,:);q(ind6,:);q(ind7,:)];
                        MomentsArm = RegressionStructure(indaxis).EquationHandle(newq');
              end
                  
        end
        
        
end
        
        