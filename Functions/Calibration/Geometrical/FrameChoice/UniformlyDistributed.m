function [frame_calib] =  UniformlyDistributed(nb_frame_calib, real_markers, varargin)
% Frames choice for the geometrical calibration
%   Frames are uniformly selected throughout the motion
%   
%   INPUT
%   - nb_frame_calib: number of frames to select
%   - real_markers: 3D position of experimental markers
%   OUTPUT
%   - frame_calib: number of frames to be used for the geometrical
%   calibration
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

nb_frame = size(real_markers(1).position,1);
frame_calib=floor(1:nb_frame/nb_frame_calib:nb_frame);

end