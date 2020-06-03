function diff=fctcoutaffich(x,BiomechanicalModel,num_muscle,Regression,nb_points,involved_solids,num_markersprov)


mac=[];
ideal_curve=[];

mac=[mac momentarmcurve(x,BiomechanicalModel,num_muscle,Regression,nb_points,'R',involved_solids,num_markersprov)];
liste_noms=[];
for j=1:size(Regression,2)
    if Regression(j).equation==1
        joint_name=Regression(j).primaryjoint;
        [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);
        rangeq=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points);
        ideal_curve=[ideal_curve polyval(flip(Regression(j).coeffs),rangeq)];
        liste_noms=[liste_noms joint_name , ' ' ];
    else
        if Regression(j).equation==2
            
            joint_name1=Regression(j).primaryjoint;
            joint_name2=Regression(j).secondaryjoint;
            [~,joint_num1]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R',joint_name1]);
            [~,joint_num2]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R',joint_name2]);
            rangeq1=linspace(BiomechanicalModel.OsteoArticularModel(joint_num1).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num1).limit_sup,nb_points);
            rangeq2=linspace(BiomechanicalModel.OsteoArticularModel(joint_num2).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num2).limit_sup,nb_points);
            liste_noms=[liste_noms joint_name1 joint_name2 , ' '] ;
            
            [X,Y]=meshgrid(rangeq1,rangeq2);
            Xline=X(:);
            Yline=Y(:);
            ideal_curve_temp=[];
            
            for i=1:length(Xline)
                ideal_curve_temp=[ ideal_curve_temp equation2(Regression(j).coeffs,Xline(i),Yline(i))];
            end
            
            figure()
            mesh(X,Y,reshape(mac((nb_points^2)*(j-1)+1:(nb_points^2)*j),nb_points,nb_points));
            hold on
            s = mesh(X,Y,reshape(ideal_curve_temp*1e-3, nb_points,nb_points),'FaceAlpha','0.5');
            s.FaceColor='Flat';
            
            ideal_curve=[ideal_curve ideal_curve_temp];
            
        else
            if Regression(j).equation==3
                joint_name1=Regression(j).primaryjoint;
                joint_name2=Regression(j).secondaryjoint;
                [~,joint_num1]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R',joint_name1]);
                [~,joint_num2]=intersect({BiomechanicalModel.OsteoArticularModel.name},['r',joint_name2]);
                rangeq1=linspace(BiomechanicalModel.OsteoArticularModel(joint_num1).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num1).limit_sup,nb_points);
                rangeq2=linspace(BiomechanicalModel.OsteoArticularModel(joint_num2).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num2).limit_sup,nb_points);
              
                liste_noms=[liste_noms joint_name1 joint_name2 , ' '] ;
                
                
                [X,Y]=meshgrid(rangeq1,rangeq2);
                Xline=X(:);
                Yline=Y(:);
                ideal_curve_temp=[];
                for i=1:length(Xline)
                    ideal_curve_temp=[ ideal_curve_temp equation2(Regression(j).coeffs,Xline(i),Yline(i))];
                end
                
                figure()
                mesh(X,Y,reshape(mac(nb_points*(j-1)+1:nb_points*j),nb_points,nb_points));
                hold on
                s = mesh(X,Y,reshape(ideal_curve_temp*1e-3, nb_points,nb_points),'FaceAlpha','0.5');
                s.FaceColor='Flat';
                
                ideal_curve=[ideal_curve ideal_curve_temp];
            end
        end
    end
    
    
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