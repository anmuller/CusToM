pfunction [BiomechanicalModel]=LengthMinimisation(involved_solids,num_markersprov,BiomechanicalModel,Regression,num_muscle,nb_points)
% Modifiying via point to minimize of musculotendon length of the model
%
%   INPUT
%   - involved_solids : vector of solids of origin, via, and insertion points 
%   - num_markersprov : vector of anatomical positions of origin, via, and insertion points 
%   - BiomechanicalModel: musculoskeletal model
%   - Regression : structure of  musculotendon length
%   - num_muscle : number of the muscle in the Muscles structure
%   - nb_points : number of point for coordinates discretization
%
%   OUTPUT
%   - BiomechanicalModel: musculoskeletal model
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

inv_sol=involved_solids;
num_markers=num_markersprov;
joint_num=[];

par_case = 0;
[sp1,sp2]=find_solid_path(BiomechanicalModel.OsteoArticularModel,involved_solids(1),involved_solids(end));
if length(sp1)~=1 && length(sp2)~=1
    par_case = 1;
end
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


theta0=0*ones(size(joint_num));


insertion = BiomechanicalModel.OsteoArticularModel(inv_sol(end)).anat_position{num_markers(end),2}(2) +  BiomechanicalModel.OsteoArticularModel(inv_sol(end)).c(2) ; 
origin = BiomechanicalModel.OsteoArticularModel(inv_sol(1)).anat_position{num_markers(1),2}(2) +  BiomechanicalModel.OsteoArticularModel(inv_sol(1)).c(2);


% Cost function and non linear constraints

muscle_length = @(theta)MinimizeLength(theta,BiomechanicalModel,inv_sol,num_markers,joint_num,num_muscle,Regression,nb_points);
nonlcon=@(theta) InCylinderTheta(theta,joint_num,BiomechanicalModel.OsteoArticularModel,inv_sol(2:end-1),num_markers(2:end-1),insertion,origin,par_case);


options =  optimoptions(@fmincon,'Algorithm','sqp','TolCon',1e-6,'Display','final','MaxIterations',1000000);%,'PlotFcn','optimplotfval');

ub=pi*ones(size(theta0));
lb=-pi*ones(size(theta0));

% Minimization
theta = fmincon(muscle_length,theta0,[],[],[],[],lb,ub,nonlcon,options);

[BiomechanicalModel.OsteoArticularModel]=OnCircle(theta,joint_num,BiomechanicalModel.OsteoArticularModel,inv_sol,num_markers);



end