function RMSE=MomentsArmComparison(BiomechanicalModel,num_muscle,MARegression, nb_points,involved_solids,num_markersprov)




violet = [169 90 161]/255;
orange = [245 121 58]/255;
bleufonce = [15 32 128]/255;
bleuclair = [133 192 249]/255;

cmap = [ linspace(bleufonce(1),violet(1),85)  linspace(violet(1),orange(1),85) linspace(orange(1),bleuclair(1),86) ;...
    linspace(bleufonce(2),violet(2),85)  linspace(violet(2),orange(2),85) linspace(orange(2),bleuclair(2),86) ;...
    linspace(bleufonce(3),violet(3),85)  linspace(violet(3),orange(3),85) linspace(orange(3),bleuclair(3),86) ]';

%colormap(cmap);


num_solid=involved_solids(2:end-1);
num_markers=num_markersprov(2:end-1);
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


Nb_q=numel(BiomechanicalModel.OsteoArticularModel)-6*(~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0')));

[sp1,sp2]=find_solid_path(BiomechanicalModel.OsteoArticularModel,involved_solids(1),involved_solids(end));
path = unique([sp1,sp2]);
FunctionalAnglesofInterest = {BiomechanicalModel.OsteoArticularModel(path).FunctionalAngle};

mac=[];

ideal_curve=[];
liste_noms=[];
for j=1:size(MARegression,2)
    mactemp=[];
    rangeq=zeros(nb_points,size(MARegression(j).joints,2));
    ideal_curve_temp=[];
    q=zeros(Nb_q,nb_points^size(MARegression(j).joints,2));
    
    map_q=zeros(nb_points^size(MARegression(j).joints,2),size(MARegression(j).joints,2));
    
    for k=1:size(MARegression(j).joints,2)
        joint_name=MARegression(j).joints{k};
        [~,joint_num]=intersect(FunctionalAnglesofInterest, joint_name);
        joint_num=path(joint_num);
        rangeq(:,k)=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points)';
        liste_noms=[liste_noms joint_name];
        
        B1=repmat(rangeq(:,k),1,nb_points^(k-1));
        B1=B1';
        B1=B1(:)';
        B2=repmat(B1,1,nb_points^(size(MARegression(j).joints,2)-k));
        map_q(:,k) = B2;
        q(joint_num,:) = B2;
    end
    
    c = ['equation',MARegression(j).equation] ;
    fh = str2func(c);
    ideal_curve_temp=[ideal_curve_temp fh(MARegression(j).coeffs,map_q)];
    

    joint_name=MARegression(j).axe;
    [~,joint_num]=intersect(FunctionalAnglesofInterest,joint_name);
    joint_num=path(joint_num);
    
    parfor i=1:nb_points^size(MARegression(j).joints,2)
        mactemp  = [mactemp MomentArmsComputationNumMuscleJoint(BiomechanicalModel,q(:,i),0.0001,num_muscle,joint_num)];
    end
    
    
   
    
    

    
    
    ideal_curve=[ideal_curve ideal_curve_temp];
    
   
    
    mac=[mac mactemp];
    
    
    
    
end


RMSE.rms=  sqrt(1/length(mac) * sum((ideal_curve - mac).^2));
RMSE.rmsr=  sqrt(1/length(mac) * sum((ideal_curve - mac).^2))/ sqrt(1/length(mac) * sum((ideal_curve).^2))* 100;




end