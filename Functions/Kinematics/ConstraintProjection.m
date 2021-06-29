function [ceq]=ConstraintProjection(Human_model,solid_path1,solid_path2,num_solid,num_markers,q,k,qchoix,String)
% Non-linear equation used in the inverse kinematics step for closed loops
%
%   INPUT
%  - Human_model: osteo-articular model (see the Documentation for the
%   structure)
%   - solid_path1 : vector of one of the two paths to close the loop
%   - solid_path2 : vector of the other of the two paths to close the loop
%   - num_solid : vector of the number of solid where the anatomical point must join the
%   origin of another joint to close the loop
%   - num_markers : vector of the position in the list "anat_position" that
%   corresponds to the point to close the loop
%   - q: vector of joint coordinates at a given instant
%   - k: vector of homothety coefficient
%
%   OUTPUT
%   - c: non-linar inequality
%   - ceq: non-linear equality
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

% Contraints initialization

%ceq=zeros(9*length(num_solid),1);

if strcmp(String,"all")
    ceq=zeros(6*length(num_solid),6);
else
    ceq=zeros(6*length(num_solid),1);
end


for pp=1:numel(num_solid)
    
    if isempty(solid_path2{pp}) % if the beginning coincides with the end of the loop
        
        % Computation on path
        path = solid_path1{pp};
        ind = find(path==qchoix);
        
        if (~isempty(ind) && ind~=1)
            
            [Human_model,p,R] = ForwardKinematics_ClosedLoop(Human_model,1,[0 0 0]',path(1:ind),[0 0 0]',eye(3),q,k);
            
            
            if strcmp(String,"all")
                
                for idx=1:3 %Translation
                    vec=[0 0 0]';
                    vec(idx)=1;
                    ptemp = R*vec;
                    
                    ceq(1+6*(pp-1),idx)=0;
                    ceq(2+6*(pp-1),idx)=0;
                    ceq(3+6*(pp-1),idx)=0;
                    
                    ceq(4+6*(pp-1),idx)=ptemp(1);
                    ceq(5+6*(pp-1),idx)=ptemp(2);
                    ceq(6+6*(pp-1),idx)=ptemp(3);
                end
                
                for idx=1:3 %Rotation
                    vec=[0 0 0]';
                    vec(idx)=1;
                    s = Human_model(num_solid(pp)).c + Human_model(num_solid(pp)).anat_position{num_markers(pp),2}; % position with respects to the position of the mother solid joint of the closed loop
                    Rtemp = R*wedge(vec);
                    ptemp = 0*p;
                    
                    if ~isempty(mainpath(ind+1:end))
                        [Human_model,ptemp,Rtemp] = ForwardKinematics_ClosedLoop(Human_model,1,0*s,mainpath(ind+1:end),0*p,Rtemp,q,k);
                    end
                    if ~isempty(intersect(mainpath,num_solid(pp))) % Finding the solid with the anatomical position to be respected
                        ptemp = Rtemp*s ;
                    end
                    ceq(1+6*(pp-1),idx+3)=Rtemp(1,1);
                    ceq(2+6*(pp-1),idx+3)=Rtemp(2,2);
                    ceq(3+6*(pp-1),idx+3)=Rtemp(3,3);
                    
                    ceq(4+6*(pp-1),idx+3)=ptemp(1);
                    ceq(5+6*(pp-1),idx+3)=ptemp(2);
                    ceq(6+6*(pp-1),idx+3)=ptemp(3);
                end
                
            else
                
                if Human_model(qchoix).joint==1
                    
                    
                    s = Human_model(num_solid(pp)).c + Human_model(num_solid(pp)).anat_position{num_markers(pp),2}; % position with respects to the position of the mother solid joint of the closed loop
                    Rtemp = R*wedge(Human_model(qchoix).a);
                    ptemp = 0*p;
                    
                    if ~isempty(mainpath(ind+1:end))
                        [Human_model,ptemp,Rtemp] = ForwardKinematics_ClosedLoop(Human_model,1,0*s,mainpath(ind+1:end),0*p,Rtemp,q,k);
                    end
                    if ~isempty(intersect(mainpath,num_solid(pp))) % Finding the solid with the anatomical position to be respected
                        ptemp = Rtemp*s ;
                    end
                    
                    
                    ceq(1+6*(pp-1))=Rtemp(1,1);
                    ceq(2+6*(pp-1))=Rtemp(2,2);
                    ceq(3+6*(pp-1))=Rtemp(3,3);
                    %                     ceq(4+9*(pp-1))=Rtemp(1,2);
                    %                     ceq(5+9*(pp-1))=Rtemp(1,3);
                    %                     ceq(6+9*(pp-1))=Rtemp(2,3);
                    ceq(4+6*(pp-1))=ptemp(1);
                    ceq(5+6*(pp-1))=ptemp(2);
                    ceq(6+6*(pp-1))=ptemp(3);
                    
                else
                    ptemp = R*Human_model(qchoix).a;
                    
                    ceq(1+6*(pp-1))=0;
                    ceq(2+6*(pp-1))=0;
                    ceq(3+6*(pp-1))=0;
                    %                     ceq(4+9*(pp-1))=0;
                    %                     ceq(5+9*(pp-1))=0;
                    %                     ceq(6+9*(pp-1))=0;
                    ceq(4+6*(pp-1))=ptemp(1);
                    ceq(5+6*(pp-1))=ptemp(2);
                    ceq(6+6*(pp-1))=ptemp(3);
                    
                end
                
            end
            
            
            
            
        end
        
    else
        if isempty(solid_path1{pp}) % if the beginning coincides with the end of the loop
            
            
            % Computation on path
            path = solid_path2{pp};
            ind = find(path==qchoix);
            
            if (~isempty(ind) && ind~=1)
                
                [Human_model,p,R] = ForwardKinematics_ClosedLoop(Human_model,1,[0 0 0]',path(1:ind),[0 0 0]',eye(3),q,k);
                
                
                if strcmp(String,"all")
                    
                    for idx=1:3 %Translation
                        vec=[0 0 0]';
                        vec(idx)=1;
                        ptemp = R*vec;
                        
                        ceq(1+6*(pp-1),idx)=0;
                        ceq(2+6*(pp-1),idx)=0;
                        ceq(3+6*(pp-1),idx)=0;
                        
                        ceq(4+6*(pp-1),idx)=ptemp(1);
                        ceq(5+6*(pp-1),idx)=ptemp(2);
                        ceq(6+6*(pp-1),idx)=ptemp(3);
                    end
                    
                    for idx=1:3 %Rotation
                        vec=[0 0 0]';
                        vec(idx)=1;
                        
                        s = Human_model(num_solid(pp)).c + Human_model(num_solid(pp)).anat_position{num_markers(pp),2}; % position with respects to the position of the mother solid joint of the closed loop
                        Rtemp = R*wedge(vec);
                        ptemp = 0*p;
                        
                        if ~isempty(mainpath(ind+1:end))
                            [Human_model,ptemp,Rtemp] = ForwardKinematics_ClosedLoop(Human_model,1,0*s,mainpath(ind+1:end),0*p,Rtemp,q,k);
                        end
                        if ~isempty(intersect(mainpath,num_solid(pp))) % Finding the solid with the anatomical position to be respected
                            ptemp = Rtemp*s ;
                        end
                        
                        
                        ceq(1+6*(pp-1),idx+3)=Rtemp(1,1);
                        ceq(2+6*(pp-1),idx+3)=Rtemp(2,2);
                        ceq(3+6*(pp-1),idx+3)=Rtemp(3,3);
                        
                        ceq(4+6*(pp-1),idx+3)=ptemp(1);
                        ceq(5+6*(pp-1),idx+3)=ptemp(2);
                        ceq(6+6*(pp-1),idx+3)=ptemp(3);
                    end
                    
                else
                    
                    if Human_model(qchoix).joint==1
                        
                        
                        s = Human_model(num_solid(pp)).c + Human_model(num_solid(pp)).anat_position{num_markers(pp),2}; % position with respects to the position of the mother solid joint of the closed loop
                        Rtemp = R*wedge(Human_model(qchoix).a);
                        ptemp = 0*p;
                        
                        if ~isempty(mainpath(ind+1:end))
                            [Human_model,ptemp,Rtemp] = ForwardKinematics_ClosedLoop(Human_model,1,0*s,mainpath(ind+1:end),0*p,Rtemp,q,k);
                        end
                        if ~isempty(intersect(mainpath,num_solid(pp))) % Finding the solid with the anatomical position to be respected
                            ptemp = Rtemp*s ;
                        end
                        
                        
                        ceq(1+6*(pp-1))=Rtemp(1,1);
                        ceq(2+6*(pp-1))=Rtemp(2,2);
                        ceq(3+6*(pp-1))=Rtemp(3,3);
                        %                         ceq(4+9*(pp-1))=Rtemp(1,2);
                        %                         ceq(5+9*(pp-1))=Rtemp(1,3);
                        %                         ceq(6+9*(pp-1))=Rtemp(2,3);
                        ceq(4+6*(pp-1))=ptemp(1);
                        ceq(5+6*(pp-1))=ptemp(2);
                        ceq(6+6*(pp-1))=ptemp(3);
                        
                    else
                        ptemp = R*Human_model(qchoix).a;
                        
                        ceq(1+6*(pp-1))=0;
                        ceq(2+6*(pp-1))=0;
                        ceq(3+6*(pp-1))=0;
                        %                         ceq(4+9*(pp-1))=0;
                        %                         ceq(5+9*(pp-1))=0;
                        %                         ceq(6+9*(pp-1))=0;
                        ceq(4+6*(pp-1))=ptemp(1);
                        ceq(5+6*(pp-1))=ptemp(2);
                        ceq(6+6*(pp-1))=ptemp(3);
                        
                    end
                end
                
                
                
            end
            
            
            
        else% if the loop is cut elsewhere in the loop
            
            % Computation on path
            path1 = solid_path1{pp};
            ind1 = find(path1==qchoix);
            
            path2 = solid_path2{pp};
            ind2 = find(path2==qchoix);
            
            ind=[];
            
            if ~isempty(ind1)
                mainpath = path1;
                secondarypath = path2;
                ind = ind1;
                
            elseif ~isempty(ind2)
                mainpath = path2;
                secondarypath = path1;
                ind = ind2;
                
            end
            
            if (~isempty(ind) && ind~=1)
                
                
                
                [Human_model,p,R] = ForwardKinematics_ClosedLoop(Human_model,1,[0 0 0]',mainpath(1:ind),[0 0 0]',eye(3),q,k);
                [Human_model,~,R_ClosedLoop2] = ForwardKinematics_ClosedLoop(Human_model,1,[0 0 0],secondarypath,[0 0 0]',eye(3),q,k);
                
                
                
                if strcmp(String,"all")
                    
                    for idx=1:3 %Translation
                        vec=[0 0 0]';
                        vec(idx)=1;
                        
                        ptemp = R*vec;
                        
                        
                        if ~isempty(ind1)
                            
                            
                            ceq(1+6*(pp-1),idx)=0;
                            ceq(2+6*(pp-1),idx)=0;
                            ceq(3+6*(pp-1),idx)=0;
                            
                            ceq(4+6*(pp-1),idx)=-ptemp(1);
                            ceq(5+6*(pp-1),idx)=-ptemp(2);
                            ceq(6+6*(pp-1),idx)=-ptemp(3);
                            
                        else
                            
                            ceq(1+6*(pp-1),idx)=0;
                            ceq(2+6*(pp-1),idx)=0;
                            ceq(3+6*(pp-1),idx)=0;
                            
                            ceq(4+6*(pp-1),idx)=ptemp(1);
                            ceq(5+6*(pp-1),idx)=ptemp(2);
                            ceq(6+6*(pp-1),idx)=ptemp(3);
                            
                        end
                    end
                    
                    for idx=1:3 %Rotation
                        vec=[0 0 0]';
                        vec(idx)=1;
                        
                        s = Human_model(num_solid(pp)).c + Human_model(num_solid(pp)).anat_position{num_markers(pp),2}; % position with respects to the position of the mother solid joint of the closed loop
                        Rtemp = R*wedge(vec);
                        ptemp = 0*p;
                        
                        if ~isempty(mainpath(ind+1:end))
                            [Human_model,ptemp,Rtemp] = ForwardKinematics_ClosedLoop(Human_model,1,0*s,mainpath(ind+1:end),0*p,Rtemp,q,k);
                        end
                        if ~isempty(intersect(mainpath,num_solid(pp))) % Finding the solid with the anatomical position to be respected
                            ptemp = Rtemp*s ;
                        end
                        
                        
                        if ~isempty(ind1)
                            Rtemp= Rtemp*R_ClosedLoop2';
                            
                            ceq(1+6*(pp-1),idx+3)=Rtemp(1,1);
                            ceq(2+6*(pp-1),idx+3)=Rtemp(2,2);
                            ceq(3+6*(pp-1),idx+3)=Rtemp(3,3);
                            
                            ceq(4+6*(pp-1),idx+3)=-ptemp(1);
                            ceq(5+6*(pp-1),idx+3)=-ptemp(2);
                            ceq(6+6*(pp-1),idx+3)=-ptemp(3);
                            
                        else
                            
                            Rtemp= -Rtemp*R_ClosedLoop2';
                            
                            
                            ceq(1+6*(pp-1),idx+3)=Rtemp(1,1);
                            ceq(2+6*(pp-1),idx+3)=Rtemp(2,2);
                            ceq(3+6*(pp-1),idx+3)=Rtemp(3,3);
                            
                            ceq(4+6*(pp-1),idx+3)=ptemp(1);
                            ceq(5+6*(pp-1),idx+3)=ptemp(2);
                            ceq(6+6*(pp-1),idx+3)=ptemp(3);
                        end
                        
                    end
                    
                else
                    
                    if Human_model(qchoix).joint==1
                        s = Human_model(num_solid(pp)).c + Human_model(num_solid(pp)).anat_position{num_markers(pp),2}; % position with respects to the position of the mother solid joint of the closed loop
                        Rtemp = R*wedge(Human_model(qchoix).a);
                        ptemp = 0*p;
                        
                        if ~isempty(mainpath(ind+1:end))
                            [Human_model,ptemp,Rtemp] = ForwardKinematics_ClosedLoop(Human_model,1,0*s,mainpath(ind+1:end),0*p,Rtemp,q,k);
                        end
                        if ~isempty(intersect(mainpath,num_solid(pp))) % Finding the solid with the anatomical position to be respected
                            ptemp = Rtemp*s ;
                        end
                        
                        if ~isempty(ind1)
                            Rtemp= Rtemp*R_ClosedLoop2';
                            
                            ceq(1+6*(pp-1))=Rtemp(1,1);
                            ceq(2+6*(pp-1))=Rtemp(2,2);
                            ceq(3+6*(pp-1))=Rtemp(3,3);
                            %                             ceq(4+9*(pp-1))=Rtemp(1,2);
                            %                             ceq(5+9*(pp-1))=Rtemp(1,3);
                            %                             ceq(6+9*(pp-1))=Rtemp(2,3);
                            ceq(4+6*(pp-1))=-ptemp(1);
                            ceq(5+6*(pp-1))=-ptemp(2);
                            ceq(6+6*(pp-1))=-ptemp(3);
                        else
                            Rtemp= -Rtemp*R_ClosedLoop2';
                            ceq(1+6*(pp-1))=Rtemp(1,1);
                            ceq(2+6*(pp-1))=Rtemp(2,2);
                            ceq(3+6*(pp-1))=Rtemp(3,3);
                            %                             ceq(4+9*(pp-1))=Rtemp(1,2);
                            %                             ceq(5+9*(pp-1))=Rtemp(1,3);
                            %                             ceq(6+9*(pp-1))=Rtemp(2,3);
                            ceq(4+6*(pp-1))=ptemp(1);
                            ceq(5+6*(pp-1))=ptemp(2);
                            ceq(6+6*(pp-1))=ptemp(3);
                            
                        end
                    else
                        ptemp = R*Human_model(qchoix).a;
                        
                        ceq(1+6*(pp-1))=0;
                        ceq(2+6*(pp-1))=0;
                        ceq(3+6*(pp-1))=0;
                        %                         ceq(4+9*(pp-1))=0;
                        %                         ceq(5+9*(pp-1))=0;
                        %                         ceq(6+9*(pp-1))=0;
                        
                        
                        if ~isempty(ind1)
                            
                            
                            ceq(4+6*(pp-1))=-ptemp(1);
                            ceq(5+6*(pp-1))=-ptemp(2);
                            ceq(6+6*(pp-1))=-ptemp(3);
                            
                        else
                            
                            ceq(4+6*(pp-1))=ptemp(1);
                            ceq(5+6*(pp-1))=ptemp(2);
                            ceq(6+6*(pp-1))=ptemp(3);
                            
                        end
                        
                        
                    end
                end
                
                
            end
        end
    end
end


end