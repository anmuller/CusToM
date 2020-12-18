function [RMSElmt,BiomechanicalModel]=MusculotendonLengthOptimization(num_muscle,BiomechanicalModel,InputMusculotendonLength,nb_points)

 [~,RegressionStructure]=InputMusculotendonLength({BiomechanicalModel.Muscles(num_muscle).name},[],[],[]);

solids = BiomechanicalModel.Muscles(num_muscle).num_solid;
markers = BiomechanicalModel.Muscles(num_muscle).num_markers;

options = optimoptions(@fmincon,'Algorithm','sqp','Display','final','MaxFunEvals',100000,'TolCon',1e-6);%,'PlotFcn','optimplotfval');


funlength = @(k)LengthDifferenceMinimisationOI(k,BiomechanicalModel,num_muscle,RegressionStructure,nb_points,solids,markers);

homocoeff = fmincon(funlength,0,[],[],[],[],0,[],[],options);

BiomechanicalModel.OsteoArticularModel(solids(1)).anat_position{markers(1),2}= ...
    homocoeff* (BiomechanicalModel.OsteoArticularModel(solids(1)).anat_position{markers(1),2} - BiomechanicalModel.OsteoArticularModel(solids(2)).anat_position{markers(2),2}) +...
    BiomechanicalModel.OsteoArticularModel(solids(2)).anat_position{markers(2),2};

BiomechanicalModel.OsteoArticularModel(solids(end)).anat_position{markers(end),2}= ...
    homocoeff*(BiomechanicalModel.OsteoArticularModel(solids(end)).anat_position{markers(end),2}- BiomechanicalModel.OsteoArticularModel(solids(end-1)).anat_position{markers(end-1),2}) +...
    BiomechanicalModel.OsteoArticularModel(solids(end-1)).anat_position{markers(end-1),2};



RMSElmt=MuscleLengthComp(BiomechanicalModel,num_muscle,RegressionStructure,nb_points,solids,markers);

end
