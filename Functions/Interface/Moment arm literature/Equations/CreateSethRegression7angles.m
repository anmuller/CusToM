function  [MomentsArm,RegressionStructure] = CreateSethRegression7angles(MuscleStruct,axis,joints_names,q)

        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula',...
            'GH plane of elevation','Negative GH elevation angle','GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
            [X,Y,Z,W,A,B,C] = ndgrid(unique(MuscleStruct.sampling_grid(:,1)),...
                unique(MuscleStruct.sampling_grid(:,2)),...
                unique(MuscleStruct.sampling_grid(:,3)),...
                unique(MuscleStruct.sampling_grid(:,4)),...
                unique(MuscleStruct.sampling_grid(:,5)),...
                unique(MuscleStruct.sampling_grid(:,6)),...
                unique(MuscleStruct.sampling_grid(:,7)));
            
            for ii=1:length(X)
                
                for jj=1:length(Y)
                    
                    for kk=1:length(Z)
                        
                        for ll=1:length(W)
                            
                            for mm=1:length(A)
                                
                                for nn=1:length(B)
                                    for oo=1:length(C)
                                        
                                        idx = find(sum([MuscleStruct.sampling_grid - [X(ii,jj,kk,ll,mm,nn,oo) Y(ii,jj,kk,ll,mm,nn,oo) ...
                                            Z(ii,jj,kk,ll,mm,nn,oo)  W(ii,jj,kk,ll,mm,nn,oo)]...
                                            A(ii,jj,kk,ll,mm,nn,oo) B(ii,jj,kk,ll,mm,nn,oo) ...
                                            C(ii,jj,kk,ll,mm,nn,oo)]')==0);
                                        
                                        MomentArmMat(ii,jj,kk) = MuscleStruct.moment_arm(idx,k);
                                        
                                    end
                                end
                            end
                        end
                        
                    end
                end
                
            end
            
            RegressionStructure(k).EquationHandle  = @(q) interpn(X,...
                Y,...
                Z,...
                MomentArmMat,...
                q(:,1),q(:,2),q(:,3),q(:,4),q(:,5),q(:,6),q(:,7));
            
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
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            
            newq = [q(ind1,:);q(ind2,:);q(ind3,:);q(ind4,:);q(ind5,:);q(ind6,:);q(ind7,:)];
            MomentsArm = RegressionStructure(indaxis).EquationHandle(newq');
        end
        
        
end
        
        