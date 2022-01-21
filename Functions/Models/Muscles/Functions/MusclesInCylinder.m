function [c,ceq]=MusclesInCylinder(x,HumanModel,num_solid,num_markers,yinsertion,yorigin,par_case,radius)
% Verifying that muscle via points are contained in a cylinder volume
%
%   INPUT
%   - x : vector of via points positions;
%   - Human_model : osteo-articular model (see the Documentation for
%   the structure);
%   - num_solid : vector of solids of via points
%   - num_markers : vector of anatomical positions of via points
%   - yinsertion : y insertion position in the insertion local frame
%   - yorigin : y origin position in the origin local frame
%   - par_case : boolean
%   - radius : vector of radius corresponding to the skin cylinder around each
%   segment
%
%   OUTPUT
%   - c : inequality constraint
%   - ceq : equality constaint
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


cpt=0;
for k=1:numel(num_solid)
    for pt=1:3
        cpt=cpt+1;
        temp1=num_solid(k);
        temp2=num_markers(k);
        HumanModel(temp1).anat_position{temp2,2}(pt)=...
            HumanModel(temp1).anat_position{temp2,2}(pt)+x(cpt);
    end
end

c=[];
for k=1:numel(num_solid)
    temp1=num_solid(k);
    temp2=num_markers(k);
    
    rcarre= radius(k)^2;
    % Constraint about radius cylinder
    
    if temp1~=20
    
    c =  [c (HumanModel(temp1).anat_position{temp2,2}(1) +  HumanModel(temp1).c(1)  )^2 +  (HumanModel(temp1).anat_position{temp2,2}(3) +  HumanModel(temp1).c(3) )^2 - rcarre];
    
    else
        
            c =  [c (HumanModel(temp1).anat_position{temp2,2}(1) +  HumanModel(temp1).c(1)  )^2 +  (HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) )^2 - rcarre];
    end
    
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
% if abs(yorigin) - abs(ylength) <0 %If the origin point is well placed, ie not above the os
    c = [c  abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) ) - abs(ylength)];
% end


% No uturn
if temp1~=7
    c = [c abs(yorigin)-abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) )];
else
    c = [c -abs(yorigin)+abs(HumanModel(temp1).anat_position{temp2,2}(2) -  HumanModel(temp1).c(2) )];
end

temp1=num_solid(end);
temp2=num_markers(end);
c = [c  abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) ) - abs(yinsertion)];

% if yinsertion < 0 %If the insertion point is well placed, ie negative in y
    c = [c HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) ];
% end


for k=2:length(num_solid) -1
    temp1=num_solid(k);
    temp2=num_markers(k);
    
    if temp1~=20  && temp1~=10
    
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
    
    
    else
        
        % Constraint max length, not being above the os
    if HumanModel(temp1).child
        ylength=HumanModel(HumanModel(temp1).child).b(3);
        temp3=temp1;
        while ~ylength && temp3
            temp3=HumanModel(temp3).child;
            ylength=HumanModel(HumanModel(temp3).child).b(3);
        end
    end
    c = [c  abs(HumanModel(temp1).anat_position{temp2,2}(3) +  HumanModel(temp1).c(3) ) - abs(ylength)];
    c = [c -HumanModel(temp1).anat_position{temp2,2}(3) - HumanModel(temp1).c(3)];
    
    end
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




end