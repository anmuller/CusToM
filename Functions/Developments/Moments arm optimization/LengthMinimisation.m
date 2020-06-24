function [Pts,BiomechanicalModel]=LengthMinimisation(involved_solids,num_markersprov,BiomechanicalModel,num_muscle)


inv_sol=involved_solids{1};
num_markers=num_markersprov{1};
% Old coordinates
rold=zeros(1,length(inv_sol)-2);
ABold=zeros(1,(length(inv_sol)-2)/2);


x0=[];
for k=2:1:length(inv_sol)-1
    x0=[x0 ; BiomechanicalModel.OsteoArticularModel(inv_sol(k)).anat_position{num_markers(k),2}];
end

[~,ceq]=OnCircle(x0,BiomechanicalModel.OsteoArticularModel,rold,ABold,inv_sol,num_markers);
rold=ceq(1:length(rold))';
ABold=ceq(length(rold)+1:end)';



% Fct coût
muscle_length = @(x)MinimizeLength(x,BiomechanicalModel.OsteoArticularModel,BiomechanicalModel.Muscles(num_muscle),inv_sol,num_markers);
% Contraintes non linéaires du cercle
nonlcon = @(x) OnCircle(x,BiomechanicalModel.OsteoArticularModel,rold,ABold,inv_sol,num_markers);



options = optimoptions(@fmincon,'Algorithm','interior-point','Display','final','TolFun',1e-6,'TolCon',1e-12,'MaxIterations',100000,'MaxFunEvals',10000,'StepTolerance',1e-14);%,'PlotFcn','optimplotfval');


% Minimisation
x = fmincon(muscle_length,x0,[],[],[],[],[],[],nonlcon,options);


for sign=1:2
    num_sol=involved_solids{sign};
    num_mark= num_markersprov{sign};
    if sign==1
        Mirror=1;
    else
        Mirror = -1;
    end
    cpt=0;
    for k=2:numel(num_sol)-1
        for pt=1:2
            cpt=cpt+1;
            temp1=num_sol(k);
            temp2=num_mark(k);
            BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2}(pt)=x(cpt);
        end
        cpt=cpt+1;
        temp1=num_sol(k);
        temp2=num_mark(k);
        BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2}(pt)=Mirror*x(cpt);
    end
end





Pts=x;

end