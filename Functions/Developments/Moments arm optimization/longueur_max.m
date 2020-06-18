function [lm,ceq]=longueur_max(x,BiomechanicalModel,nummuscle,involved_solids,num_markersprov,lmax,nb_pts)

num_solid=involved_solids;
num_markers= num_markersprov;
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


[sp1,sp2]=find_solid_path(BiomechanicalModel.OsteoArticularModel,min(num_solid),max(num_solid));
if flag
    % To be changed
    num_solid=unique([num_solid, sp1, sp2]');
    num_solid=num_solid(2:end);
else
        num_solid=unique([num_solid, sp1, sp2]');
        num_solid=num_solid(2:end); % The first solid doesn't need to be moved
end

for k=1:numel(num_solid)
    q(k,:)=linspace(BiomechanicalModel.OsteoArticularModel(num_solid(k)).limit_inf,BiomechanicalModel.OsteoArticularModel(num_solid(k)).limit_sup,nb_pts);
end

map_q=zeros(nb_pts^numel(num_solid),size(BiomechanicalModel.OsteoArticularModel,2));
for i=1:numel(num_solid)
    B1=repmat(q(i,:),nb_pts^(i-1),1);
    B1=B1(:)';
    B2=repmat(B1,1,nb_pts^(numel(num_solid)-i));
    map_q(:,num_solid(i)) = B2;
end

temp=zeros(size(map_q,1),1);


parfor j=1:size(map_q,1)
    temp(j)=Muscle_lengthNum(BiomechanicalModel.OsteoArticularModel,BiomechanicalModel.Muscles(nummuscle),map_q(j,:)');
end


% figure();
% subplot(2,1,1,'position',[0.0656,0.7877,0.8943,0.1935])
% plot(temp)
% subplot(2,1,2,'position',[0.065625,0.046826222684703,0.8953125,0.699271592091574])
% imagesc(map_q(:,num_solid)')
% yticks(1:size(BiomechanicalModel.OsteoArticularModel(num_solid),2));
% yticklabels({BiomechanicalModel.OsteoArticularModel(num_solid).name})
maxi=max(temp);



lm = maxi-1.5*lmax;

ceq=0;

end