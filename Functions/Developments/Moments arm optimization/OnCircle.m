function [Human_model]=OnCircle(theta,joint_num,Human_model,involved_solids,num_markersprov)

Nb_q=numel(Human_model)-6*(~isempty(intersect({Human_model.name},'root0')));

c=[];
format long;

Human_model1=Human_model;
num_sol=involved_solids;
num_mark= num_markersprov;
for k=2:2:numel(num_sol)-2
    
    Mbone=num_sol(k);
    Mpos=num_mark(k);
    
    Mbone2=num_sol(k+1);
    Mpos2=num_mark(k+1);
    
    for j=1:length(theta)
        if joint_num(j)<=Mbone2 && joint_num(j)>Mbone
            q=zeros(1,Nb_q);
            %q(joint_num(j-1))=pi/2+1e-4;
            %D1= distance_point(Mpos,Mbone,Mpos2,Mbone2,Human_model1,q);
            [Human_model] = rotation(Mpos,Mbone,Human_model1,q,joint_num(j),theta(j));
            [Human_model] = rotation(Mpos2,Mbone2,Human_model,q,joint_num(j),theta(j));
          %  D2= distance_point(Mpos,Mbone,Mpos2,Mbone2,Human_model,q);
        end
    end
    
    
    
    
end







end