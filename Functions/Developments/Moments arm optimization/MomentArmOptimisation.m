function [Pts,involved_solids,BiomechanicalModel]=MomentArmOptimisation(name_mus,BiomechanicalModel)

HumanModel=BiomechanicalModel.OsteoArticularModel;
Muscles=BiomechanicalModel.Muscles;

osnames={HumanModel.name};
musnames={Muscles.name};

Sign={'R','L'};
deuxcoteoupas=1;

%% Modification de la structure BiomechanicalModel
for k=deuxcoteoupas
    [~,num_muscle(k)]=intersect(musnames,[Sign{k},name_mus]);
    
    involved_solids{k}=Muscles(num_muscle(k)).num_solid;
    
    involved_solid{k}=[Muscles(num_muscle(k)).num_solid;involved_solids{k}];
    num_markers{k}=[BiomechanicalModel.Muscles(num_muscle(k)).num_markers];
    num_markersprov{k}=[];
    for j=1:size(involved_solids{k})
        
        numptdepart=strfind({BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position{:, 1}  },[osnames{involved_solids{k}(j)},'_',name_mus],'ForceCellOutput',true);
        numptdepart=find(~cellfun(@isempty,numptdepart));
        pt_depart= BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position{numptdepart(1),2};
        
        VP_name= [osnames{involved_solids{k}(j)},'_',name_mus,'_VP'];
        BiomechanicalModel.Muscles(num_muscle(k)).path{end+1}= VP_name;
        BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position{end+1,1}= VP_name;
        
        %BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position{end,2}=[0 0 0]';
        BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position{end,2}= pt_depart;
        num_markersprov{k}=[num_markersprov{k} ;size(BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position,1)];
    end
    
    [BiomechanicalModel.Muscles(num_muscle(k)).num_solid,idx] = sort(involved_solid{k});
    temp=[num_markers{k},num_markersprov{k}];
    BiomechanicalModel.Muscles(num_muscle(k)).num_markers=temp(idx);
    
end


%% Mise en place de l'optimisation

load('/home/clivet/Documents/Thèse/Developpement_CusToM/CusToM/Functions/Developments/MomentsArmRegression.mat');

 nb_points=15;
%mac=momentarmcurve(x,BiomechanicalModel,num_muscle(1),MomentsArmRegression(1).regression ,nb_points,'R',involved_solids{1},num_markersprov{1});

%diff=fctcout(x,BiomechanicalModel,num_muscle,MomentsArmRegression(1).regression,nb_points, involved_solids{1},num_markersprov{1});
Nb_q=numel(BiomechanicalModel.OsteoArticularModel)-6*(~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0')));
lmax=zeros(length(deuxcoteoupas),1);
qlim=zeros(Nb_q,length(deuxcoteoupas));
for k=deuxcoteoupas
    lmax(k)=1.2*BiomechanicalModel.Muscles(num_muscle(k)).lmax;
    for j=1:size(BiomechanicalModel.Muscles(num_muscle(k)).lmaxangles,1)
        [~,ind_arti]=intersect(osnames,BiomechanicalModel.Muscles(num_muscle(k)).lmaxangles{j,1});
        sens=BiomechanicalModel.Muscles(num_muscle(k)).lmaxangles{j,2};
        qlim(ind_arti,k)=1/2*(1+sens)*BiomechanicalModel.OsteoArticularModel(ind_arti).limit_sup +...
                                        1/2*(1-sens)*BiomechanicalModel.OsteoArticularModel(ind_arti).limit_inf; 
    end
end

options = optimoptions(@fmincon,'Algorithm','sqp','Display','final','GradObj','off','GradConstr','off','TolFun',1e-16,'TolCon',1e-16,'MaxIterations',100000,'MaxFunEvals',10000);%,'PlotFcn','optimplotfval');

x0=zeros(3* numel([involved_solids{:}]),1);
lb=-200e-2*ones(size(x0));
ub=200e-2*ones(size(x0));
% K1=zeros(1,3*length(deuxcoteoupas)/2*numel([involved_solids{:}]));
% K2=zeros(numel([involved_solids{:}])/2,3*length(deuxcoteoupas)/2*numel([involved_solids{:}]));
% ind=find((mod(find(~K1),3)==0));
% for k=1:length(ind)
%     K2(k,ind(k))=1;
% end
% Aeq=[K2 -K2];
% beq=zeros(numel([involved_solids{:}])/2,1);
fun = @(x) fctcout(x,BiomechanicalModel,num_muscle,MomentsArmRegression(1).regression,nb_points,involved_solids,num_markersprov);
nonlcon = @(x) longueur_max(x,BiomechanicalModel,num_muscle,involved_solids,num_markersprov,qlim,lmax);

x = fmincon(fun,x0,[],[],[],[],lb,ub,nonlcon,options);
%x = fmincon(fun,x0,[],[],Aeq,beq,lb,ub,nonlcon,options);
fctcoutaffich(x0,BiomechanicalModel,num_muscle,MomentsArmRegression(1).regression,nb_points,involved_solids,num_markersprov);
title('x0')
fctcoutaffich(x,BiomechanicalModel,num_muscle,MomentsArmRegression(1).regression,nb_points,involved_solids,num_markersprov);
title('x sorti de fmincon')



for sign=deuxcoteoupas
    num_solid=involved_solids{sign};
   num_markers= num_markersprov{sign};
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




Pts=x;




end
