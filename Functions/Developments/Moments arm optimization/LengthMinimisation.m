function [BiomechanicalModel]=LengthMinimisation(involved_solids,num_markersprov,BiomechanicalModel,Regression,num_muscle,nb_points)

inv_sol=involved_solids;
num_markers=num_markersprov;
joint_num=[];

[sp1,sp2]=find_solid_path(BiomechanicalModel.OsteoArticularModel,involved_solids(1),involved_solids(end));
path = unique([sp1,sp2]);
FunctionalAnglesofInterest = {BiomechanicalModel.OsteoArticularModel(path).FunctionalAngle};


for j=1:size(Regression,2)
    for k=1:size(Regression(j).joints,2)
        joint_name=Regression(j).joints{k};
        [~,temp_joint_num]=intersect(FunctionalAnglesofInterest, joint_name);
        temp_joint_num=path(temp_joint_num);
        joint_num=[joint_num temp_joint_num];
    end
end

%joint_num=unique(joint_num);

theta0=0*ones(size(joint_num));

%Biom=BiomechanicalModel;



%[Biom.OsteoArticularModel]=Symmetry(-1,joint_num,Biom.OsteoArticularModel,inv_sol,num_markers);
%MomentsArmComp(Biom,43,Regression,15,inv_sol,num_markers)

insertion = BiomechanicalModel.OsteoArticularModel(inv_sol(end)).anat_position{num_markers(end),2}(2) +  BiomechanicalModel.OsteoArticularModel(inv_sol(end)).c(2) ; 
origin = abs(BiomechanicalModel.OsteoArticularModel(inv_sol(1)).anat_position{num_markers(1),2}(2) +  BiomechanicalModel.OsteoArticularModel(inv_sol(1)).c(2)) ...
                - abs( BiomechanicalModel.OsteoArticularModel( BiomechanicalModel.OsteoArticularModel(inv_sol(1)).child).b(2)) ; 


% Fct coût  

muscle_length = @(theta)MinimizeLength(theta,BiomechanicalModel,inv_sol,num_markers,joint_num,num_muscle,Regression,nb_points);
nonlcon=@(theta) InCylinderTheta(theta,joint_num,BiomechanicalModel.OsteoArticularModel,inv_sol(2:end-1),num_markers(2:end-1),sign(insertion),sign(origin),Regression);

%muscle_length(theta0);

options =  optimoptions(@fmincon,'Algorithm','sqp','TolCon',1e-6,'Display','final','MaxIterations',1000000);%,'PlotFcn','optimplotfval');

% theta_x=-pi:0.01:pi;
% figure();
% for k=1:length(theta_x)
%     hold on 
%     plot(theta_x(k),muscle_length(theta_x(k)),'*');
% end

ub=pi*ones(size(theta0));
lb=-pi*ones(size(theta0));

% Minimisation
theta = fmincon(muscle_length,theta0,[],[],[],[],lb,ub,nonlcon,options);


[BiomechanicalModel.OsteoArticularModel]=OnCircle(theta,joint_num,BiomechanicalModel.OsteoArticularModel,inv_sol,num_markers);
%[BiomechanicalModel.OsteoArticularModel]=OnCircle(theta0,joint_num,BiomechanicalModel.OsteoArticularModel,inv_sol,num_markers);



end