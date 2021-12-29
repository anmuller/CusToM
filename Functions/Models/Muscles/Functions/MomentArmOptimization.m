function [RMSE,BiomechanicalModel]=MomentArmOptimization(num_muscle,BiomechanicalModel,InputMomentArm,nb_points,radius,involved_solids)
% Placing new via points for matching given moment arm
%
%   INPUT
%   - num_muscle : number of the muscle in the Muscles structure
%   - BiomechanicalModel: musculoskeletal model
%   - InputMomentArm : function handle of given moment arm as function of
%   coordinates q
%   - nb_points : number of point for coordinates discretization
%   - radius : vector of radius corresponding to the skin cylinder around each
%   segment
%
%   OUTPUT
%   - RMSE  : root mean square error between given moment arm and moment
%   arm from the BiomechanicalModel
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
format long

if nb_points==20
    nb_points=5;
end

HumanModel=BiomechanicalModel.OsteoArticularModel;
Muscles=BiomechanicalModel.Muscles;

osnames={HumanModel.name};
musnames={Muscles.name};
name_mus = musnames{num_muscle};
name_mus=name_mus(2:end);
[~,RegressionStructure]=InputMomentArm(musnames(num_muscle),[],[],[]);

%% Modification of BiomechanicalModel  : adding new VP points : one at each side of joints

involved_solid=[Muscles(num_muscle).num_solid(1);  Muscles(num_muscle).num_solid(end);  involved_solids' ];
num_markers=[Muscles(num_muscle).num_markers(1) ;  Muscles(num_muscle).num_markers(end) ];
num_markersprov=[];
BiomechanicalModel.Muscles(num_muscle).path=[];
BiomechanicalModel.Muscles(num_muscle).path{1} = BiomechanicalModel.OsteoArticularModel(involved_solid(1)).anat_position{num_markers(1), 1};

j=1;
VP_name= [osnames{involved_solids(j)},'_',name_mus,'_VP',num2str(j)];
BiomechanicalModel.Muscles(num_muscle).path{end+1}= VP_name;
BiomechanicalModel.OsteoArticularModel(involved_solids(j)).anat_position{end+1,1}= VP_name;

ind= find(involved_solid==involved_solids(j));
ind = ind(1);
BiomechanicalModel.OsteoArticularModel(involved_solids(j)).anat_position{end,2}= BiomechanicalModel.OsteoArticularModel(involved_solid(ind)).anat_position{num_markers(ind), 2};
num_markersprov=[num_markersprov ;size(BiomechanicalModel.OsteoArticularModel(involved_solids(j)).anat_position,1)];

for j=2:size(involved_solids,2)-1
    pt_depart=[0 0 0]';
    VP_name= [osnames{involved_solids(j)},'_',name_mus,'_VP',num2str(j)];
    BiomechanicalModel.Muscles(num_muscle).path{end+1}= VP_name;
    BiomechanicalModel.OsteoArticularModel(involved_solids(j)).anat_position{end+1,1}= VP_name;
    
    BiomechanicalModel.OsteoArticularModel(involved_solids(j)).anat_position{end,2}= pt_depart;
    num_markersprov=[num_markersprov ;size(BiomechanicalModel.OsteoArticularModel(involved_solids(j)).anat_position,1)];
end

j=size(involved_solids,2);
VP_name= [osnames{involved_solids(j)},'_',name_mus,'_VP',num2str(j)];
BiomechanicalModel.Muscles(num_muscle).path{end+1}= VP_name;
BiomechanicalModel.OsteoArticularModel(involved_solids(j)).anat_position{end+1,1}= VP_name;

ind = find(involved_solid==involved_solids(j));
ind = ind(1);
BiomechanicalModel.OsteoArticularModel(involved_solids(j)).anat_position{end,2}= BiomechanicalModel.OsteoArticularModel(involved_solid(ind)).anat_position{num_markers(ind), 2};
num_markersprov=[num_markersprov ;size(BiomechanicalModel.OsteoArticularModel(involved_solids(j)).anat_position,1)];

BiomechanicalModel.Muscles(num_muscle).path{end+1} = BiomechanicalModel.OsteoArticularModel(involved_solid(2)).anat_position{num_markers(2), 1};


num_markers=  [num_markers;num_markersprov];
A=[involved_solid,num_markers];
D=sortrows(A,[1 2]) ;
D(end-1:end, :)=sortrows(D(end-1:end, :),2,{'descend'});

BiomechanicalModel.Muscles(num_muscle).num_solid=D(:,1);
BiomechanicalModel.Muscles(num_muscle).num_markers=D(:,2);
involved_solid=D(:,1);
num_markers=D(:,2);



%% Optimisation : looking for via points positions to match the input moment arm

insertion = BiomechanicalModel.OsteoArticularModel(involved_solid(end)).anat_position{num_markers(end),2}(2) +  BiomechanicalModel.OsteoArticularModel(involved_solid(end)).c(2) ;
origin = BiomechanicalModel.OsteoArticularModel(involved_solid(1)).anat_position{num_markers(1),2}(2) +  BiomechanicalModel.OsteoArticularModel(involved_solid(1)).c(2) ;


options = optimoptions(@fmincon,'Algorithm','sqp','Display','final','MaxFunEvals',100000,'TolCon',1e-6);

par_case = 0;
[sp1,sp2]=find_solid_path(BiomechanicalModel.OsteoArticularModel, involved_solid(1), involved_solid(end));
if length(sp1)~=1 && length(sp2)~=1
    par_case = 1;
end


nonlcon=@(x) MusclesInCylinder(x,BiomechanicalModel.OsteoArticularModel,involved_solids,num_markersprov,insertion,origin,par_case,radius);


%% Discretization

Nb_q=numel(BiomechanicalModel.OsteoArticularModel)-6*(~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0')));
[sp1,sp2]=find_solid_path(BiomechanicalModel.OsteoArticularModel,involved_solids(1),involved_solids(end));
path = unique([sp1,sp2]);
FunctionalAnglesofInterest = {BiomechanicalModel.OsteoArticularModel(path).FunctionalAngle};
ideal_curve =[];
for j=1:size(RegressionStructure,2)
    rangeq=zeros(nb_points,size(RegressionStructure(j).joints,2));
    angles(j).q=zeros(Nb_q,nb_points^size(RegressionStructure(j).joints,2));
    map_q=zeros(nb_points^size(RegressionStructure(j).joints,2),size(RegressionStructure(j).joints,2));
    
    for k=1:size(RegressionStructure(j).joints,2)
        joint_name=RegressionStructure(j).joints{k};
        [~,joint_num]=intersect(FunctionalAnglesofInterest, joint_name);
        joint_num=path(joint_num);
        rangeq(:,k)=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points)';
        
        B1=repmat(rangeq(:,k),1,nb_points^(k-1));
        B1=B1';
        B1=B1(:)';
        B2=repmat(B1,1,nb_points^(size(RegressionStructure(j).joints,2)-k));
        angles(j).q(joint_num,:) = B2;
        map_q(:,k) = B2;
        
    end
    
    
    ideal_curve_temp=[];
    
    
    if isfield(RegressionStructure,'equation')
        c = ['equation',RegressionStructure(j).equation] ;
        fh = str2func(c);
        
        ideal_curve_temp=fh(RegressionStructure(j).coeffs,map_q);
    elseif isfield(RegressionStructure,'EquationHandle')
        
        ideal_curve_temp = RegressionStructure(j).EquationHandle(map_q)';
        
    end
    
    
    ideal_curve=[ ideal_curve  ideal_curve_temp];
    
    
end

fun = @(x) MomentArmDifference(x,BiomechanicalModel,num_muscle,RegressionStructure,nb_points,involved_solid,num_markers,angles,ideal_curve);

x0=zeros(3* numel(involved_solids),1);

cond_resp = nonlcon(x0);
while sum(cond_resp<=0)<length(cond_resp)
    for k=1:length(involved_solids)
        if cond_resp(k)>0
            x0(1+3*(k-1)) = 0.1*(0.5-rand(1));
            x0(3+3*(k-1)) = 0.1*(0.5-rand(1));
        end
    end
    cond_resp = nonlcon(x0);
    if sum(cond_resp(length(involved_solids):end)>0)~=0
        x0=0.1*(0.5-rand(3* numel(involved_solids),1));
        cond_resp = nonlcon(x0);
    end
end


% options_pattern = optimoptions(@patternsearch,'PlotFcn', 'psplotfuncount');
% x = patternsearch(fun,x0,[],[],[],[],[],[],nonlcon,options_pattern);

optionsgs = optimoptions(@fmincon,'MaxIter',1e10,'MaxFunEvals',1e10);%,'PlotFcn','optimplotfval');

gs = GlobalSearch('StartPointsToRun','bounds-ineqs','BasinRadiusFactor',0.2,'DistanceThresholdFactor',0.75);
problem = createOptimProblem('fmincon','x0',x0,...
    'objective',fun,'nonlcon',nonlcon,'options',optionsgs);
x = run(gs,problem);

%
% optionsfmincon = optimoptions(@fmincon,'MaxIter',30,'MaxFunEvals',1e10,'PlotFcn','optimplotfval','Display','iter-detailed');
% x = fmincon(fun,x0,[],[],[], [],[],[], nonlcon, optionsfmincon);

%x= x0;
%% Affecting via points found to BiomechanicalModel

num_solid=involved_solids;
num_mark= num_markersprov;
cpt=0;
for k=1:numel(num_solid)
    for pt=1:3
        cpt=cpt+1;
        temp1=num_solid(k);
        temp2=num_mark(k);
        BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2}(pt)=...
            BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2}(pt)+x(cpt);
    end
end


%% For muscle which path actuates at least one DOF
if size({RegressionStructure.axe},2)==1
    [BiomechanicalModel]=LengthMinimisation(involved_solid,num_markers,BiomechanicalModel,RegressionStructure,num_muscle(1),nb_points);
end



RMSE= MomentsArmComparison(BiomechanicalModel,num_muscle,RegressionStructure, nb_points,involved_solid,num_markers);



end
