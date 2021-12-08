function [MomentsArm,RegressionStructure]=SethMomentArm(mus_name,axis,joints_names,q)
% Computing of moment arm as a function of q
%
% All data comes from
% Seth, A., Dong, M., Matias, R., & Delp, S. (2019).
% Muscle contributions to upper-extremity movement and
% work from a musculoskeletal model of the human shoulder.
% Frontiers in Neurorobotics, 13(November), 1–9.
% https://doi.org/10.3389/fnbot.2019.00090
%
%   INPUT
%   - mus_name : name of the muscle concerned
%   - axis : vector of the moment arm axe
%   - joints_names : vector of names of the joints concerned in the moment
%   arm
%   - q : vector of coordinates at the current instant
%
%   OUTPUT
%   - MusculotendonLength : value of moment arm
%   - RegressionStructure : structure containing moment arm
%   equations and coefficients
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________


mus_name = mus_name{:};
mus_name = mus_name(2:end);
MomentsArm = [];
RegressionStructure = [];
load('SethMomentArmData.mat');


if ~isempty(intersect(mus_name,{'Coracobrachialis','DeltoideusScapula_M','DeltoideusScapula_P','Infraspinatus_I','Infraspinatus_S',...
        'LatissimusDorsi_I', 'LatissimusDorsi_S','LevatorScapulae','PectoralisMajorThorax_I','PectoralisMajorThorax_M'...
        'PectoralisMinor','Rhomboideus_I','Rhomboideus_S','SerratusAnterior_I','SerratusAnterior_M','SerratusAnterior_S',...
        'Subscapularis_I','Subscapularis_M','Subscapularis_S','Supraspinatus_A','Supraspinatus_P','TeresMajor',...
        'TeresMinor','TrapeziusClavicle_S','TrapeziusScapula_I','TrapeziusScapula_M','TrapeziusScapula_S'}))
    
    
    %% GH muscles
    
    if strcmp(mus_name,'Coracobrachialis')
        
        Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
            
            RegressionStructure(k).EquationHandle = @(q)  interpn( Coracobrachialis.sampling_grid(:,1), Coracobrachialis.sampling_grid(:,2),...
                Coracobrachialis.sampling_grid(:,3),Coracobrachialis.moment_arm(:,k),...
                q(1,:),q(2,:),q(3,:));
            
        end
        
        
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'});
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) && ~isempty(indaxis)
%             MomentsArm = interpn( Coracobrachialis.sampling_grid(:,1)', Coracobrachialis.sampling_grid(:,2)',...
%                 Coracobrachialis.sampling_grid(:,3)',Coracobrachialis.moment_arm(:,indaxis)',...
%                 q(ind1,:),q(ind2,:),q(ind3,:));
            
                                                            
            [X,Y,Z] = ndgrid(unique(Coracobrachialis.sampling_grid(:,1)),...
                                                unique(Coracobrachialis.sampling_grid(:,2)),...
                                                unique(Coracobrachialis.sampling_grid(:,3)));
                                            
        for ii=1:length(X)
            
            for jj=1:length(Y)
                
                for kk=1:length(Z)
                    
                    idx = find(sum([Coracobrachialis.sampling_grid - [X(ii,jj,kk) Y(ii,jj,kk) Z(ii,jj,kk)]]')==0);

                    MomentArmMat(ii,jj,kk) = Coracobrachialis.moment_arm(idx,indaxis);
                    
                end
            end

        end
                                            
            MomentsArm = interpn(X,...
                                                                Y,...
                                                                Z,...
                                                                MomentArmMat,...
                                                                q(ind1,:),q(ind2,:),q(ind3,:));
        end
        
    elseif strcmp(mus_name,'DeltoideusScapula_M')
        
        Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        
        
        [~,indaxis] = intersect(axis,  {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'});
        
        
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) && ~isempty(indaxis)
            MomentsArm = interpn( DeltoideusScapula_M.sampling_grid(:,1), DeltoideusScapula_M.sampling_grid(:,2),...
                DeltoideusScapula_M.sampling_grid(:,3),DeltoideusScapula_M.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:));
        end
    elseif strcmp(mus_name,'DeltoideusScapula_P')
        
        Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'});
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) && ~isempty(indaxis)
            MomentsArm = interpn( DeltoideusScapula_P.sampling_grid(:,1), DeltoideusScapula_P.sampling_grid(:,2),...
                DeltoideusScapula_P.sampling_grid(:,3),DeltoideusScapula_P.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:));
        end
        
    elseif strcmp(mus_name,'Infraspinatus_I')
        
        Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'});
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) && ~isempty(indaxis)
            MomentsArm = interpn( Infraspinatus_I.sampling_grid(:,1), Infraspinatus_I.sampling_grid(:,2),...
                Infraspinatus_I.sampling_grid(:,3),Infraspinatus_I.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:));
        end
    elseif strcmp(mus_name,'Infraspinatus_S')
        
        Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'});
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) && ~isempty(indaxis)
            MomentsArm = interpn( Infraspinatus_S.sampling_grid(:,1), Infraspinatus_S.sampling_grid(:,2),...
                Infraspinatus_S.sampling_grid(:,3),Infraspinatus_S.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:));
        end
        
    elseif strcmp(mus_name,'Subscapularis_I')
        
        Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'});
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) && ~isempty(indaxis)
            MomentsArm = interpn( Subscapularis_I.sampling_grid(:,1), Subscapularis_I.sampling_grid(:,2),...
                Subscapularis_I.sampling_grid(:,3),Subscapularis_I.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:));
        end
        
    elseif strcmp(mus_name,'Subscapularis_M')
        
        Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        
        
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'});
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) && ~isempty(indaxis)
            MomentsArm = interpn( Subscapularis_M.sampling_grid(:,1), Subscapularis_M.sampling_grid(:,2),...
                Subscapularis_M.sampling_grid(:,3),Subscapularis_M.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:));
        end
        
    elseif strcmp(mus_name,'Supraspinatus_A')
        
        
        Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'});
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) && ~isempty(indaxis)
            MomentsArm = interpn( Supraspinatus_A.sampling_grid(:,1), Supraspinatus_A.sampling_grid(:,2),...
                Supraspinatus_A.sampling_grid(:,3),Supraspinatus_A.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:));
        end
        
        
    elseif strcmp(mus_name,'Supraspinatus_P')
        
        
        Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'});
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) && ~isempty(indaxis)
            MomentsArm = interpn( Supraspinatus_P.sampling_grid(:,1), Supraspinatus_P.sampling_grid(:,2),...
                Supraspinatus_P.sampling_grid(:,3),Supraspinatus_P.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:));
        end
        
        
    elseif strcmp(mus_name,'TeresMajor')
        
        Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        
        
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'});
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) && ~isempty(indaxis)
            MomentsArm = interpn( TeresMajor.sampling_grid(:,1), TeresMajor.sampling_grid(:,2),...
                TeresMajor.sampling_grid(:,3),TeresMajor.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:));
        end
        
        
    elseif strcmp(mus_name,'TeresMinor')
        
        Joints = {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        
        
        [~,ind1] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind2] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind3] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'GH plane of elevation', 'Negative GH elevation angle', 'GH axial rotation'});
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) && ~isempty(indaxis)
            MomentsArm = interpn( TeresMinor.sampling_grid(:,1), TeresMinor.sampling_grid(:,2),...
                TeresMinor.sampling_grid(:,3),TeresMinor.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:));
        end
        
        
        %% Scapula  muscles
        
    elseif strcmp(mus_name,'LevatorScapulae')
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' };
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' });
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            MomentsArm = interpn( LevatorScapulae.sampling_grid(:,1), LevatorScapulae.sampling_grid(:,2),...
                LevatorScapulae.sampling_grid(:,3),LevatorScapulae.sampling_grid(:,4),...
                LevatorScapulae.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:));
        end
        
    elseif strcmp(mus_name,'Rhomboideus_I')
        
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' };
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' });
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            MomentsArm = interpn( Rhomboideus_I.sampling_grid(:,1), Rhomboideus_I.sampling_grid(:,2),...
                Rhomboideus_I.sampling_grid(:,3),Rhomboideus_I.sampling_grid(:,4),...
                Rhomboideus_I.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:));
        end
    elseif strcmp(mus_name,'Rhomboideus_S')
        
        
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' };
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' });
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            MomentsArm = interpn( Rhomboideus_S.sampling_grid(:,1), Rhomboideus_S.sampling_grid(:,2),...
                Rhomboideus_S.sampling_grid(:,3),Rhomboideus_S.sampling_grid(:,4),...
                Rhomboideus_S.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:));
        end
        
    elseif strcmp(mus_name,'SerratusAnterior_I')
        
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' };
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' });
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            MomentsArm = interpn( SerratusAnterior_I.sampling_grid(:,1), SerratusAnterior_I.sampling_grid(:,2),...
                SerratusAnterior_I.sampling_grid(:,3),SerratusAnterior_I.sampling_grid(:,4),...
                SerratusAnterior_I.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:));
        end
        
    elseif strcmp(mus_name,'SerratusAnterior_M')
        
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' };
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' });
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            MomentsArm = interpn( SerratusAnterior_M.sampling_grid(:,1), SerratusAnterior_M.sampling_grid(:,2),...
                SerratusAnterior_M.sampling_grid(:,3),SerratusAnterior_M.sampling_grid(:,4),...
                SerratusAnterior_M.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:));
        end
        
    elseif strcmp(mus_name,'SerratusAnterior_S')
        
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' };
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' });
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            MomentsArm = interpn( SerratusAnterior_S.sampling_grid(:,1), SerratusAnterior_S.sampling_grid(:,2),...
                SerratusAnterior_S.sampling_grid(:,3),SerratusAnterior_S.sampling_grid(:,4),...
                SerratusAnterior_S.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:));
        end
        
    elseif strcmp(mus_name,'TrapeziusScapula_I')
        
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' };
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' });
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            MomentsArm = interpn( TrapeziusScapula_I.sampling_grid(:,1), TrapeziusScapula_I.sampling_grid(:,2),...
                TrapeziusScapula_I.sampling_grid(:,3),TrapeziusScapula_I.sampling_grid(:,4),...
                TrapeziusScapula_I.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:));
        end
        
        
    elseif strcmp(mus_name,'TrapeziusScapula_M')
        
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' };
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' });
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            MomentsArm = interpn( TrapeziusScapula_M.sampling_grid(:,1), TrapeziusScapula_M.sampling_grid(:,2),...
                TrapeziusScapula_M.sampling_grid(:,3),TrapeziusScapula_M.sampling_grid(:,4),...
                TrapeziusScapula_M.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:));
        end
        
        
        
    elseif strcmp(mus_name,'TrapeziusScapula_S')
        
        
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' };
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' });
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            MomentsArm = interpn( TrapeziusScapula_S.sampling_grid(:,1), TrapeziusScapula_S.sampling_grid(:,2),...
                TrapeziusScapula_S.sampling_grid(:,3),TrapeziusScapula_S.sampling_grid(:,4),...
                TrapeziusScapula_S.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:));
        end
        
        %% Scapula and GH  muscles
        
        
        
        
    elseif strcmp(mus_name,'LatissimusDorsi_I')
        
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula',...
            'GH plane of elevation','Negative GH elevation angle','GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
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
            MomentsArm = interpn( LatissimusDorsi_I.sampling_grid(:,1), LatissimusDorsi_I.sampling_grid(:,2),...
                LatissimusDorsi_I.sampling_grid(:,3),LatissimusDorsi_I.sampling_grid(:,4),...
                LatissimusDorsi_I.sampling_grid(:,5),LatissimusDorsi_I.sampling_grid(:,6),...
                LatissimusDorsi_I.sampling_grid(:,7),LatissimusDorsi_I.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:),q(ind5,:),q(ind6,:),q(ind7,:));
        end
        
        
        
        
    elseif strcmp(mus_name,'LatissimusDorsi_S')
        
        
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula',...
            'GH plane of elevation','Negative GH elevation angle','GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        [~,ind5] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind6] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind7] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' });
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            MomentsArm = interpn( LatissimusDorsi_S.sampling_grid(:,1), LatissimusDorsi_S.sampling_grid(:,2),...
                LatissimusDorsi_S.sampling_grid(:,3),LatissimusDorsi_S.sampling_grid(:,4),...
                LatissimusDorsi_S.sampling_grid(:,5),LatissimusDorsi_S.sampling_grid(:,6),...
                LatissimusDorsi_S.sampling_grid(:,7),LatissimusDorsi_S.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:),q(ind5,:),q(ind6,:),q(ind7,:));
        end
        
        
    elseif strcmp(mus_name,'PectoralisMajorThorax_I')
        
        
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula',...
            'GH plane of elevation','Negative GH elevation angle','GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        [~,ind5] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind6] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind7] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' });
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            MomentsArm = interpn( PectoralisMajorThorax_I.PectoralisMajorThorax_I(:,1), PectoralisMajorThorax_I.sampling_grid(:,2),...
                PectoralisMajorThorax_I.sampling_grid(:,3),PectoralisMajorThorax_I.sampling_grid(:,4),...
                PectoralisMajorThorax_I.sampling_grid(:,5),PectoralisMajorThorax_I.sampling_grid(:,6),...
                PectoralisMajorThorax_I.sampling_grid(:,7),PectoralisMajorThorax_I.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:),q(ind5,:),q(ind6,:),q(ind7,:));
        end
        
        
        
    elseif strcmp(mus_name,'PectoralisMajorThorax_M')
        
        
        Joints = {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula',...
            'GH plane of elevation','Negative GH elevation angle','GH axial rotation'};
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        
        [~,ind1] = intersect(joints_names,{'ScapuloThoracic_J4'});
        [~,ind2] = intersect(joints_names,{'ScapuloThoracic_J5'});
        [~,ind3] = intersect(joints_names,{'ScapuloThoracic_J6'});
        [~,ind4] = intersect(joints_names,{'Scapula'});
        [~,ind5] = intersect(joints_names,{'GH plane of elevation'});
        [~,ind6] = intersect(joints_names,{'Negative GH elevation angle'});
        [~,ind7] = intersect(joints_names,{'GH axial rotation'});
        
        [~,indaxis] = intersect(axis,  {'ScapuloThoracic_J4', 'ScapuloThoracic_J5', 'ScapuloThoracic_J6','Scapula' });
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(ind3) &&~isempty(ind4) && ~isempty(indaxis)
            MomentsArm = interpn( PectoralisMajorThorax_M.PectoralisMajorThorax_I(:,1), PectoralisMajorThorax_M.sampling_grid(:,2),...
                PectoralisMajorThorax_M.sampling_grid(:,3),PectoralisMajorThorax_M.sampling_grid(:,4),...
                PectoralisMajorThorax_M.sampling_grid(:,5),PectoralisMajorThorax_M.sampling_grid(:,6),...
                PectoralisMajorThorax_M.sampling_grid(:,7),PectoralisMajorThorax_M.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:),q(ind3,:),q(ind4,:),q(ind5,:),q(ind6,:),q(ind7,:));
        end
        
        %% Clavicule muscle
        
        
        
        
    elseif strcmp(mus_name,'TrapeziusClavicle_S')
        
        
        Joints = {'Clavicle_J1', 'Clavicle_J2' };
        
        for k = 1:length(Joints)
            
            RegressionStructure(k).joints=   Joints;
            RegressionStructure(k).axe=Joints{k};
            
        end
        
        [~,ind1] = intersect(joints_names,{'Clavicle_J1'});
        [~,ind2] = intersect(joints_names,{'Clavicle_J2'});
        
        [~,indaxis] = intersect(axis,  {'Clavicle_J1', 'Clavicle_J2' });
        
        
        if ~isempty(ind1) && ~isempty(ind2) && ~isempty(indaxis)
            MomentsArm = interpn( TrapeziusClavicle_S.PectoralisMajorThorax_I(:,1), TrapeziusClavicle_S.sampling_grid(:,2),...
                TrapeziusClavicle_S.moment_arm(:,indaxis),...
                q(ind1,:),q(ind2,:));
        end
        
    end
    
    
    
end