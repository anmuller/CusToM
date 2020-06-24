function [c,ceq]=OnCircle(x,Human_model,rold,ABold,involved_solids,num_markersprov)
% x : direct coordinates of the searched points

c=[];


num_sol=involved_solids;
num_mark= num_markersprov;

cpt=0;
for k=2:numel(num_sol)-1
    for pt=1:3
        cpt=cpt+1;
        temp1=num_sol(k);
        temp2=num_mark(k);
        Human_model(temp1).anat_position{temp2,2}(pt)=x(cpt);
    end
end





r=zeros(1,numel(num_sol)-2);
% Rayon transformation
for k=1:2:numel(num_sol)-2
    curr_name = Human_model(num_sol(k+2)).name;
    previous_name = Human_model(num_sol(k)).name;
    joint_node_name=['R',curr_name(2:end),'_',previous_name(2:end),'JointNode'];
    [~,ind_jn]=intersect(Human_model(num_sol(k)).anat_position(:,1),joint_node_name);
    if isempty(ind_jn)
        Human_model(num_sol(k+2)).anat_position{end+1,1}=joint_node_name;
        Human_model(num_sol(k+2)).anat_position{end,2}=- Human_model(num_sol(k+2)).c;
        Npos=size(Human_model(num_sol(k+2)).anat_position,1);
    else
        Npos=ind_jn;
    end
    Mbone=num_sol(k);
    Mpos=num_mark(k+1);
    Nbone=num_sol(k+2);
    
    
    r(k)=distance_point(Mpos,Mbone,Npos,Nbone,Human_model,zeros(1,size(Human_model,2)-6*(~isempty(intersect({Human_model.name},'root0')))  ));

end

for k=2:2:length(x)/3
    r(k)= norm(x((k-1)*3+1:k*3));
end

% AB computation
AB=zeros(1,length(x)/3/2);
for k=2:2:length(x)/3
    Mbone=num_sol(k);
    Mpos=num_mark(k);
    Nbone=num_sol(k+1);
    Npos=num_mark(k+1);
    
    AB(0.5*k)=distance_point(Mpos,Mbone,Npos,Nbone,Human_model,zeros(1,size(Human_model,2)-6*(~isempty(intersect({Human_model.name},'root0')))  ));

end




ceq=[ r-rold, AB-ABold]';









end