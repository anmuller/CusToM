function [BiomechanicalModel]=LengthMinimisation(involved_solids,num_markersprov,BiomechanicalModel,Regression)

inv_sol=involved_solids{1};
num_markers=num_markersprov{1};
joint_num=[];
for j=1:size(Regression,2)
    for k=1:size(Regression(j).joints,2)
        joint_name=Regression(j).joints{k};
        [~,temp_joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);
        joint_num=[joint_num temp_joint_num];
    end
end

theta0=-pi +2*pi*rand(size(joint_num));


[BiomechanicalModel.OsteoArticularModel]=OnCircle(theta0,joint_num,BiomechanicalModel.OsteoArticularModel,inv_sol,num_markers);

solid_interet=involved_solids{1};
 markers_interet=num_markersprov{1};
    
for k=1:length(solid_interet)
    temp1=solid_interet(k);
    temp2=markers_interet(k);
    nom_pt_passage=BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,1};
    pt_passage=BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2}
end
    


% Fct coût
% muscle_length = @(theta)MinimizeLength(theta,BiomechanicalModel.OsteoArticularModel,inv_sol,num_markers,joint_num);
% 
% 
% options = optimoptions(@fmincon,'Algorithm','interior-point','Display','final','TolFun',1e-12,'TolCon',1e-12,'MaxIterations',100000,'MaxFunEvals',10000,'StepTolerance',1e-16,'PlotFcn','optimplotfval');
% 
% 
% % Minimisation
% theta = fmincon(muscle_length,theta0,[],[],[],[],[],[],[],options);
% 
% 
% [BiomechanicalModel.OsteoArticularModel]=OnCircle(theta,joint_num,BiomechanicalModel.OsteoArticularModel,inv_sol,num_markers);

solid_interet=involved_solids{1};
 markers_interet=num_markersprov{1};
    
for k=1:length(solid_interet)
    temp1=solid_interet(k);
    temp2=markers_interet(k);
    nom_pt_passage=BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,1};
    pt_passage=BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2}
end


end