% View the model defined with Model Parameters
%
%   INPUT
%
%   OUTPUT
%________________________________________________________
%
% Licence
% Toolbox distributed under 3-Clause BSD License
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

clear all
close all
load('ModelParameters.mat')

X=cFigure; hold on;
XX=axes;
AnimateParameters.Mode = 'GenerateParameters';
AnimateParameters.seg_anim = 1;
AnimateParameters.bone_anim = 0;
AnimateParameters.mass_centers_anim = 0;
AnimateParameters.Global_mass_center_anim = 0;
AnimateParameters.muscles_anim = 1;
AnimateParameters.mod_marker_anim = 1;
AnimateParameters.exp_marker_anim = 0;
AnimateParameters.external_forces_anim = 0;
AnimateParameters.external_forces_pred = 0;
AnimateParameters.PictureFrame = 1;
AnimateParameters.ax = XX;
PlotAnimation(ModelParameters, AnimateParameters);
axis equal;
