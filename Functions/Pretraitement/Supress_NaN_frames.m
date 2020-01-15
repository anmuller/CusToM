function [real_markers, nb_frames]=Supress_NaN_frames(real_markers)
% Eliminination of frames with NaN 
%
%   INPUT
%   - real_markers: raw 3D position of experimental markers
%   OUTPUT
%   - real_markers: 3D position of experimental markers without frames
%   containing NaN
%   - nb_frames: number of frames
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

%% Detection of frames to delete
Marqueur_absent=[];
nb_frame_origin = size(real_markers(1).position,1);
[real_markers]=CompteNaN(real_markers,'position_c3d');
for i_mk = 1:numel(real_markers)
    if ~isempty(real_markers(i_mk).position_c3d_NaN_detail)
        Marqueur_absent=[Marqueur_absent;real_markers(i_mk).position_c3d_NaN_detail];
    end
end
Marqueur_absent=sort(Marqueur_absent); % All the frames with a missing marker in c3d data.

%% Deletion of the frames
for ii_mk= 1:numel(real_markers)
        index = true( 1 , size(real_markers(ii_mk).position,1) );
        index(Marqueur_absent')=false;
        real_markers(ii_mk).position=real_markers(ii_mk).position(index,:);
end
nb_frames = size(real_markers(ii_mk).position,1);

% disp([ num2str(length(Marqueur_absent)) '/' num2str(nb_frame_origin) ' deleted frames'])

end