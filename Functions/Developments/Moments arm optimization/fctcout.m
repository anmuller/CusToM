function diff=fctcout(x,BiomechanicalModel,num_muscle,Regression,nb_points,involved_solids,num_markersprov)


ideal_curve=[];

[mac,BiomechanicalModel]=momentarmcurve(x,BiomechanicalModel,num_muscle,Regression,nb_points,'R',involved_solids(2:end-1),num_markersprov(2:end-1));

for j=1:size(Regression,2)
    rangeq=zeros(nb_points,size(Regression(j).joints,2));
     map_q=zeros(nb_points^size(Regression(j).joints,2),size(Regression(j).joints,2));

    for k=1:size(Regression(j).joints,2)
        joint_name=Regression(j).joints{k};
        [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);
        rangeq(:,k)=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points)';

        B1=repmat(rangeq(:,k),nb_points^(k-1),1);
        B1=B1(:)';
        B2=repmat(B1,1,nb_points^(size(Regression(j).joints,2)-k));
        map_q(:,k) = B2;
    end
    
    c = ['equation',Regression(j).equation] ;
    fh = str2func(c);
    ideal_curve=[ideal_curve fh(Regression(j).coeffs,map_q)];
    
end



diff=norm((mac-ideal_curve*1e-3).^2,2);



end