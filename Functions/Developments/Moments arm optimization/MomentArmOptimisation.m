function [fctcoutx,RMS,RMSlmt,involved_solid,num_markers,BiomechanicalModel,homocoeff]=MomentArmOptimisation(name_mus,BiomechanicalModel,MomentsArmRegression,LengthRegression)

HumanModel=BiomechanicalModel.OsteoArticularModel;
Muscles=BiomechanicalModel.Muscles;

osnames={HumanModel.name};
musnames={Muscles.name};


[~,ind_mus_Regr]=intersect({MomentsArmRegression.name},name_mus);

Sign={'R','L'};
deuxcoteoupas=1;
% 
% %% Modification de la structure BiomechanicalModel
 for k=deuxcoteoupas
     [~,num_muscle(k)]=intersect(musnames,[Sign{k},name_mus]);
    
    involved_solids{k}=solid_VP_choice(HumanModel,unique(Muscles(num_muscle(k)).num_solid),MomentsArmRegression(ind_mus_Regr).regression,Sign{k});
    involved_solid{k}=[Muscles(num_muscle(k)).num_solid; involved_solids{k}'];
    num_markers{k}=[Muscles(num_muscle(k)).num_markers];
    num_markersprov{k}=[];
    for j=1:size(involved_solids{k},2)
        
        if ~isempty(BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position)
            numptdepart=strfind({BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position{:, 1}  },[osnames{involved_solids{k}(j)},'_',name_mus],'ForceCellOutput',true);
            numptdepart=find(~cellfun(@isempty,numptdepart));
            if ~isempty(numptdepart)
                pt_depart= BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position{numptdepart(1),2};
            else
                pt_depart=[0 0 0]';
            end
        else
            pt_depart=[0 0 0]';
        end
        
        VP_name= [osnames{involved_solids{k}(j)},'_',name_mus,'_VP',num2str(j)];
        BiomechanicalModel.Muscles(num_muscle(k)).path{end+1}= VP_name;
        BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position{end+1,1}= VP_name;
        
        BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position{end,2}= pt_depart;
        num_markersprov{k}=[num_markersprov{k} ;size(BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position,1)];
    end
    
    num_markers{k}=  [num_markers{k};num_markersprov{k}];
    A=[involved_solid{k},num_markers{k}];
    D=sortrows(A,[1 2]) ;
    D(end-1:end, :)=sortrows(D(end-1:end, :),2,{'descend'});
    
    BiomechanicalModel.Muscles(num_muscle(k)).num_solid=D(:,1);
    BiomechanicalModel.Muscles(num_muscle(k)).num_markers=D(:,2);
    involved_solid{k}=D(:,1);
    num_markers{k}=D(:,2);
    
 end


% Mise en place de l'optimisation


nb_points=15;

insertion = BiomechanicalModel.OsteoArticularModel(involved_solid{1}(end)).anat_position{num_markers{1}(end),2}(2) +  BiomechanicalModel.OsteoArticularModel(involved_solid{1}(end)).c(2) ; 
origin = BiomechanicalModel.OsteoArticularModel(involved_solid{1}(1)).anat_position{num_markers{1}(1),2}(2) +  BiomechanicalModel.OsteoArticularModel(involved_solid{1}(1)).c(2) ;


options = optimoptions(@fmincon,'Algorithm','sqp','Display','final','MaxFunEvals',100000,'TolCon',1e-6);%,'PlotFcn','optimplotfval');

par_case = 0;
if strcmp(MomentsArmRegression(ind_mus_Regr).regression(1).joints,'Radius')    % size({MomentsArmRegression(ind_mus_Regr).regression.equation},2)==1
    par_case = 1;
end


nonlcon=@(x) InCylinder(x,BiomechanicalModel.OsteoArticularModel,involved_solids{1},num_markersprov{1},insertion,origin,par_case);

fun = @(x) fctcout(x,BiomechanicalModel,num_muscle(1),MomentsArmRegression(ind_mus_Regr).regression,nb_points,involved_solid{1},num_markers{1});

x0=0*(0.5-rand(3* numel(involved_solids{1}),1));


while sum(nonlcon(x0)<=0)<length(nonlcon(x0))
    x0=0.05*(0.5-rand(3* numel(involved_solids{1}),1));
end

x = fmincon(fun,x0,[],[],[],[],[],[],nonlcon,options);

fctcoutx=fun(x);



num_solid=involved_solids{1};
num_mark= num_markersprov{1};
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
    [BiomechanicalModel]=LengthMinimisation(involved_solid,num_markers,BiomechanicalModel,MomentsArmRegression(ind_mus_Regr).regression,num_muscle(1),nb_points);
end



solids = involved_solid{1};
markers=  num_markers{1};


funlength = @(k)LengthDifferenceMinimisationOI(k,BiomechanicalModel,num_muscle,LengthRegression(ind_mus_Regr).regression,nb_points,solids,markers);

homocoeff = fmincon(funlength,0,[],[],[],[],0,[],[],options);

BiomechanicalModel.OsteoArticularModel(solids(1)).anat_position{markers(1),2}= ...
   homocoeff* (BiomechanicalModel.OsteoArticularModel(solids(1)).anat_position{markers(1),2} - BiomechanicalModel.OsteoArticularModel(solids(2)).anat_position{markers(2),2}) +...
   BiomechanicalModel.OsteoArticularModel(solids(2)).anat_position{markers(2),2};

BiomechanicalModel.OsteoArticularModel(solids(end)).anat_position{markers(end),2}= ...
    homocoeff*(BiomechanicalModel.OsteoArticularModel(solids(end)).anat_position{markers(end),2}- BiomechanicalModel.OsteoArticularModel(solids(end-1)).anat_position{markers(end-1),2}) +...
    BiomechanicalModel.OsteoArticularModel(solids(end-1)).anat_position{markers(end-1),2};





RMS= MomentsArmComp(BiomechanicalModel,num_muscle(1),MomentsArmRegression(ind_mus_Regr).regression, LengthRegression(ind_mus_Regr).regression, nb_points,involved_solid{1},num_markers{1});
RMSlmt=MuscleLengthComp(BiomechanicalModel,num_muscle(1),LengthRegression(ind_mus_Regr).regression,nb_points,involved_solid{1},num_markers{1});



end
