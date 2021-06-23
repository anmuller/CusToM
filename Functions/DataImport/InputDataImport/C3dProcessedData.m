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
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

warning('off', 'btk:ReadAcquisition');
h = btkReadAcquisition([char(filename) '.c3d']);
[markers,markersInfo]=btkGetMarkers(h);
v=btkGetMarkersValues(h);

f=markersInfo.frequency;  % frequency

Firstframe=btkGetFirstFrame(h); % first frame
Lastframe=btkGetLastFrame(h); % last frame
nb_frame=Lastframe-Firstframe+1;  % frames count

prefixInfo = btkGetMetaData(h);
% prefix = [prefixInfo.children.SUBJECTS.children.NAMES.info.values{1} '_'];

ListMarkersName = fieldnames(markers);

real_markers=struct;
list_m_bis=cell(1,1);
list_m_table=cell(1,1);

%prefixInfo.children.SUBJECTS_2.children.NAMES.info.values  
% Creation of a table with all combinations of marker names 
% with all the prefixes available in the c3d. 
%testing all "subjects" fields

%% old way for versioning
% s1='SUBJECTS';
% nb_pref=0;
% i=2;
% if isfield(prefixInfo.children, s1)
%     %intégrer test "SUBJECTS_XXX"
%     
% nb_pref=length(prefixInfo.children.SUBJECTS.children.NAMES.info.values)+1;
% else
% nb_pref=1;
% end
    
%% new way

prefix{1} = [];%markers without prefix

%finding all the subjects in which prefixes are hidden
j=1;
k=1;
s1='SUBJECTS';
cal='prefixInfo.children.%s.children.NAMES.info.values';
if isfield(prefixInfo.children, s1)
    i=1;
while i<=length(prefixInfo.children.SUBJECTS.children.NAMES.info.values)
    prefix{j+1} = [prefixInfo.children.SUBJECTS.children.NAMES.info.values{i} '_'];
    i=i+1;
    j=j+1;
end
end

%% additional subjects fields
s=strcat(s1,'_',num2str(k+1));
while isfield(prefixInfo.children, s)
    i=1;
        cal2=sprintf(cal,s);
        w=eval(cal2);
for i=1:length(w)
    if ~any(strcmp(prefix,[w{i} '_']))
    prefix{j+1} = [w{i} '_'];
    j=j+1;
    end
end
k=k+1;
s=strcat(s1,'_',num2str(k+1));
end

%% constituting marker names with prefixes

nb_pref=length(prefix);

for i_pref=1:nb_pref

    for j=1:length(list_markers)
        list_m_table{i_pref,j} = list_markers{j};
        list_m_bis{i_pref,j} = strcat(prefix{i_pref},list_markers{j}); % toutes les combinaisons de noms de marqueurs possibles (all combinations of possible markers names)
    end
end

%% Which markers are present within all the combination ?
[list_marker_c3d,Ia,~]=intersect(list_m_bis,ListMarkersName,'stable');
cpt=1;
for ii=1:length(list_marker_c3d)
    if isempty(find(markers.(list_marker_c3d{ii})==0,1))
        real_markers(cpt).name=list_m_table(Ia(ii));
        real_markers(cpt).position_c3d=markers.(list_marker_c3d{ii})/1000;
        cpt = cpt+1;
    else
       warning(['A least one marker is occluded in ' filename ', occluded markers :'])
       disp(list_m_table(Ia(ii)));
    end
end


[list_missing_markers_in_c3d]=setdiff(list_markers,[real_markers.name]');

if ~isempty(list_missing_markers_in_c3d)
disp(['Markerset have not been extracted enterely from the .c3d file, missing markers : ' ;list_missing_markers_in_c3d])
end

%% creating time
for i=1:numel(real_markers)
    real_markers(i).time=[0:(1/f):(nb_frame-1)/f]'; %#ok<NBRAK>
end

end
