function [c,ceq]=InCylinder_LengthOpti(x,HumanModel,num_solid,num_markers)

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




for k=1:length(num_solid) 
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
        if ~temp3
            temp3=HumanModel(temp3).mother;
            [~,numnode]=intersect( HumanModel(temp3).anat_position(:,1),[HumanModel(temp3).name '_EndNode']);
            ylength = HumanModel(temp3).anat_position{numnode,2}(2);
        end
    else
        [~,numnode]=intersect( HumanModel(temp1).anat_position(:,1),[HumanModel(temp1).name '_EndNode']);
        ylength = HumanModel(temp1).anat_position{numnode,2}(2);
    end
    c = [c  abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) ) - abs(ylength)];
    c = [c HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2)];
end

% no uturn
for k=2:2:numel(num_solid)-1
    c = [c abs(x(2+3*(k-1)))-abs(x(2+3*(k)))];
end




end