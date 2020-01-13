function com=CalcCoM(Human_model)
% Function that computes the global center of mass position.
%
%   INPUT
%   - Human_model: osteo-articular model (see the Documentation for the
%   - j: current solid
%   OUTPUT
%   - com: center of mass postion
%________________________________________________________
%
% Licence
% Toolbox distributed under GPL 3.0 Licence
%________________________________________________________
%
% Authors : Antoine Muller, Charles Pontonnier, Pierre Puchaud and
% Georges Dumont
%________________________________________________________
M=sum([Human_model.m]);
MC=CalcMC(Human_model,1);
com=MC/M;
end