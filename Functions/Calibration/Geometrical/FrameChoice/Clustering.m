function [frame_calib] = Clustering(nb_frame_calib, real_markers, list_markers)
% Frames choice for the geometrical calibration
%   Frames are selected thanks to a clustering method from the position of
%   experimental markers
%   
%   INPUT
%   - nb_frame_calib: number of frames to select
%   - real_markers: 3D position of experimental markers
%   - list_markers: list of the marker names
%   OUTPUT
%   - frame_calib: number of frames to be used for the geometrical
%   calibration
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

nb_frame = size(real_markers(1).position,1);

% sélection à partir de la position des marqueurs (selection from markers position)
vect_clust=zeros(nb_frame,3*numel(list_markers));
for i=1:numel(list_markers)
    vect_clust(:,(3*(i-1)+1):(3*(i-1)+3))=real_markers(i).position;
end

% classification : k-means
nb_essai=10;
idx_inter=zeros(size(vect_clust,1),nb_essai);
sumd=zeros(nb_frame_calib,nb_essai);
normsum=zeros(1,nb_essai);
for i=1:nb_essai
    [idx_inter(:,i),~,sumd(:,i)] = kmeans(vect_clust,nb_frame_calib);
    normsum(:,i)=norm(sumd(:,i));
end
aa=find(normsum==min(normsum));
idx=idx_inter(:,aa(1));


% classification : regroupement hiérarchique (classification: hierarchical grouping) 
% Z = linkage(vect_clust,'ward');
% dendrogram(Z,5000)
% idx=cluster(Z,'cutoff',40,'criterion','distance');
% nb_frame_calib=max(idx);

% choix des frames dans les classes (médiane) (choice of frames within classes)
position_classes=cell(nb_frame_calib,1);
position_mediane=cell(nb_frame_calib,1);
for i=1:nb_frame_calib
    position_classes{i}=find(idx==i)';
    position_mediane{i}=median(vect_clust(position_classes{i},:));
end
dist=zeros(size(vect_clust,1),1);
for f=1:nb_frame
    dist(f,:)=norm(vect_clust(f,:)-position_mediane{idx(f,1)},2);
end
frame_calib=zeros(1,nb_frame_calib);

for i=1:nb_frame_calib
    test=0;
    for f=1:nb_frame
        if test == 0 && idx(f)==i
            frame_calib(i)=f;
            test=1;
            normref=dist(f,1);
        else
            if idx(f)==i
                if dist(f,1)<normref
                    frame_calib(i)=f;
                    normref=dist(f,1);
                end
            end
        end
    end
end
end


% % choix des frames dans les classes (point le plus éloigné des barycentres des autres classes) (choice of frames within classes)
%     position_classes=cell(nb_frame_calib,1);
%     position_mediane=cell(nb_frame_calib,1);
%     for i=1:nb_frame_calib
%         position_classes{i}=find(idx==i)';
%         position_mediane{i}=median(vect_clust(position_classes{i},:));
%     end
%
%     dist=zeros(size(vect_clust,1),1);
%     for f=1:nb_frame % calcul de la position du point par rapport à  la médiane (computation of point’s position wrt median)
%         dist(f,:)=norm(vect_clust(f,:)-position_mediane{idx(f,1)},2);
%     end
%     bary=zeros(1,nb_frame_calib);
%     for i=1:nb_frame_calib
%         test=0;
%         for f=1:nb_frame
%             if test == 0 && idx(f)==i
%                 bary(i)=f;
%                 test=1;
%                 normref=dist(f,1);
%             else
%                 if idx(f)==i
%                     if dist(f,1)<normref
%                         bary(i)=f;
%                         normref=dist(f,1);
%                     end
%                 end
%             end
%         end
%     end
%
%     distbis=zeros(size(vect_clust,1),1);
%     for f=1:nb_frame  % calcul de la somme des distances par rapport à chaque barycentre des autres classes (computation of distances wrt barycenters of other classes)
%         for p=1:nb_frame_calib
%             if idx(f) ~= p
%                 distbis(f,:)= distbis(f,:)+norm(vect_clust(f,:)-vect_clust(bary(p),:),2);
%             end
%         end
%     end
%     frame_calib=zeros(1,nb_frame_calib);
%     for i=1:nb_frame_calib
%         test=0;
%         for f=1:nb_frame
%             if test == 0 && idx(f)==i
%                 frame_calib(i)=f;
%                 test=1;
%                 normref=distbis(f,1);
%             else
%                 if idx(f)==i
%                     if distbis(f,1)>normref
%                         frame_calib(i)=f;
%                         normref=distbis(f,1);
%                     end
%                 end
%             end
%         end
%     end
