function [c,ceq]=InCylinderTheta(theta,joint_num,HumanModel,num_solid,num_markers,yinsertion,yorigin,par_case)
% Verifying that muscle via points are contained in a cylinder volume
%
%   INPUT
%   - theta : vector of rotation of via points
%   - joint_num  : vector of solids around via points rotates of theta
%   - HumanModel : osteo-articular model (see the Documentation for
%   the structure);
%   - num_solid : vector of solids of origin, via, and insertion points
%   - num_markers: vector of anatomical positions of origin, via, and insertion points
%   - sign_insertion : sign of y insertion point  in its local frame
%   - sign_origin : sign of y origin point  in its local frame
%   - Regression : structure of  musculotendon length
%
%   OUTPUT
%   - BiomechanicalModel: musculoskeletal model
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

ceq=0;

[HumanModel]=OnCircle(theta,joint_num,HumanModel,num_solid,num_markers);


c=[];
for k=1:numel(num_solid)
    temp1=num_solid(k);
    temp2=num_markers(k);
    
    if strcmp(HumanModel(temp1).name,'RHumerus')
        rho=1.07;
    else
        if strcmp(HumanModel(temp1).name,'RRadius') || strcmp(HumanModel(temp1).name,'RUlna')
            rho=1.13;
        else
            if strcmp(HumanModel(temp1).name,'RHand')
                rho=1.16;
            end
        end
    end
    
    if HumanModel(temp1).child
        seglength=norm(HumanModel(HumanModel(temp1).child).b);
        temp3=temp1;
        while ~seglength && temp3
            temp3=HumanModel(temp3).child;
            seglength=norm(HumanModel(HumanModel(temp3).child).b);
        end
        if ~temp3
            temp3=HumanModel(temp3).mother;
            [~,numnode]=intersect( HumanModel(temp3).anat_position(:,1),[HumanModel(temp3).name '_EndNode']);
            seglength = norm(HumanModel(temp3).anat_position{numnode,2});
        end
        
    else
        [~,numnode]=intersect( HumanModel(temp1).anat_position(:,1),[HumanModel(temp1).name '_EndNode']);
        seglength = norm(HumanModel(temp1).anat_position{numnode,2});
    end
    
    rcarre= HumanModel(temp1).m/(seglength*pi*rho*1000);
    % Constraint about radius cylinder
    c =  [c (HumanModel(temp1).anat_position{temp2,2}(1) +  HumanModel(temp1).c(1)  )^2 +  (HumanModel(temp1).anat_position{temp2,2}(3) +  HumanModel(temp1).c(3) )^2 - rcarre];
    
    
end



if ~par_case %serial case
    
    temp1=num_solid(1);
    temp2=num_markers(1);
    % Constraint max length, not being above the os
    if HumanModel(temp1).child
        ylength=HumanModel(HumanModel(temp1).child).b(2);
        temp3=temp1;
        while ~ylength && temp3
            temp3=HumanModel(temp3).child;
            ylength=HumanModel(HumanModel(temp3).child).b(2);
        end
    else
        [~,numnode]=intersect( HumanModel(temp1).anat_position(:,1),[HumanModel(temp1).name '_EndNode']);
        ylength = HumanModel(temp1).anat_position{numnode,2}(2);
    end
    if abs(yorigin) - abs(ylength) <0 %If the origin point is well placed, ie not above the os
        c = [c  abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) ) - abs(ylength)];
    end
    
    
    % No uturn
    c = [c abs(yorigin)-abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) )];
    
    temp1=num_solid(end);
    temp2=num_markers(end);
    c = [c  abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) ) - abs(yinsertion)];
    
    if yinsertion < 0 %If the insertion point is well placed, ie negative in y
        c = [c HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) ];
    end
    
    
    for k=2:length(num_solid) -1
        temp1=num_solid(k);
        temp2=num_markers(k);
        % Constraint max length, not being above the os
        if HumanModel(temp1).child
            ylength=HumanModel(HumanModel(temp1).child).b(2);
            temp3=temp1;
            while ~ylength && temp3
                temp3=HumanModel(temp3).child;
                ylength=HumanModel(HumanModel(temp3).child).b(2);
            end
        else
            [~,numnode]=intersect( HumanModel(temp1).anat_position(:,1),[HumanModel(temp1).name '_EndNode']);
            ylength = HumanModel(temp1).anat_position{numnode,2}(2);
        end
        c = [c  abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) ) - abs(ylength)];
        c = [c HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2)];
    end
    
    
else
    if abs(yorigin) < abs(yinsertion)
        temp1=num_solid(1);
        temp2=num_markers(1);
        
        c = [c abs(yorigin)-abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) )];
        c = [c abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) )-abs(yinsertion)];
        
        temp1=num_solid(end);
        temp2=num_markers(end);
        
        c = [c abs(yorigin)-abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) )];
        c = [c abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) )-abs(yinsertion)];
        
    else
        temp1=num_solid(1);
        temp2=num_markers(1);
        
        c = [c abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) )-abs(yorigin)];
        c = [c abs(yinsertion)- abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) )];
        
        temp1=num_solid(end);
        temp2=num_markers(end);
        
        c = [c abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) )-abs(yorigin)];
        c = [c abs(yinsertion)-abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) )];
        
    end
    
    
    
end