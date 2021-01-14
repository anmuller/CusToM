function muscle_length=MinimizeLength(theta,BiomechanicalModel,involved_solids,num_markers,joint_num,num_muscle,Regression,nb_points)
% Compute musculotendon length as via point position function
%
%   INPUT
%   - theta : vector of rotation of via points
%   - BiomechanicalModel: musculoskeletal model
%   - involved_solids : vector of solids of origin, via, and insertion points 
%   - num_markers : vector of anatomical positions of origin, via, and insertion points 
%   - joint_num  : vector of solids around via points rotates of theta
%   - num_muscle : number of the muscle in the Muscles structure
%   - Regression : structure of  musculotendon length
%   - nb_points : number of point for coordinates discretization
%
%   OUTPUT
%   - muscle_length : vector of musculotendon length
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________


Human_model=BiomechanicalModel.OsteoArticularModel;
Muscles=BiomechanicalModel.Muscles;

[BiomechanicalModel.OsteoArticularModel]=OnCircle(theta,joint_num,Human_model,involved_solids,num_markers);

[sp1,sp2]=find_solid_path(BiomechanicalModel.OsteoArticularModel,involved_solids(1),involved_solids(end));
path = unique([sp1,sp2]);
FunctionalAnglesofInterest = {BiomechanicalModel.OsteoArticularModel(path).FunctionalAngle};


Lmttot=[];
Nb_q=numel(BiomechanicalModel.OsteoArticularModel)-6*(~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0')));

rangeq=zeros(nb_points,size(Regression.joints,2));
q=zeros(Nb_q,nb_points^size(Regression.joints,2));

map_q=zeros(nb_points^size(Regression.joints,2),size(Regression.joints,2));

for k=1:size(Regression.joints,2)
    joint_name=Regression.joints{k};
    [~,joint_num]=intersect(FunctionalAnglesofInterest,joint_name);
    joint_num=path(joint_num);
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