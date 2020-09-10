%% Optimisation des bras de levier
clear all;
cmap=colormap(parula(3));
set(groot, 'DefaultAxesColorOrder', cmap,'DefaultAxesFontSize',20,'DefaultLineLineWidth',3);
close;
format long

%load('/home/clivet/Documents/Thèse/Developpement_CusToM/thesis/Fichiers_tests/Donnees a traiter/Ana Lucia Data - Sbj 1 - Trial 1 - Forearm model/BiomechanicalModel.mat')
%load('BiomechanicalModel.mat')
load('BiomechanicalModelOrigin.mat')
%load('BiomechanicalModel_ED_full.mat');
%load('BiomechanicalModel_BRD.mat');
%name_mus='Brachioradialis';
%name_mus='ExtensorDigitorum';
%name_mus='FlexorDigitorumSuperior';

load('handel.mat');
player = audioplayer(y,Fs);
play(player);

temp={BiomechanicalModel.Muscles.name};
for k=1:length(temp)
    temp2=temp{k};
    temp{k}=temp2(2:end);
end
all_muscles=unique(temp);

%% Stockage dans un fichier texte


% Brachio

% involved_solids{1}=[53;53;56;56];
% involved_solids{2}=[66;66;69;69];
% num_markersprov{1}=[44;63;12;7];
% num_markersprov{2}=[44;63;12;7];

%MomentsArmRegression=MomentsArmRegression_creation();
MomentsArmRegression=MomentsArmRegression_creationRRN();
LengthRegression=MuscleLengthRegression_creationRRN();


all_muscles= {'Brachioradialis','ExtensorCarpiRadialisLongus',...
    'ExtensorCarpiRadialisBrevis',...
    'ExtensorCarpiUlnaris',...
    'FlexorCarpiUlnaris','FlexorCarpiRadialis',...
    'PalmarisLongus' ,'PronatorTeres', ...
    'Anconeus', 'Brachialis',...
    'PronatorQuadratus','SupinatorBrevis', 'TricepsMed','TricepsLat'};

for i=1:length(all_muscles)
    
    
    
    name_mus=all_muscles{i};
    
    [fctcoutx,RMS,RMSLmt,involved_solids,num_markersprov,BiomechanicalModel]=MomentArmOptimisation(name_mus,BiomechanicalModel,MomentsArmRegression,LengthRegression);
    
    
    
    fileID = fopen('via_points2.txt','a');
    
    solid_interet=involved_solids{1};
    markers_interet=num_markersprov{1};
    
    for k=1:length(solid_interet)
        temp1=solid_interet(k);
        temp2=markers_interet(k);
        nom_pt_passage=BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,1};
        pt_passage=BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2};
        
        
        nom_pt_passage=nom_pt_passage(2:end);
        pt_passage=BiomechanicalModel.OsteoArticularModel(temp1).anat_position{temp2,2} +  BiomechanicalModel.OsteoArticularModel(temp1).c ;
        fprintf(fileID,'[Signe ''%6s''], k*Mirror*[%6.4f ; %6.4f ; %6.4f] - COM ;... \n',nom_pt_passage,pt_passage);
        fprintf(fileID,'[Signe ''%6s''], [%6.4f  %6.4f  %6.4f] ;... \n',nom_pt_passage,[0 -1 0;0 0 -1; 1 0 0]*pt_passage);
        
    end
    
    for p=1:size(RMS,2)
        fprintf(fileID,'RMS MA %6s :    %6.4f  (%6.4f )] ;... \n',RMS(p).axe,RMS(p).rms,RMS(p).rmsr);
    end
    
    fprintf(fileID,'RMS Lmt :    %6.4f ] ;... \n',RMSLmt.rmsr);
    fprintf(fileID,'Corr Lmt :    %6.4f  ] ;... \n',RMSLmt.corr);
    fprintf(fileID,'Fctcout  :    %6.4f ] ;... \n',fctcoutx);
    
    
    
    fclose(fileID);
    
    
    
    
end


save('BiomechanicalModel.mat','BiomechanicalModel');


% Affichage des correlations vs les longueurs

% NamesPA = {'BRD','ECRL','ECRB','ECU', 'FCU','FCR','PL','PT'};
% LmtPA  = [10.4748 , 15.1636, 12.7250, 10.0908  8.0282  10.6140 15.9160 5.8499 ];
% CorrPA = abs([0.9921 ,  0.9739,  0.9907,  -0.2822 0.9793 0.9655  0.9670   0.9633  ]);
% NamesMA={'ANC','BRA' ,'PQ','SUP','TRImed','TRIlat'};
% LmtMA=[75.1078  45.2588 1047.8462  701.1980   44.2516  34.5698  ] ;
% CorrMA = abs( [-0.9115  -0.0000 -0.9980 -0.9740  0.9472  0.9476]) ;
% 
% NamesPA1 = {'BRD','ECRL','ECRB'};
% LmtPA1  = [10.4748 , 15.1636, 12.7250  ];
% CorrPA1 = abs([0.9921 ,  0.9739,  0.9907 ]);
% NamesPA2 = {'ECU', 'FCU','FCR'};
% LmtPA2  = [ 10.0908  8.0282  10.6140 ];
% CorrPA2 = abs([-0.2822 0.9793 0.9655   ]);
% NamesPA3 = {'PL','PT'};
% LmtPA3  = [ 15.9160 ,  5.8499 ];
% CorrPA3 = abs(  [0.9670 , 0.9633] );
% 
% 
% 
% NamesMA2={'ANC','SUP','TRImed','TRIlat'};
% LmtMA2=[75.1078    701.1980   44.2516  34.5698  ] ;
% CorrMA2 = abs( [-0.9115    -0.9740  0.9472  0.9476]) ;
% NamesMA1={'PQ'};
% LmtMA1=[ 1047.8462  ] ;
% CorrMA1 = abs( [-0.9980 ]) ;
% NamesMA3={'BRA' };
% LmtMA3=[ 45.2588  ] ;
% CorrMA3 = abs( [-0.0000]) ;
% 
% 
% figure()
% plot(LmtPA,CorrPA,'Marker','d','MarkerSize',20,'MarkerFaceColor','m','LineStyle','none','MarkerEdgeColor',[0 0 0]);
% hold on
% plot(LmtMA,CorrMA,'Marker','o','MarkerSize',20,'MarkerFaceColor','g','LineStyle','none','MarkerEdgeColor',[0 0 0]);
% text(LmtPA2-0.12*LmtPA2,CorrPA2 -0.03,NamesPA2,'FontSize',30)
% text(LmtPA1-0.12*LmtPA1,CorrPA1 -0.015,NamesPA1,'FontSize',30)
% text(LmtPA3+ 0.03*LmtPA3,CorrPA3 ,NamesPA3,'FontSize',30)
% text(LmtMA2,CorrMA2 -0.02 ,NamesMA2,'FontSize',30)
% text(LmtMA1-0.1*LmtMA1,CorrMA1 -0.02 ,NamesMA1,'FontSize',30)
% text(LmtMA3,CorrMA3 +0.02 ,NamesMA3,'FontSize',30)
% 
% xlabel('Musculo-tendon length rRMSE (%)')
% ylabel('Correlation')
% legend({'Pluri-articular muscles','Mono-articular muscles'})
% 
% ax=gca;
% ax.FontSize=50;
% ax.FontName='Utopia';
% set(gca,'xscale','log')

