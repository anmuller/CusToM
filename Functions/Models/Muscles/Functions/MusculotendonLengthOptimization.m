function [RMSElmt,BiomechanicalModel]=MusculotendonLengthOptimization(num_muscle,BiomechanicalModel,InputMusculotendonLength,nb_points)
% Root mean square difference between input musculotendon length and musculotendon length from the model 
%
%   INPUT
%   - num_muscle : number of the muscle in the Muscles structure
%   - BiomechanicalModel: musculoskeletal model
%   - InputMusculotendonLength : function handle of given moment arm as function of
%   coordinates q
%   - nb_points : number of point for coordinates discretization
%
%   OUTPUT
%   - diff : root mean square difference
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
