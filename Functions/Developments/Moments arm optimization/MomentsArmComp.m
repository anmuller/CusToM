function RMS=MomentsArmComp(BiomechanicalModel,num_muscle,MARegression, LRegression, nb_points,involved_solids,num_markersprov)




violet = [169 90 161]/255;
orange = [245 121 58]/255;
bleufonce = [15 32 128]/255;
bleuclair = [133 192 249]/255;

cmap = [ linspace(bleufonce(1),violet(1),85)  linspace(violet(1),orange(1),85) linspace(orange(1),bleuclair(1),86) ;...
    linspace(bleufonce(2),violet(2),85)  linspace(violet(2),orange(2),85) linspace(orange(2),bleuclair(2),86) ;...
    linspace(bleufonce(3),violet(3),85)  linspace(violet(3),orange(3),85) linspace(orange(3),bleuclair(3),86) ]';

%colormap(cmap);


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

fig_a_sauver = figure('units','normalized','outerposition',[0 0 1 1]);


Nb_q=numel(BiomechanicalModel.OsteoArticularModel)-6*(~isempty(intersect({BiomechanicalModel.OsteoArticularModel.name},'root0')));

mac=[];

ideal_curve=[];
liste_noms=[];
for j=1:size(MARegression,2)
    mactemp=[];
    rangeq=zeros(nb_points,size(MARegression(j).joints,2));
    ideal_curve_temp=[];
    q=zeros(Nb_q,nb_points^size(MARegression(j).joints,2));
    
    map_q=zeros(nb_points^size(MARegression(j).joints,2),size(MARegression(j).joints,2));
    
    for k=1:size(MARegression(j).joints,2)
        joint_name=MARegression(j).joints{k};
        [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);
        rangeq(:,k)=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points)';
        liste_noms=[liste_noms joint_name];
        
        B1=repmat(rangeq(:,k),1,nb_points^(k-1));
        B1=B1';
        B1=B1(:)';
        B2=repmat(B1,1,nb_points^(size(MARegression(j).joints,2)-k));
        map_q(:,k) = B2;
        q(joint_num,:) = B2;
    end
    
    c = ['equation',MARegression(j).equation] ;
    fh = str2func(c);
    ideal_curve_temp=[ideal_curve_temp fh(MARegression(j).coeffs,map_q)];
    
    
    joint_name=MARegression(j).axe;
    [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);
    
    parfor i=1:nb_points^size(MARegression(j).joints,2)
        mactemp  = [mactemp MomentArmsComputationNumMuscleJoint(BiomechanicalModel,q(:,i),0.0001,num_muscle,joint_num)];
    end
    
    
    for k=1:size(MARegression(j).joints,2)
        if  strcmp(MARegression(j).joints{k},'Ulna') || strcmp(MARegression(j).joints{k},'Radius_J1')
            MARegression(j).joints{k}= 'EFE';
        else if strcmp(MARegression(j).joints{k},'Radius')
                MARegression(j).joints{k}= 'PS';
            else if strcmp(MARegression(j).joints{k},'Hand')
                    MARegression(j).joints{k}= 'WDV';
                else if strcmp(MARegression(j).joints{k},'Wrist_J1')
                        MARegression(j).joints{k}= 'WFE';
                    end
                end
            end
        end
    end
    
    if  strcmp( MARegression(j).axe,'Ulna') || strcmp(MARegression(j).axe,'Radius_J1')
        MARegression(j).axe= 'EFE';
    else if strcmp(MARegression(j).axe,'Radius')
            MARegression(j).axe= 'PS';
        else if strcmp(MARegression(j).axe,'Hand')
                MARegression(j).axe= 'WDV';
            else if strcmp(MARegression(j).axe,'Wrist_J1')
                    MARegression(j).axe= 'WFE';
                end
            end
        end
    end
    
    
    
    
    
    
    nb_row=2;
    nb_col = size(MARegression,2)/2;
    
    if size(LRegression.joints,2)==2 || size(LRegression.joints,2)==1
        if ceil(nb_col) == nb_col
            nb_col = nb_col+1;
        else
            nb_col = ceil(nb_col);
        end
    end
    
    
    
    if size(MARegression(j).joints,2)==2
        
        Z=zeros(nb_points);
        Zmac=zeros(nb_points);
        for k=1:length(rangeq(:,2))
            Z(k,:) = ideal_curve_temp((k-1)*length(rangeq(:,1))+1:k*length(rangeq(:,1)));
            Zmac(k,:) = mactemp((k-1)*length(rangeq(:,1))+1:k*length(rangeq(:,1)));
        end
        subplot(nb_col,nb_row, j)
        s = surf(rangeq(:,1)*180/pi,rangeq(:,2)*180/pi,Z,'FaceAlpha','0.5','EdgeColor','None');
        hold on
        surf(rangeq(:,1)*180/pi,rangeq(:,2)*180/pi,Zmac);
        s.FaceColor='interp';
        xlab=[MARegression(j).joints{1},' angle (deg)'];
        xlabel(xlab)
        ylabel([MARegression(j).joints{2},' angle (deg)'])
        zlabel('Moment arm (m)')
        title([' Moment arm along the ', MARegression(j).axe,' axis'])
        legend('Reference','Model')
        ax=gca;
        ax.FontSize=20;
        ax.FontName='Utopia';
        
        grid on
        ax.GridAlpha=0.5;
        
        colormap(cmap);
        
    elseif size(MARegression(j).joints,2)==1
        
        subplot(nb_col,nb_row, j)
        s = plot(rangeq(:,1)*180/pi,ideal_curve_temp,'Color',violet);
        hold on
        plot(rangeq(:,1)*180/pi,mactemp,'Color',orange,'LineStyle','--');
        xlab={"";[MARegression(j).joints{1},' angle (deg)']};
        xlabel(xlab)
        ylabel('Moment arm (m)')
        title([' Moment arm along the ', MARegression(j).axe,' axis'])
        legend('Reference','Model')
        ax=gca;
        ax.FontSize=20;
        ax.FontName='Utopia';
        
        grid on
        ax.GridAlpha=0.5;
    end
    
    
    
    
    RMS(j).rms=  sqrt(1/length(mactemp)*sum((ideal_curve_temp-mactemp).^2));
    RMS(j).rmsr=  sqrt(1/length(mactemp)*sum((ideal_curve_temp-mactemp).^2))/sqrt(1/length(mactemp)*sum((ideal_curve_temp).^2))*100;
    RMS(j).axe=  MARegression(j).axe;
    
    
    
    ideal_curve=[ideal_curve ideal_curve_temp];
    
    liste_noms=[liste_noms ' '];
    
    mac=[mac mactemp];
    
    
    
    
end


liste_noms=[];
Lmttot=[];
rangeq=zeros(nb_points,size(LRegression.joints,2));
q=zeros(Nb_q,nb_points^size(LRegression.joints,2));

map_q=zeros(nb_points^size(LRegression.joints,2),size(LRegression.joints,2));

for k=1:size(LRegression.joints,2)
    joint_name=LRegression.joints{k};
    [~,joint_num]=intersect({BiomechanicalModel.OsteoArticularModel.name},['R', joint_name]);
    rangeq(:,k)=linspace(BiomechanicalModel.OsteoArticularModel(joint_num).limit_inf,BiomechanicalModel.OsteoArticularModel(joint_num).limit_sup,nb_points)';
    liste_noms=[liste_noms joint_name];
    
    B1=repmat(rangeq(:,k),1,nb_points^(k-1));
    B1=B1';
    B1=B1(:)';
    B2=repmat(B1,1,nb_points^(size(LRegression.joints,2)-k));
    map_q(:,k) = B2;
    q(joint_num,:) = B2;
end

c = ['equation',LRegression.equation] ;
fh = str2func(c);
ideal_curveLength=fh(LRegression.coeffs,map_q);


parfor i=1:nb_points^size(LRegression.joints,2)
    [Lmt,~] = Muscle_lengthNum(BiomechanicalModel.OsteoArticularModel,BiomechanicalModel.Muscles(num_muscle),q(:,i));
    Lmttot  = [Lmttot Lmt];
end

for k=1:size(LRegression.joints,2)
    if  strcmp(LRegression.joints{k},'Ulna') || strcmp(LRegression.joints{k},'Radius_J1')
        LRegression.joints{k}= 'EFE';
    else if strcmp(LRegression.joints{k},'Radius')
            LRegression.joints{k}= 'PS';
        else if strcmp(LRegression.joints{k},'Hand')
                LRegression.joints{k}= 'WDV';
            else if strcmp(LRegression.joints{k},'Wrist_J1')
                    LRegression.joints{k}= 'WFE';
                end
            end
        end
    end
end

if size(LRegression.joints,2)==2
    
    Z=zeros(nb_points);
    ZLmttot=zeros(nb_points);
    for k=1:length(rangeq(:,2))
        Z(k,:) = ideal_curveLength((k-1)*length(rangeq(:,1))+1:k*length(rangeq(:,1)));
        ZLmttot(k,:) = Lmttot((k-1)*length(rangeq(:,1))+1:k*length(rangeq(:,1)));
    end
    
    subplot(nb_col,nb_row, nb_col*nb_row)
    s =surf(rangeq(:,1)*180/pi,rangeq(:,2)*180/pi,Z,'FaceAlpha','0.5','EdgeColor','None');
    hold on
    surf(rangeq(:,1)*180/pi,rangeq(:,2)*180/pi,ZLmttot);
    hold on
    s.FaceColor='interp';
    xlabel([LRegression.joints{1},' angle (deg)'])
    ylabel([LRegression.joints{2},' angle (deg)'])
    zlabel('Length (m)')
    title('Musculotendon length')
    legend('Reference','Model')
    ax=gca;
    ax.FontSize=20;
    ax.FontName='Utopia';
    
    colormap(cmap);
    
    grid on
    ax.GridAlpha=0.5;
elseif size(LRegression.joints,2)==1
    
    
    subplot(nb_col,nb_row, nb_col*nb_row)
    s =plot(rangeq(:,1)*180/pi,ideal_curveLength,'Color',violet);
    hold on
    plot(rangeq(:,1)*180/pi, Lmttot,'Color',orange,'LineStyle','--');
    hold on
    xlab={"";[LRegression.joints{:},' angle (deg)']};
    xlabel(xlab)
    ylabel('Length (m)')
    title('Musculotendon length')
    legend('Reference','Model')
    ax=gca;
    ax.FontSize=20;
    ax.FontName='Utopia';
    
    
    grid on
    ax.GridAlpha=0.5;
end

%RMS.rms=  sqrt(1/length(Lmttot) * sum((ideal_curveLength - Lmttot).^2));
% RMS.rmsr=  sqrt(1/length(Lmttot) * sum((ideal_curveLength - Lmttot).^2))/ sqrt(1/length(Lmttot) * sum((ideal_curveLength).^2))* 100;
% [r,~] = corrcoef(Lmttot,ideal_curveLength);
% RMS.corr=  r(2,1);
% RMS.sign=sum(sign(ideal_curveLength - Lmttot));

titlefig=[BiomechanicalModel.Muscles(num_muscle).name,'.png'];
saveas(fig_a_sauver,titlefig);


% figure()
% plot(ideal_curveLength,'k')
% hold on
% plot(Lmttot,'--b')
% title(["Longueur musculo tendineuse " BiomechanicalModel.Muscles(num_muscle).name,liste_noms])
% legend("Ce quon veut atteindre","Actuelle")
% ylabel("Longueur musculo tendineuse (m)");
%
% ax=gca;
% ax.FontSize=30;
% ax.FontName='Utopia';






% figure()
% plot(ideal_curve,'k')
% hold on
% plot(mac,'--b')
% title(["Fct coût, " BiomechanicalModel.Muscles(num_muscle).name,liste_noms])
% legend("Ce quon veut atteindre","Actuelle")
% ylabel("Moment arm (m)");
%
% ax=gca;
% ax.FontSize=30;
% ax.FontName='Utopia';



















end