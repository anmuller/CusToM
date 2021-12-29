function [mac,BiomechanicalModel]=momentarmcurve(x,BiomechanicalModel,num_muscle,Regression,nb_points,num_solid,num_markers,angles)
% Computes the moment arm from BiomechanicalModel
%
%   INPUT
%   - x : vector of via points positions;
%   - BiomechanicalModel: musculoskeletal model
%   - num_muscle : number of the muscle in the Muscles structure
%   - Regression : structure of moment arm 
%   - nb_points : number of point for coordinates discretization
%   - involved_solids : vector of solids of origin, via, and insertion points 
%   - num_markersprov : vector of anatomical positions of origin, via, and insertion points 
%
%   OUTPUT
%   - mac : vector of moment arm
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

[sp1,sp2]=find_solid_path(BiomechanicalModel.OsteoArticularModel,num_solid(1),num_solid(end));
path = unique([sp1,sp2]);
FunctionalAnglesofInterest = {BiomechanicalModel.OsteoArticularModel(path).FunctionalAngle};


mac=[];
for j=1:size(Regression,2)
    q=angles(j).q;
    
    
   joint_name=Regression(j).axe;
   [~,joint_num]=intersect(FunctionalAnglesofInterest,joint_name);
   joint_num=path(joint_num);
   
   parfor i=1:nb_points^size(Regression(j).joints,2)
        mac  = [mac  MomentArmsComputationNumMuscleJoint(BiomechanicalModel,q(:,i),0.0001,num_muscle,joint_num)];
   end
   
end

end


