function affichage_bras_de_levier(nom_muscle,num_muscle,nom_arti,num_arti,minangledeg,maxangledeg,echelle)
% Permet l'affichage des bras de levier pour un muscle donné et une
% articulation donnée
% Attention, à faire tourner dans le dossier où est placé le
% BiomechanicalModel
%----------------------------------------------------------
% INPUT
% - nom_muscle : nom du muscle concerné (sans 'R' ou 'L' devant) (au choix avec num_muscle)
% - num_muscle : numéro d'un des deux muscles concernés (au choix avec nom_muscle)
% - nom_arti : nom de l'articulation concernée (sans 'R' ou 'L' devant) (au choix avec num_arti)
% - num_arti :  numéro d'une des deux articulations concernées (au choix avec nom_arti)
% - minangledeg : angle minimal de l'articulation en degrés
% - maxangledeg : angle maximal de l'articulation en degrés
% - échelle : lors de l'affichage, pour comparer plus facilement avec la
% littérature : 1000 -> mm , 100 -> cm, 1 -> m etc.

% Par exemple :
% affichage_bras_de_levier('FlexorCarpiUlnaris',0,'Wrist_J1',0,-90,90,100);
% ou, pour un BiomechanicalModel donné : 
% affichage_bras_de_levier([],40,[],40,-90,90,100);

load('BiomechanicalModel.mat');
HumanModel=BiomechanicalModel.OsteoArticularModel;
Muscles=BiomechanicalModel.Muscles;

osnames={HumanModel.name};
musnames={Muscles.name};

if ~isempty(nom_muscle)
    num_muscle=zeros(2,1);
    [~,num_muscle(1)]=intersect(musnames,['R',nom_muscle]);
    [~,num_muscle(2)]=intersect(musnames,['L',nom_muscle]);
else
    nom_muscle=musnames{num_muscle(1)};
    nom_muscle=nom_muscle(2:end);
    if length(num_muscle)==1
            num_muscle=zeros(2,1);
            [~,num_muscle(1)]=intersect(musnames,['R',nom_muscle]);
            [~,num_muscle(2)]=intersect(musnames,['L',nom_muscle]);
    end
end

if ~isempty(nom_arti)
    num_arti=zeros(2,1);
    [~,num_arti(1)]=intersect(osnames,['R',nom_arti]);
    [~,num_arti(2)]=intersect(osnames,['L',nom_arti]);
else
    nom_arti=osnames{num_arti(1)};
    nom_arti=nom_arti(2:end);
    if length(num_arti)==1
            num_arti=zeros(2,1);
            [~,num_arti(1)]=intersect(osnames,['R',nom_arti]);
            [~,num_arti(2)]=intersect(osnames,['L',nom_arti]);
    end
end

Nb_muscles=numel(BiomechanicalModel.Muscles);
Nb_q=numel(HumanModel)-6*(~isempty(intersect(osnames,'root0')));

angle=minangledeg:(maxangledeg-minangledeg)/100:maxangledeg;
Nb_frames=length(angle);
q=zeros(Nb_q,Nb_frames);


figure()

for k=1:2
    q(num_arti(k),:)=angle*pi/180;
    
    R=zeros(Nb_q,Nb_muscles,Nb_frames);
    for i=1:Nb_frames % for each frames
        R(:,:,i)    =   MomentArmsComputationNum(BiomechanicalModel,q(:,i),0.0001); %depend on reduced set of q (q_red)
    end
    
    R=R*echelle;
    
    subplot(2,1,k)
    temp=R(num_arti(k),num_muscle(k),:);
    plot(angle,temp(:),'LineWidth',3)
    ax=gca;
    
    if k==1
        title(['R',nom_muscle])
         xlabel(['R',nom_arti,' (deg)']);
    else
        title(['L',nom_muscle])
         xlabel(['L',nom_arti,' (deg)']);
    end
    
    ylabel(['Moment arm (m/', num2str(echelle), ')' ])
    ax.FontSize=30;
    ax.FontName='Utopia';
    set(gcf, 'Position', get(0, 'Screensize'));

    
end





end