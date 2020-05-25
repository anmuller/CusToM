function [lm,ceq]=longueur_max(x,BiomechanicalModel,nummuscle,involved_solids,num_markersprov,q,lmax)

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


    lm(sign) = Muscle_lengthNum(BiomechanicalModel.OsteoArticularModel,BiomechanicalModel.Muscles(nummuscle(sign)),q(:,sign))-lmax(sign);
end

ceq=0;

end