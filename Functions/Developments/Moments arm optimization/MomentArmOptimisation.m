function [Pts,involved_solids,BiomechanicalModel]=MomentArmOptimisation(name_mus,BiomechanicalModel,MomentsArmRegression)

HumanModel=BiomechanicalModel.OsteoArticularModel;
Muscles=BiomechanicalModel.Muscles;

osnames={HumanModel.name};
musnames={Muscles.name};


[~,ind_mus_Regr]=intersect({MomentsArmRegression.name},name_mus);

Sign={'R','L'};
deuxcoteoupas=1:2;

%% Modification de la structure BiomechanicalModel
for k=deuxcoteoupas
    [~,num_muscle(k)]=intersect(musnames,[Sign{k},name_mus]);
    
    involved_solids{k}=solid_VP_choice(HumanModel,unique(Muscles(num_muscle(k)).num_solid),MomentsArmRegression(ind_mus_Regr).regression,Sign{k});
    involved_solid{k}=[Muscles(num_muscle(k)).num_solid; involved_solids{k}'];
    num_markers{k}=[BiomechanicalModel.Muscles(num_muscle(k)).num_markers];
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
    
    A=[involved_solid{k}, [num_markers{k};num_markersprov{k}]];
    D=sortrows(A,[1 2]) ;
    D(end-1:end, :)=sortrows(D(end-1:end, :),2,{'descend'});
    
    BiomechanicalModel.Muscles(num_muscle(k)).num_solid=D(:,1);
    BiomechanicalModel.Muscles(num_muscle(k)).num_markers=D(:,2);
    
end


%% Mise en place de l'optimisation


 nb_points=30;

% lmax=zeros(length(deuxcoteoupas),1);
% for k=deuxcoteoupas
%     lmax(k)=BiomechanicalModel.Muscles(num_muscle(k)).lmax;
% end
 lmax=BiomechanicalModel.Muscles(num_muscle(1)).lmax;

options = optimoptions(@fmincon,'Algorithm','sqp','Display','final','GradObj','off','GradConstr','off','TolFun',1e-16,'TolCon',1e-16,'MaxIterations',100000,'MaxFunEvals',10000,'StepTolerance',1e-14);%,'PlotFcn','optimplotfval');

x0=zeros(3* numel(involved_solids{1}),1);

fun = @(x) fctcout(x,BiomechanicalModel,num_muscle(1),MomentsArmRegression(ind_mus_Regr).regression,nb_points,involved_solids{1},num_markersprov{1});
nonlcon = @(x) longueur_max(x,BiomechanicalModel,num_muscle(1),involved_solids{1},num_markersprov{1},lmax,5);

x = fmincon(fun,x0,[],[],[],[],[],[],nonlcon,options);
%x = fmincon(fun,x0,[],[],Aeq,beq,lb,ub,nonlcon,options);
fctcoutaffich(x0,BiomechanicalModel,num_muscle(1),MomentsArmRegression(ind_mus_Regr).regression,nb_points,involved_solids{1},num_markersprov{1});
title('x0')
fctcoutaffich(x,BiomechanicalModel,num_muscle(1),MomentsArmRegression(ind_mus_Regr).regression,nb_points,involved_solids{1},num_markersprov{1});
title('x sorti de fmincon')



for sign=deuxcoteoupas
    num_solid=involved_solids{sign};
    num_markers= num_markersprov{sign};
    if sign==1
        Mirror=1;
    else
        Mirror = -1;
    end
    cpt=0;
    for k=1:numel(num_solid)
        for pt=1:2
            cpt=cpt+1;
            temp1=num_solid(k);
            temp2=num_markers(k);
            BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2}(pt)=...
                BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2}(pt)+x(cpt);
        end
        cpt=cpt+1;
        temp1=num_solid(k);
        temp2=num_markers(k);
        BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2}(pt)=...
            BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2}(pt)+Mirror*x(cpt);
    end
end




Pts=x;




end
