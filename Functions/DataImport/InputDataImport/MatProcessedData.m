function [real_markers, nb_frame, Firstframe, Lastframe, f, list_missing_markers_in_c3d]=MatProcessedData(filename, list_markers, varargin)
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

load([filename '.mat']); %#ok<LOAD>

Firstframe = ExperimentalData.FirstFrame;
Lastframe = ExperimentalData.LastFrame;
f = 1/ExperimentalData.Time(2);

[~,num1,num2]=intersect([ExperimentalData.MarkerPositions.name]', list_markers);
[~,b]=sort(num2);
real_markers = ExperimentalData.MarkerPositions(num1(b));

[list_missing_markers_in_c3d]=setdiff(list_markers,[real_markers.name]');

nb_frame = Lastframe-Firstframe+1;

end
