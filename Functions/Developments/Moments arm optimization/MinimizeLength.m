function muscle_length=MinimizeLength(theta,BiomechanicalModel,involved_solids,num_markers,joint_num,num_muscle,Regression,nb_points)

Human_model=BiomechanicalModel.OsteoArticularModel;
Muscles=BiomechanicalModel.Muscles;

[BiomechanicalModel.OsteoArticularModel]=OnCircle(theta,joint_num,Human_model,involved_solids,num_markers);



Lmttot=[];
Nb_q=numel(BiomechanicalModel.OsteoArticularModel)-6*(~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0')));

rangeq=zeros(nb_points,size(Regression.joints,2));
q=zeros(Nb_q,nb_points^size(Regression.joints,2));

map_q=zeros(nb_points^size(Regression.joints,2),size(Regression.joints,2));

for k=1:size(Regression.joints,2)
    joint_name=Regression.joints{k};
    [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);
    rangeq(:,k)=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points)';
    
    B1=repmat(rangeq(:,k),1,nb_points^(k-1));
    B1=B1';
    B1=B1(:)';
    B2=repmat(B1,1,nb_points^(size(Regression.joints,2)-k));
    map_q(:,k) = B2;
    q(joint_num,:) = B2;
end

parfor i=1:nb_points^size(Regression.joints,2)
    [Lmt,~] = Muscle_lengthNum(BiomechanicalModel.OsteoArticularModel,Muscles(num_muscle),q(:,i));
    Lmttot  = [Lmttot Lmt];
end


muscle_length = norm(Lmttot)^2;



end