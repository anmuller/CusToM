function [mac,BiomechanicalModel]=momentarmcurve(x,BiomechanicalModel,num_muscle,Regression,nb_points,Sign,num_solid,num_markers)

% Verification if a muscle as its origin or its insertion in the loop
names_list={BiomechanicalModel.OsteoArticularModel(num_solid).name};
names_loops={BiomechanicalModel.OsteoArticularModel((~cellfun('isempty',{BiomechanicalModel.OsteoArticularModel.ClosedLoop}))).ClosedLoop};
flag=0;
for k=1:length(names_loops)
    temp=names_loops{k};
    temp(1)=''; %get rid of "R" and "L"
    ind = find(temp=='_');
    name_sol1= temp(1:ind-1);
    ind_end = strfind(temp,'JointNode');
    name_sol2 = temp(ind+1:ind_end-1);
    if sum(contains(names_list,name_sol1)) || sum(contains(names_list,name_sol2))
        flag=1;
    end
end


cpt=0;
for k=1:numel(num_solid)
    for pt=1:3
        cpt=cpt+1;
        temp1=num_solid(k);
        temp2=num_markers(k);
        BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2}(pt)=...
            BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2}(pt)+x(cpt);
    end
end

Nb_q=numel(BiomechanicalModel.OsteoArticularModel)-6*(~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0')));


mac=[];
for j=1:size(Regression,2)
    rangeq=zeros(nb_points,size(Regression(j).joints,2));
    q=zeros(Nb_q,nb_points^size(Regression(j).joints,2));
    for k=1:size(Regression(j).joints,2)
        joint_name=Regression(j).joints{k};
        [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);
        rangeq(:,k)=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points)';

        B1=repmat(rangeq(:,k),1,nb_points^(k-1));
        B1=B1';
        B1=B1(:)';
        B2=repmat(B1,1,nb_points^(size(Regression(j).joints,2)-k));
        q(joint_num,:) = B2;
    end

    
    if flag %muscle origin and insertion in the loop
        
    end
    
   joint_name=Regression(j).axe;
   [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);

   parfor i=1:nb_points^size(Regression(j).joints,2)
        mac  = [mac  MomentArmsComputationNumMuscleJoint(BiomechanicalModel,q(:,i),0.0001,num_muscle,joint_num)];
    end
end

end


