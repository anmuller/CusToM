function [RMSE,BiomechanicalModel]=MomentArmOptimization(num_muscle,BiomechanicalModel,InputMomentArm,nb_points,radius)

HumanModel=BiomechanicalModel.OsteoArticularModel;
Muscles=BiomechanicalModel.Muscles;

osnames={HumanModel.name};
musnames={Muscles.name};
name_mus = musnames{num_muscle};
name_mus=name_mus(2:end);
 [~,RegressionStructure]=InputMomentArm(musnames(num_muscle),[],[],[]);

% %% Modification de la structure BiomechanicalModel

involved_solids=PathConstruction(HumanModel,unique(Muscles(num_muscle).num_solid),RegressionStructure);
involved_solid=[Muscles(num_muscle).num_solid(1);  Muscles(num_muscle).num_solid(end);  involved_solids' ];
num_markers=[Muscles(num_muscle).num_markers(1) ;  Muscles(num_muscle).num_markers(end) ];
num_markersprov=[];
BiomechanicalModel.Muscles(num_muscle).path=[];
BiomechanicalModel.Muscles(num_muscle).path{1} = BiomechanicalModel.OsteoArticularModel(involved_solid(1)).anat_position{num_markers(1), 1};

j=1;
VP_name= [osnames{involved_solids(j)},'_',name_mus,'_VP',num2str(j)];
BiomechanicalModel.Muscles(num_muscle).path{end+1}= VP_name;
BiomechanicalModel.OsteoArticularModel(involved_solids(j)).anat_position{end+1,1}= VP_name;

BiomechanicalModel.OsteoArticularModel(involved_solids(j)).anat_position{end,2}= BiomechanicalModel.OsteoArticularModel(involved_solid(1)).anat_position{num_markers(1), 2};
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

BiomechanicalModel.OsteoArticularModel(involved_solids(j)).anat_position{end,2}= BiomechanicalModel.OsteoArticularModel(involved_solid(2)).anat_position{num_markers(2), 2};
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




% Mise en place de l'optimisation



insertion = BiomechanicalModel.OsteoArticularModel(involved_solid(end)).anat_position{num_markers(end),2}(2) +  BiomechanicalModel.OsteoArticularModel(involved_solid(end)).c(2) ;
origin = BiomechanicalModel.OsteoArticularModel(involved_solid(1)).anat_position{num_markers(1),2}(2) +  BiomechanicalModel.OsteoArticularModel(involved_solid(1)).c(2) ;


options = optimoptions(@fmincon,'Algorithm','sqp','Display','final','MaxFunEvals',100000,'TolCon',1e-6);%,'PlotFcn','optimplotfval');

par_case = 0;
[sp1,sp2]=find_solid_path(BiomechanicalModel.OsteoArticularModel, involved_solid(1), involved_solid(end));
if length(sp1)~=1 && length(sp2)~=1
    par_case = 1;
end


nonlcon=@(x) MusclesInCylinder(x,BiomechanicalModel.OsteoArticularModel,involved_solids,num_markersprov,insertion,origin,par_case,radius);

fun = @(x) fctcout(x,BiomechanicalModel,num_muscle,RegressionStructure,nb_points,involved_solid,num_markers);

x0=zeros(3* numel(involved_solids),1);
x=x0;

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
tic();
%x = run(gs,problem);
toc();

%x = fmincon(fun,x0,[],[],[],[],[],[],nonlcon,options);

fctcoutx=fun(x);



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



if par_case
    [BiomechanicalModel]=LengthMinimisation(involved_solid,num_markers,BiomechanicalModel,RegressionStructure,num_muscle(1),nb_points);
end


%RMSlmtinter=MuscleLengthComp(BiomechanicalModel,num_muscle(1),LengthRegression(ind_mus_Regr).regression,nb_points,involved_solid{1},num_markers{1});



%solids = involved_solid{1};
%markers=  num_markers{1};

% 
% funlength = @(k)LengthDifferenceMinimisationOI(k,BiomechanicalModel,num_muscle,LengthRegression(ind_mus_Regr).regression,nb_points,solids,markers);
% 
% homocoeff = fmincon(funlength,0,[],[],[],[],0,[],[],options);
% 
% BiomechanicalModel.OsteoArticularModel(solids(1)).anat_position{markers(1),2}= ...
%     homocoeff* (BiomechanicalModel.OsteoArticularModel(solids(1)).anat_position{markers(1),2} - BiomechanicalModel.OsteoArticularModel(solids(2)).anat_position{markers(2),2}) +...
%     BiomechanicalModel.OsteoArticularModel(solids(2)).anat_position{markers(2),2};
% 
% BiomechanicalModel.OsteoArticularModel(solids(end)).anat_position{markers(end),2}= ...
%     homocoeff*(BiomechanicalModel.OsteoArticularModel(solids(end)).anat_position{markers(end),2}- BiomechanicalModel.OsteoArticularModel(solids(end-1)).anat_position{markers(end-1),2}) +...
%     BiomechanicalModel.OsteoArticularModel(solids(end-1)).anat_position{markers(end-1),2};



RMSE= MomentsArmComparison(BiomechanicalModel,num_muscle,RegressionStructure, nb_points,involved_solid,num_markers);



end
