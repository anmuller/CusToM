function muscle_length=MinimizeLength(theta,Human_model,involved_solids,num_markers,joint_num)

[Human_model]=OnCircle(theta,joint_num,Human_model,involved_solids,num_markers);
num_sol=involved_solids;
num_mark= num_markers;



muscle_length=0;
for k=1:2:numel(num_sol)-1
    Mbone=num_sol(k);
    Mpos=num_mark(k);
    Nbone=num_sol(k+1);
    Npos=num_mark(k+1);
    
    muscle_length=muscle_length+distance_point(Mpos,Mbone,Npos,Nbone,Human_model,zeros(1,size(Human_model,2)-6*(~isempty(intersect({Human_model.name},'root0')))  ));

end

end