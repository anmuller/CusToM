function diff= LengthDifferenceMinimisation(x,BiomechanicalModel,num_muscle,Regression,nb_points,solids,markers)

Nb_q=numel(BiomechanicalModel.OsteoArticularModel)-6*(~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0')));


BiomechanicalModel.OsteoArticularModel(solids(1)).anat_position{markers(1),2}(2)= ...
    BiomechanicalModel.OsteoArticularModel(solids(2)).anat_position{markers(2),2}(2)+ x;

BiomechanicalModel.OsteoArticularModel(solids(end)).anat_position{markers(end),2}(2)= ...
    BiomechanicalModel.OsteoArticularModel(solids(end-1)).anat_position{markers(end-1),2}(2)- x;



liste_noms=[];
Lmttot=[];
rangeq=zeros(nb_points,size(Regression.joints,2));
q=zeros(Nb_q,nb_points^size(Regression.joints,2));

map_q=zeros(nb_points^size(Regression.joints,2),size(Regression.joints,2));

for k=1:size(Regression.joints,2)
    joint_name=Regression.joints{k};
    [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);
    rangeq(:,k)=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points)';
    liste_noms=[liste_noms joint_name];
    
    B1=repmat(rangeq(:,k),1,nb_points^(k-1));
    B1=B1';
    B1=B1(:)';
    B2=repmat(B1,1,nb_points^(size(Regression.joints,2)-k));
    map_q(:,k) = B2;
    q(joint_num,:) = B2;
end

c = ['equation',Regression.equation] ;
fh = str2func(c);
ideal_curve=fh(Regression.coeffs,map_q);


parfor i=1:nb_points^size(Regression.joints,2)
    [Lmt,~] = Muscle_lengthNum(BiomechanicalModel.OsteoArticularModel,BiomechanicalModel.Muscles(num_muscle),q(:,i));
    Lmttot  = [Lmttot Lmt];
end



diff=norm((Lmttot-ideal_curve).^2,2);




end
