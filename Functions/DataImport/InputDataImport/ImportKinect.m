function [real_markers, nb_frame, Firstframe, Lastframe,f]=ImportKinect(filename, list_markers, varargin)
% Extraction of experimental data from a Kinect
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
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

%% Liste des articulations dans la hiérarchie de la Kinect

list_joint={'HIP_CENTER','SPINE','SHOULDER_CENTER','HEAD',...
    'SHOULDER_LEFT','ELBOW_LEFT','WRIST_LEFT','HAND_LEFT',...
    'SHOULDER_RIGHT','ELBOW_RIGHT','WRIST_RIGHT','HAND_RIGHT',...
    'HIP_LEFT','KNEE_LEFT','ANKLE_LEFT','FOOT_LEFT',...
    'HIP_RIGHT','KNEE_RIGHT','ANKLE_RIGHT','FOOT_RIGHT'};

%% Extraction des données du fichier txt
filename = [filename '.txt'];
delimiter = '\t';
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
fclose(fileID);

Data = [dataArray{1:end-1}];

%% Création de la structure 'real_markers' 

real_markers=struct;
for j=1:size(list_markers,1)
i=1;
    while strcmp(list_joint(i),list_markers(j)) == 0  % on cherche la position du jième marqueur de la liste dans le C3d (looking for position of j-iest marker of the list within C3D)
    i=i+1;
    end
% lorsqu'on la trouvée on créé une structure avec son nom et sa position (matrice nbframe x 3)
real_markers(j).name=list_markers(j);
real_markers(j).position=Data(:,(3*(i-1)+3):(3*i+2))*Rodrigues([1 0 0]',-pi/2); % on remet l'axe z suivant la verticale (z is the vertical axis)
end

nb_frame=numel(Data(:,1));

%% Récupération du temps (dealing with time)

Time=Data(:,2);

for i=1:numel(real_markers)
    real_markers(i).time=(Time-Time(1));
end

f=1/(Time(2)-Time(1));
Firstframe=1;
Lastframe=nb_frame;

end
