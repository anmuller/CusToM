function RMS=MuscleLengthComp(BiomechanicalModel,num_muscle,Regression,nb_points,involved_solids,num_markersprov)

num_solid=involved_solids(2:end-1);
num_markers=num_markersprov(2:end-1);
% Verification if a muscle as its origin or its insertion in the loop
names_list={BiomechanicalModel.OsteoArticularModel(num_solid).name};
names_loops={BiomechanicalModel.OsteoArticularModel((~cellfun('isempty',{BiomechanicalModel.OsteoArticularModel.ClosedLoop}))).ClosedLoop};
flag=0;
for k=1:length(names_loops)
    temp=names_loops{k};
    temp(1)=''; %get rid of "R" and "L"
    ind = find(temp=='_');
    name_sol1= temp(1:ind-1);
    ind_end = strfind(temp,'JointNode');
    name_sol2 = temp(ind+1:ind_end-1);
    if sum(contains(names_list,name_sol1)) || sum(contains(names_list,name_sol2))
        flag=1;
    end
end



Nb_q=numel(BiomechanicalModel.OsteoArticularModel)-6*(~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0')));

liste_noms=[];
Lmttot=[];
rangeq=zeros(nb_points,size(Regression.joints,2));
q=zeros(Nb_q,nb_points^size(Regression.joints,2));

map_q=zeros(nb_points^size(Regression.joints,2),size(Regression.joints,2));

for k=1:size(Regression.joints,2)
    joint_name=Regression.joints{k};
    [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);
    rangeq(:,k)=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points)';
    liste_noms=[liste_noms joint_name];
    
    B1=repmat(rangeq(:,k),1,nb_points^(k-1));
    B1=B1';
    B1=B1(:)';
    B2=repmat(B1,1,nb_points^(size(Regression.joints,2)-k));
    map_q(:,k) = B2;
    q(joint_num,:) = B2;
end

c = ['equation',Regression.equation] ;
fh = str2func(c);
ideal_curve=fh(Regression.coeffs,map_q);


parfor i=1:nb_points^size(Regression.joints,2)
    [Lmt,~] = Muscle_lengthNum(BiomechanicalModel.OsteoArticularModel,BiomechanicalModel.Muscles(num_muscle),q(:,i));
    Lmttot  = [Lmttot Lmt];
end



if size(Regression.joints,2)==2
    
    Z=zeros(nb_points);
    ZLmttot=zeros(nb_points);
    for k=1:length(rangeq(:,2))
        Z(k,:) = ideal_curve((k-1)*length(rangeq(:,1))+1:k*length(rangeq(:,1)));
        ZLmttot(k,:) = Lmttot((k-1)*length(rangeq(:,1))+1:k*length(rangeq(:,1)));
    end
    
%     figure() 
%     s =surf(rangeq(:,1),rangeq(:,2),Z,'FaceAlpha','0.5','EdgeColor','None');
%     hold on 
%     surf(rangeq(:,1),rangeq(:,2),ZLmttot); 
%     hold on
%     s.FaceColor='interp'; 
%     xlabel([Regression.joints{1},' (rad)'])
%     ylabel([Regression.joints{2},' (rad)']) 
%     zlabel('Longueur musculo-tendineuse (m)')
%     title(BiomechanicalModel.Muscles(num_muscle).name)
%     legend('Reference','Model') 
%     ax=gca; 
%     ax.FontSize=50;
%     ax.FontName='Utopia';
%     
%     
%     figure() 
%     s = surf(rangeq(:,1),rangeq(:,2),Z-ZLmttot);
%     s.FaceColor='interp'; 
%     xlabel([Regression.joints{1},' (rad)'])
%     ylabel([Regression.joints{2},' (rad)']) 
%     zlabel('Musculotendon length error (m)') 
%     title(BiomechanicalModel.Muscles(num_muscle).name)
%     ax=gca; 
%     ax.FontSize=50; 
%     ax.FontName='Utopia';
end

%RMS.rms=  sqrt(1/length(Lmttot) * sum((ideal_curve - Lmttot).^2));
RMS.rmsr=  sqrt(1/length(Lmttot) * sum((ideal_curve - Lmttot).^2))/ sqrt(1/length(Lmttot) * sum((ideal_curve).^2))* 100;
[r,~] = corrcoef(Lmttot,ideal_curve);
RMS.corr=  r(2,1);
RMS.sign=sum(sign(ideal_curve - Lmttot));


% 
% figure()
% plot(ideal_curve,'k')
% hold on
% plot(Lmttot,'--b')
% title(["Longueur musculo tendineuse " BiomechanicalModel.Muscles(num_muscle).name,liste_noms])
% legend("Ce quon veut atteindre","Actuelle")
% ylabel("Longueur musculo tendineuse (m)");
% 
% ax=gca;
% ax.FontSize=30;
% ax.FontName='Utopia';



end