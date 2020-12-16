function diff=fctcout(x,BiomechanicalModel,num_muscle,Regression,nb_points,involved_solids,num_markersprov)


ideal_curve=[];

[mac,BiomechanicalModel]=momentarmcurve(x,BiomechanicalModel,num_muscle,Regression,nb_points,'R',involved_solids(2:end-1),num_markersprov(2:end-1));


mac_norme=[];
 decalage=1;
 diff=0;

for j=1:size(Regression,2)
    ideal_curve_temp=[];
    rangeq=zeros(nb_points,size(Regression(j).joints,2));
    map_q=zeros(nb_points^size(Regression(j).joints,2),size(Regression(j).joints,2));

    for k=1:size(Regression(j).joints,2)
        joint_name=Regression(j).joints{k};
        [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);
        rangeq(:,k)=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points)';

        B1=repmat(rangeq(:,k),1,nb_points^(k-1));
        B1=B1';
        B1=B1(:)';
   
        B2=repmat(B1,1,nb_points^(size(Regression(j).joints,2)-k));
        map_q(:,k) = B2;
    end
    
    c = ['equation',Regression(j).equation] ;
    fh = str2func(c);
    
    ideal_curve_temp=fh(Regression(j).coeffs,map_q);
    
    norm_id=norm(ideal_curve_temp);
    
    ideal_curve=[ ideal_curve  ideal_curve_temp];
    
    
    mac_temp=mac(decalage: decalage + size(map_q,1) - 1);
    decalage=decalage+size(map_q,1);

    
    mac_norme=[mac_norme mac_temp];
    
    diff=diff + (norm(mac_temp-ideal_curve_temp,2)/norm_id)^2;

    
end



%diff=norm((mac-ideal_curve).^2,2);


% 
%  figure()
% plot(ideal_curve,'k')
% hold on
% plot(mac_norme,'--b')
% legend("Actuelle","Ce quon veut atteindre")
% title("Fct coût")
% legend("Actuelle","Ce quon veut atteindre")
% ylabel("Moment arm normalisé");
% 
% ax=gca;
% ax.FontSize=30;
% ax.FontName='Utopia';


end