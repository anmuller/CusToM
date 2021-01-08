function diff=fctcoutaffich(x,BiomechanicalModel,num_muscle,Regression,nb_points,involved_solids,num_markersprov)


mac=momentarmcurve(x,BiomechanicalModel,num_muscle,Regression,nb_points,'R',involved_solids,num_markersprov);

ideal_curve=[];
liste_noms=[];
for j=1:size(Regression,2)
    rangeq=zeros(nb_points,size(Regression(j).joints,2));
    ideal_curve_temp=[];
    for k=1:size(Regression(j).joints,2)
        joint_name=Regression(j).joints{k};
        [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);
        rangeq(:,k)=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points)';
        liste_noms=[liste_noms joint_name];
    end
    
    
    map_q=zeros(nb_points^size(Regression(j).joints,2),size(Regression(j).joints,2));
    for i=1:size(Regression(j).joints,2)
        B1=repmat(rangeq(:,i),nb_points^(i-1),1);
        B1=B1(:)';
        B2=repmat(B1,1,nb_points^(size(Regression(j).joints,2)-i));
        map_q(:,i) = B2;
    end
    
    c = ['equation',Regression(j).equation] ;
    fh = str2func(c);
    ideal_curve_temp=[ideal_curve_temp fh(Regression(j).coeffs,map_q)];
    
    if size(Regression(j).joints,2)==2
        figure()
        [X,Y]=meshgrid(rangeq(:,1),rangeq(:,2));
        mesh(X,Y,reshape(mac((nb_points^2)*(j-1)+1:(nb_points^2)*j),nb_points,nb_points));
        hold on
        s = mesh(X,Y,reshape(ideal_curve_temp*1e-3, nb_points,nb_points),'FaceAlpha','0.5');
        s.FaceColor='interp';
    end
            
    ideal_curve=[ideal_curve ideal_curve_temp];

   liste_noms=[liste_noms ' '];
    
end


    


figure()
plot(mac)
hold on
plot(ideal_curve*1e-3)
title(["Fct coût, " BiomechanicalModel.Muscles(num_muscle).name,liste_noms])
legend("Actuelle","Ce quon veut atteindre")
ylabel("Moment arm (m)");
diff=norm((mac-ideal_curve*1e-3).^2,2);


    
    end