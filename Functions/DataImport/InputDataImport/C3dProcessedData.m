function [real_markers, nb_frame, Firstframe, Lastframe, f, list_missing_markers_in_c3d]=C3dProcessedData(filename, list_markers, varargin)
% Extraction of experimental data in a processed c3d
%   
%   INPUT
%   - filename: name of the file to process (character string)
%   - list_markers: list of the marker names
%   OUTPUT
%   - real_markers: 3D position of experimental markers
%   - nb_frame: number of frames
%   - Firstframe: number of the first frame
%   - Lastframe: number of the last frame
%   - f: acquisition frequency
%   - list_missing_markers_in_c3d: list of marker name which are missing in
%   the c3d file
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

warning('off', 'btk:ReadAcquisition');
h = btkReadAcquisition([char(filename) '.c3d']);
[markers,markersInfo]=btkGetMarkers(h);
v=btkGetMarkersValues(h);

f=markersInfo.frequency;  % frequence

Firstframe=btkGetFirstFrame(h); % numéro de la frame 1
Lastframe=btkGetLastFrame(h); % numéro de la dernière frame
nb_frame=Lastframe-Firstframe+1;  % nb de frame

prefixInfo = btkGetMetaData(h);
% prefix = [prefixInfo.children.SUBJECTS.children.NAMES.info.values{1} '_'];

ListMarkersName = fieldnames(markers);

real_markers=struct;
list_m_bis=cell(1,1);
list_m_table=cell(1,1);

% On crée un tableau avec toutes les combinaisons de noms de marqueurs
% possibles avec tous les préfixes disponibles dans le c3d.
% Creation of a table with all combinations of marker names 
% with all the prefixes available in the c3d. 
if isfield(prefixInfo.children, 'SUBJECTS')
nb_pref=length(prefixInfo.children.SUBJECTS.children.NAMES.info.values)+1;
else nb_pref=1;
end
prefix=cell(1,3);
for i_pref=1:nb_pref
    if i_pref==nb_pref
        prefix{i_pref} = []; %marqueurs sans prefixe (marker without prefix)
    else
    prefix{i_pref} = [prefixInfo.children.SUBJECTS.children.NAMES.info.values{i_pref} '_'];
    end
    for j=1:length(list_markers)
        list_m_table{i_pref,j} = list_markers{j};
        list_m_bis{i_pref,j} = strcat(prefix{i_pref},list_markers{j}); % toutes les combinaisons de noms de marqueurs possibles (all combinations of possible markers names)
    end
end

% for i_pref=1:length(prefixInfo.children.SUBJECTS.children.NAMES.info.values)
%     prefix{i_pref} = [prefixInfo.children.SUBJECTS.children.NAMES.info.values{i_pref} '_'];
%     for j=1:size(list_markers,1)
%         i=1;
%         while strcmp(ListMarkersName{i},strcat(prefix{i_pref},list_markers{j})) == 0 && strcmp(ListMarkersName{i},list_markers{j}) == 0 ... % on cherche la position du jième marqueur de la liste dans le C3d
% Looking for position of j-iest marker of the list within C3D
%             i=i+1;
%         end
%         % lorsqu'on la trouvée on créé une structure avec son nom et sa position (matrice nbframe x 3)
%         real_markers(j).name=list_markers(j);
%         real_markers(j).position_c3d=v(:,(3*(i-1)+1):(3*(i-1)+3))/1000;
%     end
% end

% On cherche dans toutes les combinaisons de nom de marqueurs, lesquels
% sont présents
% Which markers are present within all the combination ?
[list_marker_c3d,Ia,~]=intersect(list_m_bis,ListMarkersName,'stable');

for ii=1:length(list_marker_c3d)
    real_markers(ii).name=list_m_table(Ia(ii));
    real_markers(ii).position_c3d=markers.(list_marker_c3d{ii})/1000;
end

[list_missing_markers_in_c3d]=setdiff(list_markers,[real_markers.name]');

if ~isempty(list_missing_markers_in_c3d)
disp(['Markerset have not been extracted enterely from the .c3d file, missing markers : ' ;list_missing_markers_in_c3d])
end

%Création du vecteur temps
for i=1:numel(real_markers)
    real_markers(i).time=[0:(1/f):(nb_frame-1)/f]'; %#ok<NBRAK>
end

end
