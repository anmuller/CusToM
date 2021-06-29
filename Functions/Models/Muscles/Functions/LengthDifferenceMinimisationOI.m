function diff= LengthDifferenceMinimisationOI(x,BiomechanicalModel,num_muscle,Regression,nb_points,solids,markers)
%Norm of the difference between input musculotendon length and musculotendon length from the model 
%
%   INPUT
%   - x : homothety coefficient
%   - BiomechanicalModel: musculoskeletal model
%   - num_muscle : number of the muscle in the Muscles structure
%   - Regression : structure of musculotendon length
%   - nb_points : number of point for coordinates discretization
%   - solids : vector of solids of origin, via, and insertion points 
%   - markers : vector of anatomical positions of origin, via, and insertion points 
%
%   OUTPUT
%   - diff : norm of the difference between musculotendon lengths
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________


Nb_q=numel(BiomechanicalModel.OsteoArticularModel)-6*(~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0')));


BiomechanicalModel.OsteoArticularModel(solids(1)).anat_position{markers(1),2}= ...
   x* (BiomechanicalModel.OsteoArticularModel(solids(1)).anat_position{markers(1),2} - BiomechanicalModel.OsteoArticularModel(solids(2)).anat_position{markers(2),2}) +...
   BiomechanicalModel.OsteoArticularModel(solids(2)).anat_position{markers(2),2};

BiomechanicalModel.OsteoArticularModel(solids(end)).anat_position{markers(end),2}= ...
    x*(BiomechanicalModel.OsteoArticularModel(solids(end)).anat_position{markers(end),2}- BiomechanicalModel.OsteoArticularModel(solids(end-1)).anat_position{markers(end-1),2}) +...
    BiomechanicalModel.OsteoArticularModel(solids(end-1)).anat_position{markers(end-1),2};



liste_noms=[];
Lmttot=[];
rangeq=zeros(nb_points,size(Regression.joints,2));
q=zeros(Nb_q,nb_points^size(Regression.joints,2));

map_q=zeros(nb_points^size(Regression.joints,2),size(Regression.joints,2));

[sp1,sp2]=find_solid_path(BiomechanicalModel.OsteoArticularModel,solids(1),solids(end));
path = unique([sp1,sp2]);
FunctionalAnglesofInterest = {BiomechanicalModel.OsteoArticularModel(path).FunctionalAngle};



for k=1:size(Regression.joints,2)
    joint_name=Regression.joints{k};
    [~,joint_num]=intersect(FunctionalAnglesofInterest, joint_name);
    joint_num=path(joint_num);
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



diff=norm(Lmttot-ideal_curve,2)^2;




end
