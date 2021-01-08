function [fctcoutx,RMS,RMSlmt,involved_solid,num_markers,BiomechanicalModel]=LengthandMomentArmOptimisation(name_mus,BiomechanicalModel,MomentsArmRegression,LengthRegression)

Muscles=BiomechanicalModel.Muscles;

osnames={BiomechanicalModel.OsteoArticularModel.name};
musnames={Muscles.name};


[~,ind_mus_Regr]=intersect({MomentsArmRegression.name},name_mus);

Sign={'R','L'};
deuxcoteoupas=1;
%
% %% Modification de la structure BiomechanicalModel
for k=deuxcoteoupas
    [~,num_muscle(k)]=intersect(musnames,[Sign{k},name_mus]);
    
    involved_solids{k}=solid_VP_choice(BiomechanicalModel.OsteoArticularModel,unique(Muscles(num_muscle(k)).num_solid),MomentsArmRegression(ind_mus_Regr).regression,Sign{k});
    num_markersprov{k}=[];
    
    if ~isempty(Muscles(num_muscle(k)).num_solid)
        involved_solid{k}=[Muscles(num_muscle(k)).num_solid; involved_solids{k}'];
        num_markers{k}=[Muscles(num_muscle(k)).num_markers];
        
        BiomechanicalModel.OsteoArticularModel(Muscles(num_muscle(k)).num_solid(1)).anat_position{Muscles(num_muscle(k)).num_markers(1),2} = [0 0 0]';
        endsolid = Muscles(num_muscle(k)).num_solid(2);
        if BiomechanicalModel.OsteoArticularModel(endsolid).child
            segend=BiomechanicalModel.OsteoArticularModel(BiomechanicalModel.OsteoArticularModel(endsolid).child).b;
            temp3=Muscles(num_muscle(k)).num_solid(2);
            while sum(segend)==0 && temp3
                temp3=BiomechanicalModel.OsteoArticularModel(temp3).child;
                segend=BiomechanicalModel.OsteoArticularModel(BiomechanicalModel.OsteoArticularModel(temp3).child).b;
            end
            if ~temp3
                temp3=BiomechanicalModel.OsteoArticularModel(temp3).mother;
                [~,numnode]=intersect( BiomechanicalModel.OsteoArticularModel(temp3).anat_position(:,1),[BiomechanicalModel.OsteoArticularModel(temp3).name '_EndNode']);
                segend = BiomechanicalModel.OsteoArticularModel(temp3).anat_position{numnode,2};
            end
        else
            [~,numnode]=intersect( BiomechanicalModel.OsteoArticularModel(endsolid).anat_position(:,1),[BiomechanicalModel.OsteoArticularModel(endsolid).name '_EndNode']);
            segend = BiomechanicalModel.OsteoArticularModel(endsolid).anat_position{numnode,2};
        end
        BiomechanicalModel.OsteoArticularModel(endsolid).anat_position{Muscles(num_muscle(k)).num_markers(2),2} = segend;
        
        
        
    else
        involved_solid{k}=[involved_solids{k}(1); involved_solids{k}(end); involved_solids{k}'];
        BiomechanicalModel.OsteoArticularModel(involved_solids{k}(1)).anat_position{end+1,1}= [osnames{involved_solids{k}(1)},'_',name_mus,'_o'];
        BiomechanicalModel.OsteoArticularModel(involved_solids{k}(1)).anat_position{end,2} = [0 0 0]';
        BiomechanicalModel.OsteoArticularModel(involved_solids{k}(2)).anat_position{end+1,1}= [osnames{involved_solids{k}(2)},'_',name_mus,'_i'];
        
        if BiomechanicalModel.OsteoArticularModel(involved_solids{k}(2)).child
            segend=BiomechanicalModel.OsteoArticularModel(BiomechanicalModel.OsteoArticularModel(involved_solids{k}(2)).child).b;
            temp3=involved_solids{k}(2);
            while sum(segend)==0 && temp3
                temp3=BiomechanicalModel.OsteoArticularModel(temp3).child;
                segend=BiomechanicalModel.OsteoArticularModel(BiomechanicalModel.OsteoArticularModel(temp3).child).b;
            end
            if ~temp3
                temp3=BiomechanicalModel.OsteoArticularModel(temp3).mother;
                [~,numnode]=intersect( BiomechanicalModel.OsteoArticularModel(temp3).anat_position(:,1),[BiomechanicalModel.OsteoArticularModel(temp3).name '_EndNode']);
                segend = BiomechanicalModel.OsteoArticularModel(temp3).anat_position{numnode,2};
            end
        else
            [~,numnode]=intersect( BiomechanicalModel.OsteoArticularModel(involved_solids{k}(2)).anat_position(:,1),[BiomechanicalModel.OsteoArticularModel(involved_solids{k}(2)).name '_EndNode']);
            segend = BiomechanicalModel.OsteoArticularModel(involved_solids{k}(2)).anat_position{numnode,2};
        end
        BiomechanicalModel.OsteoArticularModel(involved_solids{k}(2)).anat_position{end,2} = segend;
        
        
        num_markers{k}=[length(BiomechanicalModel.OsteoArticularModel(involved_solids{k}(1)).anat_position) ; BiomechanicalModel.OsteoArticularModel(involved_solids{k}(2)).anat_position];
    end
    
    
    for j=1:size(involved_solids{k},2)
        VP_name= [osnames{involved_solids{k}(j)},'_',name_mus,'_VP',num2str(j)];
        BiomechanicalModel.Muscles(num_muscle(k)).path{end+1}= VP_name;
        BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position{end+1,1}= VP_name;
        
        BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position{end,2}= [0 0 0]';
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


nb_points=30;

options = optimoptions(@fmincon,'Algorithm','sqp','Display','final','MaxFunEvals',100000,'TolCon',1e-6);%,'PlotFcn','optimplotfval');

par_case = 0;
if strcmp(MomentsArmRegression(ind_mus_Regr).regression(1).joints,'Radius')    % size({MomentsArmRegression(ind_mus_Regr).regression.equation},2)==1
    par_case = 1;
end

solids = involved_solid{1};
markers=  num_markers{1};
nonlcon=@(x) InCylinder_LengthOpti(x,BiomechanicalModel.OsteoArticularModel,involved_solids{1},num_markersprov{1});

fun = @(x) fctcout(x,BiomechanicalModel,num_muscle(1),MomentsArmRegression(ind_mus_Regr).regression,nb_points,solids,markers);


x0=0*rand(3* numel(involved_solids{1}),1);

for j=1:2:size(involved_solids{1},2)
    if BiomechanicalModel.OsteoArticularModel(involved_solids{1}(j)).child
        segend=BiomechanicalModel.OsteoArticularModel(BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).child).b;
        temp3=involved_solids{k}(j);
        while sum(segend)==0 && temp3
            temp3=BiomechanicalModel.OsteoArticularModel(temp3).child;
            segend=BiomechanicalModel.OsteoArticularModel(BiomechanicalModel.OsteoArticularModel(temp3).child).b;
        end
        if ~temp3
            temp3=BiomechanicalModel.OsteoArticularModel(temp3).mother;
            [~,numnode]=intersect( BiomechanicalModel.OsteoArticularModel(temp3).anat_position(:,1),[BiomechanicalModel.OsteoArticularModel(temp3).name '_EndNode']);
            segend = BiomechanicalModel.OsteoArticularModel(temp3).anat_position{numnode,2};
        end
    else
        [~,numnode]=intersect( BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position(:,1),[BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).name '_EndNode']);
        segend = BiomechanicalModel.OsteoArticularModel(involved_solids{k}(j)).anat_position{numnode,2};
    end
    x0(1+3*(j-1):3*j)= segend;
end



nonlcon(x0);

% while sum(nonlcon(x0)<=0)<length(nonlcon(x0))
%     x0=0.2*(0.5-rand(3* numel(involved_solids{1}),1));
% end


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



%% Length Difference Minimisation

%Via points and origin and insertion superposition
BiomechanicalModel.OsteoArticularModel(solids(1)).anat_position{markers(1),2}= ...
    BiomechanicalModel.OsteoArticularModel(solids(2)).anat_position{markers(2),2};
BiomechanicalModel.OsteoArticularModel(solids(end)).anat_position{markers(end),2}= ...
    BiomechanicalModel.OsteoArticularModel(solids(end-1)).anat_position{markers(end-1),2};

funlength = @(x)LengthDifferenceMinimisation(x,BiomechanicalModel,num_muscle,LengthRegression(ind_mus_Regr).regression,nb_points,solids,markers);

x = fmincon(funlength,0,[],[],[],[],[],[],[],options);


BiomechanicalModel.OsteoArticularModel(solids(1)).anat_position{markers(1),2}(2)= ...
    BiomechanicalModel.OsteoArticularModel(solids(2)).anat_position{markers(2),2}(2)+ x;

BiomechanicalModel.OsteoArticularModel(solids(end)).anat_position{markers(end),2}(2)= ...
    BiomechanicalModel.OsteoArticularModel(solids(end-1)).anat_position{markers(end-1),2}(2)- x;





RMS= MomentsArmComp(BiomechanicalModel,num_muscle(1),MomentsArmRegression(ind_mus_Regr).regression, LengthRegression(ind_mus_Regr).regression, nb_points,solids,markers);
RMSlmt=MuscleLengthComp(BiomechanicalModel,num_muscle(1),LengthRegression(ind_mus_Regr).regression,nb_points,solids,markers);



end
