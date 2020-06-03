function mac=momentarmcurve(x,BiomechanicalModel,num_muscle,Regression,nb_points,Sign,num_solid,num_markers)

% Verification if a muscle as its origin and its insertion in the loop
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
    if sum(contains(names_list,name_sol1)) && sum(contains(names_list,name_sol2))
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
    if Regression(j).equation==1
        joint_name=Regression(j).primaryjoint;
        [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},[Sign, joint_name]);
        rangeq=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points);
        q=zeros(Nb_q,nb_points);
        q(joint_num,:)=rangeq;
        
        if flag %muscle origin and insertion in the loop
            
        end
        
        
        for i=1:nb_points
            mac  = [mac  MomentArmsComputationNumMuscleJoint(BiomechanicalModel,q(:,i),0.0001,num_muscle,joint_num)];
        end
    else
        joint_name1=Regression(j).primaryjoint;
        joint_name2=Regression(j).secondaryjoint;
        [~,joint_num1]=intersect({BiomechanicalModel.OsteoArticularModel.name},[Sign,joint_name1]);
        [~,joint_num2]=intersect({BiomechanicalModel.OsteoArticularModel.name},[Sign,joint_name2]);
        rangeq1=linspace(BiomechanicalModel.OsteoArticularModel(joint_num1).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num1).limit_sup,nb_points);
        rangeq2=linspace(BiomechanicalModel.OsteoArticularModel(joint_num2).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num2).limit_sup,nb_points);
        q=zeros(Nb_q,nb_points*nb_points);
        
        [Q1,Q2]=meshgrid(rangeq1,rangeq2);
        Q1line=Q1(:);
        Q2line=Q2(:);
        
        q(joint_num1,:)=Q1line;
        q(joint_num2,:)=Q2line;
        
        if flag %muscle origin and insertion in the loop
            
        end
        
        
        for i=1:length(Q1line)
            mac  = [mac  MomentArmsComputationNumMuscleJoint(BiomechanicalModel,q(:,i),0.0001,num_muscle,joint_num1)];
        end
        
        
        
    end
end

end


