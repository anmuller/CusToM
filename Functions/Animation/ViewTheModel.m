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
XX=axes; hold on;
Anim.ModelChoice= 1;
PlotModel(ModelParameters,XX,1,0,1,0,0,0,0,0,Anim);
axis equal;

