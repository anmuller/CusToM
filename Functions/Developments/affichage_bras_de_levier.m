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
addpath('Symbolic_function');
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
    nom_arti2='';
    if strcmp(nom_arti,'Shoulder_Flexion')
        nom_arti='Glenohumeral_J2';
        nom_arti2='Glenohumeral_J1';
        
        nom_arti3='Scapula_J1';
        nom_arti4='Scapula_J2';
        nom_arti5='Scapula';
    end
    num_arti=zeros(2,1);
    [~,num_arti(1)]=intersect(osnames,['R',nom_arti]);
    [~,num_arti(2)]=intersect(osnames,['L',nom_arti]);
    if ~isempty(nom_arti2)
        num_arti2=zeros(2,1);
        num_arti3=zeros(2,1);
        num_arti4=zeros(2,1);
        num_arti5=zeros(2,1);

        [~,num_arti2(1)]=intersect(osnames,['R',nom_arti2]);
        [~,num_arti2(2)]=intersect(osnames,['L',nom_arti2]);
        [~,num_arti3(1)]=intersect(osnames,['R',nom_arti3]);
        [~,num_arti3(2)]=intersect(osnames,['L',nom_arti3]);
        [~,num_arti4(1)]=intersect(osnames,['R',nom_arti4]);
        [~,num_arti4(2)]=intersect(osnames,['L',nom_arti4]);
        [~,num_arti5(1)]=intersect(osnames,['R',nom_arti5]);
        [~,num_arti5(2)]=intersect(osnames,['L',nom_arti5]);
    end
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

Nb_ClosedLoop = sum(~cellfun('isempty',{HumanModel.ClosedLoop}));
list_q_ClosedLoop1 = [];
for i=1:size(HumanModel,2)
    if ~isempty(HumanModel(i).ClosedLoop)
        list_q_ClosedLoop1(end+1) = i;
        
    end
end

list_q_ClosedLoop2=zeros(Nb_ClosedLoop,1);
solid_path_closedloop=[];
for i=1:length(list_q_ClosedLoop1)
    attachment_pt = HumanModel(list_q_ClosedLoop1(i)).ClosedLoop;
    for j=1:size(HumanModel,2)
        for k=1:size(HumanModel(j).anat_position,1)
            if strcmp(attachment_pt,HumanModel(j).anat_position{k,1})
                list_q_ClosedLoop2(i)=j;
            end
        end
    end
    [a,b]=find_solid_path(HumanModel,list_q_ClosedLoop1(i),list_q_ClosedLoop2(i));
    solid_path_closedloop(end+1,:)=unique([a,b]);
end


angle=minangledeg:(maxangledeg-minangledeg)/50:maxangledeg;
Nb_frames=length(angle);
q_red=BiomechanicalModel.Generalized_Coordinates.q_red;

list_q_red = zeros(length(q_red),1);
for i=1:length(list_q_red)
    char_i=char(q_red(i,1));
    list_q_red(i)=str2double(char_i(2:end));
    
end
q=zeros(Nb_q,Nb_frames);
qvar=sym('q',[Nb_q,1]);
qvar(setdiff(list_q_red,solid_path_closedloop(:)),1)=0;
qvar=qvar(list_q_red);

figure()
for k=1:2
    if ~isempty(nom_arti2)
        q(num_arti2(k),:)=pi/2;
        q(num_arti3(k),:)=(-1)^(k-1)*27.939*pi/180+0.088*angle*pi/180;
        q(num_arti4(k),:)=-6.970*pi/180+0.220*angle*pi/180;
        q(num_arti5(k),:)=-4.884*pi/180+0.145*angle*pi/180;
    end
    q(num_arti(k),:)=angle*pi/180;
    
    
    
    
    R=zeros(Nb_q,Nb_muscles,Nb_frames);
    for i=1:Nb_frames % for each frames
%         qvar(list_q_red==num_arti(k),:)=angle(i)*pi/180;
%         
%         MatlabFunction(qvar)
% 
%         if Nb_ClosedLoop~=0
%             nonlcon=@(q25,q26,q27,q29,q30,q31,q32,q33,q38,q39,q40,q41,q42,q43,q44) ClosedLoop_sym(qvar,Nb_ClosedLoop);
%         end
%         
%         res=fsolve(nonlcon,zeros(15,1));
        
        R(:,:,i)    =   MomentArmsComputationNum(BiomechanicalModel,q(:,i),0.0001); %depend on reduced set of q (q_red)
    end
    
    R=R*echelle;
    
    subplot(2,1,k)
    temp=R(num_arti(k),num_muscle(k),:);
    plot(angle,temp(:),'LineWidth',3)
    ax=gca;
    
    if k==1
        title(['R',nom_muscle])
         if size(intersect(nom_arti,'Radius'),2)== length(nom_arti)
                     xlabel(['R',nom_arti,' (deg) Pro(+)/Sup(-)']);
         else if size(intersect(nom_arti,'Hand'),2)== length(nom_arti)
                    xlabel(['R',nom_arti,' (deg) Uln(+)/Rad(-)']);
             else
                      xlabel(['R',nom_arti,' (deg)']);
             end
         end
    else
        title(['L',nom_muscle])
         if size(intersect(nom_arti,'Radius'),2)== length(nom_arti)
                     xlabel(['L',nom_arti,' (deg) Pro(-)/Sup(+)']);
         else if size(intersect(nom_arti,'Hand'),2)== length(nom_arti)
                    xlabel(['L',nom_arti,' (deg) Uln(-)/Rad(+)']);
             else
                      xlabel(['L',nom_arti,' (deg)']);
             end
         end
    end
    
    ylabel(['Moment arm (m/', num2str(echelle), ')' ])
    ax.FontSize=30;
    ax.FontName='Utopia';
    set(gcf, 'Position', get(0, 'Screensize'));

    
end





end