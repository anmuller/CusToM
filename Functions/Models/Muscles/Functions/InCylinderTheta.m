function [c,ceq]=InCylinderTheta(theta,joint_num,HumanModel,num_solid,num_markers,sign_insertion,sign_origin,Regression)

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
            seglength=norm(HumanModel(HumanModel(temp1).child).b);
        end
        if ~temp3
            [~,numnode]=intersect( {HumanModel(temp1).anat_position{:,1}},[HumanModel(temp1).name '_EndNode']);
            seglength = norm(HumanModel(temp1).anat_position{numnode,2});
        end
        
    else
        [~,numnode]=intersect( {HumanModel(temp1).anat_position{:,1}},[HumanModel(temp1).name '_EndNode']);
        seglength = norm(HumanModel(temp1).anat_position{numnode,2});
    end
    
      rcarre= HumanModel(temp1).m/(seglength*pi*rho*1000);
       c =  [c (HumanModel(temp1).anat_position{temp2,2}(1) +  HumanModel(temp1).c(1)  )^2 +  (HumanModel(temp1).anat_position{temp2,2}(3) +  HumanModel(temp1).c(3) )^2 - rcarre];

    
end
 

temp1=num_solid(1);
temp2=num_markers(1);
if sign_origin<0 % If the origin point is already on the os
       c = [c  abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) ) - abs(HumanModel(HumanModel(temp1).child).b(2))]; 
end
 if size({Regression.equation},2)==1
    c = [c  HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2)];
    temp1=num_solid(end);
    temp2=num_markers(end);
    c = [c  abs(HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) ) -  abs(HumanModel(HumanModel(temp1).child).b(2)) ];
 end
  if  sign_insertion<0
    temp1=num_solid(end);
    temp2=num_markers(end);
    c = [c  (HumanModel(temp1).anat_position{temp2,2}(2) +  HumanModel(temp1).c(2) )];
     
 end





end