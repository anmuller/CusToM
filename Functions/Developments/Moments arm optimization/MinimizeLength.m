function muscle_length=MinimizeLength(x,Human_model,Muscles,involved_solids,num_markers)


num_sol=involved_solids;
num_mark= num_markers;

cpt=0;
for k=2:numel(num_sol)-1
    for pt=1:3
        cpt=cpt+1;
        temp1=num_sol(k);
        temp2=num_mark(k);
        Human_model(temp1).anat_position{temp2,2}(pt)=x(cpt);
    end
end

muscle_length=0;
for k=1:2:numel(num_sol)-1
    Mbone=num_sol(k);
    Mpos=num_mark(k);
    Nbone=num_sol(k+1);
    Npos=num_mark(k+1);
    
    muscle_length=muscle_length+distance_point(Mpos,Mbone,Npos,Nbone,Human_model,zeros(1,size(Human_model,2)-6*(~isempty(intersect({Human_model.name},'root0')))  ));

end



end