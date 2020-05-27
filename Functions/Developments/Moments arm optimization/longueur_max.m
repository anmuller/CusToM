function [lm,ceq]=longueur_max(x,BiomechanicalModel,nummuscle,involved_solids,num_markersprov,lmax,nb_pts)

deuxcoteoupas=1:length(nummuscle);
lm=zeros(length(deuxcoteoupas),1);

for sign=deuxcoteoupas
    num_solid=involved_solids{sign};
    num_markers= num_markersprov{sign};
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
    
    
     [sp1,sp2]=find_solid_path(BiomechanicalModel.OsteoArticularModel,min(num_solid),max(num_solid));
    num_solid=unique([num_solid', sp1, sp2]');
 
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
        temp(j)=Muscle_lengthNum(BiomechanicalModel.OsteoArticularModel,BiomechanicalModel.Muscles(nummuscle(sign)),map_q(j,:)');
    end
    
    maxi=max(temp);
    
    
    
    
    lm(sign) = maxi-1.3*lmax(sign);
end

ceq=0;

end