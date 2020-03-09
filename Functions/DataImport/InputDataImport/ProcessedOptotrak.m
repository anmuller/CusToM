function [real_markers, nb_frame, Firstframe, Lastframe, f, list_missing_markers_in_c3d]=ProcessedOptotrak(filename, list_markers, varargin)
% Extraction of experimental data coming from Optotrak
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

load([filename '.mat']); %#ok<LOAD>

nb_frame = size(aut.ess_Tr_Ps,1);
Firstframe = 1;
Lastframe = nb_frame;
f = 30;

markers_optotrak = {'EIASD','EIASG','EPISD','EPISG','L5','GIN_D','GEX_D','GIN_G','GEX_G','PIIND','TALDI','TALDA','TALDE','PIEXD','BP__D','MA_ID','MA_ED','PIING',...
    'TALGI','TALGA','TALGE','PIEXG','BP__G','MA_IG','MA_EG','T12_D','T12_G','STRN','T12_C','C7_D','C7_G','STRN_C7','Manubrium','C7_C','NEZ','NUQUE','VERTEX','EAV_D',...
    'EAR_D','EPI_D','EPE_D','EAV_G','EAR_G','EPI_G','EPE_G','PEX_D','PIN_D','PEX_G','PIN_G'};

real_markers=struct;

% On cherche dans toutes les combinaisons de nom de marqueurs, lesquels
% sont présents
[list_marker_c3d,Ia,~]=intersect(list_markers,markers_optotrak,'stable');

for ii=1:length(list_marker_c3d)
    real_markers(ii).name=list_markers(Ia(ii));
    [~,~,pos] = intersect(list_markers(Ia(ii)), markers_optotrak);
    real_markers(ii).position_c3d = aut.ess_Tr_Ps(:,3*(pos-1)+1:3*pos);
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
