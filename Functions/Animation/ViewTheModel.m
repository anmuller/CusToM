% View the model defined with Model Parameters
%
%   INPUT
%
%   OUTPUT
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________

clear all
close all
load('ModelParameters.mat')

X=cFigure; grid off; hold on; axis off;
XX=axes; set(XX,'visible','off')
AnimateParameters.Mode = 'GenerateParameters';
% AnimateParameters.Mode = 'cFigure';
AnimateParameters.seg_anim = 1;
AnimateParameters.bone_anim = 0;
AnimateParameters.mass_centers_anim = 0;
AnimateParameters.Global_mass_center_anim = 0;
AnimateParameters.muscles_anim = 1;
AnimateParameters.wrap_anim = 1;
AnimateParameters.mod_marker_anim = 0;
AnimateParameters.exp_marker_anim = 0;
AnimateParameters.external_forces_anim = 0;
AnimateParameters.external_forces_pred = 0;
AnimateParameters.PictureFrame = 1;
AnimateParameters.ax = XX;
PlotAnimation(ModelParameters, AnimateParameters);

view(2); axis equal; axis tight; axis vis3d; grid on; box on;
% camlight left; 
axis off; axis manual;
lighting gouraud
ax=gca;
ax.Clipping = 'off';
drawnow;
